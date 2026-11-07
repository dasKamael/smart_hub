import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/editing/plan_editing.util.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.screen.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_canvas.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_viewport.dart';

import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

const _plan = FloorPlan(
  rooms: [
    Room(
      id: 'office',
      name: 'Office',
      polygon: [PlanPoint(0, 0), PlanPoint(400, 0), PlanPoint(400, 300), PlanPoint(0, 300)],
    ),
    Room(
      id: 'kitchen',
      name: 'Kitchen',
      polygon: [PlanPoint(400, 0), PlanPoint(700, 0), PlanPoint(700, 300), PlanPoint(400, 300)],
    ),
  ],
  doors: [Door(id: 'door-1', type: DoorType.door, a: PlanPoint(400, 100), b: PlanPoint(400, 180))],
);

void main() {
  group('FloorplanEditorScreen', () {
    late FakeFloorPlanService service;
    late ProviderContainer container;

    FloorplanEditorState state() => container.read(floorplanEditorControllerProvider);

    Future<void> pumpEditor(WidgetTester tester) async {
      service = FakeFloorPlanService(_plan);
      container = createTestContainer(overrides: [floorPlanServiceProvider.overrideWith(() => service)]);
      await container.read(floorPlanServiceProvider.future);
      await loadWidgetTestApp(tester: tester, container: container, underTestWidget: const FloorplanEditorScreen());
    }

    testWidgets('Given nothing selected, when opening the editor, then the rooms and their total area are listed', (
      tester,
    ) async {
      // When
      await pumpEditor(tester);

      // Then
      expect(find.text('21.0 m²'), findsOneWidget);
      expect(find.text('Office'), findsWidgets);
      expect(find.text('12.0 m²'), findsWidgets);
      for (final tool in ['Select', 'Room', 'Rectangle', 'Door', 'Window']) {
        expect(find.text(tool), findsOneWidget);
      }
    });

    testWidgets('Given the room list, '
        'when tapping a room and typing a new name, '
        'then the room is renamed and can be deleted', (tester) async {
      // Given
      await pumpEditor(tester);

      // When
      await tester.tap(find.text('Kitchen').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'Living');
      await tester.pumpAndSettle();

      // Then
      expect(service.saved.last.rooms.last.name, 'Living');

      // When
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Then
      expect(service.saved.last.rooms.map((r) => r.id), ['office']);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('Given a selected door, when turning it into a 120 cm window, then type and width change', (
      tester,
    ) async {
      // Given
      await pumpEditor(tester);
      container.read(floorplanEditorControllerProvider.notifier).select(const EditorSelection.opening('door-1'));
      await tester.pumpAndSettle();
      expect(find.text('80 cm'), findsOneWidget);

      // When
      await tester.tap(find.text('Window').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('120 cm'));
      await tester.pumpAndSettle();

      // Then
      final window = state().plan.doors.single;
      expect(window.type, DoorType.window);
      expect(window.a.distanceTo(window.b), 120);
    });

    testWidgets('Given the room tool, '
        'when tapping three corners on the canvas and finishing, '
        'then a new room is added and selected', (tester) async {
      // Given
      await pumpEditor(tester);
      await tester.tap(find.text('Room'));
      await tester.pumpAndSettle();
      expect(find.text('Tap the corners'), findsOneWidget);
      final canvas = tester.getRect(find.byType(EditorCanvas));

      // When
      for (final at in const [Offset(0.2, 0.8), Offset(0.5, 0.8), Offset(0.5, 0.95)]) {
        await tester.tapAt(canvas.topLeft + Offset(canvas.width * at.dx, canvas.height * at.dy));
        await tester.pump(const Duration(milliseconds: 500));
      }
      await tester.tap(find.bySemanticsLabel('Finish room'));
      await tester.pumpAndSettle();

      // Then
      expect(state().plan.rooms, hasLength(3));
      expect(state().selection, EditorSelection.room(state().plan.rooms.last.id));
      expect(find.text('Room 3'), findsWidgets);
    });

    testWidgets('Given the office selected, '
        'when dragging its top left corner far outside the plan, '
        'then the corner ends under the finger', (tester) async {
      // Given
      await pumpEditor(tester);
      container.read(floorplanEditorControllerProvider.notifier).select(const EditorSelection.room('office'));
      await tester.pumpAndSettle();
      final canvas = tester.getRect(find.byType(EditorCanvas));
      final view = EditorViewport.fit([for (final room in _plan.rooms) ...room.polygon], canvas.size);
      final start = canvas.topLeft + view.toPx(PlanPoint.zero);
      final end = start - const Offset(120, 90);

      // When
      final gesture = await tester.startGesture(start);
      for (var i = 1; i <= 10; i++) {
        await gesture.moveTo(Offset.lerp(start, end, i / 10)!);
        await tester.pump();
      }
      await gesture.up();
      await tester.pumpAndSettle();

      // Then
      final corner = state().plan.rooms.first.polygon.first;
      final expected = view.toPlan(end - canvas.topLeft);
      expect(corner.x, closeTo(expected.x, PlanEditingUtil.grid));
      expect(corner.y, closeTo(expected.y, PlanEditingUtil.grid));
    });

    testWidgets('Given the rectangle tool, when dragging with one finger and lifting it, then a room is added', (
      tester,
    ) async {
      // Given
      await pumpEditor(tester);
      await tester.tap(find.text('Rectangle'));
      await tester.pumpAndSettle();
      final canvas = tester.getRect(find.byType(EditorCanvas));

      // When
      await tester.dragFrom(canvas.topLeft + const Offset(100, 600), const Offset(200, 120));
      await tester.pumpAndSettle();

      // Then
      expect(state().plan.rooms, hasLength(3));
      expect(service.saved.last.rooms, hasLength(3));
    });

    testWidgets('Given a rectangle being drawn, when a second finger touches to zoom, then no room is added', (
      tester,
    ) async {
      // Given
      await pumpEditor(tester);
      await tester.tap(find.text('Rectangle'));
      await tester.pumpAndSettle();
      final canvas = tester.getRect(find.byType(EditorCanvas));
      final first = await tester.startGesture(canvas.topLeft + const Offset(100, 600), pointer: 1);
      await first.moveBy(const Offset(150, 100));
      await tester.pump();

      // When
      final second = await tester.startGesture(canvas.topLeft + const Offset(500, 300), pointer: 2);
      await second.moveBy(const Offset(60, 60));
      await first.moveBy(const Offset(-20, -20));
      await tester.pump();
      await first.up();
      await second.up();
      await tester.pumpAndSettle();

      // Then
      expect(state().plan.rooms, hasLength(2));
      expect(service.saved, isEmpty);
    });

    testWidgets('Given a change, when undoing and redoing, then the plan follows and the buttons enable', (
      tester,
    ) async {
      // Given
      await pumpEditor(tester);
      container.read(floorplanEditorControllerProvider.notifier)
        ..select(const EditorSelection.room('kitchen'))
        ..deleteSelection();
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.bySemanticsLabel('Undo'));
      await tester.pumpAndSettle();

      // Then
      expect(state().plan, _plan);

      // When
      await tester.tap(find.bySemanticsLabel('Redo'));
      await tester.pumpAndSettle();

      // Then
      expect(state().plan.rooms, hasLength(1));
    });

    testWidgets('Given the plan, when copying it, then editor JSON is on the clipboard', (tester) async {
      // Given
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') copied = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
      await pumpEditor(tester);

      // When
      await tester.tap(find.bySemanticsLabel('Copy plan as JSON'));
      await tester.pump();

      // Then
      expect(copied, contains('"unit": "cm"'));
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
