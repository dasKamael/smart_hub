import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

import '../../fixtures/floorplan.fixture.dart';

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
      final created = layout.rooms.last.id;
      expect(PlanGeometryUtil.areaInSquareMeters(outlines[created]!), closeTo(3.9, 0.001));
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
      final layout = withClock(Clock.fixed(DateTime(2026, 11, 8)), () => LayoutRoomsUtil.normalize(walls));

      // Then
      final id = withClock(Clock.fixed(DateTime(2026, 11, 8)), () => LayoutRoomsUtil.newRoomId(const []));
      expect(layout.rooms, [LayoutRoom(id: id, name: 'Room', anchor: const PlanPoint(200, 150))]);
    });

    test('Given a room id that is taken, when making a new id, then it is a different one', () {
      final id = withClock(Clock.fixed(DateTime(2026, 11, 8)), () => LayoutRoomsUtil.newRoomId(const []));
      final next = withClock(Clock.fixed(DateTime(2026, 11, 8)), () => LayoutRoomsUtil.newRoomId([id]));
      expect(next, isNot(id));
    });
  });

  group('LayoutRoomsUtil.normalize after big moves', () {
    test('Given the WC wall moved far into the kitchen, '
        'when matching rooms, '
        'then the kitchen keeps the larger part and the WC its own, by overlap', () {
      // Given
      final apartment = loadApartmentLayout();
      final wall = LayoutGraphUtil.wallAt(apartment, const PlanPoint(715, 200), radius: 2)!;

      // When
      final moved = LayoutGraphUtil.moveWall(apartment, wall.id, const PlanPoint(-215, 0));
      final layout = LayoutRoomsUtil.normalize(moved, previousOutlines: LayoutRoomsUtil.outlines(apartment));

      // Then
      final outlines = LayoutRoomsUtil.outlines(layout);
      expect(PlanGeometryUtil.containsPoint(outlines['wc']!, const PlanPoint(770, 100)), isTrue);
      expect(PlanGeometryUtil.containsPoint(outlines['kitchen']!, const PlanPoint(470, 420)), isTrue);
    });

    test('Given a room drawn inside another, when looking up outlines, then each room gets its own area', () {
      // Given
      var layout = _bedroom();
      layout = LayoutGraphUtil.addRectangle(layout, const PlanPoint(100, 100), const PlanPoint(200, 200));
      layout = LayoutRoomsUtil.normalize(layout, previousOutlines: LayoutRoomsUtil.outlines(_bedroom()));

      // When
      final outlines = LayoutRoomsUtil.outlines(layout);

      // Then
      final inner = layout.rooms.firstWhere((room) => room.id != 'bed').id;
      expect(PlanGeometryUtil.areaInSquareMeters(outlines[inner]!), closeTo(1, 0.001));
      expect(PlanGeometryUtil.areaInSquareMeters(outlines['bed']!), closeTo(12, 0.001));
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
