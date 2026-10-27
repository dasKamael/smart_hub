import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_sky.dart';

/// The calm sky behind every page: a gradient in the colors of the time of day with two soft glows drifting
/// slowly over it. With a [tint] (the page's area color) the glows take on that color; a new tint blends in.
///
/// Ticks 15 times a second instead of every frame and stands still while the page is not shown – ambience on a
/// screen that is on all day.
class HubBackground extends StatefulWidget {
  const HubBackground({super.key, this.child, this.tint});

  final Widget? child;
  final Color? tint;

  @override
  State<HubBackground> createState() => _HubBackgroundState();
}

class _HubBackgroundState extends State<HubBackground> {
  static const _tick = Duration(milliseconds: 66);
  static const _blend = Duration(milliseconds: 1200);

  /// Seconds of drift so far.
  final _phase = ValueNotifier(0.0);
  Timer? _timer;

  /// The tint blends from [_from] to the widget's over [_blend].
  Color? _from;
  late var _changedAt = clock.now();

  @override
  void didUpdateWidget(HubBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tint != widget.tint) {
      _from = _tintAt(clock.now(), oldWidget.tint);
      _changedAt = clock.now();
    }
  }

  /// How much of the tint shows (0–1) and its color right now.
  Color? _tintAt(DateTime now, Color? to) {
    final t = (now.difference(_changedAt).inMilliseconds / _blend.inMilliseconds).clamp(0.0, 1.0);
    return switch ((_from, to)) {
      (null, null) => null,
      (final from?, null) => from.withValues(alpha: from.a * (1 - t)),
      (null, final to?) => to.withValues(alpha: to.a * t),
      (final from?, final to?) => Color.lerp(from, to, t),
    };
  }

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
        RepaintBoundary(
          child: CustomPaint(painter: _SkyPainter(_phase, tint: () => _tintAt(clock.now(), widget.tint))),
        ),
        ?widget.child,
      ],
    );
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter(this.phase, {required this.tint}) : super(repaint: phase);

  final ValueNotifier<double> phase;
  final Color? Function() tint;

  @override
  void paint(Canvas canvas, Size size) {
    final sky = HubSky.at(clock.now());
    // The area color in a deep, saturated tone, so it colors the sky instead of washing it grey; its alpha says how
    // far a change has blended in.
    final tint = this.tint();
    Color tinted(Color glow) {
      if (tint == null) return glow;
      final hsl = HSLColor.fromColor(tint.withValues(alpha: 1));
      final deep = hsl.withLightness(0.32).withSaturation(math.min(1, hsl.saturation * 1.25)).toColor();
      return Color.lerp(glow, deep, 0.55 * tint.a)!;
    }

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

    glow(tinted(sky.glow), 83, 67, 0.25, 0.2, 0.55);
    glow(tinted(sky.glow2), 97, 71, 0.78, 0.65, 0.5);
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) => false;
}
