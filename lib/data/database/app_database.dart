import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.steps.dart';
import 'package:smart_hub/data/floorplan/floor_plans.table.dart';
import 'package:smart_hub/data/floorplan/placements.table.dart';
import 'package:smart_hub/data/music/speaker_settings.table.dart';
import 'package:smart_hub/data/plants/plant_profiles.table.dart';
import 'package:smart_hub/data/plants/plants.table.dart';
import 'package:smart_hub/data/weather/weather_settings.table.dart';
import 'package:smart_hub/data/zen/zen_settings.table.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';

part 'app_database.g.dart';

/// The app's local database. Bump [schemaVersion] for every schema change and run
/// `dart run drift_dev make-migrations` (see docs/architecture.md).
@DriftDatabase(
  tables: [
    FloorPlansTable,
    PlacementsTable,
    PlantsTable,
    SpeakerSettingsTable,
    ZenSettingsTable,
    PlantProfilesTable,
    WeatherSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'smart_hub'));

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        // v2: plants.
        from1To2: (migrator, schema) => migrator.createTable(schema.plants),
        // v3: local speaker names, hidden speakers, default speaker.
        from2To3: (migrator, schema) => migrator.createTable(schema.speakerSettings),
        // v4: zen mode settings.
        from3To4: (migrator, schema) => migrator.createTable(schema.zenSettings),
        // v5: plant profiles from the plant database, fertilizing.
        from4To5: (migrator, schema) async {
          await migrator.createTable(schema.plantProfiles);
          await migrator.addColumn(schema.plants, schema.plants.fertilizeEveryWeeks);
          await migrator.addColumn(schema.plants, schema.plants.lastFertilized);
        },
        // v6: imported plant profiles (no species id), winter watering, suggested feeding.
        from5To6: (migrator, schema) => migrator.alterTable(
          TableMigration(
            schema.plantProfiles,
            newColumns: [
              schema.plantProfiles.source,
              schema.plantProfiles.wateringWinterMinDays,
              schema.plantProfiles.wateringWinterMaxDays,
              schema.plantProfiles.fertilizeEveryWeeks,
            ],
          ),
        ),
        // v7: weather location and offline cache.
        from6To7: (migrator, schema) => migrator.createTable(schema.weatherSettings),
      ),
    );
  }
}

/// Providers
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}
