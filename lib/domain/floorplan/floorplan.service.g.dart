// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floorplan.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The apartment as drawn: walls, openings, rooms and furniture. A plan still in the first format (room outlines) is
/// turned into walls once and stored that way.

@ProviderFor(HomeLayoutService)
final homeLayoutServiceProvider = HomeLayoutServiceProvider._();

/// The apartment as drawn: walls, openings, rooms and furniture. A plan still in the first format (room outlines) is
/// turned into walls once and stored that way.
final class HomeLayoutServiceProvider
    extends $AsyncNotifierProvider<HomeLayoutService, HomeLayout> {
  /// The apartment as drawn: walls, openings, rooms and furniture. A plan still in the first format (room outlines) is
  /// turned into walls once and stored that way.
  HomeLayoutServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLayoutServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLayoutServiceHash();

  @$internal
  @override
  HomeLayoutService create() => HomeLayoutService();
}

String _$homeLayoutServiceHash() => r'abd7963700b2a034095f2ff5c343d4b57a6b05cd';

/// The apartment as drawn: walls, openings, rooms and furniture. A plan still in the first format (room outlines) is
/// turned into walls once and stored that way.

abstract class _$HomeLayoutService extends $AsyncNotifier<HomeLayout> {
  FutureOr<HomeLayout> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeLayout>, HomeLayout>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeLayout>, HomeLayout>,
              AsyncValue<HomeLayout>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The floor plan the app shows: room outlines and door segments, derived from the drawn layout.

@ProviderFor(floorPlanService)
final floorPlanServiceProvider = FloorPlanServiceProvider._();

/// The floor plan the app shows: room outlines and door segments, derived from the drawn layout.

final class FloorPlanServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<FloorPlan>,
          FloorPlan,
          FutureOr<FloorPlan>
        >
    with $FutureModifier<FloorPlan>, $FutureProvider<FloorPlan> {
  /// The floor plan the app shows: room outlines and door segments, derived from the drawn layout.
  FloorPlanServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'floorPlanServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$floorPlanServiceHash();

  @$internal
  @override
  $FutureProviderElement<FloorPlan> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<FloorPlan> create(Ref ref) {
    return floorPlanService(ref);
  }
}

String _$floorPlanServiceHash() => r'5e45aa712b542fce99e54cd752928a408aed1007';

/// Placed devices, live from the database.

@ProviderFor(PlacementService)
final placementServiceProvider = PlacementServiceProvider._();

/// Placed devices, live from the database.
final class PlacementServiceProvider
    extends $StreamNotifierProvider<PlacementService, List<Placement>> {
  /// Placed devices, live from the database.
  PlacementServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placementServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placementServiceHash();

  @$internal
  @override
  PlacementService create() => PlacementService();
}

String _$placementServiceHash() => r'e6aca409c290d05a2631c672cc18d9ad70e5f36b';

/// Placed devices, live from the database.

abstract class _$PlacementService extends $StreamNotifier<List<Placement>> {
  Stream<List<Placement>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Placement>>, List<Placement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Placement>>, List<Placement>>,
              AsyncValue<List<Placement>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
