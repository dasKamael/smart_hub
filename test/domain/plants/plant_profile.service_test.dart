import 'package:drift/native.dart';
import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/common/config/perenual_config.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/plants/perenual/perenual.repository.dart';
import 'package:smart_hub/data/plants/plant.repository.dart';
import 'package:smart_hub/data/plants/plant_profile.repository.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/plant_profile_source.enum.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';

import '../../utils/riverpod.test_util.dart';

class _MockPerenual extends Mock implements PerenualRepository {}

void main() {
  group('PlantProfileService', () {
    late _MockPerenual perenual;
    late PlantProfileRepository profiles;
    late PlantRepository plants;
    final monstera = PlantProfile(
      speciesId: 2193,
      commonName: 'Swiss cheese plant',
      wateringMinDays: 7,
      wateringMaxDays: 10,
      sunlight: const ['part shade'],
      fetchedAt: DateTime(2026, 10, 26),
    );

    ProviderContainer createContainer({String apiKey = 'key-1'}) {
      return createTestContainer(
        overrides: [
          perenualConfigProvider.overrideWithValue(PerenualConfig(apiKey: apiKey)),
          perenualRepositoryProvider.overrideWithValue(perenual),
          plantProfileRepositoryProvider.overrideWithValue(profiles),
          plantRepositoryProvider.overrideWithValue(plants),
        ],
      );
    }

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      profiles = PlantProfileRepository(database: database);
      plants = PlantRepository(database: database);
      perenual = _MockPerenual();
      when(() => perenual.profile(2193)).thenAnswer((_) async => monstera);
    });

    test('Given a species, when linking a plant, then its profile is loaded and kept', () async {
      // Given
      final container = createContainer();

      // When
      await container.read(plantProfileServiceProvider.notifier).link('plant-1', 2193);

      // Then
      expect(await profiles.watch('plant-1').first, monstera);
    });

    test('Given another plant of the same species, when linking, then its profile is copied without loading', () async {
      // Given
      final container = createContainer();
      await container.read(plantProfileServiceProvider.notifier).link('plant-1', 2193);

      // When
      await container.read(plantProfileServiceProvider.notifier).link('plant-2', 2193);

      // Then
      verify(() => perenual.profile(2193)).called(1);
      expect(await profiles.watch('plant-2').first, monstera);
    });

    test('Given a linked plant, when reloading, then the profile is loaded again', () async {
      // Given
      final container = createContainer();
      await container.read(plantProfileServiceProvider.notifier).link('plant-1', 2193);
      when(() => perenual.profile(2193)).thenAnswer((_) async => monstera.copyWith(careLevel: 'Medium'));

      // When
      await container.read(plantProfileServiceProvider.notifier).reload('plant-1');

      // Then
      expect((await profiles.watch('plant-1').first)?.careLevel, 'Medium');
    });

    test('Given no API key or a short query, when searching, then nothing is asked', () async {
      // Given
      when(() => perenual.search(any()))
          .thenAnswer((_) async => const [SpeciesMatch(id: 2193, commonName: 'Swiss cheese plant')]);

      // When
      final withoutKey = await createContainer(apiKey: '').read(speciesSearchProvider('monstera').future);
      final short = await createContainer().read(speciesSearchProvider('mo').future);
      final found = await createContainer().read(speciesSearchProvider(' monstera ').future);

      // Then
      expect(withoutKey, isEmpty);
      expect(short, isEmpty);
      expect(found.single.id, 2193);
      verify(() => perenual.search('monstera')).called(1);
    });

    test('Given a plant "basil" and an import for Basil and Mint, '
        'when importing in winter, '
        'then basil takes over the winter interval and feeding, mint is added, both keep the profile', () async {
      // Given
      await plants.save(Plant(id: 'p.basil', name: 'basil', everyDays: 7, lastWatered: DateTime(2026, 10, 20)));
      final container = createTestContainer(
        overrides: [
          plantProfileRepositoryProvider.overrideWithValue(profiles),
          plantRepositoryProvider.overrideWithValue(plants),
        ],
      );
      container.listen(plantsServiceProvider, (_, _) {});
      PlantProfile imported(String name, {int? feed}) => PlantProfile(
        source: PlantProfileSource.imported,
        commonName: name,
        wateringMinDays: 2,
        wateringMaxDays: 3,
        wateringWinterMinDays: 4,
        wateringWinterMaxDays: 6,
        fertilizeEveryWeeks: feed,
        fetchedAt: DateTime(2026, 10, 26),
      );

      // When
      final result = await withClock(
        Clock.fixed(DateTime(2026, 11, 2)),
        () => container.read(plantProfileServiceProvider.notifier).importCare([
          (name: 'Basil', profile: imported('Sweet basil', feed: 2)),
          (name: 'Mint', profile: imported('Mint')),
        ]),
      );

      // Then
      expect(result, (updated: 1, added: 1));
      final all = await plants.all();
      final basil = all.firstWhere((plant) => plant.id == 'p.basil');
      final mint = all.firstWhere((plant) => plant.name == 'Mint');
      expect((basil.everyDays, basil.fertilizeEveryWeeks), (5, 2));
      expect((mint.everyDays, mint.fertilizeEveryWeeks), (5, null));
      expect((await profiles.watch('p.basil').first)?.commonName, 'Sweet basil');
      expect((await profiles.watch(mint.id).first)?.source, PlantProfileSource.imported);
    });
  });
}
