import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/http/http_client.provider.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';

part 'open_meteo.repository.g.dart';

/// Forecast and place search from Open-Meteo (open source, no key; data CC BY 4.0).
class OpenMeteoRepository {
  OpenMeteoRepository({required this.client});

  static final forecastApi = Uri.parse('https://api.open-meteo.com/v1/forecast');
  static final geocodingApi = Uri.parse('https://geocoding-api.open-meteo.com/v1/search');

  final http.Client client;

  /// The raw answer for [latitude]/[longitude]; it is kept as offline cache and read with [parse].
  Future<String> forecastJson(double latitude, double longitude) async {
    final url = forecastApi.replace(
      queryParameters: {
        'latitude': '$latitude',
        'longitude': '$longitude',
        'current':
            'temperature_2m,apparent_temperature,relative_humidity_2m,dew_point_2m,weather_code,is_day,'
            'wind_speed_10m,wind_direction_10m,wind_gusts_10m,uv_index',
        'hourly': 'temperature_2m,weather_code,precipitation_probability,precipitation,wind_gusts_10m,is_day',
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,precipitation_sum,'
            'sunrise,sunset,uv_index_max',
        'timezone': 'auto',
        'forecast_days': '10',
        'forecast_hours': '36',
      },
    );
    final response = await client.get(url).timeout(const Duration(seconds: 20));
    if (response.statusCode >= 300) throw http.ClientException('Open-Meteo answered ${response.statusCode}', url);
    return response.body;
  }

  /// Reads an answer of [forecastJson]. Times are wall-clock times of the place.
  static ({WeatherNow now, List<WeatherHour> hours, List<WeatherDay> days}) parse(String body) {
    final json = jsonDecode(body) as Map<String, Object?>;
    final current = json['current']! as Map<String, Object?>;
    final hourly = json['hourly']! as Map<String, Object?>;
    final daily = json['daily']! as Map<String, Object?>;
    List<Object?> column(Map<String, Object?> table, String key) => (table[key] as List<Object?>?) ?? const [];
    double number(Object? value) => (value as num?)?.toDouble() ?? 0;

    final hourTimes = column(hourly, 'time');
    final dayTimes = column(daily, 'time');
    return (
      now: WeatherNow(
        temperature: number(current['temperature_2m']),
        apparentTemperature: number(current['apparent_temperature']),
        condition: conditionOf(current['weather_code']),
        isDay: current['is_day'] == 1,
        humidity: number(current['relative_humidity_2m']).round(),
        dewPoint: number(current['dew_point_2m']),
        windSpeed: number(current['wind_speed_10m']),
        windGusts: number(current['wind_gusts_10m']),
        windDirection: number(current['wind_direction_10m']).round(),
        uvIndex: number(current['uv_index']),
      ),
      hours: [
        for (var i = 0; i < hourTimes.length; i++)
          WeatherHour(
            time: DateTime.parse(hourTimes[i]! as String),
            temperature: number(column(hourly, 'temperature_2m').elementAtOrNull(i)),
            condition: conditionOf(column(hourly, 'weather_code').elementAtOrNull(i)),
            isDay: column(hourly, 'is_day').elementAtOrNull(i) == 1,
            precipitationProbability: number(column(hourly, 'precipitation_probability').elementAtOrNull(i)).round(),
            precipitation: number(column(hourly, 'precipitation').elementAtOrNull(i)),
            windGusts: number(column(hourly, 'wind_gusts_10m').elementAtOrNull(i)),
          ),
      ],
      days: [
        for (var i = 0; i < dayTimes.length; i++)
          WeatherDay(
            date: DateTime.parse(dayTimes[i]! as String),
            condition: conditionOf(column(daily, 'weather_code').elementAtOrNull(i)),
            maxTemperature: number(column(daily, 'temperature_2m_max').elementAtOrNull(i)),
            minTemperature: number(column(daily, 'temperature_2m_min').elementAtOrNull(i)),
            precipitationProbability: number(column(daily, 'precipitation_probability_max').elementAtOrNull(i)).round(),
            precipitationSum: number(column(daily, 'precipitation_sum').elementAtOrNull(i)),
            sunrise: DateTime.parse(column(daily, 'sunrise').elementAtOrNull(i)! as String),
            sunset: DateTime.parse(column(daily, 'sunset').elementAtOrNull(i)! as String),
            uvIndexMax: number(column(daily, 'uv_index_max').elementAtOrNull(i)),
          ),
      ],
    );
  }

  /// Places named like [query], e.g. "Mainz".
  Future<List<WeatherPlace>> search(String query) async {
    final url = geocodingApi.replace(
      queryParameters: {'name': query, 'count': '6', 'language': 'en', 'format': 'json'},
    );
    final response = await client.get(url).timeout(const Duration(seconds: 15));
    if (response.statusCode >= 300) throw http.ClientException('Open-Meteo answered ${response.statusCode}', url);
    final results = (jsonDecode(response.body) as Map<String, Object?>)['results'] as List<Object?>? ?? const [];
    return [
      for (final result in results.whereType<Map<String, Object?>>())
        if ((result['latitude'], result['longitude'], result['name']) case (
          final num latitude,
          final num longitude,
          final String name,
        ))
          WeatherPlace(
            latitude: latitude.toDouble(),
            longitude: longitude.toDouble(),
            name: name,
            region: [?result['admin1'] as String?, ?result['country'] as String?].join(', '),
          ),
    ];
  }

  /// WMO weather interpretation codes, simplified.
  static WeatherCondition conditionOf(Object? code) {
    return switch ((code as num?)?.toInt()) {
      0 => WeatherCondition.clear,
      1 || 2 => WeatherCondition.partlyCloudy,
      45 || 48 => WeatherCondition.fog,
      final c? when c >= 51 && c <= 57 => WeatherCondition.drizzle,
      final c? when (c >= 61 && c <= 67) || (c >= 80 && c <= 82) => WeatherCondition.rain,
      final c? when (c >= 71 && c <= 77) || c == 85 || c == 86 => WeatherCondition.snow,
      final c? when c >= 95 => WeatherCondition.thunderstorm,
      _ => WeatherCondition.cloudy,
    };
  }
}

/// Providers
@Riverpod(keepAlive: true)
OpenMeteoRepository openMeteoRepository(Ref ref) => OpenMeteoRepository(client: ref.watch(httpClientProvider));
