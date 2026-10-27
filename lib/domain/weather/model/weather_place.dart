import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_place.freezed.dart';

/// A place the weather is for, e.g. "Mainz".
@freezed
abstract class WeatherPlace with _$WeatherPlace {
  const factory WeatherPlace({
    required double latitude,
    required double longitude,
    required String name,

    /// State or country, to tell places with the same name apart.
    String? region,
  }) = _WeatherPlace;
}
