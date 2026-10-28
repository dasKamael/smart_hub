// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_settings.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(weatherSettingsRepository)
final weatherSettingsRepositoryProvider = WeatherSettingsRepositoryProvider._();

/// Providers

final class WeatherSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherSettingsRepository,
          WeatherSettingsRepository,
          WeatherSettingsRepository
        >
    with $Provider<WeatherSettingsRepository> {
  /// Providers
  WeatherSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherSettingsRepository create(Ref ref) {
    return weatherSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherSettingsRepository>(value),
    );
  }
}

String _$weatherSettingsRepositoryHash() =>
    r'bbfc316253a189ad34822382467a53d9ec8efe50';
