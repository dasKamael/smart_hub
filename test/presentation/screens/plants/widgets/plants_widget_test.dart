import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/plants_widget.dart';

import '../../../../mocks/floorplan.mock.dart';
import '../../../../utils/widget.test_util.dart';

void main() {
  group('PlantsWidget', () {
    late FakePlantsService plants;

    Future<void> load(WidgetTester tester, WidgetSize size, {List<Plant>? withPlants}) async {
      plants = FakePlantsService(
        withPlants ??
            [
              Plant(id: 'p.basil', name: 'Basil', everyDays: 7, lastWatered: DateTime(2026, 10, 17)),
              Plant(id: 'p.mint', name: 'Mint', everyDays: 7, lastWatered: DateTime(2026, 10, 19)),
              Plant(id: 'p.fern', name: 'Fern', everyDays: 7, lastWatered: DateTime(2026, 10, 26)),
              Plant(id: 'p.cactus', name: 'Cactus', everyDays: 14, lastWatered: DateTime(2026, 10, 15)),
            ],
      );
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(overrides: floorplanWidgetTestOverrides(FakePlacementService(), plants: plants)),
        underTestWidget: Center(child: PlantsWidget(size: size)),
      );
    }

    testWidgets('Given one overdue and one due plant, when shown small, then it counts both and the overdue one', (
      tester,
    ) async {
      // Given / When
      await load(tester, WidgetSize.small);

      // Then
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1 overdue'), findsOneWidget);
    });

    testWidgets('Given due plants, when tapping one in the medium widget, then it is watered', (tester) async {
      // Given
      await load(tester, WidgetSize.medium);
      final shown = (find.text('Basil').evaluate().length, find.text('Fern').evaluate().length);

      // When
      await tester.tap(find.text('Basil'));
      await tester.pump();

      // Then
      expect(shown, (1, 0));
      expect(plants.commands, ['water p.basil']);
    });

    testWidgets(
      'Given due plants, when shown large, then they are grouped into overdue and today and the next plant fills the rest',
      (tester) async {
        // Given / When
        await load(tester, WidgetSize.large);

        // Then
        expect(find.text('Overdue'), findsOneWidget);
        expect(find.text('Today'), findsOneWidget);
        expect(find.text('Mint'), findsOneWidget);
        expect(find.text('In 3 d'), findsOneWidget);
      },
    );

    testWidgets('Given a plant watered today, when tapping it in the week view, then the watering is undone', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.extraLarge);
      final upcoming = find.text('Cactus').evaluate().length;

      // When
      await tester.tap(find.text('Fern'));
      await tester.pump();

      // Then
      expect(upcoming, 1);
      expect(find.text('TODAY'), findsOneWidget);
      expect(plants.commands, ['undo p.fern']);
    });

    testWidgets('Given every plant is watered, when shown large, then it says so', (tester) async {
      // Given / When
      await load(
        tester,
        WidgetSize.large,
        withPlants: [Plant(id: 'p.fern', name: 'Fern', everyDays: 7, lastWatered: DateTime(2026, 10, 26))],
      );

      // Then
      expect(find.text('Every plant is watered.'), findsOneWidget);
    });
  });
}
