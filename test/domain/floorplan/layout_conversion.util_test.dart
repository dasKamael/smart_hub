import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/layout_conversion.util.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

import '../../fixtures/floorplan.fixture.dart';

void main() {
  group('LayoutConversionUtil.fromFloorPlan', () {
    final apartment = loadApartmentPlan();
    late HomeLayout layout;

    setUp(() => layout = LayoutConversionUtil.fromFloorPlan(apartment));

    test('Given the apartment as room outlines, '
        'when turning it into walls, '
        'then the same seven rooms come out with the same areas', () {
      // When
      final plan = LayoutRoomsUtil.toFloorPlan(layout);

      // Then
      expect(plan.rooms.map((room) => room.id), apartment.rooms.map((room) => room.id));
      for (final room in apartment.rooms) {
        final converted = plan.rooms.firstWhere((other) => other.id == room.id);
        expect(
          PlanGeometryUtil.areaInSquareMeters(converted.polygon),
          closeTo(PlanGeometryUtil.areaInSquareMeters(room.polygon), 0.001),
          reason: room.name,
        );
      }
    });

    test('Given walls shared by two rooms, when turning them into walls, then each exists only once', () {
      // Then
      final pairs = {
        for (final wall in layout.walls) ([wall.from, wall.to]..sort()).join('|'),
      };
      expect(pairs, hasLength(layout.walls.length));
      // The kitchen and the WC share the wall with the WC door.
      final door = layout.openings.firstWhere((opening) => opening.id == 'd5');
      final (a, b) = LayoutGraphUtil.openingSegment(layout, door)!;
      expect(a, const PlanPoint(745, 365));
      expect(b, const PlanPoint(795, 365));
    });

    test('Given the apartment, when turning it into walls, then every door hangs on a wall at its old place', () {
      // Then
      expect(layout.openings, hasLength(apartment.doors.length));
      for (final door in apartment.doors) {
        final (a, b) = LayoutGraphUtil.openingSegment(layout, layout.openings.firstWhere((o) => o.id == door.id))!;
        final middle = PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);
        expect(middle.distanceTo(PlanPoint((door.a.x + door.b.x) / 2, (door.a.y + door.b.y) / 2)), lessThan(1));
        expect(a.distanceTo(b), closeTo(door.a.distanceTo(door.b), 1));
      }
    });

    test('Given the apartment, when turning it into walls, then outer walls are thick and inner walls thin', () {
      // Then
      LayoutWall wallThrough(PlanPoint point) => LayoutGraphUtil.wallAt(layout, point, radius: 2)!;
      expect(wallThrough(const PlanPoint(200, 0)).thickness, LayoutWall.outerThickness);
      expect(wallThrough(const PlanPoint(715, 200)).thickness, LayoutWall.innerThickness);
    });

    test('Given room names, when turning them into walls, then the rooms get their type from the name', () {
      // Then
      final types = {for (final room in layout.rooms) room.id: room.type};
      expect(types, {
        'office': RoomType.office,
        'storage': RoomType.storage,
        'storage2': RoomType.storage,
        'hall': RoomType.hall,
        'kitchen': RoomType.kitchen,
        'wc': RoomType.wc,
        'sleep': RoomType.bedroom,
      });
    });
  });
}
