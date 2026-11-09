import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/furnishing.util.dart';
import 'package:smart_hub/domain/floorplan/layout_conversion.util.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

import '../../fixtures/floorplan.fixture.dart';

/// A 4 × 3 m room of [type] with a door in the middle of the bottom wall.
HomeLayout _room(RoomType type) {
  final walls = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));
  final bottom = LayoutGraphUtil.wallAt(walls, const PlanPoint(200, 300), radius: 2)!;
  final (a, _) = LayoutGraphUtil.endsOf(walls, bottom);
  return walls.copyWith(
    rooms: [LayoutRoom(id: 'r', name: type.label, type: type, anchor: const PlanPoint(200, 150))],
    openings: [
      LayoutOpening(
        id: 'd',
        wallId: bottom.id,
        type: DoorType.door,
        offset: a.distanceTo(const PlanPoint(200, 300)),
        width: 80,
      ),
    ],
  );
}

void _expectSensible(HomeLayout layout) {
  final outline = LayoutRoomsUtil.outlineOf(layout, 'r')!;
  for (final item in layout.furniture) {
    for (final corner in FurnishingUtil.cornersOf(item)) {
      expect(PlanGeometryUtil.containsPoint(outline, corner), isTrue, reason: '${item.kind} inside');
    }
    // Nothing stands in the 90 cm in front of the door.
    if (!item.kind.isFlat) {
      expect(
        FurnishingUtil.cornersOf(item).every((c) => !(c.x > 160 && c.x < 240 && c.y > 210)),
        isTrue,
        reason: '${item.kind} clear of the door',
      );
    }
  }
}

void main() {
  group('FurnishingUtil.furnish', () {
    test('Given a bedroom with a door, '
        'when furnishing it, '
        'then it gets a bed with two nightstands and a wardrobe, inside and clear of the door', () {
      // When
      final layout = FurnishingUtil.furnish(_room(RoomType.bedroom), 'r');

      // Then
      final kinds = layout.furniture.map((item) => item.kind).toList();
      expect(kinds.where((kind) => kind == FurnitureKind.bed), hasLength(1));
      expect(kinds.where((kind) => kind == FurnitureKind.nightstand), hasLength(2));
      expect(kinds, contains(FurnitureKind.wardrobe));
      _expectSensible(layout);
    });

    test('Given a living room, when furnishing it, then sofa, coffee table on a rug and a TV opposite come in', () {
      // When
      final layout = FurnishingUtil.furnish(_room(RoomType.living), 'r');

      // Then
      final kinds = layout.furniture.map((item) => item.kind).toSet();
      expect(kinds, containsAll([FurnitureKind.sofa, FurnitureKind.coffeeTable, FurnitureKind.rug]));
      _expectSensible(layout);
    });

    test('Given a kitchen, when furnishing it, then it gets counters along a wall and a fridge', () {
      // When
      final layout = FurnishingUtil.furnish(_room(RoomType.kitchen), 'r');

      // Then
      final kinds = layout.furniture.map((item) => item.kind).toSet();
      expect(kinds, containsAll([FurnitureKind.counter, FurnitureKind.fridge]));
      _expectSensible(layout);
    });

    test('Given a furnished room, when furnishing it again, then its furniture is replaced, not doubled', () {
      // Given
      final once = FurnishingUtil.furnish(_room(RoomType.bedroom), 'r');

      // When
      final twice = FurnishingUtil.furnish(once, 'r');

      // Then
      expect(twice.furniture, hasLength(once.furniture.length));
    });
  });

  group('FurnishingUtil.place', () {
    test(
      'Given a room, when putting a bed down 30 cm from the left wall, then it stands with its back to that wall',
      () {
        // Given
        final layout = _room(RoomType.bedroom);

        // When
        final bed = FurnishingUtil.place(layout, FurnitureKind.bed, const PlanPoint(140, 150), id: 'b');

        // Then
        expect(bed.rotation, 270);
        expect(bed.position.x, closeTo(5 + FurnitureKind.bed.depth / 2 + 1, 0.1));
      },
    );

    test('Given a room, when putting a chair down in its middle, then it stays where it was put', () {
      // When
      final chair = FurnishingUtil.place(
        _room(RoomType.bedroom),
        FurnitureKind.chair,
        const PlanPoint(200, 150),
        id: 'c',
      );

      // Then
      expect(chair.position, const PlanPoint(200, 150));
    });

    test('Given a room with outer walls, when putting a bed down near the left one, then its back touches the wall\'s '
        'inner face (outer walls grow outwards)', () {
      // Given
      final layout = _room(RoomType.bedroom).copyWith(
        walls: [for (final wall in _room(RoomType.bedroom).walls) wall.copyWith(thickness: LayoutWall.outerThickness)],
      );

      // When
      final bed = FurnishingUtil.place(layout, FurnitureKind.bed, const PlanPoint(140, 150), id: 'b');

      // Then
      expect(bed.position.x, closeTo(LayoutWall.innerThickness / 2 + FurnitureKind.bed.depth / 2 + 1, 0.1));
    });
  });

  group('FurnishingUtil.touchWall', () {
    const desk = Furniture(
      id: 'd',
      kind: FurnitureKind.desk,
      position: PlanPoint(200, 150),
      rotation: 30,
      width: 120,
      depth: 60,
    );

    test('Given a piece in the middle of the room, when snapping it, then it stays where it is, turned as it was', () {
      // When
      final snapped = FurnishingUtil.touchWall(_room(RoomType.office), desk, reach: 10);

      // Then
      expect(snapped, desk);
    });

    test('Given an unturned piece 8 cm from the left wall\'s face, when snapping within 10 cm, then it touches the '
        'wall and keeps its turn', () {
      // Given
      final near = desk.copyWith(rotation: 90, position: const PlanPoint(5 + 8 + 30, 150));

      // When
      final snapped = FurnishingUtil.touchWall(_room(RoomType.office), near, reach: 10);

      // Then
      expect(snapped.position.x, closeTo(5 + 30, 0.1));
      expect(snapped.position.y, 150);
      expect(snapped.rotation, 90);
    });

    test('Given a piece 30 cm from the wall, when snapping within 10 cm, then it is left where it is', () {
      // Given
      final away = desk.copyWith(rotation: 90, position: const PlanPoint(5 + 30 + 30, 150));

      // When
      final snapped = FurnishingUtil.touchWall(_room(RoomType.office), away, reach: 10);

      // Then
      expect(snapped, away);
    });
  });

  group('FurnishingUtil.keepInside', () {
    test('Given a desk turned so that a corner reaches into the left wall, when keeping it inside, then it is pushed '
        'back into the room', () {
      // Given
      const desk = Furniture(
        id: 'd',
        kind: FurnitureKind.desk,
        position: PlanPoint(20, 150),
        rotation: 90,
        width: 120,
        depth: 60,
      );

      // When
      final kept = FurnishingUtil.keepInside(_room(RoomType.office), desk);

      // Then
      expect(kept.position.x, closeTo(5 + 30, 0.1));
      expect(kept.position.y, 150);
      expect(kept.rotation, 90);
    });

    test('Given a piece wedged into a corner, when keeping it inside, then it moves out of both walls', () {
      // Given
      const table = Furniture(
        id: 't',
        kind: FurnitureKind.diningTable,
        position: PlanPoint(30, 30),
        width: 100,
        depth: 100,
      );

      // When
      final kept = FurnishingUtil.keepInside(_room(RoomType.office), table);

      // Then
      expect(kept.position.x, closeTo(55, 0.1));
      expect(kept.position.y, closeTo(55, 0.1));
    });

    test('Given a piece well inside its room, when keeping it inside, then it stays as it is', () {
      // Given
      const chair = Furniture(
        id: 'c',
        kind: FurnitureKind.chair,
        position: PlanPoint(200, 150),
        rotation: 30,
        width: 45,
        depth: 50,
      );

      // When
      final kept = FurnishingUtil.keepInside(_room(RoomType.office), chair);

      // Then
      expect(kept, chair);
    });
  });

  group('FurnishingUtil.furnishAll', () {
    test('Given the apartment, when furnishing all rooms, then each room with a type gets furniture inside it', () {
      // Given
      final apartment = LayoutConversionUtil.fromFloorPlan(loadApartmentPlan());

      // When
      final layout = FurnishingUtil.furnishAll(apartment);

      // Then
      for (final roomId in ['office', 'kitchen', 'wc', 'sleep', 'hall']) {
        final outline = LayoutRoomsUtil.outlineOf(layout, roomId)!;
        expect(
          layout.furniture.where((item) => PlanGeometryUtil.containsPoint(outline, item.position)),
          isNotEmpty,
          reason: roomId,
        );
      }
    });
  });
}
