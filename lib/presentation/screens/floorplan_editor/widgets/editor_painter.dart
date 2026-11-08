import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/furniture_models.dart';
import 'package:smart_hub/presentation/design_system/tokens/home_scene.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_viewport.dart';

/// The plan while editing, seen from above: grid, floors, furniture, walls at their thickness, openings with door
/// swings, room names, and the handles of what is selected (`Floor Plan Editor.dc.html`).
class EditorPainter extends CustomPainter {
  EditorPainter({required this.state, required this.viewport});

  final FloorplanEditorState state;
  final EditorViewport viewport;

  HomeLayout get _layout => state.layout;

  @override
  void paint(Canvas canvas, Size size) {
    final outlines = LayoutRoomsUtil.outlines(_layout);
    _paintGrid(canvas, size);
    _paintFloors(canvas, outlines);
    _paintFurniture(canvas);
    _paintWalls(canvas);
    _paintOpenings(canvas);
    _paintLabels(canvas, outlines);
    _paintHandles(canvas, outlines);
    _paintGuides(canvas, size);
    _paintDrafts(canvas);
  }

  Offset _px(PlanPoint point) => viewport.toPx(point);

  Path _path(List<PlanPoint> polygon) => Path()..addPolygon([for (final p in polygon) _px(p)], true);

  void _paintGrid(Canvas canvas, Size size) {
    final topLeft = viewport.toPlan(Offset.zero);
    final bottomRight = viewport.toPlan(Offset(size.width, size.height));
    final step = 50 * viewport.scale >= 12 ? 50.0 : 100.0;
    final fine = Paint()..color = HubColorPalette.planGrid;
    final strong = Paint()..color = HubColorPalette.planGridStrong;
    for (var x = (topLeft.x / step).floor() * step; x <= bottomRight.x; x += step) {
      final px = _px(PlanPoint(x, 0)).dx;
      canvas.drawLine(Offset(px, 0), Offset(px, size.height), x % 100 == 0 ? strong : fine);
    }
    for (var y = (topLeft.y / step).floor() * step; y <= bottomRight.y; y += step) {
      final py = _px(PlanPoint(0, y)).dy;
      canvas.drawLine(Offset(0, py), Offset(size.width, py), y % 100 == 0 ? strong : fine);
    }
  }

  void _paintFloors(Canvas canvas, Map<String, List<PlanPoint>> outlines) {
    final selected = state.selectedRoom?.id;
    for (final MapEntry(key: id, value: outline) in outlines.entries) {
      canvas.drawPath(
        _path(outline),
        Paint()..color = id == selected ? HubColorPalette.accent.withValues(alpha: 0.16) : HubColorPalette.floor,
      );
    }
  }

  void _paintFurniture(Canvas canvas) {
    final selected = state.selectedFurniture?.id;
    final items = [..._layout.furniture]..sort((a, b) => a.kind.isFlat == b.kind.isFlat ? 0 : (a.kind.isFlat ? -1 : 1));
    for (final item in items) {
      final solids = FurnitureModels.solidsOf(item)..sort((a, b) => a.top.compareTo(b.top));
      for (final solid in solids) {
        final color = HomeSceneColorPalette.of(solid.material);
        // Seen from above: lighter the higher a part is, so the shape reads.
        final light = 0.55 + 0.35 * math.min(1.0, solid.top / 120);
        canvas.drawPath(
          _path(solid.base),
          Paint()
            ..color = Color.from(alpha: color.a, red: color.r * light, green: color.g * light, blue: color.b * light),
        );
      }
      final outline = _path(_cornersOf(item));
      canvas.drawPath(
        outline,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = item.id == selected ? 2.5 : 1
          ..color = item.id == selected ? HubColorPalette.accent : HubColorPalette.planFurnitureEdge,
      );
    }
  }

  static List<PlanPoint> _cornersOf(Furniture item) {
    final angle = item.rotation * math.pi / 180;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    PlanPoint corner(double x, double y) =>
        PlanPoint(item.position.x + x * cos - y * sin, item.position.y + x * sin + y * cos);
    final w = item.width / 2;
    final d = item.depth / 2;
    return [corner(-w, -d), corner(w, -d), corner(w, d), corner(-w, d)];
  }

  void _paintWalls(Canvas canvas) {
    final positions = {for (final node in _layout.nodes) node.id: node.position};
    final selected = state.selectedWall?.id;
    final fill = Paint()..color = HubColorPalette.wall;
    for (final wall in _layout.walls) {
      final a = positions[wall.from]!;
      final b = positions[wall.to]!;
      canvas.drawPath(
        _path(_wallOutline(a, b, wall.thickness)),
        wall.id == selected ? (Paint()..color = HubColorPalette.accent) : fill,
      );
    }
    // Joints: fill the corners where walls meet.
    for (final node in _layout.nodes) {
      final thickness = _layout.walls
          .where((wall) => wall.from == node.id || wall.to == node.id)
          .fold(0.0, (max, wall) => math.max(max, wall.thickness));
      final half = thickness / 2 * viewport.scale;
      canvas.drawRect(Rect.fromCenter(center: _px(node.position), width: 2 * half, height: 2 * half), fill);
    }
  }

  static List<PlanPoint> _wallOutline(PlanPoint a, PlanPoint b, double thickness) {
    final length = a.distanceTo(b);
    if (length == 0) return [a, a, a, a];
    final n = PlanPoint(-(b.y - a.y) / length * thickness / 2, (b.x - a.x) / length * thickness / 2);
    return [a + n, b + n, b - n, a - n];
  }

  void _paintOpenings(Canvas canvas) {
    final selected = state.selectedOpening?.id;
    for (final opening in _layout.openings) {
      final segment = LayoutGraphUtil.openingSegment(_layout, opening);
      final wall = _layout.walls.where((wall) => wall.id == opening.wallId).firstOrNull;
      if (segment == null || wall == null) continue;
      final (a, b) = segment;
      final isSelected = opening.id == selected;
      final color = isSelected ? HubColorPalette.accent : HubColorPalette.text2;
      // The gap through the wall.
      canvas.drawPath(_path(_wallOutline(a, b, wall.thickness + 1)), Paint()..color = HubColorPalette.planGap);
      final length = a.distanceTo(b);
      if (length == 0) continue;
      final u = PlanPoint((b.x - a.x) / length, (b.y - a.y) / length);
      switch (opening.type) {
        case DoorType.door:
          final hingeAtEnd = opening.swing & 1 == 1;
          final side = opening.swing & 2 == 2 ? -1.0 : 1.0;
          final hinge = hingeAtEnd ? b : a;
          final free = hingeAtEnd ? a : b;
          final normal = PlanPoint(-u.y * side, u.x * side);
          final tip = PlanPoint(hinge.x + normal.x * length, hinge.y + normal.y * length);
          canvas.drawLine(
            _px(hinge),
            _px(tip),
            Paint()
              ..color = color
              ..strokeWidth = 2,
          );
          final radius = length * viewport.scale;
          final start = math.atan2(tip.y - hinge.y, tip.x - hinge.x);
          var sweep = math.atan2(free.y - hinge.y, free.x - hinge.x) - start;
          if (sweep > math.pi) sweep -= 2 * math.pi;
          if (sweep < -math.pi) sweep += 2 * math.pi;
          canvas.drawPath(
            _dashed(Path()..addArc(Rect.fromCircle(center: _px(hinge), radius: radius), start, sweep)),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = color
              ..strokeWidth = 1,
          );
        case DoorType.open:
          canvas.drawPath(
            _dashed(
              Path()
                ..moveTo(_px(a).dx, _px(a).dy)
                ..lineTo(_px(b).dx, _px(b).dy),
            ),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = isSelected ? HubColorPalette.accent : HubColorPalette.text3
              ..strokeWidth = 1.5,
          );
        case DoorType.window:
          final offset = PlanPoint(-u.y * wall.thickness / 4, u.x * wall.thickness / 4);
          final pane = Paint()
            ..color = isSelected ? HubColorPalette.accent : HubColorPalette.window
            ..strokeWidth = 1.5;
          canvas
            ..drawLine(_px(a + offset), _px(b + offset), pane)
            ..drawLine(_px(a - offset), _px(b - offset), pane);
      }
    }
  }

  void _paintLabels(Canvas canvas, Map<String, List<PlanPoint>> outlines) {
    final selected = state.selectedRoom?.id;
    for (final room in _layout.rooms) {
      final outline = outlines[room.id];
      if (outline == null) continue;
      final center = _px(PlanGeometryUtil.interiorPoint(outline));
      _drawText(
        canvas,
        room.name,
        HubTextStyles.label.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: room.id == selected ? HubColorPalette.accentText : HubColorPalette.planLabel,
        ),
        (size) => center - Offset(size.width / 2, size.height),
      );
      _drawText(
        canvas,
        '${PlanGeometryUtil.areaInSquareMeters(outline).toStringAsFixed(1)} m²',
        HubTextStyles.label.copyWith(fontSize: 12, color: HubColorPalette.text3),
        (size) => center - Offset(size.width / 2, 0),
      );
    }
  }

  void _paintHandles(Canvas canvas, Map<String, List<PlanPoint>> outlines) {
    if (state.tool != EditorTool.select) return;
    // Every junction can be dragged.
    for (final node in _layout.nodes) {
      final at = _px(node.position);
      canvas
        ..drawCircle(at, 4, Paint()..color = HubColorPalette.text)
        ..drawCircle(at, 4, _stroke(HubColorPalette.accent, 1.5));
    }
    if (state.selectedWall case final wall?) {
      final (a, b) = LayoutGraphUtil.endsOf(_layout, wall);
      _lengthLabel(canvas, a, b, null);
    }
    final room = state.selectedRoom;
    final outline = room == null ? null : outlines[room.id];
    if (outline == null) return;
    final center = PlanGeometryUtil.interiorPoint(outline);
    for (var i = 0; i < outline.length; i++) {
      final a = outline[i];
      final b = outline[(i + 1) % outline.length];
      if (a.distanceTo(b) * viewport.scale < 50) continue;
      _lengthLabel(canvas, a, b, center);
    }
  }

  /// The length of the wall from [a] to [b], beside it – away from [inside] when given.
  void _lengthLabel(Canvas canvas, PlanPoint a, PlanPoint b, PlanPoint? inside) {
    final pa = _px(a);
    final pb = _px(b);
    final length = (pb - pa).distance;
    if (length < 1) return;
    final middle = (pa + pb) / 2;
    var normal = Offset(-(pb.dy - pa.dy), pb.dx - pa.dx) / length;
    if (inside != null) {
      final c = _px(inside);
      if (((middle + normal) - c).distance < (middle - c).distance) normal = -normal;
    }
    _drawText(
      canvas,
      '${(a.distanceTo(b) / 100).toStringAsFixed(2)} m',
      HubTextStyles.label.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: HubColorPalette.accentText),
      (size) {
        final clearance = 14 + (normal.dx * size.width).abs() / 2 + (normal.dy * size.height).abs() / 2;
        return middle + normal * clearance - Offset(size.width / 2, size.height / 2);
      },
    );
  }

  void _paintGuides(Canvas canvas, Size size) {
    final paint = _stroke(HubColorPalette.accent.withValues(alpha: 0.7), 1);
    if (state.guideX case final x?) {
      final px = _px(PlanPoint(x, 0)).dx;
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
      final py = _px(PlanPoint(0, y)).dy;
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

  void _paintDrafts(Canvas canvas) {
    final chain = state.chain;
    if (chain.isNotEmpty) {
      for (final (i, point) in chain.indexed) {
        canvas
          ..drawCircle(
            _px(point),
            i == 0 ? 7 : 5,
            Paint()..color = i == 0 ? HubColorPalette.accent : HubColorPalette.text,
          )
          ..drawCircle(_px(point), i == 0 ? 7 : 5, _stroke(HubColorPalette.accent, 2));
      }
    }
    if (state.rectangle case [final from, final to]) {
      final rect = Rect.fromPoints(_px(from), _px(to));
      canvas
        ..drawRect(rect, Paint()..color = HubColorPalette.accent.withValues(alpha: 0.12))
        ..drawRect(rect, _stroke(HubColorPalette.accent, 2.5));
      final width = (to.x - from.x).abs();
      final height = (to.y - from.y).abs();
      _drawText(
        canvas,
        '${(width / 100).toStringAsFixed(2)} × ${(height / 100).toStringAsFixed(2)} m · '
        '${(width * height / 10000).toStringAsFixed(1)} m²',
        HubTextStyles.label.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
        (size) => rect.center - Offset(size.width / 2, size.height / 2),
      );
    }
    if (state.splitDraft case [final from, final to]) {
      canvas.drawLine(
        _px(from),
        _px(to),
        Paint()
          ..color = HubColorPalette.accent
          ..strokeWidth = math.max(4, LayoutWall.innerThickness * viewport.scale),
      );
      _drawText(
        canvas,
        '${(from.distanceTo(to) / 100).toStringAsFixed(2)} m',
        HubTextStyles.label.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
        (size) => (_px(from) + _px(to)) / 2 - Offset(size.width / 2, size.height + 12),
      );
    }
    if (state.openingDraft case [final from, final to]) {
      final wall = LayoutGraphUtil.wallAt(_layout, from, radius: 60);
      if (wall != null) {
        final (a, b) = LayoutGraphUtil.endsOf(_layout, wall);
        final p = PlanGeometryUtil.closestOnSegment(from, a, b);
        final q = PlanGeometryUtil.closestOnSegment(to, a, b);
        canvas.drawLine(
          _px(p),
          _px(q),
          Paint()
            ..color = HubColorPalette.accent
            ..strokeWidth = math.max(6, wall.thickness * viewport.scale)
            ..strokeCap = StrokeCap.butt,
        );
        _drawText(
          canvas,
          '${p.distanceTo(q).round()} cm',
          HubTextStyles.label.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
          (size) => (_px(p) + _px(q)) / 2 - Offset(size.width / 2, size.height + 12),
        );
      }
    }
  }

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
