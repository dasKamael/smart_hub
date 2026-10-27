// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_scene.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(roomSceneRepository)
final roomSceneRepositoryProvider = RoomSceneRepositoryProvider._();

/// Providers

final class RoomSceneRepositoryProvider
    extends $FunctionalProvider<RoomSceneRepository, RoomSceneRepository, RoomSceneRepository>
    with $Provider<RoomSceneRepository> {
  /// Providers
  RoomSceneRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomSceneRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomSceneRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoomSceneRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  RoomSceneRepository create(Ref ref) {
    return roomSceneRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomSceneRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RoomSceneRepository>(value));
  }
}

String _$roomSceneRepositoryHash() => r'219b436d2a632061c2fa88052cd8547bf7a60782';
