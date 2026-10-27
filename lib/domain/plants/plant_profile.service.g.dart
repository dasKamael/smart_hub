// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_profile.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether plants can be linked with the plant database (needs an API key in the build).

@ProviderFor(plantDatabaseAvailable)
final plantDatabaseAvailableProvider = PlantDatabaseAvailableProvider._();

/// Whether plants can be linked with the plant database (needs an API key in the build).

final class PlantDatabaseAvailableProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether plants can be linked with the plant database (needs an API key in the build).
  PlantDatabaseAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantDatabaseAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantDatabaseAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return plantDatabaseAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$plantDatabaseAvailableHash() => r'44e61cbfa27e9859f0991411b80bc9347330c371';

/// The profile of [plantId]; `null` while the plant is not linked with a species.

@ProviderFor(plantProfile)
final plantProfileProvider = PlantProfileFamily._();

/// The profile of [plantId]; `null` while the plant is not linked with a species.

final class PlantProfileProvider
    extends $FunctionalProvider<AsyncValue<PlantProfile?>, PlantProfile?, Stream<PlantProfile?>>
    with $FutureModifier<PlantProfile?>, $StreamProvider<PlantProfile?> {
  /// The profile of [plantId]; `null` while the plant is not linked with a species.
  PlantProfileProvider._({required PlantProfileFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'plantProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantProfileHash();

  @override
  String toString() {
    return r'plantProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<PlantProfile?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<PlantProfile?> create(Ref ref) {
    final argument = this.argument as String;
    return plantProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantProfileHash() => r'6a42e15d8012590f719c71500f70c0137b4726f9';

/// The profile of [plantId]; `null` while the plant is not linked with a species.

final class PlantProfileFamily extends $Family with $FunctionalFamilyOverride<Stream<PlantProfile?>, String> {
  PlantProfileFamily._()
    : super(
        retry: null,
        name: r'plantProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The profile of [plantId]; `null` while the plant is not linked with a species.

  PlantProfileProvider call(String plantId) => PlantProfileProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantProfileProvider';
}

/// Species matching [query] in the plant database; empty for short queries or without the database.

@ProviderFor(speciesSearch)
final speciesSearchProvider = SpeciesSearchFamily._();

/// Species matching [query] in the plant database; empty for short queries or without the database.

final class SpeciesSearchProvider
    extends $FunctionalProvider<AsyncValue<List<SpeciesMatch>>, List<SpeciesMatch>, FutureOr<List<SpeciesMatch>>>
    with $FutureModifier<List<SpeciesMatch>>, $FutureProvider<List<SpeciesMatch>> {
  /// Species matching [query] in the plant database; empty for short queries or without the database.
  SpeciesSearchProvider._({required SpeciesSearchFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'speciesSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speciesSearchHash();

  @override
  String toString() {
    return r'speciesSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SpeciesMatch>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<SpeciesMatch>> create(Ref ref) {
    final argument = this.argument as String;
    return speciesSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpeciesSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speciesSearchHash() => r'c6e3b58363b67d272bb5c85ffb95eb4cc285ecd5';

/// Species matching [query] in the plant database; empty for short queries or without the database.

final class SpeciesSearchFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<SpeciesMatch>>, String> {
  SpeciesSearchFamily._()
    : super(
        retry: null,
        name: r'speciesSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Species matching [query] in the plant database; empty for short queries or without the database.

  SpeciesSearchProvider call(String query) => SpeciesSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'speciesSearchProvider';
}

/// Links plants with species of the plant database. Profiles are stored with the plant, and a species another plant
/// already has is copied instead of loaded again.

@ProviderFor(PlantProfileService)
final plantProfileServiceProvider = PlantProfileServiceProvider._();

/// Links plants with species of the plant database. Profiles are stored with the plant, and a species another plant
/// already has is copied instead of loaded again.
final class PlantProfileServiceProvider extends $NotifierProvider<PlantProfileService, void> {
  /// Links plants with species of the plant database. Profiles are stored with the plant, and a species another plant
  /// already has is copied instead of loaded again.
  PlantProfileServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantProfileServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantProfileServiceHash();

  @$internal
  @override
  PlantProfileService create() => PlantProfileService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$plantProfileServiceHash() => r'3ec3117b93180803e88bd45b417e4b2c1123e50d';

/// Links plants with species of the plant database. Profiles are stored with the plant, and a species another plant
/// already has is copied instead of loaded again.

abstract class _$PlantProfileService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
