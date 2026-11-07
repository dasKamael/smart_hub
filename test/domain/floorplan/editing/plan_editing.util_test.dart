import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/editing/plan_editing.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Two rooms side by side, sharing the wall at x = 400.
FloorPlan _twoRooms({List<Door> doors = const []}) {
  return FloorPlan(
    rooms: [
      Room(id: 'office', name: 'Office', polygon: _box(0, 0, 400, 300)),
      Room(id: 'kitchen', name: 'Kitchen', polygon: _box(400, 0, 700, 300)),
    ],
    doors: doors,
  );
}

List<PlanPoint> _box(double left, double top, double right, double bottom) => [
  PlanPoint(left, top),
  PlanPoint(right, top),
  PlanPoint(right, bottom),
  PlanPoint(left, bottom),
];

void main() {
  group('PlanEditingUtil.snap', () {
    const corners = [PlanPoint(100, 100), PlanPoint(300, 250)];

    test('Given a point 5 cm from a corner, '
        'when snapping with a radius of 10 cm, '
        'then it lands on the corner without guides', () {
      // When
      final result = PlanEditingUtil.snap(const PlanPoint(104, 103), corners, radius: 10);

      // Then
      expect(result.point, const PlanPoint(100, 100));
      expect(result.guideX, isNull);
      expect(result.guideY, isNull);
    });

    test('Given a point exactly 10 cm from a corner, '
        'when snapping with a radius of 10 cm, '
        'then it does not land on the corner', () {
      // When
      final result = PlanEditingUtil.snap(const PlanPoint(110, 100), corners, radius: 10);

      // Then
      expect(result.point, isNot(const PlanPoint(100, 100)));
    });

    test('Given a point far from all corners, '
        'when snapping, '
        'then it is rounded to the 10 cm grid', () {
      // When
      final result = PlanEditingUtil.snap(const PlanPoint(503, 447), corners, radius: 10);

      // Then
      expect(result.point, const PlanPoint(500, 450));
      expect(result.guideX, isNull);
      expect(result.guideY, isNull);
    });

    test('Given a point in line with a corner, '
        'when snapping, '
        'then it takes over that coordinate and reports a guide', () {
      // When
      final result = PlanEditingUtil.snap(const PlanPoint(303, 600), corners, radius: 10);

      // Then
      expect(result.point, const PlanPoint(300, 600));
      expect(result.guideX, 300);
      expect(result.guideY, isNull);
    });
  });

  group('PlanEditingUtil.wallAt', () {
    test('Given a point 10 cm inside the top wall, '
        'when looking for a wall within 24 cm, '
        'then the top edge is found with the closest point on it', () {
      // When
      final hit = PlanEditingUtil.wallAt(_twoRooms(), const PlanPoint(150, 10), radius: 24);

      // Then
      expect(hit?.roomId, 'office');
      expect(hit?.a, PlanPoint.zero);
      expect(hit?.b, const PlanPoint(400, 0));
      expect(hit?.point, const PlanPoint(150, 0));
    });

    test('Given a point in the middle of a room, '
        'when looking for a wall within 24 cm, '
        'then there is none', () {
      expect(PlanEditingUtil.wallAt(_twoRooms(), const PlanPoint(200, 150), radius: 24), isNull);
    });

    test('Given a point exactly 24 cm from the nearest wall, '
        'when looking within 24 cm, '
        'then there is none', () {
      expect(PlanEditingUtil.wallAt(_twoRooms(), const PlanPoint(200, 24), radius: 24), isNull);
    });
  });

  group('PlanEditingUtil.placeOpening', () {
    const wall = WallHit(roomId: 'office', index: 0, a: PlanPoint.zero, b: PlanPoint(400, 0), point: PlanPoint(152, 0));

    test('Given a tap on a long wall, '
        'when placing an 80 cm door, '
        'then it is centered on the tap rounded to 5 cm', () {
      // When
      final door = PlanEditingUtil.placeOpening(wall, id: 'd1', type: DoorType.door, width: 80);

      // Then
      expect(door, const Door(id: 'd1', type: DoorType.door, a: PlanPoint(110, 0), b: PlanPoint(190, 0)));
    });

    test('Given a tap next to a corner, '
        'when placing a 100 cm window, '
        'then it is pushed back onto the wall', () {
      // When
      final window = PlanEditingUtil.placeOpening(
        const WallHit(roomId: 'office', index: 0, a: PlanPoint.zero, b: PlanPoint(400, 0), point: PlanPoint(10, 0)),
        id: 'w1',
        type: DoorType.window,
        width: 100,
      );

      // Then
      expect(window.a, PlanPoint.zero);
      expect(window.b, const PlanPoint(100, 0));
    });

    test('Given a wall shorter than the opening, '
        'when placing, '
        'then the opening takes the whole wall', () {
      // When
      final door = PlanEditingUtil.placeOpening(
        const WallHit(roomId: 'wc', index: 0, a: PlanPoint.zero, b: PlanPoint(0, 60), point: PlanPoint(0, 30)),
        id: 'd1',
        type: DoorType.door,
        width: 80,
      );

      // Then
      expect(door.a, PlanPoint.zero);
      expect(door.b, const PlanPoint(0, 60));
    });
  });

  group('PlanEditingUtil.wallOf', () {
    test('Given a door on the shared wall, '
        'when looking for its wall, '
        'then the edge it lies on is found', () {
      // Given
      const door = Door(id: 'd1', type: DoorType.door, a: PlanPoint(400, 100), b: PlanPoint(400, 180));

      // When
      final wall = PlanEditingUtil.wallOf(_twoRooms(doors: [door]), door);

      // Then
      expect(wall?.roomId, 'office');
      expect(wall?.point, const PlanPoint(400, 140));
    });

    test('Given a door that no longer lies on a wall, when looking for its wall, then there is none', () {
      // Given
      const door = Door(id: 'd1', type: DoorType.door, a: PlanPoint(200, 100), b: PlanPoint(200, 180));

      // Then
      expect(PlanEditingUtil.wallOf(_twoRooms(doors: [door]), door), isNull);
    });
  });

  group('PlanEditingUtil.resizeOpening and slideOpening', () {
    const door = Door(id: 'd1', type: DoorType.door, a: PlanPoint(110, 0), b: PlanPoint(190, 0));

    test('Given an 80 cm door, '
        'when resizing it to 100 cm, '
        'then it keeps its center', () {
      // When
      final resized = PlanEditingUtil.resizeOpening(_twoRooms(doors: [door]), door, 100);

      // Then
      expect(resized, const Door(id: 'd1', type: DoorType.door, a: PlanPoint(100, 0), b: PlanPoint(200, 0)));
    });

    test('Given a door, '
        'when sliding it beyond the end of its wall, '
        'then it stops at the corner and keeps its width', () {
      // When
      final slid = PlanEditingUtil.slideOpening(_twoRooms(doors: [door]), door, const PlanPoint(500, 40));

      // Then
      expect(slid.a, const PlanPoint(320, 0));
      expect(slid.b, const PlanPoint(400, 0));
    });
  });

  group('PlanEditingUtil corners', () {
    final square = _box(0, 0, 100, 100);

    test('Given a square, when moving its second corner, then only that corner changes', () {
      // When
      final moved = PlanEditingUtil.moveCorner(square, 1, const PlanPoint(120, -10));

      // Then
      expect(moved, [PlanPoint.zero, const PlanPoint(120, -10), const PlanPoint(100, 100), const PlanPoint(0, 100)]);
    });

    test('Given a square, when inserting a corner after the first one, then it sits between the first two', () {
      // When
      final inserted = PlanEditingUtil.insertCorner(square, 0, const PlanPoint(50, 0));

      // Then
      expect(inserted, hasLength(5));
      expect(inserted[1], const PlanPoint(50, 0));
    });

    test('Given a square, when removing a corner, then a triangle is left', () {
      expect(PlanEditingUtil.removeCorner(square, 2), [
        PlanPoint.zero,
        const PlanPoint(100, 0),
        const PlanPoint(0, 100),
      ]);
    });

    test('Given a triangle, when removing a corner, then it is refused', () {
      expect(PlanEditingUtil.removeCorner(square.sublist(0, 3), 0), isNull);
    });

    test('Given corners and a point 5 cm from the third one, '
        'when looking for a corner within 10 cm, '
        'then the third one is found', () {
      expect(PlanEditingUtil.cornerAt(square, const PlanPoint(103, 96), radius: 10), 2);
    });

    test('Given a point 5 cm from the middle of the top edge, '
        'when looking for an edge middle within 10 cm, '
        'then the top edge is found', () {
      expect(PlanEditingUtil.edgeMiddleAt(square, const PlanPoint(50, 5), radius: 10), 0);
    });
  });

  group('PlanEditingUtil.rectangle', () {
    test('Given two opposite corners in any order, when drawing a rectangle, then it starts at the top left', () {
      expect(PlanEditingUtil.rectangle(const PlanPoint(200, 150), const PlanPoint(100, 50)), _box(100, 50, 200, 150));
    });

    test('Given a side of exactly 50 cm, when drawing, then the rectangle is kept', () {
      expect(PlanEditingUtil.rectangle(PlanPoint.zero, const PlanPoint(50, 80)), isNotNull);
    });

    test('Given a side shorter than 50 cm, when drawing, then there is no rectangle', () {
      expect(PlanEditingUtil.rectangle(PlanPoint.zero, const PlanPoint(49, 80)), isNull);
    });
  });

  group('PlanEditingUtil.gridDelta', () {
    test('Given a finger moved 14 cm right and 26 cm up, when rounding, then the room moves 10 right and 30 up', () {
      expect(PlanEditingUtil.gridDelta(PlanPoint.zero, const PlanPoint(14, -26)), const PlanPoint(10, -30));
    });
  });

  group('PlanEditingUtil.moveRoom', () {
    test('Given a door on the office wall and one on the kitchen wall, '
        'when moving the kitchen, '
        'then the shared door and the kitchen door move with it', () {
      // Given
      const shared = Door(id: 'shared', type: DoorType.door, a: PlanPoint(400, 100), b: PlanPoint(400, 180));
      const office = Door(id: 'office', type: DoorType.window, a: PlanPoint(100, 0), b: PlanPoint(200, 0));
      const kitchen = Door(id: 'kitchen', type: DoorType.window, a: PlanPoint(500, 0), b: PlanPoint(600, 0));

      // When
      final plan = PlanEditingUtil.moveRoom(
        _twoRooms(doors: [shared, office, kitchen]),
        'kitchen',
        const PlanPoint(50, 0),
      );

      // Then
      expect(plan.rooms[1].polygon, _box(450, 0, 750, 300));
      expect(plan.rooms[0].polygon, _box(0, 0, 400, 300));
      expect(plan.doors.map((d) => d.a), [const PlanPoint(450, 100), const PlanPoint(100, 0), const PlanPoint(550, 0)]);
    });
  });

  group('PlanEditingUtil.deleteRoom', () {
    test('Given an opening elsewhere that lies on no wall, '
        'when deleting the kitchen, '
        'then that opening is left alone', () {
      // Given
      const loose = Door(id: 'loose', type: DoorType.open, a: PlanPoint(100, 100), b: PlanPoint(100, 180));

      // When
      final plan = PlanEditingUtil.deleteRoom(_twoRooms(doors: [loose]), 'kitchen');

      // Then
      expect(plan.doors, [loose]);
    });

    test('Given a door on the shared wall and a window only on the kitchen, '
        'when deleting the kitchen, '
        'then the shared door stays and the kitchen window is gone', () {
      // Given
      const shared = Door(id: 'shared', type: DoorType.door, a: PlanPoint(400, 100), b: PlanPoint(400, 180));
      const kitchen = Door(id: 'kitchen', type: DoorType.window, a: PlanPoint(500, 0), b: PlanPoint(600, 0));

      // When
      final plan = PlanEditingUtil.deleteRoom(_twoRooms(doors: [shared, kitchen]), 'kitchen');

      // Then
      expect(plan.rooms.map((r) => r.id), ['office']);
      expect(plan.doors.map((d) => d.id), ['shared']);
    });
  });

  group('PlanEditingUtil.withRoomPolygon', () {
    test('Given a window on the top wall of the office, '
        'when the top left corner moves up, '
        'then the window is put back onto the moved wall with its width', () {
      // Given
      const window = Door(id: 'w', type: DoorType.window, a: PlanPoint(100, 0), b: PlanPoint(200, 0));
      final plan = _twoRooms(doors: [window]);
      final polygon = PlanEditingUtil.moveCorner(plan.rooms.first.polygon, 0, const PlanPoint(0, -100));

      // When
      final moved = PlanEditingUtil.withRoomPolygon(plan, 'office', polygon);

      // Then
      final opening = moved.doors.single;
      expect(PlanEditingUtil.wallOf(moved, opening)?.roomId, 'office');
      expect(opening.a.distanceTo(opening.b), closeTo(100, 0.2));
    });

    test('Given a door in the middle of the top wall, '
        'when a corner is inserted under it, '
        'then the door lies on one of the two new walls', () {
      // Given
      const door = Door(id: 'd', type: DoorType.door, a: PlanPoint(160, 0), b: PlanPoint(240, 0));
      final plan = _twoRooms(doors: [door]);
      final polygon = PlanEditingUtil.insertCorner(plan.rooms.first.polygon, 0, const PlanPoint(200, 0));

      // When
      final changed = PlanEditingUtil.withRoomPolygon(plan, 'office', polygon);

      // Then
      expect(PlanEditingUtil.wallOf(changed, changed.doors.single), isNotNull);
      expect(changed.doors.single.a.distanceTo(changed.doors.single.b), 80);
    });

    test('Given a door on the shared wall, '
        'when a corner of the office away from it moves, '
        'then the door stays where it is', () {
      // Given
      const door = Door(id: 'd', type: DoorType.door, a: PlanPoint(400, 100), b: PlanPoint(400, 180));
      final plan = _twoRooms(doors: [door]);
      final polygon = PlanEditingUtil.moveCorner(plan.rooms.first.polygon, 0, const PlanPoint(-50, 0));

      // When
      final changed = PlanEditingUtil.withRoomPolygon(plan, 'office', polygon);

      // Then
      expect(changed.doors.single, door);
    });
  });

  group('PlanEditingUtil openings on a diagonal wall', () {
    final diagonal = FloorPlan(
      rooms: [
        Room(id: 'hall', name: 'Hall', polygon: const [PlanPoint.zero, PlanPoint(300, 400), PlanPoint(0, 400)]),
      ],
    );

    test('Given a door on a diagonal wall, '
        'when sliding it in many small steps from its start, '
        'then it stays on the wall and keeps its width', () {
      // Given
      final wall = PlanEditingUtil.wallAt(diagonal, const PlanPoint(150, 195), radius: 24)!;
      final door = PlanEditingUtil.placeOpening(wall, id: 'd', type: DoorType.door, width: 80);

      // When
      var slid = door;
      for (var i = 1; i <= 20; i++) {
        slid = PlanEditingUtil.slideOpening(diagonal, door, PlanPoint(150 + i * 3.0, 200 + i * 4.0));
      }

      // Then
      expect(PlanEditingUtil.wallOf(diagonal, slid), isNotNull);
      expect(slid.a.distanceTo(slid.b), closeTo(80, 0.15));
    });
  });

  group('PlanEditingUtil.closesDraft', () {
    const draft = [PlanPoint.zero, PlanPoint(100, 0), PlanPoint(100, 100)];

    test('Given three corners, when tapping 5 cm from the first, then the draft closes', () {
      expect(PlanEditingUtil.closesDraft(draft, const PlanPoint(3, 4), radius: 10), isTrue);
    });

    test('Given two corners, when tapping on the first, then the draft does not close', () {
      expect(PlanEditingUtil.closesDraft(draft.sublist(0, 2), PlanPoint.zero, radius: 10), isFalse);
    });
  });

  group('PlanEditingUtil.nextId', () {
    test('Given room-1 and room-3 exist, when asking for a new id, then room-2 is free', () {
      expect(PlanEditingUtil.nextId('room-', ['room-1', 'room-3', 'office']), 'room-2');
    });
  });

  group('PlanEditingUtil.centroid', () {
    test('Given an L shaped room, when computing its centroid, then it is the area center', () {
      // Given
      const polygon = [
        PlanPoint.zero,
        PlanPoint(200, 0),
        PlanPoint(200, 100),
        PlanPoint(100, 100),
        PlanPoint(100, 200),
        PlanPoint(0, 200),
      ];

      // When
      final center = PlanEditingUtil.centroid(polygon);

      // Then
      expect(center.x, closeTo(83.33, 0.01));
      expect(center.y, closeTo(83.33, 0.01));
    });
  });
}
