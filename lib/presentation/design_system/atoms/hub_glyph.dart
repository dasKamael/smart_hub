import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The hub's own filled glyphs (`UI Library` → "Grundriss-Marker"). Paths are taken from the prototype SVGs.
enum HubGlyph {
  bulb(Size(14, 18), Size(15, 19)),
  leaf(Size(16, 16), Size(17, 17)),
  speaker(Size(14, 18), Size(15, 19)),
  drop(Size(16, 20), Size(14, 18)),
  check(Size(18, 18), Size(16, 16)),
  plus(Size(18, 18), Size(16, 16)),
  alert(Size(18, 18), Size(16, 16)),
  pencil(Size(18, 18), Size(16, 16)),
  play(Size(18, 18), Size(16, 16)),
  pause(Size(18, 18), Size(16, 16)),
  next(Size(18, 18), Size(16, 16)),
  previous(Size(18, 18), Size(16, 16)),
  note(Size(18, 18), Size(16, 16)),
  close(Size(18, 18), Size(16, 16)),
  phone(Size(18, 18), Size(18, 18)),
  tablet(Size(18, 18), Size(18, 18)),
  computer(Size(18, 18), Size(18, 18)),
  tv(Size(18, 18), Size(18, 18)),
  minus(Size(18, 18), Size(16, 16)),
  back(Size(18, 18), Size(16, 16)),
  gear(Size(18, 18), Size(18, 18)),
  offline(Size(18, 18), Size(16, 16)),
  sync(Size(18, 18), Size(16, 16)),
  key(Size(18, 18), Size(16, 16)),
  undo(Size(18, 18), Size(16, 16)),
  clock(Size(18, 18), Size(16, 16)),
  library(Size(18, 18), Size(16, 16)),
  heart(Size(18, 18), Size(16, 16)),
  moon(Size(18, 18), Size(16, 16)),

  /// Fertilizer bottle.
  feed(Size(18, 18), Size(16, 16)),
  sun(Size(18, 18), Size(16, 16)),

  /// Arrow into a tray.
  import(Size(18, 18), Size(16, 16)),

  /// Potted plant, the illustration for plants without a photo.
  pottedPlant(Size(24, 24), Size(22, 22));

  const HubGlyph(this.viewBox, this.markerSize);

  /// Coordinate space of the path.
  final Size viewBox;

  /// Optical size inside a 44 px marker.
  final Size markerSize;
}

/// Paints a [HubGlyph] in [color] at [size] (defaults to the marker size of the glyph).
class HubGlyphIcon extends StatelessWidget {
  const HubGlyphIcon(this.glyph, {super.key, required this.color, this.size});

  final HubGlyph glyph;
  final Color color;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: size ?? glyph.markerSize, painter: _GlyphPainter(glyph, color));
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.glyph, this.color);

  final HubGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / glyph.viewBox.width, size.height / glyph.viewBox.height);
    final fill = Paint()
      ..color = color
      ..isAntiAlias = true;
    switch (glyph) {
      case HubGlyph.bulb:
        canvas
          ..drawPath(_bulb, fill)
          ..drawRRect(RRect.fromLTRBR(4.5, 14.5, 9.5, 16.5, const Radius.circular(1)), fill);
      case HubGlyph.leaf:
        canvas.drawPath(_leaf, fill);
      case HubGlyph.speaker:
        final stroke = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8;
        canvas
          ..drawRRect(RRect.fromLTRBR(1.5, 1, 12.5, 17, const Radius.circular(3)), stroke)
          ..drawCircle(const Offset(7, 11.2), 2.6, fill)
          ..drawCircle(const Offset(7, 5), 1.2, fill);
      case HubGlyph.drop:
        canvas.drawPath(_drop, fill);
      case HubGlyph.check:
        canvas.drawPath(_check, _stroke(2.6));
      case HubGlyph.plus:
        canvas
          ..drawLine(const Offset(9, 3), const Offset(9, 15), _stroke(2.4))
          ..drawLine(const Offset(3, 9), const Offset(15, 9), _stroke(2.4));
      case HubGlyph.alert:
        canvas
          ..drawLine(const Offset(9, 3), const Offset(9, 10.5), _stroke(2.6))
          ..drawCircle(const Offset(9, 14.8), 1.6, fill);
      case HubGlyph.pencil:
        canvas.drawPath(_pencil, fill);
      case HubGlyph.play:
        canvas.drawPath(_play, fill);
      case HubGlyph.pause:
        canvas
          ..drawRRect(RRect.fromLTRBR(4, 3, 7.6, 15, const Radius.circular(1.2)), fill)
          ..drawRRect(RRect.fromLTRBR(10.4, 3, 14, 15, const Radius.circular(1.2)), fill);
      case HubGlyph.next:
        canvas
          ..drawPath(_next, fill)
          ..drawRRect(RRect.fromLTRBR(12.2, 3.5, 14.6, 14.5, const Radius.circular(1)), fill);
      case HubGlyph.previous:
        canvas
          ..drawPath(_previous, fill)
          ..drawRRect(RRect.fromLTRBR(3.4, 3.5, 5.8, 14.5, const Radius.circular(1)), fill);
      case HubGlyph.note:
        canvas
          ..drawOval(Rect.fromCenter(center: const Offset(6.6, 13.8), width: 6.6, height: 5.2), fill)
          ..drawRect(const Rect.fromLTRB(8.4, 2.5, 10, 13.8), fill)
          ..drawPath(_noteFlag, fill);
      case HubGlyph.phone:
        canvas
          ..drawRRect(RRect.fromLTRBR(5, 1.5, 13, 16.5, const Radius.circular(2.2)), _stroke(1.8))
          ..drawLine(const Offset(8, 13.6), const Offset(10, 13.6), _stroke(1.6));
      case HubGlyph.tablet:
        canvas
          ..drawRRect(RRect.fromLTRBR(2, 3, 16, 15, const Radius.circular(2)), _stroke(1.8))
          ..drawCircle(const Offset(13.6, 9), 0.9, fill);
      case HubGlyph.computer:
        canvas
          ..drawRRect(RRect.fromLTRBR(3, 3, 15, 12, const Radius.circular(1.5)), _stroke(1.8))
          ..drawLine(const Offset(1.5, 15), const Offset(16.5, 15), _stroke(1.8));
      case HubGlyph.tv:
        canvas
          ..drawRRect(RRect.fromLTRBR(1.5, 3, 16.5, 13, const Radius.circular(1.5)), _stroke(1.8))
          ..drawLine(const Offset(6, 15.6), const Offset(12, 15.6), _stroke(1.8));
      case HubGlyph.close:
        canvas
          ..drawLine(const Offset(4.5, 4.5), const Offset(13.5, 13.5), _stroke(2.4))
          ..drawLine(const Offset(13.5, 4.5), const Offset(4.5, 13.5), _stroke(2.4));
      case HubGlyph.minus:
        canvas.drawLine(const Offset(3, 9), const Offset(15, 9), _stroke(2.4));
      case HubGlyph.back:
        canvas
          ..drawLine(const Offset(15, 9), const Offset(4, 9), _stroke(2.4))
          ..drawPath(_backHead, _stroke(2.4));
      case HubGlyph.gear:
        _paintGear(canvas, fill);
      case HubGlyph.offline:
        canvas
          ..drawPath(_cloud, _stroke(1.8))
          ..drawLine(const Offset(3, 3), const Offset(15, 15), _stroke(2));
      case HubGlyph.sync:
        canvas
          ..drawArc(Rect.fromCircle(center: const Offset(9, 9), radius: 6), -1.2, 5, false, _stroke(2.2))
          ..drawPath(_syncHead, fill);
      case HubGlyph.key:
        canvas
          ..drawCircle(const Offset(5.8, 9), 3.4, _stroke(2))
          ..drawLine(const Offset(9.2, 9), const Offset(16, 9), _stroke(2))
          ..drawLine(const Offset(13, 9), const Offset(13, 12), _stroke(2))
          ..drawLine(const Offset(15.6, 9), const Offset(15.6, 11.4), _stroke(2));
      case HubGlyph.clock:
        canvas
          ..drawCircle(const Offset(9, 9), 6.8, _stroke(1.9))
          ..drawLine(const Offset(9, 9), const Offset(9, 5.2), _stroke(1.9))
          ..drawLine(const Offset(9, 9), const Offset(11.8, 10.6), _stroke(1.9));
      case HubGlyph.library:
        canvas
          ..drawRRect(RRect.fromLTRBR(2.5, 3, 15.5, 5.4, const Radius.circular(1.2)), fill)
          ..drawRRect(RRect.fromLTRBR(2.5, 7.8, 15.5, 10.2, const Radius.circular(1.2)), fill)
          ..drawRRect(RRect.fromLTRBR(2.5, 12.6, 10.5, 15, const Radius.circular(1.2)), fill);
      case HubGlyph.heart:
        canvas.drawPath(_heart, fill);
      case HubGlyph.moon:
        canvas.drawPath(_moon, fill);
      case HubGlyph.feed:
        canvas
          ..drawRRect(RRect.fromLTRBR(7, 1.5, 11, 4.2, const Radius.circular(1)), fill)
          ..drawPath(_bottle, fill);
      case HubGlyph.import:
        canvas
          ..drawLine(const Offset(9, 2.5), const Offset(9, 10.5), _stroke(2))
          ..drawPath(
            Path()
              ..moveTo(5.2, 7.4)
              ..lineTo(9, 11.4)
              ..lineTo(12.8, 7.4),
            _stroke(2)..strokeJoin = StrokeJoin.round,
          )
          ..drawPath(
            Path()
              ..moveTo(3, 11.5)
              ..lineTo(3, 15)
              ..lineTo(15, 15)
              ..lineTo(15, 11.5),
            _stroke(2)..strokeJoin = StrokeJoin.round,
          );
      case HubGlyph.sun:
        canvas.drawCircle(const Offset(9, 9), 3.6, fill);
        for (var i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          canvas.drawLine(
            Offset(9 + math.cos(angle) * 5.8, 9 + math.sin(angle) * 5.8),
            Offset(9 + math.cos(angle) * 7.8, 9 + math.sin(angle) * 7.8),
            _stroke(1.6),
          );
        }
      case HubGlyph.undo:
        canvas
          ..drawPath(_undoArc, _stroke(2.2))
          ..drawPath(_undoHead, fill);
      case HubGlyph.pottedPlant:
        canvas
          ..drawPath(_leafLeft, fill)
          ..drawPath(_leafRight, fill)
          ..drawPath(_leafMiddle, Paint()..color = color.withValues(alpha: 0.75))
          ..drawRRect(RRect.fromLTRBR(5.5, 13.2, 18.5, 15.6, const Radius.circular(1.2)), fill)
          ..drawPath(_pot, Paint()..color = color.withValues(alpha: 0.85));
    }
  }

  /// Eight teeth around a ring.
  void _paintGear(Canvas canvas, Paint fill) {
    const center = Offset(9, 9);
    for (var tooth = 0; tooth < 8; tooth++) {
      canvas
        ..save()
        ..translate(center.dx, center.dy)
        ..rotate(tooth * 3.14159265 / 4)
        ..drawRRect(RRect.fromLTRBR(-1.6, -8.4, 1.6, -4.6, const Radius.circular(0.8)), fill)
        ..restore();
    }
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addOval(Rect.fromCircle(center: center, radius: 5.9))
        ..addOval(Rect.fromCircle(center: center, radius: 2.4)),
      fill,
    );
  }

  Paint _stroke(double width) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  // M8 1 C8 1 2 8.5 2 12.5 a6 6 0 0 0 12 0 C14 8.5 8 1 8 1 Z
  static final _drop = Path()
    ..moveTo(8, 1)
    ..cubicTo(8, 1, 2, 8.5, 2, 12.5)
    ..arcToPoint(const Offset(14, 12.5), radius: const Radius.circular(6), clockwise: false)
    ..cubicTo(14, 8.5, 8, 1, 8, 1)
    ..close();

  static final _check = Path()
    ..moveTo(3.5, 9.5)
    ..lineTo(7.5, 13.5)
    ..lineTo(14.5, 5);

  static final _backHead = Path()
    ..moveTo(8.5, 4)
    ..lineTo(3.5, 9)
    ..lineTo(8.5, 14);

  static final _cloud = Path()
    ..moveTo(5.2, 14)
    ..arcToPoint(const Offset(5.2, 7.4), radius: const Radius.circular(3.3))
    ..arcToPoint(const Offset(13.3, 6.2), radius: const Radius.circular(4.4))
    ..arcToPoint(const Offset(13.6, 14), radius: const Radius.circular(3.9))
    ..close();

  static final _syncHead = Path()
    ..moveTo(15.8, 2.8)
    ..lineTo(15.8, 8.2)
    ..lineTo(10.6, 6.4)
    ..close();

  static final _play = Path()
    ..moveTo(5, 2.8)
    ..lineTo(15.4, 9)
    ..lineTo(5, 15.2)
    ..close();

  static final _next = Path()
    ..moveTo(3.4, 3.5)
    ..lineTo(11.4, 9)
    ..lineTo(3.4, 14.5)
    ..close();

  static final _previous = Path()
    ..moveTo(14.6, 3.5)
    ..lineTo(6.6, 9)
    ..lineTo(14.6, 14.5)
    ..close();

  static final _noteFlag = Path()
    ..moveTo(10, 2.5)
    ..cubicTo(12.4, 3.4, 14.6, 5, 14.6, 8.2)
    ..cubicTo(13.6, 6.8, 12, 6.2, 10, 6.2)
    ..close();

  static final _pencil = Path()
    ..moveTo(11.8, 2.8)
    ..lineTo(15.2, 6.2)
    ..lineTo(6.6, 14.8)
    ..lineTo(2.6, 15.6)
    ..lineTo(3.4, 11.6)
    ..close();

  static final _heart = Path()
    ..moveTo(9, 15.6)
    ..cubicTo(4.2, 12.2, 1.8, 9.6, 1.8, 6.6)
    ..cubicTo(1.8, 4.2, 3.6, 2.6, 5.6, 2.6)
    ..cubicTo(7, 2.6, 8.2, 3.4, 9, 4.6)
    ..cubicTo(9.8, 3.4, 11, 2.6, 12.4, 2.6)
    ..cubicTo(14.4, 2.6, 16.2, 4.2, 16.2, 6.6)
    ..cubicTo(16.2, 9.6, 13.8, 12.2, 9, 15.6)
    ..close();

  // Crescent: a full circle minus an offset one.
  static final _moon = Path.combine(
    PathOperation.difference,
    Path()..addOval(Rect.fromCircle(center: const Offset(9, 9), radius: 7)),
    Path()..addOval(Rect.fromCircle(center: const Offset(13, 6), radius: 6)),
  );

  static final _bottle = Path()
    ..moveTo(7.4, 5)
    ..lineTo(10.6, 5)
    ..lineTo(10.6, 7)
    ..cubicTo(13, 7.8, 14.4, 9.6, 14.4, 12)
    ..lineTo(14.4, 15)
    ..cubicTo(14.4, 16, 13.6, 16.6, 12.6, 16.6)
    ..lineTo(5.4, 16.6)
    ..cubicTo(4.4, 16.6, 3.6, 16, 3.6, 15)
    ..lineTo(3.6, 12)
    ..cubicTo(3.6, 9.6, 5, 7.8, 7.4, 7)
    ..close();

  static final _undoArc = Path()
    ..moveTo(5.5, 7.5)
    ..lineTo(11, 7.5)
    ..arcToPoint(const Offset(11, 15), radius: const Radius.circular(3.75))
    ..lineTo(6.5, 15);

  static final _undoHead = Path()
    ..moveTo(2.5, 7.5)
    ..lineTo(7, 3.8)
    ..lineTo(7, 11.2)
    ..close();

  static final _leafLeft = Path()
    ..moveTo(12, 13)
    ..cubicTo(8, 12.5, 3.8, 9.5, 4.2, 4.8)
    ..cubicTo(8.6, 5, 11.6, 8.6, 12, 13)
    ..close();

  static final _leafRight = Path()
    ..moveTo(12, 13)
    ..cubicTo(16, 12.5, 20.2, 9.2, 19.8, 4.2)
    ..cubicTo(15.4, 4.6, 12.4, 8.6, 12, 13)
    ..close();

  static final _leafMiddle = Path()
    ..moveTo(12, 12.5)
    ..cubicTo(10.4, 9, 10.6, 5, 12, 2)
    ..cubicTo(13.4, 5, 13.6, 9, 12, 12.5)
    ..close();

  static final _pot = Path()
    ..moveTo(6.8, 15.6)
    ..lineTo(17.2, 15.6)
    ..lineTo(15.8, 22)
    ..lineTo(8.2, 22)
    ..close();

  @override
  bool shouldRepaint(_GlyphPainter oldDelegate) => oldDelegate.glyph != glyph || oldDelegate.color != color;

  // M7 1a5.5 5.5 0 0 0-3.3 9.9c.5.4.8 1 .8 1.6V13h5v-.5c0-.6.3-1.2.8-1.6A5.5 5.5 0 0 0 7 1z
  static final _bulb = Path()
    ..moveTo(7, 1)
    ..arcToPoint(const Offset(3.7, 10.9), radius: const Radius.circular(5.5), clockwise: false)
    ..cubicTo(4.2, 11.3, 4.5, 11.9, 4.5, 12.5)
    ..lineTo(4.5, 13)
    ..lineTo(9.5, 13)
    ..lineTo(9.5, 12.5)
    ..cubicTo(9.5, 11.9, 9.8, 11.3, 10.3, 10.9)
    ..arcToPoint(const Offset(7, 1), radius: const Radius.circular(5.5), clockwise: false)
    ..close();

  // M14 2C7 2 2 5 2 11c0 1 .2 2 .6 3C4 9 7 7 11 6 8 8 5.5 10.5 4 14.5c1 .3 1.8.5 3 .5 5 0 7-5 7-13z
  static final _leaf = Path()
    ..moveTo(14, 2)
    ..cubicTo(7, 2, 2, 5, 2, 11)
    ..cubicTo(2, 12, 2.2, 13, 2.6, 14)
    ..cubicTo(4, 9, 7, 7, 11, 6)
    ..cubicTo(8, 8, 5.5, 10.5, 4, 14.5)
    ..cubicTo(5, 14.8, 5.8, 15, 7, 15)
    ..cubicTo(12, 15, 14, 10, 14, 2)
    ..close();
}
