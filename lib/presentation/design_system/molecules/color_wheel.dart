import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// The color wheel as in the lights app of the bridge: natural tones round the rim, red at the top left running
/// clockwise, softer towards a wide white middle. Converts between colors and places on a wheel of [size].
abstract final class ColorWheelScale {
  static const _redAngle = -110 * math.pi / 180;

  /// How quickly the colors get saturated from the white center to the rim.
  static const _falloff = 1.7;

  /// The rim, clockwise from red: softer, natural tones with more room for the warm ones (as lamps show them).
  static const _rim = [
    (0.00, Color(0xFFE5322A)),
    (0.07, Color(0xFFEE7A2E)),
    (0.15, Color(0xFFF4B33C)),
    (0.22, Color(0xFFF7E64B)),
    (0.32, Color(0xFFB8F048)),
    (0.42, Color(0xFF6EEA5A)),
    (0.52, Color(0xFF67EBC8)),
    (0.60, Color(0xFF5CCDF2)),
    (0.68, Color(0xFF3F7DF0)),
    (0.76, Color(0xFF4B33F2)),
    (0.84, Color(0xFF9A2EF0)),
    (0.91, Color(0xFFE33AC9)),
    (0.96, Color(0xFFEC3B8A)),
    (1.00, Color(0xFFE5322A)),
  ];

  static const CustomPainter painter = _HuePainter();

  /// The rim color at [fraction] of the way round.
  static Color rimAt(double fraction) {
    for (var i = 1; i < _rim.length; i++) {
      final (to, toColor) = _rim[i];
      if (fraction > to) continue;
      final (from, fromColor) = _rim[i - 1];
      return Color.lerp(fromColor, toColor, (fraction - from) / (to - from))!;
    }
    return _rim.last.$2;
  }

  /// The color at [local]: the rim color, whiter towards the middle.
  static Color colorAt(Offset local, double size) {
    final radius = size / 2;
    final offset = local - Offset(radius, radius);
    final fraction = ((math.atan2(offset.dy, offset.dx) - _redAngle) / (2 * math.pi) % 1 + 1) % 1;
    final distance = (offset.distance / radius).clamp(0.0, 1.0);
    return Color.lerp(Colors.white, rimAt(fraction), math.pow(distance, _falloff).toDouble())!;
  }

  /// Where [color] sits: round to the rim tone of the same hue, out as far as it is saturated.
  static Offset positionOf(Color color, double size) {
    final hsv = HSVColor.fromColor(color);
    var best = 0.0;
    var bestDistance = double.infinity;
    for (var step = 0; step < 360; step++) {
      final hue = HSVColor.fromColor(rimAt(step / 360)).hue;
      final distance = math.min((hue - hsv.hue).abs(), 360 - (hue - hsv.hue).abs());
      if (distance < bestDistance) {
        bestDistance = distance;
        best = step / 360;
      }
    }
    final rimSaturation = HSVColor.fromColor(rimAt(best)).saturation;
    final reach = math.pow((hsv.saturation / rimSaturation).clamp(0.0, 1.0), 1 / _falloff).toDouble();
    final angle = _redAngle + best * 2 * math.pi;
    final radius = size / 2;
    return Offset(radius, radius) + Offset(math.cos(angle), math.sin(angle)) * reach * radius;
  }
}

/// The white light wheel: cool white at the top, warm white at the bottom, within a range of color temperatures.
/// Only the height counts, so lamps can sit side by side.
final class WhiteWheelScale {
  const WhiteWheelScale({required this.minKelvin, required this.maxKelvin, required this.colorOf});

  final int minKelvin;
  final int maxKelvin;

  /// The color white light of a temperature looks like.
  final Color Function(int kelvin) colorOf;

  CustomPainter get painter =>
      _WhitePainter(top: colorOf(maxKelvin), middle: colorOf((minKelvin + maxKelvin) ~/ 2), bottom: colorOf(minKelvin));

  int kelvinAt(Offset local, double size) {
    final t = (local.dy / size).clamp(0.0, 1.0);
    return ((maxKelvin - (maxKelvin - minKelvin) * t) / 50).round() * 50;
  }

  /// The height of [kelvin], kept a little inside the rim.
  double heightOf(int kelvin, double size) {
    final range = (maxKelvin - minKelvin).clamp(1, 100000);
    final t = ((kelvin - minKelvin) / range).clamp(0.0, 1.0);
    return (size * (1 - t)).clamp(size * 0.08, size * 0.92);
  }
}

/// One marker on a [PinWheel]: a lamp, or a group of lamps that move together.
final class WheelPin {
  const WheelPin({
    required this.id,
    required this.position,
    required this.color,
    required this.label,
    this.count = 1,
    this.selected = false,
  });

  final String id;
  final Offset position;
  final Color color;
  final String label;

  /// More than one: a group, showing the number instead of the lamp.
  final int count;
  final bool selected;
}

/// A wheel with a pin per lamp or group (as in the lights app of the bridge): drag a pin to change its color, drop it
/// on another to group them, tap a group to take it apart, tap a single pin to select it.
class PinWheel extends StatefulWidget {
  const PinWheel({
    super.key,
    required this.background,
    required this.pins,
    required this.colorAt,
    required this.onMove,
    required this.onMoveEnd,
    required this.onMerge,
    required this.onTap,
    this.enabled = true,
    this.size = 320,
  });

  final CustomPainter background;
  final List<WheelPin> pins;

  /// The color under a place, so a dragged pin shows it at once.
  final Color Function(Offset local) colorAt;
  final void Function(String id, Offset local) onMove;
  final void Function(String id, Offset local) onMoveEnd;

  /// [dropped] was let go on [target].
  final void Function(String dropped, String target) onMerge;
  final ValueChanged<String> onTap;
  final bool enabled;
  final double size;

  @override
  State<PinWheel> createState() => _PinWheelState();
}

class _PinWheelState extends State<PinWheel> {
  /// Pins closer than this when one is let go form a group.
  static const _mergeDistance = 34.0;

  String? _dragged;
  Offset? _drag;
  var _down = Offset.zero;

  Offset _inside(Offset local) {
    final radius = widget.size / 2;
    final center = Offset(radius, radius);
    final offset = local - center;
    return offset.distance <= radius ? local : center + offset / offset.distance * radius;
  }

  /// The pin whose drop or tip is under [local], the topmost (last drawn) first.
  WheelPin? _pinAt(Offset local) {
    for (final pin in widget.pins.reversed) {
      final body = Rect.fromLTWH(pin.position.dx - _Pin.tip.dx, pin.position.dy - _Pin.tip.dy, _Pin.width, _Pin.height);
      if (body.inflate(6).contains(local)) return pin;
    }
    return null;
  }

  void _start(Offset local) {
    final pin = _pinAt(local);
    if (pin == null) return;
    setState(() {
      _dragged = pin.id;
      _drag = pin.position;
    });
  }

  void _update(DragUpdateDetails details) {
    final id = _dragged;
    final drag = _drag;
    if (id == null || drag == null) return;
    final moved = _inside(drag + details.delta);
    setState(() => _drag = moved);
    widget.onMove(id, moved);
  }

  void _end() {
    final id = _dragged;
    final drag = _drag;
    setState(() {
      _dragged = null;
      _drag = null;
    });
    if (id == null || drag == null) return;
    final target = widget.pins
        .where((pin) => pin.id != id && (pin.position - drag).distance < _mergeDistance)
        .firstOrNull;
    if (target != null) {
      widget.onMerge(id, target.id);
    } else {
      widget.onMoveEnd(id, drag);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    // The dragged pin on top.
    final pins = [...widget.pins.where((pin) => pin.id != _dragged), ...widget.pins.where((pin) => pin.id == _dragged)];
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: enabled
            ? (details) {
                if (_pinAt(details.localPosition) case final pin?) widget.onTap(pin.id);
              }
            : null,
        // Where the finger went down picks the pin; the drag starts only after a few pixels.
        onPanDown: enabled ? (details) => _down = details.localPosition : null,
        onPanStart: enabled ? (_) => _start(_down) : null,
        onPanUpdate: enabled ? _update : null,
        onPanEnd: enabled ? (_) => _end() : null,
        onPanCancel: enabled ? _end : null,
        child: SizedBox.square(
          dimension: widget.size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(child: CustomPaint(painter: widget.background)),
              for (final pin in pins)
                AnimatedPositioned(
                  key: ValueKey(pin.id),
                  // Follows the finger at once; changes from the lamps glide there.
                  duration: pin.id == _dragged ? Duration.zero : const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  left: (pin.id == _dragged ? _drag! : pin.position).dx - _Pin.tip.dx,
                  top: (pin.id == _dragged ? _drag! : pin.position).dy - _Pin.tip.dy,
                  child: IgnorePointer(
                    child: Semantics(
                      container: true,
                      label: pin.label,
                      selected: pin.selected,
                      // The count on a group pin is part of the label already.
                      excludeSemantics: true,
                      child: _Pin(
                        color: pin.id == _dragged ? widget.colorAt(_drag!) : pin.color,
                        count: pin.count,
                        selected: pin.selected,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HuePainter extends CustomPainter {
  const _HuePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    // Many stops so the tones blend without visible steps; a slight blur hides where the circle closes.
    canvas
      ..save()
      ..clipPath(Path()..addOval(rect));
    canvas.drawCircle(
      center,
      radius + 6,
      Paint()
        ..imageFilter = ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5)
        ..shader = SweepGradient(
          transform: const GradientRotation(ColorWheelScale._redAngle),
          stops: [for (var i = 0; i <= 72; i++) i / 72],
          colors: [for (var i = 0; i <= 72; i++) ColorWheelScale.rimAt(i / 72)],
        ).createShader(rect),
    );
    canvas.restore();
    // White towards the middle; the stops follow the same curve the picked colors use.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          stops: [for (var i = 0; i <= 20; i++) i / 20],
          colors: [
            for (var i = 0; i <= 20; i++)
              Colors.white.withValues(alpha: 1 - math.pow(i / 20, ColorWheelScale._falloff).toDouble()),
          ],
        ).createShader(rect),
    );
    _drawRim(canvas, center, radius);
  }

  @override
  bool shouldRepaint(_HuePainter oldDelegate) => false;
}

/// A fine light edge, so the wheel looks finished on the dark dialog.
void _drawRim(Canvas canvas, Offset center, double radius) {
  canvas.drawCircle(
    center,
    radius - 0.75,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0x2EFFFFFF),
  );
}

class _WhitePainter extends CustomPainter {
  _WhitePainter({required this.top, required this.middle, required this.bottom});

  final Color top;
  final Color middle;
  final Color bottom;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, middle, bottom],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    _drawRim(canvas, center, radius);
  }

  @override
  bool shouldRepaint(_WhitePainter oldDelegate) =>
      oldDelegate.top != top || oldDelegate.middle != middle || oldDelegate.bottom != bottom;
}

/// The marker: a pin with a lamp in the picked color, its tip on the exact spot.
class _Pin extends StatelessWidget {
  const _Pin({required this.color, this.count = 1, this.selected = false});

  static const width = 64.0;
  static const height = 80.0;

  /// The round head and where the drop narrows to.
  static const head = Offset(width / 2, 28);
  static const headRadius = 24.0;
  static const point = Offset(width / 2, 64);

  /// The exact spot: a small dot right under the point.
  static const tip = Offset(width / 2, 70);

  final Color color;

  /// More than one: a group, showing the number.
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final fill = Color.lerp(color, Colors.white, 0.12)!;
    const ink = Color(0xD91B2230);
    return AnimatedScale(
      scale: selected ? 1.1 : 1,
      alignment: Alignment(0, tip.dy / height * 2 - 1),
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _PinPainter(fill, selected: selected),
          child: Align(
            alignment: Alignment(0, head.dy / height * 2 - 1),
            child: count > 1
                ? Text(
                    '$count',
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                    style: HubTextStyles.body.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      color: ink,
                    ),
                  )
                : const HubGlyphIcon(HubGlyph.bulb, color: ink, size: Size(15, 19)),
          ),
        ),
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  _PinPainter(this.fill, {required this.selected});

  final Color fill;
  final bool selected;

  /// A drop: the round head narrowing smoothly to the point, the sides tangent to the circle.
  static Path _drop(Offset shift) {
    const c = _Pin.head;
    const r = _Pin.headRadius;
    final p = _Pin.point;
    // Where the sides touch the circle, seen from the point.
    final distance = (p - c).distance;
    final spread = math.acos(r / distance);
    final down = math.atan2(p.dy - c.dy, p.dx - c.dx);
    return Path()
      ..moveTo(p.dx, p.dy)
      ..lineTo(c.dx + r * math.cos(down + spread), c.dy + r * math.sin(down + spread))
      ..arcTo(Rect.fromCircle(center: c, radius: r), down + spread, 2 * math.pi - 2 * spread, false)
      ..close()
      ..shift(shift);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // A light pin needs a darker edge to stand out on the pale middle of the wheel.
    final edge = fill.computeLuminance() > 0.6 ? const Color(0x33000000) : const Color(0x80FFFFFF);
    final drop = _drop(Offset.zero);
    canvas
      ..drawShadow(drop, const Color(0xFF000000), 5, false)
      ..drawPath(drop, Paint()..color = fill)
      ..drawPath(
        drop,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 2.5 : 1
          ..color = selected ? const Color(0xFFFFFFFF) : edge,
      )
      // The dot on the exact spot, joined to the point.
      ..drawCircle(_Pin.tip, 5, Paint()..color = const Color(0xFFFFFFFF))
      ..drawCircle(_Pin.tip, 3.2, Paint()..color = fill)
      ..drawCircle(
        _Pin.tip,
        5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0x33000000),
      );
  }

  @override
  bool shouldRepaint(_PinPainter oldDelegate) => oldDelegate.fill != fill || oldDelegate.selected != selected;
}
