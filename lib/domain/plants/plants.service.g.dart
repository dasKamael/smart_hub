// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plants.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All plants, sorted by name, and watering.

@ProviderFor(PlantsService)
final plantsServiceProvider = PlantsServiceProvider._();

/// All plants, sorted by name, and watering.
final class PlantsServiceProvider
    extends $StreamNotifierProvider<PlantsService, List<Plant>> {
  /// All plants, sorted by name, and watering.
  PlantsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantsServiceHash();

  @$internal
  @override
  PlantsService create() => PlantsService();
}

String _$plantsServiceHash() => r'e4b0030e90cf58c08c5a606780925c0b06e2c355';

/// All plants, sorted by name, and watering.

abstract class _$PlantsService extends $StreamNotifier<List<Plant>> {
  Stream<List<Plant>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Plant>>, List<Plant>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Plant>>, List<Plant>>,
              AsyncValue<List<Plant>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
