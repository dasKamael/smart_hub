// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_profile.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(plantProfileRepository)
final plantProfileRepositoryProvider = PlantProfileRepositoryProvider._();

/// Providers

final class PlantProfileRepositoryProvider
    extends $FunctionalProvider<PlantProfileRepository, PlantProfileRepository, PlantProfileRepository>
    with $Provider<PlantProfileRepository> {
  /// Providers
  PlantProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantProfileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantProfileRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  PlantProfileRepository create(Ref ref) {
    return plantProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantProfileRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PlantProfileRepository>(value));
  }
}

String _$plantProfileRepositoryHash() => r'b58a53110597742170e83021c04f799968354fe9';
