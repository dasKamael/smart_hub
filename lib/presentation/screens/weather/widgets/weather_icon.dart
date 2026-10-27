import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';

/// Colored weather symbol, drawn like the kit: yellow sun, pale moon, light cloud, blue rain.
class WeatherIcon extends StatelessWidget {
  const WeatherIcon(this.condition, {super.key, this.isDay = true, this.size = 24});

  final WeatherCondition condition;
  final bool isDay;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: condition.name,
      child: CustomPaint(
        size: Size.square(size),
        painter: _WeatherPainter(condition, isDay: isDay),
      ),
    );
  }
}

class _WeatherPainter extends CustomPainter {
  _WeatherPainter(this.condition, {required this.isDay});

  static const _sun = Color(0xFFFFD60A);
  static const _moon = Color(0xFFE5E5EA);
  static const _cloud = Color(0xFFE5E5EA);
  static const _darkCloud = Color(0xFFAEAEB2);
  static const _water = Color(0xFF64D2FF);
  static const _bolt = Color(0xFFFFD60A);

  final WeatherCondition condition;
  final bool isDay;

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn on a 24 × 24 grid.
    canvas.scale(size.width / 24);
    switch (condition) {
      case WeatherCondition.clear:
        isDay ? _paintSun(canvas, const Offset(12, 12), 5) : _paintMoon(canvas, const Offset(12, 12), 7);
      case WeatherCondition.partlyCloudy:
        isDay ? _paintSun(canvas, const Offset(8.5, 8.5), 4) : _paintMoon(canvas, const Offset(7.5, 7), 4.2);
        _paintCloud(canvas, const Offset(13.5, 15.5), 1, _cloud);
      case WeatherCondition.cloudy:
        _paintCloud(canvas, const Offset(12, 13), 1.15, _cloud);
      case WeatherCondition.fog:
        _paintCloud(canvas, const Offset(12, 10), 1, _darkCloud);
        final line = Paint()
          ..color = _darkCloud
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;
        canvas
          ..drawLine(const Offset(5, 17), const Offset(19, 17), line)
          ..drawLine(const Offset(7, 20.5), const Offset(17, 20.5), line);
      case WeatherCondition.drizzle || WeatherCondition.rain:
        _paintCloud(canvas, const Offset(12, 10), 1, _darkCloud);
        final drops = condition == WeatherCondition.rain ? const [7.5, 12.0, 16.5] : const [9.5, 14.5];
        final paint = Paint()
          ..color = _water
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;
        for (final x in drops) {
          canvas.drawLine(Offset(x, 16.5), Offset(x - 1.2, 20.5), paint);
        }
      case WeatherCondition.snow:
        _paintCloud(canvas, const Offset(12, 10), 1, _darkCloud);
        final flake = Paint()..color = _cloud;
        for (final (x, y) in const [(7.5, 18.0), (12.0, 20.5), (16.5, 18.0)]) {
          canvas.drawCircle(Offset(x, y), 1.4, flake);
        }
      case WeatherCondition.thunderstorm:
        _paintCloud(canvas, const Offset(12, 10), 1, _darkCloud);
        canvas.drawPath(
          Path()
            ..moveTo(12.8, 14)
            ..lineTo(9.6, 19)
            ..lineTo(12, 19)
            ..lineTo(10.8, 23)
            ..lineTo(14.6, 17.4)
            ..lineTo(12.2, 17.4)
            ..close(),
          Paint()..color = _bolt,
        );
    }
  }

  static void _paintSun(Canvas canvas, Offset center, double radius) {
    final paint = Paint()..color = _sun;
    canvas.drawCircle(center, radius, paint);
    final rays = Paint()
      ..color = _sun
      ..strokeWidth = radius * 0.32
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(center + direction * (radius * 1.45), center + direction * (radius * 1.9), rays);
    }
  }

  static void _paintMoon(Canvas canvas, Offset center, double radius) {
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
        Path()..addOval(Rect.fromCircle(center: center + Offset(radius * 0.55, -radius * 0.4), radius: radius * 0.85)),
      ),
      Paint()..color = _moon,
    );
  }

  /// A cloud about 15 × 9 units around [center], scaled by [scale].
  static void _paintCloud(Canvas canvas, Offset center, double scale, Color color) {
    final paint = Paint()..color = color;
    Offset at(double dx, double dy) => center + Offset(dx, dy) * scale;
    canvas
      ..drawCircle(at(-3.5, 1), 3.4 * scale, paint)
      ..drawCircle(at(0.5, -1.5), 4.4 * scale, paint)
      ..drawCircle(at(4.4, 1.2), 3.1 * scale, paint)
      ..drawRRect(
        RRect.fromRectAndRadius(Rect.fromPoints(at(-6.9, 0.8), at(7.5, 4.4)), Radius.circular(1.8 * scale)),
        paint,
      );
  }

  @override
  bool shouldRepaint(_WeatherPainter oldDelegate) => oldDelegate.condition != condition || oldDelegate.isDay != isDay;
}
