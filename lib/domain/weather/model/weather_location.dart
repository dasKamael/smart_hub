import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';

part 'weather_location.freezed.dart';

/// Where the weather is shown for: where the hub is (default) or a chosen place.
@freezed
sealed class WeatherLocation with _$WeatherLocation {
  const factory WeatherLocation.device() = DeviceWeatherLocation;

  const factory WeatherLocation.place(WeatherPlace place) = PlaceWeatherLocation;
}
