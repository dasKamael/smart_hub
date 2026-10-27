// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plants.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watering plan page: watering, undo and editing plants.

@ProviderFor(PlantsController)
final plantsControllerProvider = PlantsControllerProvider._();

/// Watering plan page: watering, undo and editing plants.
final class PlantsControllerProvider extends $NotifierProvider<PlantsController, PlantsPageState> {
  /// Watering plan page: watering, undo and editing plants.
  PlantsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantsControllerHash();

  @$internal
  @override
  PlantsController create() => PlantsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantsPageState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PlantsPageState>(value));
  }
}

String _$plantsControllerHash() => r'5cdb4ddc2ff77277128d08ccbdb32fb1264bd2d8';

/// Watering plan page: watering, undo and editing plants.

abstract class _$PlantsController extends $Notifier<PlantsPageState> {
  PlantsPageState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PlantsPageState, PlantsPageState>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<PlantsPageState, PlantsPageState>, PlantsPageState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// All plants with their state today, plus the plants per day of the coming week (today first).

@ProviderFor(wateringPlan)
final wateringPlanProvider = WateringPlanProvider._();

/// All plants with their state today, plus the plants per day of the coming week (today first).

final class WateringPlanProvider
    extends
        $FunctionalProvider<
          ({List<ScheduledPlant> all, List<List<ScheduledPlant>> week}),
          ({List<ScheduledPlant> all, List<List<ScheduledPlant>> week}),
          ({List<ScheduledPlant> all, List<List<ScheduledPlant>> week})
        >
    with $Provider<({List<ScheduledPlant> all, List<List<ScheduledPlant>> week})> {
  /// All plants with their state today, plus the plants per day of the coming week (today first).
  WateringPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wateringPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wateringPlanHash();

  @$internal
  @override
  $ProviderElement<({List<ScheduledPlant> all, List<List<ScheduledPlant>> week})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({List<ScheduledPlant> all, List<List<ScheduledPlant>> week}) create(Ref ref) {
    return wateringPlan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({List<ScheduledPlant> all, List<List<ScheduledPlant>> week}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({List<ScheduledPlant> all, List<List<ScheduledPlant>> week})>(value),
    );
  }
}

String _$wateringPlanHash() => r'3f1f93f114efecf83cf5ac0873460e056a6677ae';

/// The color of the plants area: overdue plants warm it towards terracotta, a watered home freshens it.

@ProviderFor(plantsTint)
final plantsTintProvider = PlantsTintProvider._();

/// The color of the plants area: overdue plants warm it towards terracotta, a watered home freshens it.

final class PlantsTintProvider extends $FunctionalProvider<Color, Color, Color> with $Provider<Color> {
  /// The color of the plants area: overdue plants warm it towards terracotta, a watered home freshens it.
  PlantsTintProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantsTintProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantsTintHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return plantsTint(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Color>(value));
  }
}

String _$plantsTintHash() => r'7d16b65377c83c9167a8bbb24912f99ec885aa95';
