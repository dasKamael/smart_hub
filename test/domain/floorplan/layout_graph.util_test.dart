import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/layout_conversion.util.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

import '../../fixtures/floorplan.fixture.dart';

/// Outlines of all rooms by id, without corners on straight walls.
Map<String, List<PlanPoint>> _outlines(HomeLayout layout) => {
  for (final room in LayoutRoomsUtil.toFloorPlan(layout).rooms) room.id: room.polygon,
};

/// [after] with its rooms given to the areas they had in [before].
HomeLayout _rooms(HomeLayout before, HomeLayout after) =>
    LayoutRoomsUtil.normalize(after, previousOutlines: LayoutRoomsUtil.outlines(before));

double _area(HomeLayout layout, String roomId) => PlanGeometryUtil.areaInSquareMeters(_outlines(layout)[roomId]!);

void main() {
  group('LayoutGraphUtil.addWall', () {
    test('Given an empty plan, when adding a rectangle, then four walls between four junctions make one area', () {
      // When
      final layout = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));

      // Then
      expect(layout.nodes, hasLength(4));
      expect(layout.walls, hasLength(4));
      expect(LayoutRoomsUtil.areas(layout), hasLength(1));
    });

    test('Given a rectangle, '
        'when adding a second one sharing a wall, '
        'then the shared wall exists once and there are two areas', () {
      // Given
      final first = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));

      // When
      final layout = LayoutGraphUtil.addRectangle(first, const PlanPoint(400, 0), const PlanPoint(700, 300));

      // Then
      expect(layout.walls, hasLength(7));
      expect(LayoutRoomsUtil.areas(layout), hasLength(2));
    });

    test('Given a rectangle, '
        'when adding a smaller one against part of its wall, '
        'then that wall is split where the new walls end on it', () {
      // Given
      final first = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));

      // When
      final layout = LayoutGraphUtil.addRectangle(first, const PlanPoint(100, 300), const PlanPoint(250, 450));

      // Then
      expect(layout.nodes, hasLength(8));
      expect(layout.walls, hasLength(4 + 2 + 3));
      expect(LayoutRoomsUtil.areas(layout), hasLength(2));
    });

    test('Given a rectangle, when adding a wall across it from wall to wall, then the area is split in two', () {
      // Given
      final room = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));

      // When
      final layout = LayoutGraphUtil.addWall(room, const PlanPoint(150, 0), const PlanPoint(150, 300));

      // Then
      final areas = LayoutRoomsUtil.areas(layout).map(PlanGeometryUtil.areaInSquareMeters).toList()..sort();
      expect(areas, [closeTo(4.5, 0.001), closeTo(7.5, 0.001)]);
    });

    test('Given two walls, when adding one that crosses both, then all three are split at the crossings', () {
      // Given
      var layout = LayoutGraphUtil.addWall(const HomeLayout(), const PlanPoint(0, 100), const PlanPoint(300, 100));
      layout = LayoutGraphUtil.addWall(layout, const PlanPoint(0, 200), const PlanPoint(300, 200));

      // When
      layout = LayoutGraphUtil.addWall(layout, const PlanPoint(150, 0), const PlanPoint(150, 300));

      // Then
      expect(layout.walls, hasLength(2 + 2 + 3));
    });

    test('Given a wall, when adding the same wall again, then nothing is added', () {
      // Given
      final layout = LayoutGraphUtil.addWall(const HomeLayout(), PlanPoint.zero, const PlanPoint(300, 0));

      // When
      final again = LayoutGraphUtil.addWall(layout, const PlanPoint(300, 0), PlanPoint.zero);

      // Then
      expect(again, layout);
    });

    test(
      'Given a door on a wall, when another wall is added ending on the wall behind the door, then it keeps place',
      () {
        // Given
        var layout = LayoutGraphUtil.addWall(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 0));
        layout = layout.copyWith(
          openings: [
            LayoutOpening(id: 'd', wallId: layout.walls.single.id, type: DoorType.door, offset: 300, width: 80),
          ],
        );

        // When
        layout = LayoutGraphUtil.addWall(layout, const PlanPoint(100, 0), const PlanPoint(100, 200));

        // Then
        final (a, b) = LayoutGraphUtil.openingSegment(layout, layout.openings.single)!;
        expect(a, const PlanPoint(260, 0));
        expect(b, const PlanPoint(340, 0));
      },
    );
  });

  group('LayoutGraphUtil.removeWall', () {
    test('Given a room split by a wall, '
        'when removing that wall, '
        'then the room is whole again and its walls run straight through', () {
      // Given
      final room = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));
      final split = LayoutGraphUtil.addWall(room, const PlanPoint(150, 0), const PlanPoint(150, 300));
      final middle = LayoutGraphUtil.wallAt(split, const PlanPoint(150, 150), radius: 2)!;

      // When
      final layout = LayoutGraphUtil.removeWall(split, middle.id);

      // Then
      expect(layout.walls, hasLength(4));
      expect(layout.nodes, hasLength(4));
      expect(LayoutRoomsUtil.areas(layout), hasLength(1));
    });
  });

  group('LayoutGraphUtil.moveWall on the apartment', () {
    late HomeLayout apartment;

    setUp(() => apartment = LayoutConversionUtil.fromFloorPlan(loadApartmentPlan()));

    LayoutWall wallThrough(HomeLayout layout, PlanPoint point) => LayoutGraphUtil.wallAt(layout, point, radius: 2)!;

    test('Given the WC wall with the door, '
        'when moving it 60 cm up, '
        'then the WC gets smaller, the kitchen bigger by the same, and the door goes along', () {
      // Given
      final wall = wallThrough(apartment, const PlanPoint(770, 365));

      // When
      final layout = _rooms(apartment, LayoutGraphUtil.moveWall(apartment, wall.id, const PlanPoint(0, -60)));

      // Then
      expect(_area(layout, 'wc'), closeTo(_area(apartment, 'wc') - 0.66, 0.001));
      expect(_area(layout, 'kitchen'), closeTo(_area(apartment, 'kitchen') + 0.66, 0.001));
      expect(_area(layout, 'sleep'), closeTo(_area(apartment, 'sleep'), 0.001));
      final (a, b) = LayoutGraphUtil.openingSegment(layout, layout.openings.firstWhere((o) => o.id == 'd5'))!;
      expect(a, const PlanPoint(745, 305));
      expect(b, const PlanPoint(795, 305));
    });

    test('Given the storage below part of the long office wall, '
        'when moving the storage top wall 30 cm down, '
        'then the office takes the freed strip and storage 2 stays as it is', () {
      // Given
      final wall = wallThrough(apartment, const PlanPoint(320, 270));

      // When
      final layout = _rooms(apartment, LayoutGraphUtil.moveWall(apartment, wall.id, const PlanPoint(10, 30)));

      // Then
      expect(_area(layout, 'storage'), closeTo(_area(apartment, 'storage') - 0.27, 0.001));
      expect(_area(layout, 'storage2'), closeTo(_area(apartment, 'storage2'), 0.001));
      expect(_outlines(layout)['storage'], containsAll(const [PlanPoint(280, 300), PlanPoint(370, 300)]));
      expect(_outlines(layout)['office'], containsAll(const [PlanPoint(370, 270), PlanPoint(370, 300)]));
      expect(
        _area(layout, 'office') + _area(layout, 'hall'),
        closeTo(_area(apartment, 'office') + _area(apartment, 'hall') + 0.27, 0.001),
      );
    });

    test('Given storage 2 above part of the hall wall, '
        'when moving its bottom wall 65 cm up, '
        'then the hall takes the freed space and the opening on that wall goes along', () {
      // Given
      final wall = wallThrough(apartment, const PlanPoint(410, 365));

      // When
      final layout = _rooms(apartment, LayoutGraphUtil.moveWall(apartment, wall.id, const PlanPoint(0, -65)));

      // Then
      expect(_area(layout, 'storage2'), closeTo(0.24, 0.001));
      expect(_area(layout, 'hall'), closeTo(_area(apartment, 'hall') + 0.52, 0.001));
      final (a, _) = LayoutGraphUtil.openingSegment(layout, layout.openings.firstWhere((o) => o.id == 'd3'))!;
      expect(a.y, 300);
      final (b, _) = LayoutGraphUtil.openingSegment(layout, layout.openings.firstWhere((o) => o.id == 'd2'))!;
      expect(b.y, 365);
    });
  });

  group('LayoutGraphUtil.moveNode', () {
    test('Given a window in the middle of a wall, when moving one end of the wall, then it stays in its middle', () {
      // Given
      var layout = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));
      final top = LayoutGraphUtil.wallAt(layout, const PlanPoint(200, 0), radius: 2)!;
      layout = layout.copyWith(
        openings: [LayoutOpening(id: 'w', wallId: top.id, type: DoorType.window, offset: 200, width: 100)],
      );
      final corner = LayoutGraphUtil.nodeAt(layout, const PlanPoint(400, 0), radius: 2)!;

      // When
      layout = LayoutGraphUtil.moveNode(layout, corner.id, const PlanPoint(600, 0));

      // Then
      final (a, b) = LayoutGraphUtil.openingSegment(layout, layout.openings.single)!;
      expect((a.x + b.x) / 2, closeTo(300, 0.001));
    });
  });
}
