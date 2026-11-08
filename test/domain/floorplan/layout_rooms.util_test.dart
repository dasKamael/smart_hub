import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

/// A 4 × 3 m bedroom.
HomeLayout _bedroom() {
  final walls = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));
  return walls.copyWith(
    rooms: const [LayoutRoom(id: 'bed', name: 'Bedroom', type: RoomType.bedroom, anchor: PlanPoint(200, 150))],
  );
}

void main() {
  group('LayoutRoomsUtil.normalize', () {
    test('Given a bedroom, '
        'when a wall splits off a third of it, '
        'then the bedroom keeps the larger part and the smaller part becomes a new room', () {
      // Given
      final before = _bedroom();

      // When
      final split = LayoutGraphUtil.addWall(before, const PlanPoint(130, 0), const PlanPoint(130, 300));
      final layout = LayoutRoomsUtil.normalize(split, previousOutlines: LayoutRoomsUtil.outlines(before));

      // Then
      final outlines = LayoutRoomsUtil.outlines(layout);
      expect(layout.rooms.map((room) => room.name), ['Bedroom', 'Room']);
      expect(PlanGeometryUtil.areaInSquareMeters(outlines['bed']!), closeTo(8.1, 0.001));
      expect(PlanGeometryUtil.areaInSquareMeters(outlines['room-1']!), closeTo(3.9, 0.001));
    });

    test('Given two rooms, '
        'when the wall between them is removed, '
        'then one room is left: the one that was larger', () {
      // Given
      final split = LayoutGraphUtil.addWall(_bedroom(), const PlanPoint(130, 0), const PlanPoint(130, 300));
      final before = LayoutRoomsUtil.normalize(split, previousOutlines: LayoutRoomsUtil.outlines(_bedroom()));
      final wall = LayoutGraphUtil.wallAt(before, const PlanPoint(130, 150), radius: 2)!;

      // When
      final merged = LayoutGraphUtil.removeWall(before, wall.id);
      final layout = LayoutRoomsUtil.normalize(merged, previousOutlines: LayoutRoomsUtil.outlines(before));

      // Then
      expect(layout.rooms.map((room) => room.id), ['bed']);
      expect(PlanGeometryUtil.areaInSquareMeters(LayoutRoomsUtil.outlines(layout)['bed']!), closeTo(12, 0.001));
    });

    test('Given walls without rooms, when normalizing, then every area gets a room', () {
      // Given
      final walls = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));

      // When
      final layout = LayoutRoomsUtil.normalize(walls);

      // Then
      expect(layout.rooms, [const LayoutRoom(id: 'room-1', name: 'Room', anchor: PlanPoint(200, 150))]);
    });
  });

  group('LayoutRoomsUtil.toFloorPlan', () {
    test('Given a room with a door, when showing the plan, then the room has its outline and the door its segment', () {
      // Given
      final room = _bedroom();
      final top = LayoutGraphUtil.wallAt(room, const PlanPoint(200, 0), radius: 2)!;
      final layout = room.copyWith(
        openings: [LayoutOpening(id: 'd', wallId: top.id, type: DoorType.door, offset: 100, width: 80)],
      );

      // When
      final plan = LayoutRoomsUtil.toFloorPlan(layout);

      // Then
      expect(plan.rooms.single.name, 'Bedroom');
      expect(PlanGeometryUtil.areaInSquareMeters(plan.rooms.single.polygon), 12);
      expect(plan.doors.single.a, const PlanPoint(60, 0));
      expect(plan.doors.single.b, const PlanPoint(140, 0));
    });
  });
}
