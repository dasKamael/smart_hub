import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';

part 'forecast.freezed.dart';

/// The weather now and ahead at a place. Times are local wall-clock times of the place.
@freezed
abstract class Forecast with _$Forecast {
  const factory Forecast({
    required WeatherPlace place,
    required WeatherNow now,

    /// From the current hour on.
    required List<WeatherHour> hours,

    /// From today on.
    required List<WeatherDay> days,
    required DateTime fetchedAt,
  }) = _Forecast;
}

@freezed
abstract class WeatherNow with _$WeatherNow {
  const factory WeatherNow({
    required double temperature,
    required double apparentTemperature,
    required WeatherCondition condition,
    required bool isDay,

    /// Percent.
    required int humidity,
    required double dewPoint,

    /// km/h.
    required double windSpeed,
    required double windGusts,

    /// Degrees the wind comes from, 0 = north.
    required int windDirection,
    required double uvIndex,
  }) = _WeatherNow;
}

@freezed
abstract class WeatherHour with _$WeatherHour {
  const factory WeatherHour({
    required DateTime time,
    required double temperature,
    required WeatherCondition condition,
    required bool isDay,

    /// Percent.
    required int precipitationProbability,

    /// mm.
    required double precipitation,

    /// km/h.
    required double windGusts,
  }) = _WeatherHour;
}

@freezed
abstract class WeatherDay with _$WeatherDay {
  const factory WeatherDay({
    required DateTime date,
    required WeatherCondition condition,
    required double maxTemperature,
    required double minTemperature,

    /// Percent.
    required int precipitationProbability,

    /// mm.
    required double precipitationSum,
    required DateTime sunrise,
    required DateTime sunset,
    required double uvIndexMax,
  }) = _WeatherDay;
}
