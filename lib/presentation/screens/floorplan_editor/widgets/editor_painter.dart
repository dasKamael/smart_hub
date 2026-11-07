import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:smart_hub/domain/floorplan/editing/plan_editing.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_viewport.dart';

/// The plan while editing: grid, rooms, openings, labels and the handles of the selection, the room being drawn
/// and snap guides (`Floor Plan Editor.dc.html`).
class EditorPainter extends CustomPainter {
  EditorPainter({required this.state, required this.viewport});

  /// The gap of an opening hides the wall in the floor color; the floor itself is translucent over the card.
  static final _gapColor = Color.alphaBlend(HubColorPalette.floor, HubColorPalette.card);

  final FloorplanEditorState state;
  final EditorViewport viewport;

  FloorPlan get _plan => state.plan;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, size);
    final selectedRoom = state.selectedRoom;
    for (final room in _plan.rooms) {
      _paintRoom(canvas, room, selected: room.id == selectedRoom?.id);
    }
    for (final opening in _plan.doors) {
      _paintOpening(canvas, opening, selected: opening.id == state.selectedOpening?.id);
    }
    for (final room in _plan.rooms) {
      _paintLabel(canvas, room, selected: room.id == selectedRoom?.id);
    }
    if (selectedRoom != null && state.tool == EditorTool.select) _paintHandles(canvas, selectedRoom);
    _paintGuides(canvas, size);
    _paintDraft(canvas);
    _paintRectangle(canvas);
  }

  void _paintGrid(Canvas canvas, Size size) {
    final topLeft = viewport.toPlan(Offset.zero);
    final bottomRight = viewport.toPlan(Offset(size.width, size.height));
    // Fine lines only while they are far enough apart to read.
    final step = 50 * viewport.scale >= 12 ? 50.0 : 100.0;
    final fine = Paint()..color = HubColorPalette.planGrid;
    final strong = Paint()..color = HubColorPalette.planGridStrong;
    for (var x = (topLeft.x / step).floor() * step; x <= bottomRight.x; x += step) {
      final px = viewport.toPx(PlanPoint(x, 0)).dx;
      canvas.drawLine(Offset(px, 0), Offset(px, size.height), x % 100 == 0 ? strong : fine);
    }
    for (var y = (topLeft.y / step).floor() * step; y <= bottomRight.y; y += step) {
      final py = viewport.toPx(PlanPoint(0, y)).dy;
      canvas.drawLine(Offset(0, py), Offset(size.width, py), y % 100 == 0 ? strong : fine);
    }
  }

  void _paintRoom(Canvas canvas, Room room, {required bool selected}) {
    final path = _path(room.polygon);
    canvas
      ..drawPath(
        path,
        Paint()..color = selected ? HubColorPalette.accent.withValues(alpha: 0.16) : HubColorPalette.floor,
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = selected ? HubColorPalette.accent : HubColorPalette.wall
          ..strokeWidth = selected ? 3 : 2.5
          ..strokeJoin = StrokeJoin.round,
      );
  }

  void _paintOpening(Canvas canvas, Door opening, {required bool selected}) {
    final a = viewport.toPx(opening.a);
    final b = viewport.toPx(opening.b);
    final length = (b - a).distance;
    if (length == 0) return;
    final normal = Offset(-(b.dy - a.dy), b.dx - a.dx) / length;
    final color = selected ? HubColorPalette.accent : HubColorPalette.text3;
    canvas.drawLine(
      a,
      b,
      Paint()
        ..color = _gapColor
        ..strokeWidth = 6,
    );

    switch (opening.type) {
      case DoorType.door:
        final tip = a + normal * length;
        final start = math.atan2(normal.dy, normal.dx);
        var sweep = math.atan2(b.dy - a.dy, b.dx - a.dx) - start;
        if (sweep > math.pi) sweep -= 2 * math.pi;
        if (sweep < -math.pi) sweep += 2 * math.pi;
        canvas
          ..drawLine(
            a,
            tip,
            Paint()
              ..color = color
              ..strokeWidth = 1.5,
          )
          ..drawPath(
            _dashed(Path()..addArc(Rect.fromCircle(center: a, radius: length), start, sweep)),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = color
              ..strokeWidth = 1,
          );
      case DoorType.open:
        if (selected) {
          canvas.drawPath(
            _dashed(
              Path()
                ..moveTo(a.dx, a.dy)
                ..lineTo(b.dx, b.dy),
            ),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = HubColorPalette.accent
              ..strokeWidth = 2,
          );
        }
      case DoorType.window:
        final pane = Paint()
          ..color = selected ? HubColorPalette.accent : HubColorPalette.window
          ..strokeWidth = 1.5;
        canvas
          ..drawLine(a + normal * 2.5, b + normal * 2.5, pane)
          ..drawLine(a - normal * 2.5, b - normal * 2.5, pane);
    }
  }

  void _paintLabel(Canvas canvas, Room room, {required bool selected}) {
    final center = viewport.toPx(PlanEditingUtil.centroid(room.polygon));
    _drawText(
      canvas,
      room.name,
      HubTextStyles.label.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: selected ? HubColorPalette.accentText : HubColorPalette.planLabel,
      ),
      (size) => center - Offset(size.width / 2, size.height),
    );
    _drawText(
      canvas,
      '${PlanGeometryUtil.areaInSquareMeters(room.polygon).toStringAsFixed(1)} m²',
      HubTextStyles.label.copyWith(fontSize: 12, color: HubColorPalette.text3),
      (size) => center - Offset(size.width / 2, 0),
    );
  }

  /// Wall lengths outside the room, a handle in the middle of every wall (adds a corner) and on every corner.
  void _paintHandles(Canvas canvas, Room room) {
    final polygon = room.polygon;
    final center = viewport.toPx(PlanEditingUtil.centroid(polygon));
    for (var i = 0; i < polygon.length; i++) {
      final a = viewport.toPx(polygon[i]);
      final b = viewport.toPx(polygon[(i + 1) % polygon.length]);
      final length = (b - a).distance;
      if (length < 1) continue;
      final middle = (a + b) / 2;
      var normal = Offset(-(b.dy - a.dy), b.dx - a.dx) / length;
      if (((middle + normal) - center).distance < (middle - center).distance) normal = -normal;
      _drawText(
        canvas,
        _meters(polygon[i].distanceTo(polygon[(i + 1) % polygon.length])),
        HubTextStyles.label.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: HubColorPalette.accentText),
        // Clear of the wall whatever its direction: half the label's extent along the normal plus a gap.
        (size) {
          final clearance = 10 + (normal.dx * size.width).abs() / 2 + (normal.dy * size.height).abs() / 2;
          return middle + normal * clearance - Offset(size.width / 2, size.height / 2);
        },
      );
      canvas
        ..drawCircle(middle, 5, Paint()..color = HubColorPalette.card)
        ..drawCircle(middle, 5, _stroke(HubColorPalette.accent, 1.5));
    }
    for (final corner in polygon) {
      final px = viewport.toPx(corner);
      canvas
        ..drawCircle(px, 7, Paint()..color = HubColorPalette.text)
        ..drawCircle(px, 7, _stroke(HubColorPalette.accent, 2.5));
    }
  }

  void _paintGuides(Canvas canvas, Size size) {
    final paint = _stroke(HubColorPalette.accent.withValues(alpha: 0.7), 1);
    if (state.guideX case final x?) {
      final px = viewport.toPx(PlanPoint(x, 0)).dx;
      canvas.drawPath(
        _dashed(
          Path()
            ..moveTo(px, 0)
            ..lineTo(px, size.height),
        ),
        paint,
      );
    }
    if (state.guideY case final y?) {
      final py = viewport.toPx(PlanPoint(0, y)).dy;
      canvas.drawPath(
        _dashed(
          Path()
            ..moveTo(0, py)
            ..lineTo(size.width, py),
        ),
        paint,
      );
    }
  }

  void _paintDraft(Canvas canvas) {
    final draft = state.draft;
    if (draft.isEmpty) return;
    final points = [for (final p in draft) viewport.toPx(p)];
    if (points.length >= 3) {
      canvas.drawPath(Path()..addPolygon(points, true), Paint()..color = HubColorPalette.accent.withValues(alpha: 0.1));
    }
    canvas.drawPath(Path()..addPolygon(points, false), _stroke(HubColorPalette.accent, 2.5));
    for (final (i, point) in points.indexed) {
      // The first corner closes the room: larger and filled.
      canvas
        ..drawCircle(point, i == 0 ? 8 : 5, Paint()..color = i == 0 ? HubColorPalette.accent : HubColorPalette.text)
        ..drawCircle(point, i == 0 ? 8 : 5, _stroke(HubColorPalette.accent, 2));
    }
  }

  void _paintRectangle(Canvas canvas) {
    final rectangle = state.rectangle;
    if (rectangle == null) return;
    final [from, to] = rectangle;
    final rect = Rect.fromPoints(viewport.toPx(from), viewport.toPx(to));
    canvas
      ..drawRect(rect, Paint()..color = HubColorPalette.accent.withValues(alpha: 0.12))
      ..drawRect(rect, _stroke(HubColorPalette.accent, 2.5));
    final width = (to.x - from.x).abs();
    final height = (to.y - from.y).abs();
    _drawText(
      canvas,
      '${_meters(width)} × ${_meters(height)} · ${(width * height / 10000).toStringAsFixed(1)} m²',
      HubTextStyles.label.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
      (size) => rect.center - Offset(size.width / 2, size.height / 2),
    );
  }

  Path _path(List<PlanPoint> polygon) => Path()..addPolygon([for (final p in polygon) viewport.toPx(p)], true);

  static String _meters(double cm) => '${(cm / 100).toStringAsFixed(2)} m';

  static Paint _stroke(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..color = color
    ..strokeWidth = width
    ..strokeJoin = StrokeJoin.round;

  /// Draws [text] at the offset [at] returns for its size.
  static void _drawText(Canvas canvas, String text, TextStyle style, Offset Function(Size size) at) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at(painter.size));
    painter.dispose();
  }

  /// [path] as 4 px dashes with 4 px gaps.
  static Path _dashed(Path path) {
    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 8) {
        dashed.addPath(metric.extractPath(distance, math.min(distance + 4, metric.length)), Offset.zero);
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(EditorPainter oldDelegate) => oldDelegate.state != state || oldDelegate.viewport != viewport;
}
