import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/plants/plant.repository.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';

void main() {
  group('PlantRepository', () {
    late PlantRepository repository;
    final fern = Plant(
      id: 'plant-fern',
      name: 'Fern',
      everyDays: 4,
      lastWatered: DateTime(2026, 10, 25, 18, 30),
      previousWatered: DateTime(2026, 10, 21, 8),
      photoPath: '/photos/fern.jpg',
    );

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = PlantRepository(database: database);
    });

    test('Given a saved plant, when reading all, then every field comes back', () async {
      await repository.save(fern);

      final plants = await repository.all();

      expect(plants.single.id, fern.id);
      expect(plants.single.name, 'Fern');
      expect(plants.single.everyDays, 4);
      expect(plants.single.lastWatered.isAtSameMomentAs(fern.lastWatered), isTrue);
      expect(plants.single.previousWatered?.isAtSameMomentAs(fern.previousWatered!), isTrue);
      expect(plants.single.photoPath, '/photos/fern.jpg');
    });

    test('Given a saved plant, when saving it again with changes, then it is updated', () async {
      await repository.save(fern);

      await repository.save(fern.copyWith(name: 'Boston fern', previousWatered: null));

      final plant = (await repository.all()).single;
      expect(plant.name, 'Boston fern');
      expect(plant.previousWatered, isNull);
    });

    test('Given plants, when deleting one, then the other stays', () async {
      await repository.saveAll([fern, fern.copyWith(id: 'plant-palm', name: 'Palm')]);

      await repository.delete('plant-fern');

      expect((await repository.all()).map((p) => p.id), ['plant-palm']);
    });
  });
}
