// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_name.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(placeNameRepository)
final placeNameRepositoryProvider = PlaceNameRepositoryProvider._();

/// Providers

final class PlaceNameRepositoryProvider
    extends $FunctionalProvider<PlaceNameRepository, PlaceNameRepository, PlaceNameRepository>
    with $Provider<PlaceNameRepository> {
  /// Providers
  PlaceNameRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeNameRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeNameRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlaceNameRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  PlaceNameRepository create(Ref ref) {
    return placeNameRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaceNameRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PlaceNameRepository>(value));
  }
}

String _$placeNameRepositoryHash() => r'9fcb1760491172f0b798df81ed999fbcc7f2decc';
