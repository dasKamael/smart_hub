import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/presentation/screens/plants/plant_profile.screen.dart';

import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('PlantProfileScreen', () {
    late FakePlantsService plants;
    late _FakeProfiles profiles;
    final monstera = Plant(id: 'p.monstera', name: 'Monstera', everyDays: 5, lastWatered: DateTime(2026, 10, 24));
    final profile = PlantProfile(
      speciesId: 2193,
      commonName: 'Swiss cheese plant',
      scientificName: 'Monstera deliciosa',
      watering: 'Average',
      wateringMinDays: 7,
      wateringMaxDays: 10,
      sunlight: const ['part shade'],
      careLevel: 'Medium',
      poisonousToPets: true,
      pruningMonths: const ['March', 'April'],
      wateringGuide: 'Water when the top inch of soil is dry.',
      fetchedAt: DateTime(2026, 10, 26),
    );

    Future<void> pumpScreen(WidgetTester tester, {PlantProfile? linked}) async {
      plants = FakePlantsService([monstera]);
      profiles = _FakeProfiles();
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            ...floorplanWidgetTestOverrides(FakePlacementService(), plants: plants),
            plantProfileProvider('p.monstera').overrideWith((ref) => Stream.value(linked)),
            plantProfileServiceProvider.overrideWith(() => profiles),
            plantDatabaseAvailableProvider.overrideWithValue(true),
            speciesSearchProvider.overrideWith(
              (ref, query) async =>
                  query.trim().length < 3 ? const [] : const [SpeciesMatch(id: 2193, commonName: 'Swiss cheese plant')],
            ),
          ],
        ),
        underTestWidget: const PlantProfileScreen(plantId: 'p.monstera'),
      );
    }

    testWidgets('Given a linked plant, when rendering, then care facts, guide and the plan show', (tester) async {
      // When
      await pumpScreen(tester, linked: profile);

      // Then
      expect(find.text('Swiss cheese plant · Monstera deliciosa'), findsOneWidget);
      expect(find.text('Part shade'), findsOneWidget);
      expect(find.text('March, April'), findsOneWidget);
      expect(find.text('Toxic'), findsOneWidget);
      expect(find.text('Water when the top inch of soil is dry.'), findsOneWidget);
      expect(find.text('Water every 5 days'), findsOneWidget);
      expect(find.text('Not fertilized'), findsOneWidget);
    });

    testWidgets('Given suggestions of the species, when using them, then the plant takes them over', (tester) async {
      // Given
      await pumpScreen(tester, linked: profile);

      // When
      await tester.tap(find.text('Suggested: 7–10 days · Use'));
      await tester.tap(find.text('Feed every 4 weeks · Use'));
      await tester.pump();

      // Then
      expect(plants.commands, ['edit p.monstera Monstera every 9', 'edit p.monstera Monstera every 5 feed 4']);
    });

    testWidgets('Given a plant without species, when picking one, then it is linked', (tester) async {
      // Given
      await pumpScreen(tester);
      expect(find.text('Which plant is it?'), findsOneWidget);

      // When
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Swiss cheese plant'));
      await tester.pump();

      // Then
      expect(profiles.linked, ['p.monstera 2193']);
    });
  });
}

class _FakeProfiles extends PlantProfileService {
  final linked = <String>[];

  @override
  Future<PlantProfile> link(String plantId, int speciesId) async {
    linked.add('$plantId $speciesId');
    return PlantProfile(speciesId: speciesId, commonName: 'Swiss cheese plant', fetchedAt: DateTime(2026));
  }
}
