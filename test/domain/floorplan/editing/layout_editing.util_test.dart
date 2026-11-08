import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/editing/layout_editing.util.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';

/// Two rooms of 4 × 3 m side by side.
HomeLayout _rooms() {
  var layout = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));
  layout = LayoutGraphUtil.addRectangle(layout, const PlanPoint(400, 0), const PlanPoint(800, 300));
  return LayoutRoomsUtil.normalize(
    layout.copyWith(
      rooms: const [
        LayoutRoom(id: 'a', name: 'Office', type: RoomType.office, anchor: PlanPoint(200, 150)),
        LayoutRoom(id: 'b', name: 'Kitchen', type: RoomType.kitchen, anchor: PlanPoint(600, 150)),
      ],
    ),
  );
}

void main() {
  group('LayoutEditingUtil.snap', () {
    test('Given a point 8 cm from a junction, when snapping within 10 cm, then it lands on the junction', () {
      final result = LayoutEditingUtil.snap(_rooms(), const PlanPoint(406, 5), radius: 10);
      expect(result.point, const PlanPoint(400, 0));
      expect(result.onDrawing, isTrue);
    });

    test('Given a point next to a wall, when snapping, then it lands on the wall in 5 cm steps', () {
      final result = LayoutEditingUtil.snap(_rooms(), const PlanPoint(203, 4), radius: 10);
      expect(result.point, const PlanPoint(205, 0));
      expect(result.onDrawing, isTrue);
    });

    test('Given a point in free space in line with a junction, when snapping, then it aligns with a guide', () {
      final result = LayoutEditingUtil.snap(_rooms(), const PlanPoint(406, 512), radius: 10);
      expect(result.point, const PlanPoint(400, 510));
      expect(result.guideX, 400);
      expect(result.onDrawing, isFalse);
    });

    test('Given a point drawn but not stored yet, when snapping next to it, then it counts like a junction', () {
      final result = LayoutEditingUtil.snap(
        _rooms(),
        const PlanPoint(1003, 498),
        radius: 10,
        drawn: const [PlanPoint(1000, 500)],
      );
      expect(result.point, const PlanPoint(1000, 500));
    });
  });

  group('LayoutEditingUtil.splitLine', () {
    final outline = LayoutRoomsUtil.outlineOf(_rooms(), 'a')!;

    test('Given a short, slightly slanted stroke inside a room, '
        'when making the split line, '
        'then it is straight and reaches both walls', () {
      // When
      final (from, to) = LayoutEditingUtil.splitLine(outline, const PlanPoint(150, 100), const PlanPoint(155, 200))!;

      // Then
      expect({from, to}, {const PlanPoint(150, 0), const PlanPoint(150, 300)});
    });

    test('Given a stroke shorter than 30 cm, when making the split line, then there is none', () {
      expect(LayoutEditingUtil.splitLine(outline, const PlanPoint(150, 100), const PlanPoint(150, 120)), isNull);
    });
  });

  group('LayoutEditingUtil openings', () {
    test(
      'Given a drag from close to one end of a wall to close to the other, when placing, then it spans the wall',
      () {
        // Given
        final layout = _rooms();
        final wall = LayoutGraphUtil.wallAt(layout, const PlanPoint(400, 150), radius: 2)!;

        // When
        final opening = LayoutEditingUtil.openingBetween(
          layout,
          wall,
          id: 'o',
          type: DoorType.open,
          from: const PlanPoint(400, 12),
          to: const PlanPoint(400, 290),
          snap: 20,
        );

        // Then
        expect(opening.width, 300);
        expect(opening.offset, 150);
      },
    );

    test('Given a tap next to a corner, when placing a door, then it stays on the wall', () {
      // Given
      final layout = _rooms();
      final wall = LayoutGraphUtil.wallAt(layout, const PlanPoint(200, 0), radius: 2)!;

      // When
      final door = LayoutEditingUtil.openingOn(
        layout,
        wall,
        id: 'd',
        type: DoorType.door,
        center: const PlanPoint(10, 0),
      );

      // Then
      expect(LayoutGraphUtil.openingSegment(layout.copyWith(openings: [door]), door)!.$1.x, anyOf(0, 400));
    });
  });

  group('LayoutEditingUtil rooms', () {
    test('Given an office, when naming another room an office, then it gets a number', () {
      expect(LayoutEditingUtil.nameFor(_rooms(), RoomType.office, exceptRoomId: 'b'), 'Office 2');
      expect(LayoutEditingUtil.nameFor(_rooms(), RoomType.office, exceptRoomId: 'a'), 'Office');
    });

    test('Given two rooms, when deleting one, then its own walls go and the shared one stays', () {
      // When
      final layout = LayoutEditingUtil.deleteRoom(_rooms(), 'b');

      // Then
      expect(layout.rooms.map((room) => room.id), ['a']);
      expect(layout.walls, hasLength(4));
    });
  });
}
