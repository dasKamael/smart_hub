import 'package:drift/drift.dart';

/// Care data per plant from the plant database. Lists are stored as text, one item per line.
@DataClassName('PlantProfileRow')
class PlantProfilesTable extends Table {
  @override
  String get tableName => 'plant_profiles';

  TextColumn get plantId => text()();

  /// `null` for imported profiles.
  IntColumn get speciesId => integer().nullable()();

  /// `PlantProfileSource` name.
  TextColumn get source => text().withDefault(const Constant('perenual'))();

  TextColumn get commonName => text()();

  TextColumn get scientificName => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  TextColumn get watering => text().nullable()();

  IntColumn get wateringMinDays => integer().nullable()();

  IntColumn get wateringMaxDays => integer().nullable()();

  IntColumn get wateringWinterMinDays => integer().nullable()();

  IntColumn get wateringWinterMaxDays => integer().nullable()();

  IntColumn get fertilizeEveryWeeks => integer().nullable()();

  TextColumn get sunlight => text().withDefault(const Constant(''))();

  TextColumn get careLevel => text().nullable()();

  BoolColumn get indoor => boolean().nullable()();

  BoolColumn get poisonousToPets => boolean().nullable()();

  TextColumn get pruningMonths => text().withDefault(const Constant(''))();

  TextColumn get wateringGuide => text().nullable()();

  TextColumn get sunlightGuide => text().nullable()();

  TextColumn get pruningGuide => text().nullable()();

  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {plantId};
}
