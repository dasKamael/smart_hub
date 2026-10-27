import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/presentation/screens/plants/plants.screen.dart';

import '../../../../mocks/floorplan.mock.dart';
import '../../../../utils/widget.test_util.dart';

void main() {
  group('PlantEditorDialog', () {
    testWidgets('Given the plant database, '
        'when adding a plant by picking its species, '
        'then name and suggested intervals are taken over and the plant is linked', (tester) async {
      // Given
      final plants = FakePlantsService();
      final profiles = _FakeProfiles();
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            ...floorplanWidgetTestOverrides(FakePlacementService(), plants: plants),
            plantDatabaseAvailableProvider.overrideWithValue(true),
            plantProfileServiceProvider.overrideWith(() => profiles),
            speciesSearchProvider.overrideWith(
              (ref, query) async => query.trim().length < 3
                  ? const []
                  : const [
                      SpeciesMatch(id: 2773, commonName: 'golden pothos', scientificName: 'Epipremnum aureum'),
                      SpeciesMatch(id: 7276, commonName: 'satin pothos', available: false),
                    ],
            ),
          ],
        ),
        underTestWidget: const PlantsScreen(),
      );
      await tester.tap(find.text('Plant'));
      await tester.pumpAndSettle();

      // When
      await tester.enterText(find.byType(TextFormField).at(1), 'pothos');
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('satin pothos'));
      await tester.tap(find.text('golden pothos'));
      await tester.pumpAndSettle();
      final suggested = find.text('Suggested for golden pothos – change them as you like.').evaluate().length;
      await tester.ensureVisible(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Then
      expect(suggested, 1);
      expect(plants.commands, ['add golden pothos every 9 feed 6 photo -']);
      expect(profiles.linked, ['new 2773']);
    });

    testWidgets('Given a new plant, '
        'when copying its prompt and pasting the answer, '
        'then the intervals are taken over and the care data is kept with the plant', (tester) async {
      // Given
      final plants = FakePlantsService();
      final profiles = _FakeProfiles();
      String? clipboard;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        if (call.method == 'Clipboard.getData') {
          return {
            'text':
                '```json\n{"plants": [{"name": "Sweet basil", "commonName": "Sweet basil", '
                '"wateringSummerDays": [2, 3], "fertilizeEveryWeeks": 2}]}\n```',
          };
        }
        return null;
      });
      await withClock(Clock.fixed(DateTime(2026, 6, 1)), () async {
        await loadWidgetTestApp(
          tester: tester,
          container: createTestContainer(
            overrides: [
              ...floorplanWidgetTestOverrides(FakePlacementService(), plants: plants),
              plantProfileServiceProvider.overrideWith(() => profiles),
            ],
          ),
          underTestWidget: const PlantsScreen(),
        );
        await tester.tap(find.text('Plant'));
        await tester.pumpAndSettle();

        // When
        await tester.enterText(find.byType(TextFormField).first, 'Basil');
        await tester.pump();
        await tester.tap(find.text('Copy prompt'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Paste answer'));
        await tester.pumpAndSettle();
        final shown = find.text('Sweet basil · summer 2–3 d').evaluate().length;
        await tester.ensureVisible(find.text('Save'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Then
        expect(clipboard, contains('- Basil'));
        expect(shown, 1);
        expect(plants.commands, ['add Basil every 3 feed 2 photo -']);
        expect(profiles.kept, ['new Sweet basil']);
      });
    });
  });
}

class _FakeProfiles extends PlantProfileService {
  final linked = <String>[];
  final kept = <String>[];

  @override
  Future<void> keep(String plantId, PlantProfile profile) async => kept.add('$plantId ${profile.commonName}');

  @override
  Future<PlantProfile> preview(int speciesId) async => PlantProfile(
    speciesId: speciesId,
    commonName: 'golden pothos',
    wateringMinDays: 7,
    wateringMaxDays: 10,
    careLevel: 'Low',
    fetchedAt: DateTime(2026),
  );

  @override
  Future<PlantProfile> link(String plantId, int speciesId) async {
    linked.add('$plantId $speciesId');
    return preview(speciesId);
  }
}
