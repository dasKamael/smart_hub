// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_photo.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(plantPhotoRepository)
final plantPhotoRepositoryProvider = PlantPhotoRepositoryProvider._();

/// Providers

final class PlantPhotoRepositoryProvider
    extends
        $FunctionalProvider<
          PlantPhotoRepository,
          PlantPhotoRepository,
          PlantPhotoRepository
        >
    with $Provider<PlantPhotoRepository> {
  /// Providers
  PlantPhotoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantPhotoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantPhotoRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantPhotoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlantPhotoRepository create(Ref ref) {
    return plantPhotoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantPhotoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantPhotoRepository>(value),
    );
  }
}

String _$plantPhotoRepositoryHash() =>
    r'8ea25b9d37c19ecc33e1025f19f180c2a28f4a65';
