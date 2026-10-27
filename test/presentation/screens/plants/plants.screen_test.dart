import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/presentation/screens/plants/plants.screen.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/plant_card.dart';

import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('PlantsScreen', () {
    late FakePlantsService plants;
    late FakePlacementService placements;

    // testToday is Monday 2026-10-26.
    final monstera = Plant(id: 'p.monstera', name: 'Monstera', everyDays: 7, lastWatered: DateTime(2026, 10, 17));
    final basil = Plant(id: 'p.basil', name: 'Basil', everyDays: 2, lastWatered: DateTime(2026, 10, 24));
    final fern = Plant(
      id: 'p.fern',
      name: 'Fern',
      everyDays: 3,
      lastWatered: DateTime(2026, 10, 26, 8),
      previousWatered: DateTime(2026, 10, 23),
    );
    final fig = Plant(id: 'p.fig', name: 'Fig', everyDays: 7, lastWatered: DateTime(2026, 10, 23));

    Future<void> pumpScreen(WidgetTester tester, {List<Plant>? list}) async {
      plants = FakePlantsService(list ?? [monstera, basil, fern, fig]);
      placements = FakePlacementService(const [
        Placement(deviceId: 'p.monstera', kind: DeviceKind.plant, position: PlanPoint(290, 120)),
        Placement(deviceId: 'p.fig', kind: DeviceKind.plant, position: PlanPoint(600, 200)),
      ]);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(overrides: floorplanWidgetTestOverrides(placements, plants: plants)),
        underTestWidget: const PlantsScreen(),
      );
    }

    Finder card(String name) => find.byWidgetPredicate((w) => w is PlantCard && w.entry.plant.name == name);

    Finder optionOf(String name, String option) => find.descendant(of: card(name), matching: find.text(option));

    /// Taps the tile of [name] and then one of the options shown on it.
    Future<void> choose(WidgetTester tester, String name, String option) async {
      await tester.tap(card(name));
      await tester.pumpAndSettle();
      await tester.tap(optionOf(name, option));
      await tester.pumpAndSettle();
    }

    bool optionsShown(WidgetTester tester, String name) => tester.widget<PlantCard>(card(name)).optionsShown;

    testWidgets('Given plants in every state, '
        'when rendering, '
        'then the key figures add up and today shows due and watered plants', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(card('Monstera'), findsOneWidget);
      expect(card('Basil'), findsOneWidget);
      expect(card('Fern'), findsOneWidget);
      expect(card('Fig'), findsNothing, reason: 'due on Friday');
      expect(find.text('2 d late'), findsOneWidget);
      expect(find.text('Office · every 7 d'), findsOneWidget, reason: 'room from the floor plan');
      expect(find.text('Not placed · every 2 d'), findsOneWidget);
    });

    testWidgets('Given the page has been shown for a while, '
        'when watering a due plant and undoing a watered one, '
        'then both reach the service', (tester) async {
      // Given
      await pumpScreen(tester);
      await tester.pump(const Duration(seconds: 5));

      // When
      await choose(tester, 'Basil', 'Water');
      await choose(tester, 'Fern', 'Undo');

      // Then
      expect(plants.commands, ['water p.basil', 'undo p.fern']);
    });

    testWidgets('Given due plants, when tapping Water all, then all due plants are watered', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Water all'));
      await tester.pump();

      // Then
      expect(plants.commands.single, anyOf('water p.monstera,p.basil', 'water p.basil,p.monstera'));
    });

    testWidgets('Given nothing is due, when rendering, then there is no Water all', (tester) async {
      await pumpScreen(tester, list: [fern, fig]);

      expect(find.text('Water all'), findsNothing);
    });

    testWidgets('Given the week strip, '
        'when selecting Friday, '
        'then Friday shows the plants due that day', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.bySemanticsLabel(RegExp('^Fri 30')));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Friday, 30 Oct'), findsOneWidget);
      expect(card('Fig'), findsOneWidget);
      expect(card('Monstera'), findsNothing);
    });

    testWidgets('Given the week strip, when selecting All, then every plant is listed, most urgent first', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.bySemanticsLabel(RegExp('^All plants')));
      await tester.pumpAndSettle();

      // Then
      final names = tester.widgetList<PlantCard>(find.byType(PlantCard)).map((c) => c.entry.plant.name);
      expect(names, ['Monstera', 'Basil', 'Fig', 'Fern']);
    });

    testWidgets('Given the page, '
        'when adding a plant with a name and fewer days, '
        'then it is added', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Plant'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Calathea');
      await tester.tap(find.bySemanticsLabel('Fewer days'));
      await tester.pump();
      await tester.tap(find.bySemanticsLabel('Fewer days'));
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Then
      expect(plants.commands, ['add Calathea every 5 photo -']);
    });

    testWidgets('Given the editor, when the name is empty, then Save does nothing', (tester) async {
      // Given
      await pumpScreen(tester);
      await tester.tap(find.text('Plant'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Add plant'), findsOneWidget, reason: 'dialog still open');
      expect(plants.commands, isEmpty);
    });

    testWidgets('Given a placed plant, '
        'when choosing Edit on its tile and deleting it, '
        'then the plant and its placement are removed', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await choose(tester, 'Monstera', 'Edit');
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Then
      expect(placements.removed, ['p.monstera']);
      expect(plants.commands, ['delete p.monstera']);
    });

    testWidgets('Given a plant, when choosing Edit on its tile and renaming it, then the change is saved', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);

      // When
      await choose(tester, 'Monstera', 'Edit');
      await tester.enterText(find.byType(TextFormField), 'Swiss cheese plant');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Then
      expect(plants.commands, ['edit p.monstera Swiss cheese plant every 7']);
    });

    testWidgets('Given a tile, '
        'when tapping it, another tile and then next to the tiles, '
        'then options are shown on one tile at a time and hidden again', (tester) async {
      // Given
      await pumpScreen(tester);

      // When / Then
      await tester.tap(card('Monstera'));
      await tester.pumpAndSettle();
      expect(optionsShown(tester, 'Monstera'), isTrue);

      await tester.tap(card('Basil'));
      await tester.pumpAndSettle();
      expect(optionsShown(tester, 'Monstera'), isFalse);
      expect(optionsShown(tester, 'Basil'), isTrue);

      await tester.tapAt(tester.getBottomRight(find.byType(PlantsScreen)) - const Offset(40, 40));
      await tester.pumpAndSettle();
      expect(optionsShown(tester, 'Basil'), isFalse);
      expect(plants.commands, isEmpty, reason: 'showing options does not water');
    });

    testWidgets('Given hidden options, when tapping where Water would be, then nothing is watered', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(optionOf('Basil', 'Water'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Then
      expect(plants.commands, isEmpty);
      expect(optionsShown(tester, 'Basil'), isTrue, reason: 'the tap opened the options instead');
    });
  });
}
