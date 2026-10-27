import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_hub/data/weather/open_meteo.repository.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';

void main() {
  group('OpenMeteoRepository', () {
    String fixture(String name) => File('test/fixtures/weather/$name.json').readAsStringSync();

    test('Given an answer from Open-Meteo, when parsing it, then now, hours and days are read in local time', () {
      // When
      final forecast = OpenMeteoRepository.parse(fixture('forecast'));

      // Then
      expect(forecast.now.temperature, 10.2);
      expect(forecast.now.apparentTemperature, 7.5);
      expect(forecast.now.condition, WeatherCondition.partlyCloudy);
      expect(forecast.now.isDay, isTrue);
      expect(forecast.now.humidity, 70);
      expect(forecast.now.windDirection, 168);
      expect(forecast.hours, hasLength(36));
      expect(forecast.hours.first.time, DateTime(2026, 10, 27, 10));
      expect(forecast.days, hasLength(10));
      expect(forecast.days[1].condition, WeatherCondition.rain);
      expect(forecast.days[1].precipitationProbability, 63);
      expect(forecast.days.first.sunset, DateTime(2026, 10, 27, 16, 46));
    });

    test('Given WMO codes, when simplifying them, then every group gets its condition', () {
      expect([0, 1, 3, 45, 53, 61, 81, 73, 86, 95, 99, null].map(OpenMeteoRepository.conditionOf), [
        WeatherCondition.clear,
        WeatherCondition.partlyCloudy,
        WeatherCondition.cloudy,
        WeatherCondition.fog,
        WeatherCondition.drizzle,
        WeatherCondition.rain,
        WeatherCondition.rain,
        WeatherCondition.snow,
        WeatherCondition.snow,
        WeatherCondition.thunderstorm,
        WeatherCondition.thunderstorm,
        WeatherCondition.cloudy,
      ]);
    });

    test('Given a place name, when searching, then the places come with region and position', () async {
      // Given
      late Uri asked;
      final repository = OpenMeteoRepository(
        client: MockClient((request) async {
          asked = request.url;
          return http.Response(fixture('geocoding'), 200);
        }),
      );

      // When
      final places = await repository.search('Mainz');

      // Then
      expect(asked.host, 'geocoding-api.open-meteo.com');
      expect(asked.queryParameters['name'], 'Mainz');
      expect(places.first.name, 'Mainz');
      expect(places.first.region, 'Rhineland-Palatinate, Germany');
      expect(places.first.latitude, closeTo(49.98, 0.01));
    });

    test('Given coordinates, when loading the forecast, then the request asks for local times and 10 days', () async {
      // Given
      late Uri asked;
      final repository = OpenMeteoRepository(
        client: MockClient((request) async {
          asked = request.url;
          return http.Response(fixture('forecast'), 200);
        }),
      );

      // When
      await repository.forecastJson(49.99, 8.27);

      // Then
      expect(asked.queryParameters['latitude'], '49.99');
      expect(asked.queryParameters['timezone'], 'auto');
      expect(asked.queryParameters['forecast_days'], '10');
    });
  });
}
