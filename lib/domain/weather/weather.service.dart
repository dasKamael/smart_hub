import 'dart:async';

import 'package:clock/clock.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/weather/device_location.repository.dart';
import 'package:smart_hub/data/weather/open_meteo.repository.dart';
import 'package:smart_hub/data/weather/place_name.repository.dart';
import 'package:smart_hub/data/weather/weather_settings.repository.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/model/weather_location.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';

part 'weather.service.g.dart';

/// The hub's position is unknown (location off or not allowed) and no place is chosen.
class WeatherLocationUnavailableException implements Exception {
  const WeatherLocationUnavailableException();

  @override
  String toString() => 'Location not available';
}

/// Where the weather is for: where the hub is (default) or a chosen place.
@Riverpod(keepAlive: true)
class WeatherLocationService extends _$WeatherLocationService {
  @override
  Stream<WeatherLocation> build() => ref.watch(weatherSettingsRepositoryProvider).watchLocation();

  Future<void> set(WeatherLocation location) => ref.read(weatherSettingsRepositoryProvider).setLocation(location);
}

/// Places named like [query]; empty for short queries.
@riverpod
Future<List<WeatherPlace>> placeSearch(Ref ref, String query) async {
  final text = query.trim();
  if (text.length < 2) return const [];
  return ref.watch(openMeteoRepositoryProvider).search(text);
}

/// An unknown location is not retried right away – it needs the user (or the next refresh); network errors are.
Duration? _retryUnlessLocationUnavailable(int retryCount, Object error) {
  if (error is WeatherLocationUnavailableException) return null;
  return Duration(seconds: 1 << retryCount.clamp(0, 6));
}

/// The forecast for the [WeatherLocationService] location. Shows the last forecast at once after a start, then
/// loads a fresh one and again every [refreshInterval]. A failed refresh keeps the last forecast.
@Riverpod(keepAlive: true, retry: _retryUnlessLocationUnavailable)
class WeatherService extends _$WeatherService {
  static final _log = Logger('WeatherService');
  static const refreshInterval = Duration(minutes: 30);

  /// A position within this many degrees (about 5 km) keeps the name found before.
  static const _sameTown = 0.05;

  @override
  Future<Forecast> build() async {
    final location = await ref.watch(weatherLocationServiceProvider.future);
    final timer = Timer.periodic(refreshInterval, (_) => unawaited(refresh()));
    ref.onDispose(timer.cancel);

    final cached = await ref.read(weatherSettingsRepositoryProvider).cached();
    if (cached != null && _fits(cached.place, location)) {
      Future(() async {
        if (ref.mounted) await refresh();
      }).ignore();
      return _forecastOf(cached);
    }
    return _load(location, cached);
  }

  /// Loads a fresh forecast; on failure the shown one stays.
  Future<void> refresh() async {
    final location = ref.read(weatherLocationServiceProvider).value;
    if (location == null) return;
    try {
      final forecast = await _load(location, await ref.read(weatherSettingsRepositoryProvider).cached());
      if (ref.mounted) state = AsyncData(forecast);
    } on Object catch (e, stackTrace) {
      _log.warning('Could not load the weather: $e');
      if (ref.mounted && !state.hasValue) state = AsyncError(e, stackTrace);
    }
  }

  Future<Forecast> _load(WeatherLocation location, CachedForecast? cached) async {
    final place = switch (location) {
      PlaceWeatherLocation(:final place) => place,
      DeviceWeatherLocation() => await _devicePlace(cached),
    };
    final json = await ref.read(openMeteoRepositoryProvider).forecastJson(place.latitude, place.longitude);
    final fresh = (json: json, place: place, at: clock.now());
    final forecast = _forecastOf(fresh);
    await ref.read(weatherSettingsRepositoryProvider).saveCache(fresh);
    return forecast;
  }

  /// Where the hub is, named after its town. Without a position the last one is used, if any.
  Future<WeatherPlace> _devicePlace(CachedForecast? cached) async {
    final position = await ref.read(deviceLocationRepositoryProvider).current();
    if (position == null) {
      if (cached != null) return cached.place;
      throw const WeatherLocationUnavailableException();
    }
    final known = cached?.place;
    if (known != null &&
        known.name.isNotEmpty &&
        (known.latitude - position.latitude).abs() < _sameTown &&
        (known.longitude - position.longitude).abs() < _sameTown) {
      return known.copyWith(latitude: position.latitude, longitude: position.longitude);
    }
    String? name;
    try {
      name = await ref.read(placeNameRepositoryProvider).nameAt(position.latitude, position.longitude);
    } on Object catch (e) {
      _log.info('No place name: $e');
    }
    return WeatherPlace(latitude: position.latitude, longitude: position.longitude, name: name ?? 'Here');
  }

  static bool _fits(WeatherPlace cached, WeatherLocation location) {
    return switch (location) {
      DeviceWeatherLocation() => true,
      PlaceWeatherLocation(:final place) =>
        (cached.latitude - place.latitude).abs() < 0.001 && (cached.longitude - place.longitude).abs() < 0.001,
    };
  }

  static Forecast _forecastOf(CachedForecast cached) {
    final parsed = OpenMeteoRepository.parse(cached.json);
    // A cached forecast may be hours old: start the hours at the current one.
    final now = clock.now();
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);
    final today = DateTime(now.year, now.month, now.day);
    return Forecast(
      place: cached.place,
      now: parsed.now,
      hours: [
        for (final hour in parsed.hours)
          if (!hour.time.isBefore(currentHour)) hour,
      ],
      days: [
        for (final day in parsed.days)
          if (!day.date.isBefore(today)) day,
      ],
      fetchedAt: cached.at,
    );
  }
}
