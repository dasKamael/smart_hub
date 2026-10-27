import 'dart:io';

import 'package:smart_hub/data/weather/open_meteo.repository.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';

/// The forecast of `test/fixtures/weather/forecast.json` (27 Oct 2026, from 10:00) for Mainz.
Forecast fixtureForecast() {
  final parsed = OpenMeteoRepository.parse(File('test/fixtures/weather/forecast.json').readAsStringSync());
  return Forecast(
    place: const WeatherPlace(latitude: 49.99, longitude: 8.27, name: 'Mainz'),
    now: parsed.now,
    hours: parsed.hours,
    days: parsed.days,
    fetchedAt: DateTime(2026, 10, 27, 10, 5),
  );
}

/// [WeatherService] with a fixed [forecast], or failing with [error].
class FakeWeatherService extends WeatherService {
  FakeWeatherService({this.forecast, this.error});

  final Forecast? forecast;
  final Object? error;

  @override
  Future<Forecast> build() async => forecast ?? (throw error ?? const WeatherLocationUnavailableException());
}
