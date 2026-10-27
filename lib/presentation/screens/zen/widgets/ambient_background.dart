import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

/// Soft color clouds in the colors of the cover that drift slowly; a new cover blends its colors in.
///
/// Ticks 20 times a second instead of every frame, and slower while paused – ambience on a screen that is on all day.
/// Stands still while the zen mode is not shown.
class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key, required this.colors, required this.playing});

  final List<Color> colors;
  final bool playing;

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground> {
  static const _tick = Duration(milliseconds: 50);
  static const _blend = Duration(seconds: 3);

  /// Seconds of drift so far; runs at a third of the speed while paused.
  final _phase = ValueNotifier(0.0);
  late List<Color> _from = widget.colors;
  late DateTime _changedAt = clock.now();
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    _timer = TickerMode.valuesOf(context).enabled
        ? Timer.periodic(_tick, (_) => _phase.value += _tick.inMilliseconds / 1000 * (widget.playing ? 1 : 0.35))
        : null;
  }

  @override
  void didUpdateWidget(AmbientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.colors != widget.colors) {
      _from = _colorsAt(clock.now(), oldWidget.colors);
      _changedAt = clock.now();
    }
  }

  List<Color> _colorsAt(DateTime now, List<Color> to) {
    final t = (now.difference(_changedAt).inMilliseconds / _blend.inMilliseconds).clamp(0.0, 1.0);
    return [for (var i = 0; i < to.length; i++) Color.lerp(_from[math.min(i, _from.length - 1)], to[i], t) ?? to[i]];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _CloudsPainter(phase: _phase, colors: () => _colorsAt(clock.now(), widget.colors)),
      ),
    );
  }
}

class _CloudsPainter extends CustomPainter {
  _CloudsPainter({required this.phase, required this.colors}) : super(repaint: phase);

  final ValueNotifier<double> phase;
  final List<Color> Function() colors;

  /// Periods in seconds per cloud, different so the pattern never repeats visibly.
  static const _periods = [(47.0, 61.0), (71.0, 53.0), (59.0, 83.0), (89.0, 67.0)];

  @override
  void paint(Canvas canvas, Size size) {
    final palette = colors();
    final base = HSVColor.fromColor(palette.first);
    canvas.drawRect(Offset.zero & size, Paint()..color = base.withValue(base.value * 0.22).toColor());
    final t = phase.value;
    for (final (i, (periodX, periodY)) in _periods.indexed) {
      final color = palette[i % palette.length];
      final center = Offset(
        size.width * (0.5 + 0.42 * math.sin(2 * math.pi * t / periodX + i * 1.7)),
        size.height * (0.5 + 0.4 * math.cos(2 * math.pi * t / periodY + i * 2.3)),
      );
      final radius = size.longestSide * (0.42 + 0.08 * math.sin(2 * math.pi * t / (periodX + periodY) + i));
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(colors: [color.withValues(alpha: 0.7), color.withValues(alpha: 0)])
              .createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }
    // Keeps the time and text on the left readable.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(colors: [Color(0xB3000000), Color(0x1A000000)])
            .createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_CloudsPainter oldDelegate) => true;
}

/// Background while the zen mode has no colors yet.
const ambientFallback = [HubColorPalette.surface, HubColorPalette.elevated, HubColorPalette.control];
