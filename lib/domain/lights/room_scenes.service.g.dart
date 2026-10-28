// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_scenes.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The light scenes of every room: saved ones, or the templates until a room's scenes are changed. A room keeps at
/// least one and at most `SceneUtil.maxScenes` scenes.
///
/// This service is the only writer: it loads the scenes once and keeps them, so quick changes build on each other.

@ProviderFor(RoomScenesService)
final roomScenesServiceProvider = RoomScenesServiceProvider._();

/// The light scenes of every room: saved ones, or the templates until a room's scenes are changed. A room keeps at
/// least one and at most `SceneUtil.maxScenes` scenes.
///
/// This service is the only writer: it loads the scenes once and keeps them, so quick changes build on each other.
final class RoomScenesServiceProvider
    extends
        $AsyncNotifierProvider<
          RoomScenesService,
          Map<String, List<RoomScene>>
        > {
  /// The light scenes of every room: saved ones, or the templates until a room's scenes are changed. A room keeps at
  /// least one and at most `SceneUtil.maxScenes` scenes.
  ///
  /// This service is the only writer: it loads the scenes once and keeps them, so quick changes build on each other.
  RoomScenesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomScenesServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomScenesServiceHash();

  @$internal
  @override
  RoomScenesService create() => RoomScenesService();
}

String _$roomScenesServiceHash() => r'550a48faf888ada99277f3ed7a14d17fb154e880';

/// The light scenes of every room: saved ones, or the templates until a room's scenes are changed. A room keeps at
/// least one and at most `SceneUtil.maxScenes` scenes.
///
/// This service is the only writer: it loads the scenes once and keeps them, so quick changes build on each other.

abstract class _$RoomScenesService
    extends $AsyncNotifier<Map<String, List<RoomScene>>> {
  FutureOr<Map<String, List<RoomScene>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<String, List<RoomScene>>>,
              Map<String, List<RoomScene>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, List<RoomScene>>>,
                Map<String, List<RoomScene>>
              >,
              AsyncValue<Map<String, List<RoomScene>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
