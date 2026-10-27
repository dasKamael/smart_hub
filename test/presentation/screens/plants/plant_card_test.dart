import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/plant_card.dart';

import '../../../utils/widget.test_util.dart';

void main() {
  group('PlantCard.thirstOf', () {
    final plant = Plant(id: 'p', name: 'P', everyDays: 4, lastWatered: DateTime(2026, 10, 24));

    test('Given half of the interval passed, when computing thirst, then the ring is half full', () {
      expect(
        PlantCard.thirstOf((plant: plant, state: WateringState.upcoming, dueInDays: 2, room: null, feedInDays: null)),
        0.5,
      );
    });

    test('Given an overdue plant, when computing thirst, then the ring is full', () {
      expect(
        PlantCard.thirstOf((plant: plant, state: WateringState.overdue, dueInDays: -3, room: null, feedInDays: null)),
        1,
      );
    });

    test('Given a plant watered today, when computing thirst, then the ring is full in its done color', () {
      expect(
        PlantCard.thirstOf((
          plant: plant,
          state: WateringState.wateredToday,
          dueInDays: 4,
          room: null,
          feedInDays: null,
        )),
        1,
      );
      expect(PlantCard.colorOf(WateringState.wateredToday), PlantCard.colorOf(WateringState.upcoming));
    });
  });

  group('PlantCard', () {
    // The badge, not the Feed option (which has a label below its icon).
    final feedBadge = find.byWidgetPredicate(
      (w) => w is HubGlyphIcon && w.glyph == HubGlyph.feed && w.size == const Size(12, 12),
    );
    final plant = Plant(id: 'p', name: 'Monstera', everyDays: 7, lastWatered: DateTime(2026, 10, 24));

    Future<List<String>> pumpCard(WidgetTester tester, {int? feedInDays}) async {
      final taps = <String>[];
      await loadWidgetTestApp(
        tester: tester,
        underTestWidget: Center(
          child: SizedBox(
            width: 240,
            height: 140,
            child: PlantCard(
              entry: (
                plant: plant,
                state: WateringState.upcoming,
                dueInDays: 5,
                room: 'Office',
                feedInDays: feedInDays,
              ),
              optionsShown: true,
              onTap: () => taps.add('tap'),
              onWater: () => taps.add('water'),
              onFeed: () => taps.add('feed'),
              onProfile: () => taps.add('profile'),
              onEdit: () => taps.add('edit'),
            ),
          ),
        ),
      );
      return taps;
    }

    testWidgets('Given feeding is due, when showing the options, then the badge shows and Feed feeds', (tester) async {
      // Given
      final taps = await pumpCard(tester, feedInDays: 0);

      // When
      await tester.tap(find.bySemanticsLabel('Feed'));

      // Then
      expect(feedBadge, findsOneWidget);
      expect(taps, ['feed']);
    });

    testWidgets('Given feeding is not due, when showing the options, then there is no badge and no Feed', (
      tester,
    ) async {
      // Given
      final taps = await pumpCard(tester, feedInDays: 12);

      // When
      await tester.tap(find.bySemanticsLabel('Info'));

      // Then
      expect(feedBadge, findsNothing);
      expect(find.bySemanticsLabel('Feed'), findsNothing);
      expect(taps, ['profile']);
    });
  });
}
