import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';

/// Progress bar with elapsed and remaining time. While playing the bar moves on whenever it would cover one more
/// pixel – smooth to the eye, but only a few frames per second on a screen that is on all day.
class TrackProgress extends StatefulWidget {
  const TrackProgress({super.key, required this.track, this.showTimes = true});

  final NowPlaying track;

  /// Elapsed and remaining time next to the bar; off where there is no room.
  final bool showTimes;

  @override
  State<TrackProgress> createState() => _TrackProgressState();
}

class _TrackProgressState extends State<TrackProgress> {
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
    if (_duration == 0) return SizedBox(height: widget.showTimes ? 18 : 5);
    final bar = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth != _barWidth) {
          _barWidth = constraints.maxWidth;
          _restartTimer();
        }
        return RepaintBoundary(
          child: CustomPaint(size: const Size.fromHeight(5), painter: _BarPainter(_played)),
        );
      },
    );
    if (!widget.showTimes) return bar;
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
      child: bar,
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
