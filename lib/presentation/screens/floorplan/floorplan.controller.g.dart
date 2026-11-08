// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floorplan.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// UI state of the floor plan (selection, visible layers) and the device commands of the inspector.

@ProviderFor(FloorplanController)
final floorplanControllerProvider = FloorplanControllerProvider._();

/// UI state of the floor plan (selection, visible layers) and the device commands of the inspector.
final class FloorplanControllerProvider
    extends $NotifierProvider<FloorplanController, FloorplanState> {
  /// UI state of the floor plan (selection, visible layers) and the device commands of the inspector.
  FloorplanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'floorplanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$floorplanControllerHash();

  @$internal
  @override
  FloorplanController create() => FloorplanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FloorplanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FloorplanState>(value),
    );
  }
}

String _$floorplanControllerHash() =>
    r'08daeeb66bad411f84431623881fbb3ff9288ea9';

/// UI state of the floor plan (selection, visible layers) and the device commands of the inspector.

abstract class _$FloorplanController extends $Notifier<FloorplanState> {
  FloorplanState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FloorplanState, FloorplanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FloorplanState, FloorplanState>,
              FloorplanState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The apartment in 3D: walls, floors and furniture of the drawn layout.

@ProviderFor(homeScene)
final homeSceneProvider = HomeSceneProvider._();

/// The apartment in 3D: walls, floors and furniture of the drawn layout.

final class HomeSceneProvider
    extends $FunctionalProvider<HomeScene?, HomeScene?, HomeScene?>
    with $Provider<HomeScene?> {
  /// The apartment in 3D: walls, floors and furniture of the drawn layout.
  HomeSceneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSceneProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSceneHash();

  @$internal
  @override
  $ProviderElement<HomeScene?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeScene? create(Ref ref) {
    return homeScene(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeScene? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeScene?>(value),
    );
  }
}

String _$homeSceneHash() => r'31ee583b47d9344286269209b71ed13b8b29a156';

/// Placed lamps that are on, shining into the 3D apartment.

@ProviderFor(sceneLights)
final sceneLightsProvider = SceneLightsProvider._();

/// Placed lamps that are on, shining into the 3D apartment.

final class SceneLightsProvider
    extends
        $FunctionalProvider<
          List<SceneLight>,
          List<SceneLight>,
          List<SceneLight>
        >
    with $Provider<List<SceneLight>> {
  /// Placed lamps that are on, shining into the 3D apartment.
  SceneLightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sceneLightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sceneLightsHash();

  @$internal
  @override
  $ProviderElement<List<SceneLight>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SceneLight> create(Ref ref) {
    return sceneLights(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SceneLight> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SceneLight>>(value),
    );
  }
}

String _$sceneLightsHash() => r'c110f01ab79e44fa9d4491642644a21f5210912d';

/// Every device the hub knows, joined with its placement (or the position it was just dropped at).

@ProviderFor(planDevices)
final planDevicesProvider = PlanDevicesProvider._();

/// Every device the hub knows, joined with its placement (or the position it was just dropped at).

final class PlanDevicesProvider
    extends
        $FunctionalProvider<
          List<PlanDevice>,
          List<PlanDevice>,
          List<PlanDevice>
        >
    with $Provider<List<PlanDevice>> {
  /// Every device the hub knows, joined with its placement (or the position it was just dropped at).
  PlanDevicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planDevicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planDevicesHash();

  @$internal
  @override
  $ProviderElement<List<PlanDevice>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<PlanDevice> create(Ref ref) {
    return planDevices(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PlanDevice> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PlanDevice>>(value),
    );
  }
}

String _$planDevicesHash() => r'42b22f16067249546876e4bf3e94e407db3485c4';

/// Groups of visible placed devices that stand close together. The dragged device never belongs to a group.

@ProviderFor(planGroups)
final planGroupsProvider = PlanGroupsProvider._();

/// Groups of visible placed devices that stand close together. The dragged device never belongs to a group.

final class PlanGroupsProvider
    extends
        $FunctionalProvider<
          List<List<String>>,
          List<List<String>>,
          List<List<String>>
        >
    with $Provider<List<List<String>>> {
  /// Groups of visible placed devices that stand close together. The dragged device never belongs to a group.
  PlanGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planGroupsHash();

  @$internal
  @override
  $ProviderElement<List<List<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<List<String>> create(Ref ref) {
    return planGroups(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<String>>>(value),
    );
  }
}

String _$planGroupsHash() => r'2b090e872c4f17b37eae7fc98f7b5d9d7d34e08c';
