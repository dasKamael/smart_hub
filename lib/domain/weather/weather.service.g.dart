// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where the weather is for: where the hub is (default) or a chosen place.

@ProviderFor(WeatherLocationService)
final weatherLocationServiceProvider = WeatherLocationServiceProvider._();

/// Where the weather is for: where the hub is (default) or a chosen place.
final class WeatherLocationServiceProvider extends $StreamNotifierProvider<WeatherLocationService, WeatherLocation> {
  /// Where the weather is for: where the hub is (default) or a chosen place.
  WeatherLocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherLocationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherLocationServiceHash();

  @$internal
  @override
  WeatherLocationService create() => WeatherLocationService();
}

String _$weatherLocationServiceHash() => r'bc5827d09941f87f7c7f0912d22be7b90d24280a';

/// Where the weather is for: where the hub is (default) or a chosen place.

abstract class _$WeatherLocationService extends $StreamNotifier<WeatherLocation> {
  Stream<WeatherLocation> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WeatherLocation>, WeatherLocation>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WeatherLocation>, WeatherLocation>,
              AsyncValue<WeatherLocation>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Places named like [query]; empty for short queries.

@ProviderFor(placeSearch)
final placeSearchProvider = PlaceSearchFamily._();

/// Places named like [query]; empty for short queries.

final class PlaceSearchProvider
    extends $FunctionalProvider<AsyncValue<List<WeatherPlace>>, List<WeatherPlace>, FutureOr<List<WeatherPlace>>>
    with $FutureModifier<List<WeatherPlace>>, $FutureProvider<List<WeatherPlace>> {
  /// Places named like [query]; empty for short queries.
  PlaceSearchProvider._({required PlaceSearchFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'placeSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeSearchHash();

  @override
  String toString() {
    return r'placeSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WeatherPlace>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeatherPlace>> create(Ref ref) {
    final argument = this.argument as String;
    return placeSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placeSearchHash() => r'987bbe0ffee960ccf56e06eec8bf06dfdfae8bae';

/// Places named like [query]; empty for short queries.

final class PlaceSearchFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<WeatherPlace>>, String> {
  PlaceSearchFamily._()
    : super(
        retry: null,
        name: r'placeSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Places named like [query]; empty for short queries.

  PlaceSearchProvider call(String query) => PlaceSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'placeSearchProvider';
}

/// The forecast for the [WeatherLocationService] location. Shows the last forecast at once after a start, then
/// loads a fresh one and again every [refreshInterval]. A failed refresh keeps the last forecast.

@ProviderFor(WeatherService)
final weatherServiceProvider = WeatherServiceProvider._();

/// The forecast for the [WeatherLocationService] location. Shows the last forecast at once after a start, then
/// loads a fresh one and again every [refreshInterval]. A failed refresh keeps the last forecast.
final class WeatherServiceProvider extends $AsyncNotifierProvider<WeatherService, Forecast> {
  /// The forecast for the [WeatherLocationService] location. Shows the last forecast at once after a start, then
  /// loads a fresh one and again every [refreshInterval]. A failed refresh keeps the last forecast.
  WeatherServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: _retryUnlessLocationUnavailable,
        name: r'weatherServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherServiceHash();

  @$internal
  @override
  WeatherService create() => WeatherService();
}

String _$weatherServiceHash() => r'a61ef64d7d542c7196493e36f05751efe0fc2821';

/// The forecast for the [WeatherLocationService] location. Shows the last forecast at once after a start, then
/// loads a fresh one and again every [refreshInterval]. A failed refresh keeps the last forecast.

abstract class _$WeatherService extends $AsyncNotifier<Forecast> {
  FutureOr<Forecast> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Forecast>, Forecast>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Forecast>, Forecast>,
              AsyncValue<Forecast>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
