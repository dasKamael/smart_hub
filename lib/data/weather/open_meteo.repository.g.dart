// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_meteo.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(openMeteoRepository)
final openMeteoRepositoryProvider = OpenMeteoRepositoryProvider._();

/// Providers

final class OpenMeteoRepositoryProvider
    extends $FunctionalProvider<OpenMeteoRepository, OpenMeteoRepository, OpenMeteoRepository>
    with $Provider<OpenMeteoRepository> {
  /// Providers
  OpenMeteoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openMeteoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openMeteoRepositoryHash();

  @$internal
  @override
  $ProviderElement<OpenMeteoRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  OpenMeteoRepository create(Ref ref) {
    return openMeteoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenMeteoRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<OpenMeteoRepository>(value));
  }
}

String _$openMeteoRepositoryHash() => r'100f514f56557976c92367bcc556b8a807b093bf';
