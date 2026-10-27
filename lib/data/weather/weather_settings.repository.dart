import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/weather/model/weather_location.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';

part 'weather_settings.repository.g.dart';

/// The last forecast kept for offline starts.
typedef CachedForecast = ({String json, WeatherPlace place, DateTime at});

class WeatherSettingsRepository {
  WeatherSettingsRepository({required this.database});

  static const _id = 0;

  final AppDatabase database;

  SimpleSelectStatement<$WeatherSettingsTableTable, WeatherSettingsRow> get _row =>
      database.select(database.weatherSettingsTable)..where((t) => t.id.equals(_id));

  Stream<WeatherLocation> watchLocation() {
    return _row.watchSingleOrNull().map((row) {
      return switch (row) {
        WeatherSettingsRow(
          placeLatitude: final latitude?,
          placeLongitude: final longitude?,
          placeName: final name?,
          :final placeRegion,
        ) =>
          WeatherLocation.place(
            WeatherPlace(latitude: latitude, longitude: longitude, name: name, region: placeRegion),
          ),
        _ => const WeatherLocation.device(),
      };
    }).distinct();
  }

  Future<void> setLocation(WeatherLocation location) {
    final place = switch (location) {
      PlaceWeatherLocation(:final place) => place,
      DeviceWeatherLocation() => null,
    };
    return database
        .into(database.weatherSettingsTable)
        .insertOnConflictUpdate(
          WeatherSettingsTableCompanion(
            id: const Value(_id),
            placeLatitude: Value(place?.latitude),
            placeLongitude: Value(place?.longitude),
            placeName: Value(place?.name),
            placeRegion: Value(place?.region),
          ),
        );
  }

  Future<CachedForecast?> cached() async {
    final row = await _row.getSingleOrNull();
    return switch (row) {
      WeatherSettingsRow(
        cachedJson: final json?,
        cachedLatitude: final latitude?,
        cachedLongitude: final longitude?,
        cachedAt: final at?,
        :final cachedPlaceName,
      ) =>
        (
          json: json,
          place: WeatherPlace(latitude: latitude, longitude: longitude, name: cachedPlaceName ?? ''),
          at: at,
        ),
      _ => null,
    };
  }

  Future<void> saveCache(CachedForecast cache) {
    return database
        .into(database.weatherSettingsTable)
        .insertOnConflictUpdate(
          WeatherSettingsTableCompanion(
            id: const Value(_id),
            cachedJson: Value(cache.json),
            cachedLatitude: Value(cache.place.latitude),
            cachedLongitude: Value(cache.place.longitude),
            cachedPlaceName: Value(cache.place.name),
            cachedAt: Value(cache.at),
          ),
        );
  }
}

/// Providers
@Riverpod(keepAlive: true)
WeatherSettingsRepository weatherSettingsRepository(Ref ref) {
  return WeatherSettingsRepository(database: ref.watch(appDatabaseProvider));
}
