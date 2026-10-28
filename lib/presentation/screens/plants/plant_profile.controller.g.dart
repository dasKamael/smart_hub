// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_profile.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Profile page of one plant: linking with the plant database and taking over its suggestions. The state says
/// whether the plant database is being asked.

@ProviderFor(PlantProfileController)
final plantProfileControllerProvider = PlantProfileControllerFamily._();

/// Profile page of one plant: linking with the plant database and taking over its suggestions. The state says
/// whether the plant database is being asked.
final class PlantProfileControllerProvider
    extends $NotifierProvider<PlantProfileController, bool> {
  /// Profile page of one plant: linking with the plant database and taking over its suggestions. The state says
  /// whether the plant database is being asked.
  PlantProfileControllerProvider._({
    required PlantProfileControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'plantProfileControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantProfileControllerHash();

  @override
  String toString() {
    return r'plantProfileControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlantProfileController create() => PlantProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlantProfileControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantProfileControllerHash() =>
    r'7f5e4cd2c9f751c764933fe91bc1f6d877ff8aae';

/// Profile page of one plant: linking with the plant database and taking over its suggestions. The state says
/// whether the plant database is being asked.

final class PlantProfileControllerFamily extends $Family
    with
        $ClassFamilyOverride<PlantProfileController, bool, bool, bool, String> {
  PlantProfileControllerFamily._()
    : super(
        retry: null,
        name: r'plantProfileControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Profile page of one plant: linking with the plant database and taking over its suggestions. The state says
  /// whether the plant database is being asked.

  PlantProfileControllerProvider call(String plantId) =>
      PlantProfileControllerProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantProfileControllerProvider';
}

/// Profile page of one plant: linking with the plant database and taking over its suggestions. The state says
/// whether the plant database is being asked.

abstract class _$PlantProfileController extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get plantId => _$args;

  bool build(String plantId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
