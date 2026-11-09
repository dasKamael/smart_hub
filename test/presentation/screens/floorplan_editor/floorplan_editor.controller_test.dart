import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';

import '../../../mocks/floorplan.mock.dart';
import '../../../utils/riverpod.test_util.dart';

/// An office (4 × 3 m) and a kitchen (3 × 3 m) side by side, sharing the wall at x = 400.
final editorTestLayout = () {
  var layout = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));
  layout = LayoutGraphUtil.addRectangle(layout, const PlanPoint(400, 0), const PlanPoint(700, 300));
  return layout.copyWith(
    rooms: const [
      LayoutRoom(id: 'office', name: 'Office', type: RoomType.office, anchor: PlanPoint(200, 150)),
      LayoutRoom(id: 'kitchen', name: 'Kitchen', type: RoomType.kitchen, anchor: PlanPoint(550, 150)),
    ],
  );
}();

void main() {
  late FakeHomeLayoutService service;
  late ProviderContainer container;

  FloorplanEditorController controller() => container.read(floorplanEditorControllerProvider.notifier);
  FloorplanEditorState state() => container.read(floorplanEditorControllerProvider);
  Map<String, double> areas() => {
    for (final MapEntry(key: id, value: outline) in LayoutRoomsUtil.outlines(state().layout).entries)
      id: PlanGeometryUtil.areaInSquareMeters(outline),
  };

  setUp(() async {
    service = FakeHomeLayoutService(editorTestLayout);
    container = createTestContainer(overrides: [homeLayoutServiceProvider.overrideWith(() => service)]);
    await container.read(homeLayoutServiceProvider.future);
    container.listen(floorplanEditorControllerProvider, (_, _) {});
  });

  group('rooms', () {
    test('Given the room tool, '
        'when dragging a rectangle against the office, '
        'then a new room sharing its wall is added, selected and saved, and the tool stays', () {
      // Given
      controller().selectTool(EditorTool.room);

      // When
      expect(controller().startDrag(const PlanPoint(0, 300), cmPerPx: 1), isTrue);
      controller()
        ..updateDrag(const PlanPoint(398, 551), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(areas().values.toList()..sort(), [closeTo(9, 0.01), closeTo(10, 0.01), closeTo(12, 0.01)]);
      final created = state().layout.rooms.last;
      expect(state().selection, EditorSelection.room(created.id));
      expect(state().tool, EditorTool.room);
      expect(service.saved.last, state().layout);
    });

    test('Given a new room selected, when picking its type, then it is named after it in one step', () {
      // Given
      controller()
        ..selectTool(EditorTool.room)
        ..startDrag(const PlanPoint(0, 300), cmPerPx: 1)
        ..updateDrag(const PlanPoint(400, 550), cmPerPx: 1)
        ..endDrag();

      // When
      controller().setRoomType(RoomType.bedroom);

      // Then
      expect(state().selectedRoom?.name, 'Bedroom');
      expect(state().selectedRoom?.type, RoomType.bedroom);
    });

    test('Given a second room of the same type, when picking the type, then its name gets a number', () {
      // Given
      controller().select(const EditorSelection.room('kitchen'));

      // When
      controller().setRoomType(RoomType.office);

      // Then
      expect(state().selectedRoom?.name, 'Office 2');
    });

    test('Given the wall tool, '
        'when tapping from one wall of the office to the opposite one, '
        'then two taps split it and the new room is selected', () {
      // Given
      controller().selectTool(EditorTool.wall);

      // When
      controller()
        ..tap(const PlanPoint(152, 3), cmPerPx: 1)
        ..tap(const PlanPoint(148, 298), cmPerPx: 1);

      // Then
      expect(areas()['office'], closeTo(7.5, 0.01));
      expect(state().chain, isEmpty);
      expect(state().selectedRoom?.name, 'Room');
    });

    test('Given the wall tool, when tapping corners in free space and back to the start, then a room is closed', () {
      // Given
      controller().selectTool(EditorTool.wall);

      // When
      for (final point in const [
        PlanPoint(800, 0),
        PlanPoint(1000, 0),
        PlanPoint(1000, 200),
        PlanPoint(800, 200),
        PlanPoint(801, 2),
      ]) {
        controller().tap(point, cmPerPx: 1);
      }

      // Then
      expect(areas().values.where((area) => (area - 4).abs() < 0.01), hasLength(1));
      expect(state().chain, isEmpty);
    });

    test('Given a room, when furnishing it, then it gets the furniture of its type in one step', () {
      // Given
      controller().select(const EditorSelection.room('office'));

      // When
      controller().furnishRoom();

      // Then
      expect(state().layout.furniture.map((item) => item.kind), contains(FurnitureKind.desk));
    });

    test('Given the kitchen selected, when deleting it, then its own walls go and the shared wall stays', () {
      // Given
      controller().select(const EditorSelection.room('kitchen'));

      // When
      controller().deleteRoom();

      // Then
      expect(state().layout.rooms.map((room) => room.id), ['office']);
      expect(state().layout.walls, hasLength(4));
      expect(state().selection, isNull);
    });
  });

  group('walls', () {
    test('Given the select tool, '
        'when dragging the shared wall 50 cm to the right, '
        'then the office grows and the kitchen shrinks by the same, as one undo step', () {
      // When
      expect(controller().startDrag(const PlanPoint(401, 150), cmPerPx: 1), isTrue);
      controller()
        ..updateDrag(const PlanPoint(430, 160), cmPerPx: 1)
        ..updateDrag(const PlanPoint(452, 140), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(areas()['office'], closeTo(13.5, 0.01));
      expect(areas()['kitchen'], closeTo(7.5, 0.01));
      expect(state().past, [editorTestLayout]);
    });

    test('Given the select tool, when dragging a corner, then the walls meeting there follow', () {
      // When
      controller()
        ..startDrag(const PlanPoint(2, 2), cmPerPx: 1)
        ..updateDrag(const PlanPoint(-48, -2), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(areas()['office'], closeTo(12.75, 0.01));
    });

    test('Given a selected wall, when making it an outer wall, then it gets thicker', () {
      // Given
      controller().tap(const PlanPoint(200, 2), cmPerPx: 1);

      // When
      controller().setWallThickness(LayoutWall.outerThickness);

      // Then
      expect(state().selectedWall?.thickness, LayoutWall.outerThickness);
    });
  });

  group('openings', () {
    test('Given the door tool, when tapping the shared wall, then an 80 cm door is put there in one tap', () {
      // Given
      controller().selectTool(EditorTool.door);

      // When
      controller().tap(const PlanPoint(398, 152), cmPerPx: 1);

      // Then
      final door = state().layout.openings.single;
      expect(door.type, DoorType.door);
      expect(door.width, 80);
      expect(state().selection, EditorSelection.opening(door.id));
      expect(state().tool, EditorTool.door);
    });

    test('Given the opening tool, '
        'when dragging along the shared wall from end to end, '
        'then the whole wall is open', () {
      // Given
      controller().selectTool(EditorTool.opening);

      // When
      controller()
        ..startDrag(const PlanPoint(401, 5), cmPerPx: 1)
        ..updateDrag(const PlanPoint(402, 330), cmPerPx: 1)
        ..endDrag();

      // Then
      final opening = state().layout.openings.single;
      expect(opening.type, DoorType.open);
      expect(opening.width, 300);
    });

    test('Given a selected window, when choosing the whole wall, then it spans the wall', () {
      // Given
      controller()
        ..selectTool(EditorTool.window)
        ..tap(const PlanPoint(200, 2), cmPerPx: 1);

      // When
      controller().setOpeningWidth(null);

      // Then
      expect(state().selectedOpening?.width, 400);
    });

    test('Given a selected door, when tapping it again with the door tool, then it swings the other way', () {
      // Given
      controller()
        ..selectTool(EditorTool.door)
        ..tap(const PlanPoint(398, 152), cmPerPx: 1);

      // When
      controller().tap(const PlanPoint(398, 152), cmPerPx: 1);

      // Then
      expect(state().selectedOpening?.swing, 1);
      expect(state().layout.openings, hasLength(1));
    });
  });

  group('walls', () {
    test('Given the wall between office and kitchen, when removing it, then it is open along its whole length and both '
        'rooms stay', () {
      // Given
      final wall = LayoutGraphUtil.wallAt(state().layout, const PlanPoint(400, 150), radius: 2)!;
      controller().select(EditorSelection.wall(wall.id));

      // When
      controller().removeWall();

      // Then
      expect(LayoutGraphUtil.isOpen(state().layout, wall), isTrue);
      expect(state().layout.rooms.map((room) => room.id), containsAll(['office', 'kitchen']));
      expect(state().selectedOpening?.type, DoorType.open);
    });

    test('Given a removed wall, when deleting the opening left, then the wall is back', () {
      // Given
      final wall = LayoutGraphUtil.wallAt(state().layout, const PlanPoint(400, 150), radius: 2)!;
      controller()
        ..select(EditorSelection.wall(wall.id))
        ..removeWall();

      // When
      controller().deleteOpening();

      // Then
      expect(LayoutGraphUtil.isOpen(state().layout, wall), isFalse);
    });
  });

  group('furniture', () {
    test('Given the furniture tool with a bed, '
        'when tapping near the left wall of the office, '
        'then the bed stands with its back against that wall', () {
      // Given
      controller().selectFurnitureKind(FurnitureKind.bed);

      // When
      controller().tap(const PlanPoint(140, 150), cmPerPx: 1);

      // Then
      final bed = state().layout.furniture.single;
      expect(bed.rotation, 270);
      expect(state().selection, EditorSelection.furniture(bed.id));
    });

    test('Given a piece of furniture, when long pressing it, then it turns by a quarter', () {
      // Given
      controller()
        ..selectFurnitureKind(FurnitureKind.chair)
        ..tap(const PlanPoint(200, 150), cmPerPx: 1);

      // When
      controller().longPress(const PlanPoint(200, 150), cmPerPx: 1);

      // Then
      expect(state().layout.furniture.single.rotation, 90);
    });

    /// A coffee table (110 × 60 cm) in the middle of the office, selected, with the furniture tool still picked.
    Furniture placeTable() {
      controller()
        ..selectFurnitureKind(FurnitureKind.coffeeTable)
        ..tap(const PlanPoint(200, 150), cmPerPx: 1);
      return state().selectedFurniture!;
    }

    test(
      'Given a selected table and the furniture tool, when dragging the table, then it moves instead of the view',
      () {
        // Given
        placeTable();

        // When
        final dragging = controller().startDrag(const PlanPoint(200, 150), cmPerPx: 1);
        controller()
          ..updateDrag(const PlanPoint(220, 170), cmPerPx: 1)
          ..endDrag();

        // Then
        expect(dragging, isTrue);
        expect(state().layout.furniture.single.position, const PlanPoint(220, 170));
        expect(state().past, hasLength(2), reason: 'placing and moving are one step each');
      },
    );

    test(
      'Given a table, when dragging it to 40 cm from the office\'s left wall, then it stays under the finger, turned '
      'as it was, instead of jumping to the wall',
      () {
        // Given
        final table = placeTable();

        // When
        controller().startDrag(const PlanPoint(200, 150), cmPerPx: 1);
        controller()
          ..updateDrag(const PlanPoint(100, 150), cmPerPx: 1)
          ..endDrag();

        // Then
        final moved = state().layout.furniture.single;
        expect(moved.position, const PlanPoint(100, 150));
        expect(moved.rotation, table.rotation);
      },
    );

    test('Given a table, when dragging it to a few cm from the left wall, then it snaps flush against it', () {
      // Given
      placeTable();

      // When
      controller().startDrag(const PlanPoint(200, 150), cmPerPx: 1);
      controller()
        ..updateDrag(PlanPoint(LayoutWall.innerThickness / 2 + 55 + 6, 150), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().layout.furniture.single.position.x, closeTo(LayoutWall.innerThickness / 2 + 55, 0.1));
    });

    test('Given a selected chair (45 × 50 cm) at a zoom where its handles are close to its middle, when dragging it '
        'from its middle, then it moves instead of being resized', () {
      // Given
      controller().dropFurniture(FurnitureKind.chair, const PlanPoint(180, 120), cmPerPx: 1.2);

      // When
      expect(controller().startDrag(const PlanPoint(180, 120), cmPerPx: 1.2), isTrue);
      controller()
        ..updateDrag(const PlanPoint(240, 160), cmPerPx: 1.2)
        ..endDrag();

      // Then
      final chair = state().layout.furniture.single;
      expect((chair.width, chair.depth), (FurnitureKind.chair.width, FurnitureKind.chair.depth));
      expect(chair.position, const PlanPoint(240, 160));
    });

    test('Given a selected chair, when dragging its width handle from just outside the chair, then it gets wider', () {
      // Given
      controller().dropFurniture(FurnitureKind.chair, const PlanPoint(180, 120), cmPerPx: 1);

      // When
      controller().startDrag(PlanPoint(180 + FurnitureKind.chair.width / 2 + 8, 120), cmPerPx: 1);
      controller()
        ..updateDrag(PlanPoint(180 + FurnitureKind.chair.width / 2 + 28, 120), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().layout.furniture.single.width, greaterThan(FurnitureKind.chair.width));
    });

    test('Given a chair dragged out of the palette, when dropping it in the office, then it stands where it was '
        'dropped and is selected', () {
      // When
      controller().dropFurniture(FurnitureKind.chair, const PlanPoint(180, 120), cmPerPx: 1);

      // Then
      final chair = state().layout.furniture.single;
      expect(chair.kind, FurnitureKind.chair);
      expect(chair.position, const PlanPoint(180, 120));
      expect(state().selection, EditorSelection.furniture(chair.id));
      expect(state().tool, EditorTool.furniture);
    });

    test('Given a chair dropped outside every room, when dropping it, then nothing is placed', () {
      // When
      controller().dropFurniture(FurnitureKind.chair, const PlanPoint(-200, -200), cmPerPx: 1);

      // Then
      expect(state().layout.furniture, isEmpty);
    });

    test('Given a selected table, when dragging its width handle 20 cm out, then it is 20 cm wider and its left side '
        'stays', () {
      // Given
      placeTable();

      // When
      controller().startDrag(const PlanPoint(255, 150), cmPerPx: 1);
      controller()
        ..updateDrag(const PlanPoint(275, 150), cmPerPx: 1)
        ..endDrag();

      // Then
      final table = state().layout.furniture.single;
      expect((table.width, table.depth), (130, 60));
      expect(table.position, const PlanPoint(210, 150));
    });

    test('Given a selected table, when dragging its turn handle to the left, then its front faces left', () {
      // Given
      placeTable();

      // When
      controller().startDrag(const PlanPoint(200, 150 + 30 + FloorplanEditorController.turnPx), cmPerPx: 1);
      controller()
        ..updateDrag(const PlanPoint(100, 150), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().layout.furniture.single.rotation, 90);
    });

    test('Given a selected table, when tapping its turn handle, then it stays selected and nothing is placed', () {
      // Given
      final table = placeTable();

      // When
      controller().tap(const PlanPoint(200, 150 + 30 + FloorplanEditorController.turnPx), cmPerPx: 1);

      // Then
      expect(state().layout.furniture, hasLength(1));
      expect(state().selection, EditorSelection.furniture(table.id));
    });

    test('Given a selected table, when copying it, then a second one is placed and selected', () {
      // Given
      final table = placeTable();

      // When
      controller().duplicateFurniture();

      // Then
      expect(state().layout.furniture, hasLength(2));
      expect(state().selectedFurniture?.id, isNot(table.id));
      expect(state().selectedFurniture?.kind, FurnitureKind.coffeeTable);
    });

    test('Given a selected table, when making it deeper, then it grows to the front and its back stays', () {
      // Given
      placeTable();

      // When
      controller().setFurnitureSize(depth: 80);

      // Then
      final table = state().layout.furniture.single;
      expect(table.depth, 80);
      expect(table.position, const PlanPoint(200, 160));
    });

    test('Given a selected table, when setting the size it already has, then no undo step is added', () {
      // Given
      final table = placeTable();

      // When
      controller().setFurnitureSize(width: table.width);

      // Then
      expect(state().past, hasLength(1));
    });

    test('Given a table being dragged, when undoing, then the drag ends and the next drag step changes nothing', () {
      // Given
      placeTable();
      controller()
        ..startDrag(const PlanPoint(200, 150), cmPerPx: 1)
        ..updateDrag(const PlanPoint(220, 170), cmPerPx: 1);

      // When
      controller()
        ..undo()
        ..updateDrag(const PlanPoint(240, 190), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().layout.furniture.single.position, const PlanPoint(200, 150));
    });
  });

  group('history', () {
    test('Given a deleted room, when undoing and redoing, then the room comes back and goes again', () {
      // Given
      controller()
        ..select(const EditorSelection.room('kitchen'))
        ..deleteRoom();

      // When
      controller().undo();

      // Then
      expect(state().layout.rooms, hasLength(2));

      // When
      controller().redo();

      // Then
      expect(state().layout.rooms, hasLength(1));
    });

    test('Given a typed room name, when undoing, then all the typing is one step', () {
      // Given
      controller().select(const EditorSelection.room('office'));
      for (final name in ['S', 'St', 'Stu', 'Study']) {
        controller().renameRoom(name);
      }

      // When
      controller().undo();

      // Then
      expect(state().layout.rooms.first.name, 'Office');
    });

    test('Given the plan, when exporting, then it is the stored JSON', () {
      // When
      final json = jsonDecode(controller().exportJson()) as Map<String, Object?>;

      // Then
      expect(json['format'], 'smart-hub-home');
    });
  });
}
