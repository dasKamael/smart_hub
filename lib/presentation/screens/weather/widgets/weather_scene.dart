import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';

/// The weather as a living scene behind the weather widget and the weather page: the sky of the condition and the
/// time of day, the sun or the moon and stars, drifting clouds, rain, snow, fog or a storm.
///
/// Ticks 30 times a second and stands still while it is not shown. A dark veil keeps text on it readable.
class WeatherScene extends StatefulWidget {
  const WeatherScene({super.key, required this.condition, required this.isDay, this.precipitation = 0});

  final WeatherCondition condition;
  final bool isDay;

  /// Millimetres in the current hour; more means denser, faster rain.
  final double precipitation;

  @override
  State<WeatherScene> createState() => _WeatherSceneState();
}

class _WeatherSceneState extends State<WeatherScene> {
  static const _tick = Duration(milliseconds: 33);

  /// Seconds of animation so far.
  final _time = ValueNotifier(0.0);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    _timer = TickerMode.valuesOf(context).enabled
        ? Timer.periodic(_tick, (_) => _time.value += _tick.inMilliseconds / 1000)
        : null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _ScenePainter(
          time: _time,
          condition: widget.condition,
          isDay: widget.isDay,
          precipitation: widget.precipitation,
        ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter({required this.time, required this.condition, required this.isDay, required this.precipitation})
    : super(repaint: time);

  final ValueNotifier<double> time;
  final WeatherCondition condition;
  final bool isDay;
  final double precipitation;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final rect = Offset.zero & size;
    final (top, bottom) = _skyOf(condition, isDay);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ).createShader(rect),
    );

    final clearish = condition == WeatherCondition.clear || condition == WeatherCondition.partlyCloudy;
    if (clearish && isDay) _sun(canvas, size, t);
    if (clearish && !isDay) {
      _stars(canvas, size, t);
      _moon(canvas, size, top);
    }
    switch (condition) {
      case WeatherCondition.clear:
        break;
      case WeatherCondition.partlyCloudy:
        _clouds(canvas, size, t, count: 2, color: Colors.white.withValues(alpha: isDay ? 0.55 : 0.18));
      case WeatherCondition.cloudy:
        _clouds(
          canvas,
          size,
          t,
          count: 4,
          color: (isDay ? const Color(0xFFB4BECB) : const Color(0xFF4A5468)).withValues(alpha: 0.6),
        );
      case WeatherCondition.fog:
        _fog(canvas, size, t);
      case WeatherCondition.drizzle:
        _clouds(canvas, size, t, count: 3, color: _rainCloud.withValues(alpha: 0.65));
        _rain(canvas, size, t, density: 0.35, speed: 0.7, length: 0.7);
      case WeatherCondition.rain:
        final heavy = precipitation >= 2.5;
        _clouds(canvas, size, t, count: 4, color: _rainCloud.withValues(alpha: 0.75));
        _rain(canvas, size, t, density: heavy ? 1.6 : 1, speed: heavy ? 1.3 : 1, length: heavy ? 1.4 : 1);
      case WeatherCondition.snow:
        _clouds(
          canvas,
          size,
          t,
          count: 3,
          color: (isDay ? const Color(0xFFCDD6E2) : const Color(0xFF55607A)).withValues(alpha: 0.55),
        );
        _snow(canvas, size, t);
      case WeatherCondition.thunderstorm:
        _clouds(canvas, size, t, count: 4, color: const Color(0xFF2A303D).withValues(alpha: 0.85));
        _rain(canvas, size, t, density: 1.4, speed: 1.25, length: 1.3);
        _flash(canvas, size, t);
    }

    // Keeps temperature and text readable on every sky.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x14000000), Color(0x52000000)],
        ).createShader(rect),
    );
  }

  Color get _rainCloud => isDay ? const Color(0xFF7D8898) : const Color(0xFF3A4252);

  static (Color, Color) _skyOf(WeatherCondition condition, bool isDay) {
    return switch ((condition, isDay)) {
      (WeatherCondition.clear, true) => (const Color(0xFF3F7DC2), const Color(0xFF1F426E)),
      (WeatherCondition.clear, false) => (const Color(0xFF0E1A36), const Color(0xFF060A18)),
      (WeatherCondition.partlyCloudy, true) => (const Color(0xFF4877A8), const Color(0xFF223A5C)),
      (WeatherCondition.partlyCloudy, false) => (const Color(0xFF131C35), const Color(0xFF080C1A)),
      (WeatherCondition.cloudy, true) => (const Color(0xFF55657A), const Color(0xFF2B3544)),
      (WeatherCondition.cloudy, false) => (const Color(0xFF1C2232), const Color(0xFF0C1018)),
      (WeatherCondition.fog, true) => (const Color(0xFF707A86), const Color(0xFF3B434E)),
      (WeatherCondition.fog, false) => (const Color(0xFF282D36), const Color(0xFF12151A)),
      (WeatherCondition.drizzle || WeatherCondition.rain, true) => (const Color(0xFF41506A), const Color(0xFF1F2834)),
      (WeatherCondition.drizzle || WeatherCondition.rain, false) => (const Color(0xFF161D2A), const Color(0xFF0A0E15)),
      (WeatherCondition.snow, true) => (const Color(0xFF71829A), const Color(0xFF3A475A)),
      (WeatherCondition.snow, false) => (const Color(0xFF1F2839), const Color(0xFF0E1221)),
      (WeatherCondition.thunderstorm, true) => (const Color(0xFF323A4C), const Color(0xFF161A25)),
      (WeatherCondition.thunderstorm, false) => (const Color(0xFF151A27), const Color(0xFF07090F)),
    };
  }

  /// A pseudo random number 0–1 that is the same for the same [i] and [salt], so particles keep their place.
  static double _rand(int i, int salt) {
    final x = math.sin(i * 12.9898 + salt * 78.233) * 43758.5453;
    return x - x.floorToDouble();
  }

  void _sun(Canvas canvas, Size size, double t) {
    final center = Offset(size.width * 0.82, size.height * 0.22);
    final r = size.shortestSide * 0.09;
    final pulse = 1 + 0.08 * math.sin(2 * math.pi * t / 6);
    final glow = r * 4.2 * pulse;
    canvas.drawCircle(
      center,
      glow,
      Paint()
        ..shader = RadialGradient(colors: [const Color(0xFFFFE7A0).withValues(alpha: 0.55), const Color(0x00FFE7A0)])
            .createShader(Rect.fromCircle(center: center, radius: glow)),
    );
    canvas.drawCircle(center, r, Paint()..color = const Color(0xFFFFF1C4));
  }

  void _moon(Canvas canvas, Size size, Color sky) {
    final center = Offset(size.width * 0.8, size.height * 0.22);
    final r = size.shortestSide * 0.075;
    canvas.drawCircle(
      center,
      r * 3,
      Paint()
        ..shader = RadialGradient(colors: [const Color(0x33DCE6FF), const Color(0x00DCE6FF)])
            .createShader(Rect.fromCircle(center: center, radius: r * 3)),
    );
    canvas.saveLayer(Rect.fromCircle(center: center, radius: r * 1.2), Paint());
    canvas.drawCircle(center, r, Paint()..color = const Color(0xFFE9EEF8));
    canvas.drawCircle(center + Offset(r * 0.45, -r * 0.2), r * 0.85, Paint()..blendMode = BlendMode.dstOut);
    canvas.restore();
  }

  void _stars(Canvas canvas, Size size, double t) {
    final count = (size.width * size.height / 2600).round().clamp(20, 120);
    final paint = Paint();
    for (var i = 0; i < count; i++) {
      final twinkle = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(t * (0.8 + _rand(i, 3) * 1.6) + _rand(i, 4) * 6.28));
      paint.color = Colors.white.withValues(alpha: 0.85 * twinkle);
      canvas.drawCircle(
        Offset(_rand(i, 1) * size.width, _rand(i, 2) * size.height * 0.75),
        0.6 + _rand(i, 5) * 1.1,
        paint,
      );
    }
  }

  /// Soft clouds drifting to the right; the back ones are smaller and slower.
  void _clouds(Canvas canvas, Size size, double t, {required int count, required Color color}) {
    final paint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, size.shortestSide * 0.035);
    for (var i = 0; i < count; i++) {
      final depth = (i + 1) / count;
      final width = size.width * (0.45 + 0.25 * depth);
      final speed = size.width * (0.006 + 0.012 * depth);
      final span = size.width + width;
      final x = (_rand(i, 7) * span + t * speed) % span - width * 0.5;
      final y = size.height * (0.08 + 0.3 * _rand(i, 8));
      paint.color = color.withValues(alpha: color.a * (0.55 + 0.45 * depth));
      final h = width * 0.28;
      for (final (dx, dy, r) in const [(0.0, 0.0, 0.5), (0.28, -0.25, 0.42), (0.55, 0.0, 0.5), (0.8, 0.1, 0.36)]) {
        canvas.drawCircle(Offset(x + width * dx, y + h * dy), h * r * 1.6, paint);
      }
    }
  }

  void _rain(
    Canvas canvas,
    Size size,
    double t, {
    required double density,
    required double speed,
    required double length,
  }) {
    final count = (size.width * size.height / 1900 * density).round().clamp(12, 260);
    final paint = Paint()
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: isDay ? 0.38 : 0.26);
    const slant = 0.2;
    for (var i = 0; i < count; i++) {
      final dropLength = (10 + 12 * _rand(i, 11)) * length;
      final fall = size.height * (1.2 + 0.6 * _rand(i, 12)) * speed;
      final span = size.height + dropLength;
      final y = (_rand(i, 13) * span + t * fall) % span - dropLength;
      final x = (_rand(i, 14) * (size.width + size.height * slant)) - y * slant;
      canvas.drawLine(Offset(x, y), Offset(x - dropLength * slant, y + dropLength), paint);
    }
  }

  void _snow(Canvas canvas, Size size, double t) {
    final count = (size.width * size.height / 2400).round().clamp(15, 140);
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    for (var i = 0; i < count; i++) {
      final r = 1.2 + 1.6 * _rand(i, 21);
      final fall = size.height * (0.12 + 0.12 * _rand(i, 22)) * (r / 2);
      final span = size.height + 6;
      final y = (_rand(i, 23) * span + t * fall) % span - 3;
      final x = _rand(i, 24) * size.width + 8 * math.sin(t * (0.6 + _rand(i, 25)) + i);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  void _fog(Canvas canvas, Size size, double t) {
    final paint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, size.height * 0.06);
    for (var i = 0; i < 4; i++) {
      final width = size.width * 1.2;
      final x = (t * size.width * (0.008 + 0.006 * i) + _rand(i, 31) * width) % (width * 2) - width;
      final y = size.height * (0.25 + 0.18 * i);
      paint.color = Colors.white.withValues(alpha: isDay ? 0.16 : 0.08);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, width, size.height * 0.12), Radius.circular(size.height * 0.06)),
        paint,
      );
    }
  }

  /// Every 14 s a soft double flash brightens the clouds.
  void _flash(Canvas canvas, Size size, double t) {
    final phase = t % 14;
    final strength = switch (phase) {
      < 0.12 => phase / 0.12,
      < 0.3 => 1 - (phase - 0.12) / 0.18,
      < 0.42 => 0.6 * (phase - 0.3) / 0.12,
      < 0.7 => 0.6 * (1 - (phase - 0.42) / 0.28),
      _ => 0.0,
    };
    if (strength <= 0) return;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFDDE6FF).withValues(alpha: 0.28 * strength));
  }

  @override
  bool shouldRepaint(_ScenePainter oldDelegate) =>
      oldDelegate.condition != condition || oldDelegate.isDay != isDay || oldDelegate.precipitation != precipitation;
}
