import 'package:drift/drift.dart';

/// Where the weather is for, and the last forecast as offline cache; a single row.
@DataClassName('WeatherSettingsRow')
class WeatherSettingsTable extends Table {
  @override
  String get tableName => 'weather_settings';

  IntColumn get id => integer()();

  /// A chosen place; all `null` = where the hub is.
  RealColumn get placeLatitude => real().nullable()();

  RealColumn get placeLongitude => real().nullable()();

  TextColumn get placeName => text().nullable()();

  TextColumn get placeRegion => text().nullable()();

  /// The last answer of the weather service, where it was for and when.
  TextColumn get cachedJson => text().nullable()();

  RealColumn get cachedLatitude => real().nullable()();

  RealColumn get cachedLongitude => real().nullable()();

  TextColumn get cachedPlaceName => text().nullable()();

  DateTimeColumn get cachedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
