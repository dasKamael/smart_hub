import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

/// Derives the room of a position. Rooms are never stored with a device.
abstract final class RoomLookupUtil {
  /// The room containing [point], or `null` outside of all rooms.
  static Room? roomAt(FloorPlan plan, PlanPoint point) {
    for (final room in plan.rooms) {
      if (PlanGeometryUtil.containsPoint(room.polygon, point)) return room;
    }
    return null;
  }

  /// Ids of the devices in [positions] that are inside [room].
  static Set<String> devicesIn(Room room, Map<String, PlanPoint> positions) {
    return {
      for (final MapEntry(key: id, value: position) in positions.entries)
        if (PlanGeometryUtil.containsPoint(room.polygon, position)) id,
    };
  }
}
