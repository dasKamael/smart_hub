import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/editing/plan_editing.util.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';

import '../../../mocks/floorplan.mock.dart';
import '../../../utils/riverpod.test_util.dart';

/// Two rooms side by side, sharing the wall at x = 400.
final _plan = FloorPlan(
  rooms: [
    Room(id: 'office', name: 'Office', polygon: _box(0, 0, 400, 300)),
    Room(id: 'kitchen', name: 'Kitchen', polygon: _box(400, 0, 700, 300)),
  ],
  doors: const [Door(id: 'door-1', type: DoorType.door, a: PlanPoint(400, 100), b: PlanPoint(400, 180))],
);

List<PlanPoint> _box(double left, double top, double right, double bottom) => [
  PlanPoint(left, top),
  PlanPoint(right, top),
  PlanPoint(right, bottom),
  PlanPoint(left, bottom),
];

void main() {
  late FakeFloorPlanService service;
  late ProviderContainer container;

  FloorplanEditorController controller() => container.read(floorplanEditorControllerProvider.notifier);
  FloorplanEditorState state() => container.read(floorplanEditorControllerProvider);

  setUp(() async {
    service = FakeFloorPlanService(_plan);
    container = createTestContainer(overrides: [floorPlanServiceProvider.overrideWith(() => service)]);
    await container.read(floorPlanServiceProvider.future);
    container.listen(floorplanEditorControllerProvider, (_, _) {});
  });

  group('drawing rooms', () {
    test('Given the room tool, '
        'when tapping three corners and then the first one again, '
        'then a selected room is added and saved', () {
      // Given
      controller().selectTool(EditorTool.room);

      // When
      for (final point in const [PlanPoint(0, 400), PlanPoint(203, 398), PlanPoint(200, 600), PlanPoint(4, 402)]) {
        controller().tap(point, cmPerPx: 1);
      }

      // Then
      final room = state().plan.rooms.last;
      expect(room.polygon, const [PlanPoint(0, 400), PlanPoint(200, 400), PlanPoint(200, 600)]);
      expect(room.name, 'Room 3');
      expect(state().selection, EditorSelection.room(room.id));
      expect(state().tool, EditorTool.select);
      expect(state().draft, isEmpty);
      expect(service.saved.last, state().plan);
    });

    test('Given two drawn corners, when removing the last one, then only the first is left', () {
      // Given
      controller()
        ..selectTool(EditorTool.room)
        ..tap(const PlanPoint(0, 400), cmPerPx: 1)
        ..tap(const PlanPoint(200, 400), cmPerPx: 1);

      // When
      controller().removeLastDraftCorner();

      // Then
      expect(state().draft, const [PlanPoint(0, 400)]);
    });

    test('Given the rectangle tool, '
        'when dragging from one corner to the opposite one, '
        'then a rectangular room is added', () {
      // Given
      controller().selectTool(EditorTool.rectangle);

      // When
      expect(controller().startDrag(const PlanPoint(0, 400), cmPerPx: 1), isTrue);
      controller()
        ..updateDrag(const PlanPoint(302, 597), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().plan.rooms.last.polygon, _box(0, 400, 300, 600));
      expect(state().rectangle, isNull);
    });

    test('Given the rectangle tool, when dragging less than 50 cm, then no room is added', () {
      // Given
      controller().selectTool(EditorTool.rectangle);

      // When
      controller()
        ..startDrag(const PlanPoint(0, 400), cmPerPx: 1)
        ..updateDrag(const PlanPoint(40, 600), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().plan.rooms, hasLength(2));
    });
  });

  group('interrupted and odd input', () {
    test('Given a rectangle being dragged, when the drag is cancelled by a second finger, then no room is added', () {
      // Given
      controller()
        ..selectTool(EditorTool.rectangle)
        ..startDrag(const PlanPoint(0, 400), cmPerPx: 1)
        ..updateDrag(const PlanPoint(300, 600), cmPerPx: 1);

      // When
      controller().cancelDrag();

      // Then
      expect(state().plan.rooms, hasLength(2));
      expect(state().rectangle, isNull);
      expect(service.saved, isEmpty);
    });

    test('Given a corner being dragged, when the drag is cancelled, then the moved corner is kept and saved', () {
      // Given
      controller()
        ..select(const EditorSelection.room('office'))
        ..startDrag(PlanPoint.zero, cmPerPx: 1)
        ..updateDrag(const PlanPoint(-50, -50), cmPerPx: 1);

      // When
      controller().cancelDrag();

      // Then
      expect(state().plan.rooms.first.polygon.first, const PlanPoint(-50, -50));
      expect(service.saved.last, state().plan);
    });

    test('Given the room tool, when tapping the same spot twice, then the corner is added once', () {
      // Given
      controller().selectTool(EditorTool.room);

      // When
      controller()
        ..tap(const PlanPoint(0, 400), cmPerPx: 1)
        ..tap(const PlanPoint(2, 401), cmPerPx: 1);

      // Then
      expect(state().draft, const [PlanPoint(0, 400)]);
    });

    test('Given three corners on one line, when finishing, then no room without area is added', () {
      // Given
      controller()
        ..selectTool(EditorTool.room)
        ..tap(const PlanPoint(0, 400), cmPerPx: 1)
        ..tap(const PlanPoint(100, 400), cmPerPx: 1)
        ..tap(const PlanPoint(200, 400), cmPerPx: 1);

      // When
      controller().finishDraft();

      // Then
      expect(state().plan.rooms, hasLength(2));
    });

    test('Given a renamed room, '
        'when one of its corners is dragged and the name is typed on, '
        'then the typing after the drag is its own undo step', () {
      // Given
      controller()
        ..select(const EditorSelection.room('office'))
        ..renameRoom('Stu');

      // When
      controller()
        ..startDrag(PlanPoint.zero, cmPerPx: 1)
        ..updateDrag(const PlanPoint(-50, 0), cmPerPx: 1)
        ..endDrag()
        ..renameRoom('Study');

      // Then
      expect(state().past, hasLength(3));
      controller().undo();
      expect(state().plan.rooms.first.name, 'Stu');
      expect(state().plan.rooms.first.polygon.first, const PlanPoint(-50, 0));
    });
  });

  group('openings', () {
    test('Given the door tool, '
        'when tapping next to a wall, '
        'then a selected 80 cm door is placed on it and the tool goes back to select', () {
      // Given
      controller().selectTool(EditorTool.door);

      // When
      controller().tap(const PlanPoint(150, 10), cmPerPx: 1);

      // Then
      final door = state().plan.doors.last;
      expect(door, const Door(id: 'door-2', type: DoorType.door, a: PlanPoint(110, 0), b: PlanPoint(190, 0)));
      expect(state().selection, const EditorSelection.opening('door-2'));
      expect(state().tool, EditorTool.select);
    });

    test('Given the window tool, when tapping next to a wall, then a 100 cm window is placed', () {
      // Given
      controller().selectTool(EditorTool.window);

      // When
      controller().tap(const PlanPoint(550, 295), cmPerPx: 1);

      // Then
      expect(
        state().plan.doors.last,
        const Door(id: 'window-1', type: DoorType.window, a: PlanPoint(600, 300), b: PlanPoint(500, 300)),
      );
    });

    test('Given the door tool, when tapping in the middle of a room, then nothing is placed', () {
      // Given
      controller().selectTool(EditorTool.door);

      // When
      controller().tap(const PlanPoint(200, 150), cmPerPx: 1);

      // Then
      expect(state().plan.doors, hasLength(1));
      expect(state().tool, EditorTool.door);
    });

    test('Given a selected door, when making it a 100 cm window, then it keeps its middle', () {
      // Given
      controller().select(const EditorSelection.opening('door-1'));

      // When
      controller()
        ..setOpeningType(DoorType.window)
        ..setOpeningWidth(100);

      // Then
      expect(
        state().plan.doors.single,
        const Door(id: 'door-1', type: DoorType.window, a: PlanPoint(400, 90), b: PlanPoint(400, 190)),
      );
    });

    test('Given a selected door, when dragging it along its wall, then it slides in 5 cm steps', () {
      // Given
      controller().select(const EditorSelection.opening('door-1'));

      // When
      expect(controller().startDrag(const PlanPoint(402, 140), cmPerPx: 1), isTrue);
      controller()
        ..updateDrag(const PlanPoint(420, 211), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().plan.doors.single.a, const PlanPoint(400, 170));
      expect(state().past, hasLength(1));
    });
  });

  group('changing rooms', () {
    test('Given the office selected, '
        'when dragging a corner next to another corner, '
        'then it snaps onto it and the drag is one undo step', () {
      // Given
      controller().select(const EditorSelection.room('office'));

      // When
      expect(controller().startDrag(const PlanPoint(5, 295), cmPerPx: 1), isTrue);
      controller()
        ..updateDrag(const PlanPoint(30, 320), cmPerPx: 1)
        ..updateDrag(const PlanPoint(52, 351), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().plan.rooms.first.polygon.last, const PlanPoint(50, 350));
      expect(state().past, [_plan]);
      expect(service.saved, [state().plan]);
    });

    test('Given the office selected, '
        'when dragging the middle of its top wall up, '
        'then a new corner is added there', () {
      // Given
      controller().select(const EditorSelection.room('office'));

      // When
      controller()
        ..startDrag(const PlanPoint(200, 2), cmPerPx: 1)
        ..updateDrag(const PlanPoint(200, -40), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().plan.rooms.first.polygon, hasLength(5));
      expect(state().plan.rooms.first.polygon[1], const PlanPoint(200, -40));
      expect(state().past, hasLength(1));
    });

    test('Given a window in the middle of the top wall, '
        'when a corner is added under it and dragged up, '
        'then the window stays on a wall of the office with its width', () {
      // Given
      controller()
        ..selectTool(EditorTool.window)
        ..tap(const PlanPoint(200, 5), cmPerPx: 1)
        ..select(const EditorSelection.room('office'));

      // When
      controller()
        ..startDrag(const PlanPoint(200, 0), cmPerPx: 1)
        ..updateDrag(const PlanPoint(200, -60), cmPerPx: 1)
        ..endDrag();

      // Then
      final window = state().plan.doors.last;
      expect(state().plan.rooms.first.polygon, hasLength(5));
      expect(PlanEditingUtil.wallOf(state().plan, window, roomId: 'office'), isNotNull);
      expect(window.a.distanceTo(window.b), closeTo(100, 0.2));
    });

    test('Given the office selected, when long pressing a corner, then the corner is removed', () {
      // Given
      controller().select(const EditorSelection.room('office'));

      // When
      controller().longPress(const PlanPoint(398, 302), cmPerPx: 1);

      // Then
      expect(state().plan.rooms.first.polygon, const [PlanPoint.zero, PlanPoint(400, 0), PlanPoint(0, 300)]);
    });

    test('Given nothing selected, '
        'when dragging the kitchen, '
        'then it is selected and moves in 10 cm steps together with the door on its wall', () {
      // When
      controller()
        ..startDrag(const PlanPoint(500, 150), cmPerPx: 1)
        ..updateDrag(const PlanPoint(534, 150), cmPerPx: 1)
        ..endDrag();

      // Then
      expect(state().selection, const EditorSelection.room('kitchen'));
      expect(state().plan.rooms.last.polygon.first, const PlanPoint(430, 0));
      expect(state().plan.doors.single.a, const PlanPoint(430, 100));
    });

    test('Given nothing under the finger, when starting a drag, then the view may pan', () {
      expect(controller().startDrag(const PlanPoint(900, 900), cmPerPx: 1), isFalse);
    });

    test('Given the office selected, when typing a new name letter by letter, then it is one undo step', () {
      // Given
      controller().select(const EditorSelection.room('office'));

      // When
      controller()
        ..renameRoom('S')
        ..renameRoom('St')
        ..renameRoom('Study');

      // Then
      expect(state().plan.rooms.first.name, 'Study');
      expect(state().past, [_plan]);
      expect(service.saved.last.rooms.first.name, 'Study');
    });

    test(
      'Given the kitchen selected, when deleting it, then the room is gone and the door on the shared wall stays',
      () {
        // Given
        controller().select(const EditorSelection.room('kitchen'));

        // When
        controller().deleteSelection();

        // Then
        expect(state().plan.rooms.map((r) => r.id), ['office']);
        expect(state().plan.doors, hasLength(1));
        expect(state().selection, isNull);
      },
    );
  });

  group('selection', () {
    test('Given the select tool, when tapping on the door, then the door is selected rather than the room', () {
      // When
      controller().tap(const PlanPoint(395, 140), cmPerPx: 1);

      // Then
      expect(state().selection, const EditorSelection.opening('door-1'));
    });

    test('Given a selected room, when tapping outside of all rooms, then nothing is selected', () {
      // Given
      controller().select(const EditorSelection.room('office'));

      // When
      controller().tap(const PlanPoint(900, 900), cmPerPx: 1);

      // Then
      expect(state().selection, isNull);
    });
  });

  group('undo and redo', () {
    test('Given a deleted room, when undoing and redoing, then the room comes back and goes again', () {
      // Given
      controller()
        ..select(const EditorSelection.room('kitchen'))
        ..deleteSelection();

      // When
      controller().undo();

      // Then
      expect(state().plan, _plan);
      expect(service.saved.last, _plan);

      // When
      controller().redo();

      // Then
      expect(state().plan.rooms, hasLength(1));
      expect(state().future, isEmpty);
    });

    test('Given 60 changes, when looking at the history, then only the last 50 are kept', () {
      // Given
      controller().select(const EditorSelection.opening('door-1'));

      // When
      for (var i = 0; i < 60; i++) {
        controller().setOpeningWidth(i.isEven ? 70 : 90);
      }

      // Then
      expect(state().past, hasLength(FloorplanEditorController.historyLimit));
    });
  });

  test('Given the plan, when exporting, then it is editor JSON in centimeters', () {
    // When
    final json = jsonDecode(controller().exportJson()) as Map<String, Object?>;

    // Then
    expect(json['unit'], 'cm');
    expect(json['rooms'], hasLength(2));
  });
}
