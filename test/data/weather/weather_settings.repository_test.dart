import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/weather/weather_settings.repository.dart';
import 'package:smart_hub/domain/weather/model/weather_location.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';

void main() {
  group('WeatherSettingsRepository', () {
    late WeatherSettingsRepository repository;
    const mainz = WeatherPlace(latitude: 49.98, longitude: 8.27, name: 'Mainz', region: 'Germany');

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = WeatherSettingsRepository(database: database);
    });

    test('Given nothing chosen, when reading the location, then it is where the hub is', () async {
      expect(await repository.watchLocation().first, const WeatherLocation.device());
    });

    test('Given a chosen place and a cache, when switching back to the hub, then the cache stays', () async {
      // Given
      await repository.setLocation(const WeatherLocation.place(mainz));
      final chosen = await repository.watchLocation().first;
      await repository.saveCache((json: '{}', place: mainz, at: DateTime(2026, 10, 27, 10)));

      // When
      await repository.setLocation(const WeatherLocation.device());

      // Then
      expect(chosen, const WeatherLocation.place(mainz));
      expect(await repository.watchLocation().first, const WeatherLocation.device());
      final cached = await repository.cached();
      expect(cached?.place.name, 'Mainz');
      expect(cached?.at, DateTime(2026, 10, 27, 10));
    });
  });
}
