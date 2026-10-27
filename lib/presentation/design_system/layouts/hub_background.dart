import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_sky.dart';

/// The calm sky behind every page: a gradient in the colors of the time of day with two soft glows drifting
/// slowly over it.
///
/// Ticks 15 times a second instead of every frame and stands still while the page is not shown – ambience on a
/// screen that is on all day.
class HubBackground extends StatefulWidget {
  const HubBackground({super.key, this.child});

  final Widget? child;

  @override
  State<HubBackground> createState() => _HubBackgroundState();
}

class _HubBackgroundState extends State<HubBackground> {
  static const _tick = Duration(milliseconds: 66);

  /// Seconds of drift so far.
  final _phase = ValueNotifier(0.0);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    _timer = TickerMode.valuesOf(context).enabled
        ? Timer.periodic(_tick, (_) => _phase.value += _tick.inMilliseconds / 1000)
        : null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(child: CustomPaint(painter: _SkyPainter(_phase))),
        ?widget.child,
      ],
    );
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter(this.phase) : super(repaint: phase);

  final ValueNotifier<double> phase;

  @override
  void paint(Canvas canvas, Size size) {
    final sky = HubSky.at(clock.now());
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [sky.top, sky.bottom],
        ).createShader(rect),
    );
    final t = phase.value;
    // Different periods per glow, so the pattern never repeats visibly; one glow stays in the upper half.
    void glow(Color color, double periodX, double periodY, double x, double y, double radius) {
      final center = Offset(
        size.width * (x + 0.22 * math.sin(2 * math.pi * t / periodX)),
        size.height * (y + 0.16 * math.cos(2 * math.pi * t / periodY)),
      );
      final r = size.longestSide * radius;
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(colors: [color.withValues(alpha: 0.55), color.withValues(alpha: 0)])
              .createShader(Rect.fromCircle(center: center, radius: r)),
      );
    }

    glow(sky.glow, 83, 67, 0.25, 0.2, 0.55);
    glow(sky.glow2, 97, 71, 0.78, 0.65, 0.5);
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) => false;
}
