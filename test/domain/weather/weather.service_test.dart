import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/weather/device_location.repository.dart';
import 'package:smart_hub/data/weather/open_meteo.repository.dart';
import 'package:smart_hub/data/weather/place_name.repository.dart';
import 'package:smart_hub/data/weather/weather_settings.repository.dart';
import 'package:smart_hub/domain/weather/model/weather_location.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';

import '../../utils/riverpod.test_util.dart';

class _MockOpenMeteo extends Mock implements OpenMeteoRepository {}

class _MockPlaceNames extends Mock implements PlaceNameRepository {}

class _MockDevice extends Mock implements DeviceLocationRepository {}

void main() {
  group('WeatherService', () {
    final forecastJson = File('test/fixtures/weather/forecast.json').readAsStringSync();
    final morning = DateTime(2026, 10, 27, 10, 20);
    late _MockOpenMeteo openMeteo;
    late _MockPlaceNames placeNames;
    late _MockDevice device;
    late WeatherSettingsRepository settings;

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      settings = WeatherSettingsRepository(database: database);
      openMeteo = _MockOpenMeteo();
      placeNames = _MockPlaceNames();
      device = _MockDevice();
      when(() => openMeteo.forecastJson(any(), any())).thenAnswer((_) async => forecastJson);
      when(() => placeNames.nameAt(any(), any())).thenAnswer((_) async => 'Mainz');
      when(() => device.current()).thenAnswer((_) async => (latitude: 49.99, longitude: 8.27));
    });

    ProviderContainer createContainer() {
      final container = createTestContainer(
        overrides: [
          openMeteoRepositoryProvider.overrideWithValue(openMeteo),
          placeNameRepositoryProvider.overrideWithValue(placeNames),
          deviceLocationRepositoryProvider.overrideWithValue(device),
          weatherSettingsRepositoryProvider.overrideWithValue(settings),
        ],
      );
      container.listen(weatherServiceProvider, (_, _) {});
      return container;
    }

    test('Given the hub may locate itself, when loading, then the forecast is for its town and kept', () async {
      // When
      final forecast = await withClock(
        Clock.fixed(morning),
        () => createContainer().read(weatherServiceProvider.future),
      );

      // Then
      expect(forecast.place.name, 'Mainz');
      expect(forecast.now.temperature, 10.2);
      expect(forecast.hours.first.time, DateTime(2026, 10, 27, 10));
      verify(() => openMeteo.forecastJson(49.99, 8.27)).called(1);
      expect((await settings.cached())?.place.name, 'Mainz');
    });

    test('Given a forecast loaded before nearby, when loading again, then the town is not asked again', () async {
      // Given
      await settings.saveCache((
        json: forecastJson,
        place: const WeatherPlace(latitude: 49.98, longitude: 8.26, name: 'Mainz'),
        at: morning,
      ));
      final container = createContainer();

      // When
      await withClock(Clock.fixed(morning), () async {
        await container.read(weatherServiceProvider.future);
        await container.read(weatherServiceProvider.notifier).refresh();
      });

      // Then
      verifyNever(() => placeNames.nameAt(any(), any()));
      expect(container.read(weatherServiceProvider).value?.place.name, 'Mainz');
    });

    test('Given location is off and nothing loaded before, when loading, then it asks for a place', () async {
      // Given
      when(() => device.current()).thenAnswer((_) async => null);

      // When / Then
      await expectLater(
        withClock(Clock.fixed(morning), () => createContainer().read(weatherServiceProvider.future)),
        throwsA(isA<WeatherLocationUnavailableException>()),
      );
    });

    test('Given a chosen place, when loading, then the forecast is for it without locating the hub', () async {
      // Given
      await settings.setLocation(
        const WeatherLocation.place(WeatherPlace(latitude: 52.52, longitude: 13.41, name: 'Berlin')),
      );

      // When
      final forecast = await withClock(
        Clock.fixed(morning),
        () => createContainer().read(weatherServiceProvider.future),
      );

      // Then
      expect(forecast.place.name, 'Berlin');
      verify(() => openMeteo.forecastJson(52.52, 13.41)).called(1);
      verifyNever(() => device.current());
    });

    test('Given a forecast from hours ago, when showing it, then past hours are left out', () async {
      // Given
      await settings.saveCache((
        json: forecastJson,
        place: const WeatherPlace(latitude: 49.99, longitude: 8.27, name: 'Mainz'),
        at: morning,
      ));
      when(() => openMeteo.forecastJson(any(), any())).thenAnswer((_) async => throw const SocketException('offline'));

      // When
      final forecast = await withClock(
        Clock.fixed(DateTime(2026, 10, 27, 14, 5)),
        () => createContainer().read(weatherServiceProvider.future),
      );

      // Then
      expect(forecast.hours.first.time, DateTime(2026, 10, 27, 14));
      expect(forecast.fetchedAt, morning);
    });
  });
}
