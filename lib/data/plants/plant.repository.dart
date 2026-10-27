import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';

part 'plant.repository.g.dart';

class PlantRepository {
  PlantRepository({required this.database});

  final AppDatabase database;

  $PlantsTableTable get _table => database.plantsTable;

  Stream<List<Plant>> watchAll() => database.select(_table).watch().map((rows) => rows.map(_toPlant).toList());

  Future<List<Plant>> all() async => (await database.select(_table).get()).map(_toPlant).toList();

  Future<void> save(Plant plant) => database.into(_table).insertOnConflictUpdate(_toCompanion(plant));

  Future<void> saveAll(Iterable<Plant> plants) {
    return database.batch((batch) => batch.insertAllOnConflictUpdate(_table, plants.map(_toCompanion)));
  }

  Future<void> delete(String id) => (database.delete(_table)..where((t) => t.id.equals(id))).go();

  static Plant _toPlant(PlantRow row) {
    return Plant(
      id: row.id,
      name: row.name,
      everyDays: row.everyDays,
      lastWatered: row.lastWatered,
      previousWatered: row.previousWatered,
      photoPath: row.photoPath,
      fertilizeEveryWeeks: row.fertilizeEveryWeeks,
      lastFertilized: row.lastFertilized,
    );
  }

  /// `nullToAbsent: false`: an upsert must clear fields that became `null` (e.g. the previous watering after undo).
  static PlantsTableCompanion _toCompanion(Plant plant) => _toRow(plant).toCompanion(false);

  static PlantRow _toRow(Plant plant) {
    return PlantRow(
      id: plant.id,
      name: plant.name,
      everyDays: plant.everyDays,
      lastWatered: plant.lastWatered,
      previousWatered: plant.previousWatered,
      photoPath: plant.photoPath,
      fertilizeEveryWeeks: plant.fertilizeEveryWeeks,
      lastFertilized: plant.lastFertilized,
    );
  }
}

/// Providers
@Riverpod(keepAlive: true)
PlantRepository plantRepository(Ref ref) => PlantRepository(database: ref.watch(appDatabaseProvider));
