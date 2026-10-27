import 'package:flutter/rendering.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_transform.dart';

/// Static floor plan: rooms, walls, doors and the selected room overlay.
///
/// Rooms are stroked thick first and filled afterwards, so only the outer outline stays thick (12 px) while
/// inner walls end up 4 px.
class PlanPainter extends CustomPainter {
  PlanPainter({required this.plan, required this.transform, this.selectedRoomId});

  static const _outerWallWidth = 12.0;
  static const _innerWallWidth = 4.0;
  static const _innerDoorWidth = 7.0;
  static const _outerDoorWidth = 14.0;

  final FloorPlan plan;
  final PlanTransform transform;
  final String? selectedRoomId;

  @override
  void paint(Canvas canvas, Size size) {
    final rooms = [for (final room in plan.rooms) transform.pathOf(room.polygon)];
    final walls = [for (final wall in plan.walls) transform.pathOf(wall.polygon)];

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..color = HubColorPalette.wall
      ..strokeWidth = _outerWallWidth
      ..strokeJoin = StrokeJoin.round;
    final floor = Paint()..color = HubColorPalette.floor;
    final innerWall = Paint()
      ..style = PaintingStyle.stroke
      ..color = HubColorPalette.wall
      ..strokeWidth = _innerWallWidth
      ..strokeJoin = StrokeJoin.round;
    final solidWall = Paint()..color = HubColorPalette.wall;

    for (final room in rooms) {
      canvas.drawPath(room, outline);
    }
    for (final room in rooms) {
      canvas.drawPath(room, floor);
    }
    for (final room in rooms) {
      canvas.drawPath(room, innerWall);
    }
    for (final wall in walls) {
      canvas.drawPath(wall, solidWall);
    }
    for (final door in plan.doors) {
      _paintDoor(canvas, door);
    }
    _paintSelection(canvas);
  }

  void _paintDoor(Canvas canvas, Door door) {
    final isOuter = _isOnOuterWall(door);
    final gap = Paint()
      ..color = isOuter ? HubColorPalette.surface : HubColorPalette.floor
      ..strokeWidth = isOuter ? _outerDoorWidth : _innerDoorWidth;
    canvas.drawLine(transform.toPx(door.a), transform.toPx(door.b), gap);
  }

  /// A door is on the outer wall when one side of it is outside of every room.
  bool _isOnOuterWall(Door door) {
    final middle = PlanPoint((door.a.x + door.b.x) / 2, (door.a.y + door.b.y) / 2);
    final direction = door.b - door.a;
    final length = door.a.distanceTo(door.b);
    if (length == 0) return false;
    // 10 cm to both sides, perpendicular to the door.
    final normal = PlanPoint(-direction.y / length * 10, direction.x / length * 10);
    return RoomLookupUtil.roomAt(plan, middle + normal) == null || RoomLookupUtil.roomAt(plan, middle - normal) == null;
  }

  void _paintSelection(Canvas canvas) {
    final selected = plan.rooms.where((room) => room.id == selectedRoomId).firstOrNull;
    if (selected == null) return;
    final path = transform.pathOf(selected.polygon);
    canvas
      ..drawPath(path, Paint()..color = HubColorPalette.accent.withValues(alpha: 0.12))
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = HubColorPalette.accent
          ..strokeWidth = _innerWallWidth
          ..strokeJoin = StrokeJoin.round,
      );
  }

  @override
  bool shouldRepaint(PlanPainter oldDelegate) {
    return oldDelegate.plan != plan ||
        oldDelegate.transform != transform ||
        oldDelegate.selectedRoomId != selectedRoomId;
  }

  @override
  bool? hitTest(Offset position) => false;
}
