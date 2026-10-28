import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/lights/room_scenes.table.dart';
import 'package:smart_hub/data/dashboard/dashboard_state.table.dart';
import 'package:smart_hub/data/dashboard/dashboard_widgets.table.dart';
import 'package:smart_hub/data/database/app_database.steps.dart';
import 'package:smart_hub/data/focus/focus_points.table.dart';
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
    DashboardWidgetsTable,
    DashboardStateTable,
    RoomScenesTable,
    FocusPointsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'smart_hub'));

  @override
  int get schemaVersion => 14;

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
        // v8: arranged dashboard widgets.
        from7To8: (migrator, schema) async {
          await migrator.createTable(schema.dashboardWidgets);
          await migrator.createTable(schema.dashboardState);
        },
        // v9: what a dashboard widget shows, e.g. the rooms of a lights widget.
        from8To9: (migrator, schema) => migrator.addColumn(schema.dashboardWidgets, schema.dashboardWidgets.selection),
        // v10: dashboard widgets with or without a card.
        from9To10: (migrator, schema) => migrator.addColumn(schema.dashboardWidgets, schema.dashboardWidgets.card),
        // v11: light scenes per room.
        from10To11: (migrator, schema) => migrator.createTable(schema.roomScenes),
        // v12: focus points and the days they were worked on.
        from11To12: (migrator, schema) async {
          await migrator.createTable(schema.focusPoints);
          await migrator.createTable(schema.focusTouches);
        },
        // v13: dashboard widgets keep the cell they were put in, and a focus point is a name and the day it is
        // due – the days worked on and the rest are gone.
        from12To13: (migrator, schema) async {
          await migrator.addColumn(schema.dashboardWidgets, schema.dashboardWidgets.gridColumn);
          await migrator.addColumn(schema.dashboardWidgets, schema.dashboardWidgets.gridRow);
          await migrator.deleteTable('focus_touches');
          await migrator.deleteTable(schema.focusPoints.actualTableName);
          await migrator.createTable(schema.focusPoints);
        },
        // v14: builds the focus points again for databases that reached v13 while the focus tables still had their
        // first shape. Everywhere else it only writes the same empty table once more.
        from13To14: (migrator, schema) async {
          await migrator.deleteTable('focus_touches');
          await migrator.deleteTable(schema.focusPoints.actualTableName);
          await migrator.createTable(schema.focusPoints);
        },
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
