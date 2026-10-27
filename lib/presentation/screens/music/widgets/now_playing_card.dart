import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/presentation/screens/music/widgets/connect_device_tile.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// Current track of the active target: where it plays, cover tint, title, live progress and transport controls.
class NowPlayingCard extends StatelessWidget {
  const NowPlayingCard({
    super.key,
    required this.target,
    required this.enabled,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
  });

  final PlaybackTarget target;
  final bool enabled;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final track = target.nowPlaying;
    final seed = track.title ?? target.name;
    final tint = Artwork.colorOf(seed);
    return AnimatedContainer(
      duration: HubMotion.glowDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HubRadius.pageCard),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color.alphaBlend(tint.withValues(alpha: 0.3), HubColorPalette.surface), HubColorPalette.surface],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 24, 18),
      child: Row(
        spacing: 20,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 8))],
            ),
            child: Artwork(seed: seed, url: track.artworkUrl, size: 124, radius: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    HubGlyphIcon(
                      switch (target) {
                        ConnectTarget(:final device) => ConnectDeviceTile.glyphOf(device.type),
                        SpeakerGroupTarget() => HubGlyph.speaker,
                      },
                      color: HubColorPalette.text2,
                      size: const Size(12, 12),
                    ),
                    Flexible(
                      child: Text(
                        target.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  track.title ?? 'Nothing playing',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HubTextStyles.sectionTitle,
                ),
                Text(
                  [?track.artist, ?track.source].where((part) => part.isNotEmpty).join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HubTextStyles.secondary.copyWith(fontSize: 16, color: const Color(0xB3EBEBF5)),
                ),
                const SizedBox(height: 4),
                _Progress(track: track),
              ],
            ),
          ),
          _Transport(
            playing: track.isPlaying,
            enabled: enabled,
            onPrevious: onPrevious,
            onPlayPause: onPlayPause,
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}

/// Progress bar with elapsed and remaining time. While playing the bar moves on whenever it would cover one more
/// pixel – smooth to the eye, but only a few frames per second on a screen that is on all day.
class _Progress extends StatefulWidget {
  const _Progress({required this.track});

  final NowPlaying track;

  @override
  State<_Progress> createState() => _ProgressState();
}

class _ProgressState extends State<_Progress> {
  /// Differences up to this are polling and clock drift; the bar keeps running instead of jumping.
  static const _tolerance = 1.5;

  /// Played part of the track, 0–1.
  final _played = ValueNotifier(0.0);
  final _second = ValueNotifier(0);
  Timer? _timer;
  var _duration = 0;
  var _barWidth = 0.0;
  var _active = true;

  /// Position at [_anchorAt]; the shown position runs on from there while playing.
  var _anchor = 0.0;
  var _anchorAt = DateTime(0);

  @override
  void initState() {
    super.initState();
    _sync(jump: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No ticking while the tab is not shown.
    _active = TickerMode.valuesOf(context).enabled;
    _restartTimer();
  }

  @override
  void didUpdateWidget(_Progress oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(jump: widget.track.title != oldWidget.track.title || widget.track.isPlaying != oldWidget.track.isPlaying);
  }

  void _sync({required bool jump}) {
    final now = clock.now();
    final duration = widget.track.durationSeconds ?? 0;
    final position = widget.track.positionAtTime(now);
    _duration = position == null ? 0 : duration;
    if (_duration <= 0 || position == null) {
      _restartTimer();
      return;
    }
    if (jump || (position - _positionAt(now)).abs() > _tolerance) {
      _anchor = position;
      _anchorAt = now;
    }
    _tick();
    _restartTimer();
  }

  double _positionAt(DateTime now) {
    final elapsed = widget.track.isPlaying ? now.difference(_anchorAt).inMilliseconds / 1000 : 0.0;
    return (_anchor + elapsed).clamp(0, _duration.toDouble());
  }

  void _tick() {
    if (_duration <= 0) return;
    final position = _positionAt(clock.now());
    _played.value = position / _duration;
    _second.value = position.floor();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = null;
    if (!_active || !widget.track.isPlaying || _duration <= 0) return;
    final perPixel = _barWidth > 0 ? _duration * 1000 / _barWidth : 1000;
    _timer = Timer.periodic(Duration(milliseconds: perPixel.clamp(50, 1000).round()), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _played.dispose();
    _second.dispose();
    super.dispose();
  }

  static String _format(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_duration == 0) return const SizedBox(height: 18);
    final timeStyle = HubTextStyles.micro.copyWith(fontSize: 12, color: HubColorPalette.text2).tabular;
    return ValueListenableBuilder(
      valueListenable: _second,
      builder: (context, second, bar) => Row(
        spacing: 10,
        children: [
          SizedBox(width: 38, child: Text(_format(second), style: timeStyle)),
          Expanded(child: bar!),
          SizedBox(
            width: 44,
            child: Text('-${_format(_duration - second)}', textAlign: TextAlign.right, style: timeStyle),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth != _barWidth) {
            _barWidth = constraints.maxWidth;
            _restartTimer();
          }
          return RepaintBoundary(
            child: CustomPaint(size: const Size.fromHeight(5), painter: _BarPainter(_played)),
          );
        },
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.played) : super(repaint: played);

  final ValueListenable<double> played;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    canvas
      ..drawRRect(RRect.fromRectAndRadius(Offset.zero & size, radius), Paint()..color = const Color(0x38FFFFFF))
      ..drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width * played.value.clamp(0, 1), size.height), radius),
        Paint()..color = HubColorPalette.text,
      );
  }

  @override
  bool shouldRepaint(_BarPainter oldDelegate) => oldDelegate.played != played;
}

class _Transport extends StatelessWidget {
  const _Transport({
    required this.playing,
    required this.enabled,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
  });

  final bool playing;
  final bool enabled;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Row(
        spacing: 12,
        children: [
          _RoundButton(glyph: HubGlyph.previous, label: 'Previous', size: 48, onTap: enabled ? onPrevious : null),
          _RoundButton(
            glyph: playing ? HubGlyph.pause : HubGlyph.play,
            label: playing ? 'Pause' : 'Play',
            size: 64,
            light: true,
            onTap: enabled ? onPlayPause : null,
          ),
          _RoundButton(glyph: HubGlyph.next, label: 'Next', size: 48, onTap: enabled ? onNext : null),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.glyph, required this.label, required this.size, this.light = false, this.onTap});

  final HubGlyph glyph;
  final String label;
  final double size;
  final bool light;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: light ? HubColorPalette.text : const Color(0x26FFFFFF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: HubGlyphIcon(
            glyph,
            color: light ? HubColorPalette.surface : HubColorPalette.text,
            size: Size.square(size * 0.36),
          ),
        ),
      ),
    );
  }
}
