// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(lightRepository)
final lightRepositoryProvider = LightRepositoryProvider._();

/// Providers

final class LightRepositoryProvider extends $FunctionalProvider<LightRepository, LightRepository, LightRepository>
    with $Provider<LightRepository> {
  /// Providers
  LightRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightRepositoryHash();

  @$internal
  @override
  $ProviderElement<LightRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  LightRepository create(Ref ref) {
    return lightRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LightRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<LightRepository>(value));
  }
}

String _$lightRepositoryHash() => r'391018332b50ff09b3cf3edee1b5d29ef1aa32de';
