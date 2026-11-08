import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

/// Turns a plan of room outlines (the first format, one outline per room) into walls: shared walls become one,
/// walls another one ends on are split there, outer walls get thicker, doors hang on the wall they lie on.
abstract final class LayoutConversionUtil {
  static HomeLayout fromFloorPlan(FloorPlan plan) {
    var layout = const HomeLayout();
    for (final room in plan.rooms) {
      layout = LayoutGraphUtil.addChain(layout, [...room.polygon, room.polygon.first]);
    }
    for (final wall in plan.walls) {
      layout = LayoutGraphUtil.addChain(layout, [...wall.polygon, wall.polygon.first]);
    }
    layout = layout.copyWith(
      walls: [
        for (final wall in layout.walls)
          wall.copyWith(
            thickness: _sidesInRooms(layout, wall, plan) < 2 ? LayoutWall.outerThickness : LayoutWall.innerThickness,
          ),
      ],
      rooms: [
        for (final room in plan.rooms)
          LayoutRoom(
            id: room.id,
            name: room.name,
            type: RoomType.fromName(room.name),
            anchor: PlanGeometryUtil.interiorPoint(room.polygon),
          ),
      ],
      openings: [for (final door in plan.doors) ?_hang(layout, door)],
    );
    return LayoutRoomsUtil.normalize(layout);
  }

  /// On how many sides of [wall] there is a room.
  static int _sidesInRooms(HomeLayout layout, LayoutWall wall, FloorPlan plan) {
    final (a, b) = LayoutGraphUtil.endsOf(layout, wall);
    final length = a.distanceTo(b);
    if (length == 0) return 0;
    final middle = PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);
    final normal = PlanPoint(-(b.y - a.y) / length * 15, (b.x - a.x) / length * 15);
    var sides = 0;
    for (final side in [middle + normal, middle - normal]) {
      if (plan.rooms.any((room) => PlanGeometryUtil.containsPoint(room.polygon, side))) sides++;
    }
    return sides;
  }

  /// [door] as an opening on the wall its middle lies on.
  static LayoutOpening? _hang(HomeLayout layout, Door door) {
    final middle = PlanPoint((door.a.x + door.b.x) / 2, (door.a.y + door.b.y) / 2);
    final wall = LayoutGraphUtil.wallAt(layout, middle, radius: 2);
    if (wall == null) return null;
    final (a, b) = LayoutGraphUtil.endsOf(layout, wall);
    final length = a.distanceTo(b);
    final width = math.min(door.a.distanceTo(door.b), length);
    final offset = (PlanGeometryUtil.segmentParameter(middle, a, b) * length).clamp(width / 2, length - width / 2);
    return LayoutOpening(id: door.id, wallId: wall.id, type: door.type, offset: offset, width: width);
  }
}
