import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/plants/plant.repository.dart';
import 'package:smart_hub/data/plants/plant_photo.repository.dart';
import 'package:smart_hub/data/plants/plant_profile.repository.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';

import '../../utils/riverpod.test_util.dart';

void main() {
  group('PlantsService', () {
    final morning = DateTime(2026, 10, 26, 9);
    late ProviderContainer container;
    late PlantRepository repository;
    late Directory documents;

    PlantsService service() => container.read(plantsServiceProvider.notifier);

    Future<Plant> stored(String id) async => (await repository.all()).firstWhere((plant) => plant.id == id);

    setUp(() async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      documents = await Directory.systemTemp.createTemp('plants_service_test');
      addTearDown(() => documents.delete(recursive: true));
      repository = PlantRepository(database: database);
      container = createTestContainer(
        overrides: [
          plantRepositoryProvider.overrideWithValue(repository),
          plantPhotoRepositoryProvider.overrideWithValue(PlantPhotoRepository(directory: () async => documents)),
          plantProfileRepositoryProvider.overrideWithValue(PlantProfileRepository(database: database)),
        ],
      );
      container.listen(plantsServiceProvider, (_, _) {});
    });

    test('Given a name, interval and photo, '
        'when adding a plant, '
        'then it is stored as watered now with a copied photo', () async {
      // Given
      final picked = File(p.join(documents.path, 'picked.jpg'))..writeAsBytesSync([7]);

      // When
      final plant = await withClock(Clock.fixed(morning), () {
        return service().add(name: '  Monstera ', everyDays: 7, photoSource: picked.path);
      });

      // Then
      final saved = await stored(plant.id);
      expect(saved.name, 'Monstera');
      expect(saved.everyDays, 7);
      expect(saved.lastWatered, morning);
      expect(saved.photoPath, isNot(picked.path));
      expect(File(saved.photoPath!).existsSync(), isTrue);
    });

    test('Given an interval of 0, when adding, then it becomes 1 day', () async {
      final plant = await service().add(name: 'Cress', everyDays: 0);

      expect((await stored(plant.id)).everyDays, 1);
    });

    test('Given due plants, '
        'when watering them, '
        'then they are watered now and remember the previous watering', () async {
      // Given
      await repository.saveAll([
        Plant(id: 'a', name: 'A', everyDays: 3, lastWatered: DateTime(2026, 10, 20)),
        Plant(id: 'b', name: 'B', everyDays: 3, lastWatered: DateTime(2026, 10, 22)),
      ]);

      // When
      await withClock(Clock.fixed(morning), () => service().water(['a', 'b']));

      // Then
      expect((await stored('a')).lastWatered, morning);
      expect((await stored('a')).previousWatered, DateTime(2026, 10, 20));
      expect((await stored('b')).previousWatered, DateTime(2026, 10, 22));
    });

    test('Given a plant watered today, '
        'when watering it again, '
        'then nothing changes so undo still restores the real previous watering', () async {
      // Given
      await repository.save(
        Plant(
          id: 'a',
          name: 'A',
          everyDays: 3,
          lastWatered: DateTime(2026, 10, 26, 8),
          previousWatered: DateTime(2026, 10, 20),
        ),
      );

      // When
      await withClock(Clock.fixed(morning), () => service().water(['a']));

      // Then
      expect((await stored('a')).previousWatered, DateTime(2026, 10, 20));
    });

    test('Given a plant watered today, when undoing, then the previous watering is back', () async {
      // Given
      await repository.save(
        Plant(
          id: 'a',
          name: 'A',
          everyDays: 3,
          lastWatered: DateTime(2026, 10, 26, 8),
          previousWatered: DateTime(2026, 10, 20),
        ),
      );

      // When
      await withClock(Clock.fixed(morning), () => service().undoWatering('a'));

      // Then
      expect((await stored('a')).lastWatered, DateTime(2026, 10, 20));
      expect((await stored('a')).previousWatered, isNull);
    });

    test('Given a plant watered yesterday, when undoing today, then nothing changes', () async {
      // Given
      await repository.save(
        Plant(
          id: 'a',
          name: 'A',
          everyDays: 3,
          lastWatered: DateTime(2026, 10, 25, 8),
          previousWatered: DateTime(2026, 10, 20),
        ),
      );

      // When
      await withClock(Clock.fixed(morning), () => service().undoWatering('a'));

      // Then
      expect((await stored('a')).lastWatered, DateTime(2026, 10, 25, 8));
    });

    test('Given a plant with photo, when replacing the photo and deleting the plant, then no photo is left', () async {
      // Given
      final first = File(p.join(documents.path, 'first.jpg'))..writeAsBytesSync([1]);
      final second = File(p.join(documents.path, 'second.jpg'))..writeAsBytesSync([2]);
      final plant = await service().add(name: 'Fig', everyDays: 5, photoSource: first.path);
      final firstCopy = (await stored(plant.id)).photoPath!;

      // When
      await service().edit((await stored(plant.id)).copyWith(name: 'Fiddle leaf fig'), photoSource: second.path);
      final secondCopy = (await stored(plant.id)).photoPath!;
      await service().delete(await stored(plant.id));

      // Then
      expect(File(firstCopy).existsSync(), isFalse, reason: 'replaced photo is removed');
      expect(File(secondCopy).existsSync(), isFalse, reason: 'photo of a deleted plant is removed');
      expect(await repository.all(), isEmpty);
    });

    test('Given plants exist, when adding the demo plants, then nothing is added', () async {
      await repository.save(Plant(id: 'a', name: 'A', everyDays: 3, lastWatered: morning));

      await service().addAllIfEmpty([Plant(id: 'demo', name: 'Demo', everyDays: 3, lastWatered: morning)]);

      expect((await repository.all()).map((p) => p.id), ['a']);
    });

    test('Given a new plant fed every 4 weeks, when adding it, then it counts as fertilized now', () async {
      // When
      final plant = await withClock(
        Clock.fixed(morning),
        () => service().add(name: 'Monstera', everyDays: 7, fertilizeEveryWeeks: 4),
      );

      // Then
      expect((await stored(plant.id)).fertilizeEveryWeeks, 4);
      expect((await stored(plant.id)).lastFertilized, morning);
    });

    test('Given a plant without fertilizing, when switching it on, then the first feeding starts today', () async {
      // Given
      final plant = await withClock(Clock.fixed(morning), () => service().add(name: 'Fern', everyDays: 4));

      // When
      await withClock(Clock.fixed(morning), () => service().edit(plant.copyWith(fertilizeEveryWeeks: 3)));

      // Then
      expect((await stored(plant.id)).lastFertilized, morning);
    });

    test('Given two plants, when fertilizing one, then only that one is fertilized now', () async {
      // Given
      final fern = await withClock(Clock.fixed(morning), () => service().add(name: 'Fern', everyDays: 4));
      final palm = await withClock(
        Clock.fixed(morning.add(const Duration(minutes: 1))),
        () => service().add(name: 'Palm', everyDays: 9),
      );
      final later = morning.add(const Duration(days: 20));

      // When
      await withClock(Clock.fixed(later), () => service().fertilize([fern.id]));

      // Then
      expect((await stored(fern.id)).lastFertilized, later);
      expect((await stored(palm.id)).lastFertilized, isNull);
    });
  });
}
