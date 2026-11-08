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
