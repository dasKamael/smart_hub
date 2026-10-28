import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';

/// Progress bar with elapsed and remaining time. While playing it follows the display's frames but only repaints when
/// the bar has grown by a whole device pixel – smooth to the eye, a few repaints a second on a screen that is on all
/// day.
///
/// With [onSeek] the bar can be dragged: it thickens and shows a grip under the finger, and the jump is sent once on
/// release. A tap alone does not jump.
class TrackProgress extends StatefulWidget {
  const TrackProgress({super.key, required this.track, this.showTimes = true, this.onSeek});

  final NowPlaying track;

  /// Elapsed and remaining time next to the bar; off where there is no room.
  final bool showTimes;

  /// Jumps to the given second of the track.
  final ValueChanged<int>? onSeek;

  @override
  State<TrackProgress> createState() => _TrackProgressState();
}

class _TrackProgressState extends State<TrackProgress> with TickerProviderStateMixin {
  /// Differences up to this are polling and clock drift; the bar keeps running instead of jumping.
  static const _tolerance = 1.5;

  /// Played part of the track, 0–1.
  final _played = ValueNotifier(0.0);
  final _second = ValueNotifier(0);
  late final _ticker = createTicker((_) => _tick());
  late final _grip = AnimationController(vsync: this, duration: HubMotion.fadeDuration);

  /// Where the finger holds the bar, 0–1; `null` while it is not dragged.
  double? _dragged;
  var _duration = 0;
  var _barWidth = 0.0;
  var _devicePixelRatio = 1.0;

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
    _devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
  }

  @override
  void didUpdateWidget(TrackProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(jump: widget.track.title != oldWidget.track.title || widget.track.isPlaying != oldWidget.track.isPlaying);
  }

  void _sync({required bool jump}) {
    final now = clock.now();
    final duration = widget.track.durationSeconds ?? 0;
    final position = widget.track.positionAtTime(now);
    _duration = position == null ? 0 : duration;
    if (_duration <= 0 || position == null) {
      _restartTicker();
      return;
    }
    if (jump || (position - _positionAt(now)).abs() > _tolerance) {
      _anchor = position;
      _anchorAt = now;
    }
    _tick();
    _restartTicker();
  }

  double _positionAt(DateTime now) {
    final elapsed = widget.track.isPlaying ? now.difference(_anchorAt).inMilliseconds / 1000 : 0.0;
    return (_anchor + elapsed).clamp(0, _duration.toDouble());
  }

  void _tick() {
    if (_duration <= 0 || _dragged != null) return;
    final position = _positionAt(clock.now());
    final played = position / _duration;
    // A repaint only once the bar covers one more device pixel.
    if (_barWidth == 0 || (played - _played.value).abs() * _barWidth * _devicePixelRatio >= 1) _played.value = played;
    _second.value = position.floor();
  }

  /// Ticks only while playing; the ticker stays quiet while the tab or the page is not shown.
  void _restartTicker() {
    final run = widget.track.isPlaying && _duration > 0;
    if (run && !_ticker.isActive) unawaited(_ticker.start());
    if (!run && _ticker.isActive) _ticker.stop();
  }

  void _drag(double x) {
    final dragged = (x / _barWidth).clamp(0.0, 1.0);
    _dragged = dragged;
    _played.value = dragged;
    _second.value = (dragged * _duration).round();
  }

  void _release() {
    final dragged = _dragged;
    if (dragged == null) return;
    final seconds = (dragged * _duration).round();
    _dragged = null;
    unawaited(_grip.reverse());
    // The bar stays where it was let go and runs on from there.
    _anchor = seconds.toDouble();
    _anchorAt = clock.now();
    _tick();
    widget.onSeek?.call(seconds);
  }

  @override
  void dispose() {
    _grip.dispose();
    _ticker.dispose();
    _played.dispose();
    _second.dispose();
    super.dispose();
  }

  /// Height of the draggable bar: room for a finger, the bar itself stays thin.
  static const _touchHeight = 28.0;

  static String _format(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_duration == 0) return SizedBox(height: widget.showTimes ? 18 : 5);
    final bar = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth != _barWidth) {
          _barWidth = constraints.maxWidth;
          _restartTicker();
        }
        final painted = RepaintBoundary(
          child: CustomPaint(
            size: Size.fromHeight(widget.onSeek == null ? 5 : _touchHeight),
            painter: _BarPainter(_played, grip: _grip),
          ),
        );
        if (widget.onSeek == null) return painted;
        return Semantics(
          slider: true,
          label: 'Position',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // Only a moving finger jumps: alone on screen the drag also starts for a plain tap.
            onHorizontalDragUpdate: (details) {
              if (_dragged == null) unawaited(_grip.forward());
              _drag(details.localPosition.dx);
            },
            onHorizontalDragEnd: (_) => _release(),
            onHorizontalDragCancel: _release,
            child: painted,
          ),
        );
      },
    );
    if (!widget.showTimes) return bar;
    final timeStyle = HubTextStyles.micro.copyWith(fontSize: 12, color: HubColorPalette.text2).tabular;
    return ListenableBuilder(
      listenable: Listenable.merge([_second, _grip]),
      builder: (context, bar) => Row(
        spacing: 10,
        children: [
          // While dragging, the time the finger points at stands out.
          SizedBox(
            width: 44,
            child: Text(
              _format(_second.value),
              style: timeStyle.copyWith(
                fontSize: 12 + 4 * _grip.value,
                color: Color.lerp(HubColorPalette.text2, HubColorPalette.text, _grip.value),
              ),
            ),
          ),
          Expanded(child: bar!),
          SizedBox(
            width: 44,
            child: Text('-${_format(_duration - _second.value)}', textAlign: TextAlign.right, style: timeStyle),
          ),
        ],
      ),
      child: bar,
    );
  }
}

/// The bar, vertically centered; while [grip] runs it thickens and a grip shows at the played end.
class _BarPainter extends CustomPainter {
  _BarPainter(this.played, {required this.grip}) : super(repaint: Listenable.merge([played, grip]));

  final ValueListenable<double> played;
  final Animation<double> grip;

  @override
  void paint(Canvas canvas, Size size) {
    final held = Curves.easeOut.transform(grip.value);
    final height = 5 + 4 * held;
    final track = Rect.fromLTWH(0, (size.height - height) / 2, size.width, height);
    final radius = Radius.circular(height / 2);
    final end = size.width * played.value.clamp(0, 1);
    canvas
      ..drawRRect(RRect.fromRectAndRadius(track, radius), Paint()..color = const Color(0x38FFFFFF))
      ..drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTRB(0, track.top, end, track.bottom), radius),
        Paint()..color = HubColorPalette.text,
      );
    if (held > 0) {
      final center = Offset(end.clamp(0, size.width), size.height / 2);
      canvas
        ..drawCircle(
          center,
          11 * held,
          Paint()
            ..color = const Color(0x40000000)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        )
        ..drawCircle(center, 10 * held, Paint()..color = HubColorPalette.text);
    }
  }

  @override
  bool shouldRepaint(_BarPainter oldDelegate) => oldDelegate.played != played || oldDelegate.grip != grip;
}
