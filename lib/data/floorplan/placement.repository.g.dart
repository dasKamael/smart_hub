// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(placementRepository)
final placementRepositoryProvider = PlacementRepositoryProvider._();

/// Providers

final class PlacementRepositoryProvider
    extends $FunctionalProvider<PlacementRepository, PlacementRepository, PlacementRepository>
    with $Provider<PlacementRepository> {
  /// Providers
  PlacementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placementRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placementRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlacementRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  PlacementRepository create(Ref ref) {
    return placementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlacementRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PlacementRepository>(value));
  }
}

String _$placementRepositoryHash() => r'5ca4783c552a913388cb8b71010baea652ae96e4';
