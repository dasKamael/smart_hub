import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_side_panel.dart';

import '../../../../mocks/floorplan.mock.dart';
import '../../../../utils/widget.test_util.dart';
import '../floorplan_editor.controller_test.dart' show editorTestLayout;

void main() {
  late ProviderContainer container;

  FloorplanEditorState state() => container.read(floorplanEditorControllerProvider);

  /// The side panel with a coffee table just put down in the office with the furniture tool.
  Future<void> pumpPanel(WidgetTester tester) async {
    container = createTestContainer(
      overrides: [homeLayoutServiceProvider.overrideWith(() => FakeHomeLayoutService(editorTestLayout))],
    );
    await container.read(homeLayoutServiceProvider.future);
    container.read(floorplanEditorControllerProvider.notifier)
      ..selectFurnitureKind(FurnitureKind.coffeeTable)
      ..tap(const PlanPoint(200, 150), cmPerPx: 1);
    await loadWidgetTestApp(
      tester: tester,
      container: container,
      underTestWidget: const Align(
        alignment: Alignment.topLeft,
        child: SizedBox(height: 760, child: EditorSidePanel()),
      ),
    );
  }

  group('EditorSidePanel with a piece of furniture', () {
    testWidgets('Given a table placed with the furniture tool, when rendering, then its size and the palette for the '
        'next piece are both there', (tester) async {
      // When
      await pumpPanel(tester);

      // Then
      expect(find.text('110 cm'), findsOneWidget);
      expect(find.text('60 cm'), findsOneWidget);
      expect(find.text('Bed'), findsOneWidget, reason: 'palette');
    });

    testWidgets('Given a selected table, when tapping the larger width and Copy, then it is 10 cm wider and copied', (
      tester,
    ) async {
      // Given
      await pumpPanel(tester);

      // When
      await tester.tap(find.bySemanticsLabel('Width larger'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Copy'));
      await tester.pumpAndSettle();

      // Then
      expect(state().layout.furniture.map((item) => item.width), [120, 120]);
      expect(find.text('120 cm'), findsOneWidget);
    });

    testWidgets('Given a selected table, when picking a chair in the palette, then the next piece will be a chair', (
      tester,
    ) async {
      // Given
      await pumpPanel(tester);

      // When
      await tester.ensureVisible(find.text('Chair'));
      await tester.tap(find.text('Chair'));
      await tester.pumpAndSettle();

      // Then
      expect(state().furnitureKind, FurnitureKind.chair);
      expect(state().tool, EditorTool.furniture);
    });
  });

  group('EditorSidePanel with a wall', () {
    testWidgets('Given the wall between office and kitchen, when tapping Remove wall, then it is open along its whole '
        'length and Merge rooms was offered for it', (tester) async {
      // Given
      container = createTestContainer(
        overrides: [homeLayoutServiceProvider.overrideWith(() => FakeHomeLayoutService(editorTestLayout))],
      );
      await container.read(homeLayoutServiceProvider.future);
      final wall = LayoutGraphUtil.wallAt(editorTestLayout, const PlanPoint(400, 150), radius: 2)!;
      container.read(floorplanEditorControllerProvider.notifier).select(EditorSelection.wall(wall.id));
      await loadWidgetTestApp(
        tester: tester,
        container: container,
        underTestWidget: const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(height: 760, child: EditorSidePanel()),
        ),
      );
      expect(find.text('Merge rooms'), findsOneWidget);

      // When
      await tester.tap(find.text('Remove wall'));
      await tester.pumpAndSettle();

      // Then
      expect(LayoutGraphUtil.isOpen(state().layout, wall), isTrue);
    });
  });
}
