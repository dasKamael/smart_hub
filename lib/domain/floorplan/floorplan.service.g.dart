// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floorplan.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(floorPlanService)
final floorPlanServiceProvider = FloorPlanServiceProvider._();

final class FloorPlanServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<FloorPlan>,
          FloorPlan,
          FutureOr<FloorPlan>
        >
    with $FutureModifier<FloorPlan>, $FutureProvider<FloorPlan> {
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

String _$floorPlanServiceHash() => r'44fb965431fbdbf766675b1334d8247c12752128';

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
