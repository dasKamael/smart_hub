// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(plantRepository)
final plantRepositoryProvider = PlantRepositoryProvider._();

/// Providers

final class PlantRepositoryProvider
    extends
        $FunctionalProvider<PlantRepository, PlantRepository, PlantRepository>
    with $Provider<PlantRepository> {
  /// Providers
  PlantRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlantRepository create(Ref ref) {
    return plantRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantRepository>(value),
    );
  }
}

String _$plantRepositoryHash() => r'e705e443383318e54020668157a7c2466953b709';
