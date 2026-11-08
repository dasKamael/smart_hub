// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'furniture_meshes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The furniture models, loaded from the app's assets once.

@ProviderFor(furnitureMeshes)
final furnitureMeshesProvider = FurnitureMeshesProvider._();

/// The furniture models, loaded from the app's assets once.

final class FurnitureMeshesProvider
    extends
        $FunctionalProvider<
          AsyncValue<FurnitureMeshLibrary>,
          FurnitureMeshLibrary,
          FutureOr<FurnitureMeshLibrary>
        >
    with
        $FutureModifier<FurnitureMeshLibrary>,
        $FutureProvider<FurnitureMeshLibrary> {
  /// The furniture models, loaded from the app's assets once.
  FurnitureMeshesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'furnitureMeshesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$furnitureMeshesHash();

  @$internal
  @override
  $FutureProviderElement<FurnitureMeshLibrary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FurnitureMeshLibrary> create(Ref ref) {
    return furnitureMeshes(ref);
  }
}

String _$furnitureMeshesHash() => r'31553e65ba699e090a7da6dd295e56caa7f6da8f';
