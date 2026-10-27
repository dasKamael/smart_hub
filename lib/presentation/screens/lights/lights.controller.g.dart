// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lights.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lights page: selected room and room wide commands.

@ProviderFor(LightsController)
final lightsControllerProvider = LightsControllerProvider._();

/// Lights page: selected room and room wide commands.
final class LightsControllerProvider extends $NotifierProvider<LightsController, LightsPageState> {
  /// Lights page: selected room and room wide commands.
  LightsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightsControllerHash();

  @$internal
  @override
  LightsController create() => LightsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LightsPageState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<LightsPageState>(value));
  }
}

String _$lightsControllerHash() => r'48bee49bfa93eba43b4362a32ade02641ed67d41';

/// Lights page: selected room and room wide commands.

abstract class _$LightsController extends $Notifier<LightsPageState> {
  LightsPageState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LightsPageState, LightsPageState>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<LightsPageState, LightsPageState>, LightsPageState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Lights grouped by the room they stand in on the floor plan, in plan order. Lights that are not placed come last.

@ProviderFor(lightRooms)
final lightRoomsProvider = LightRoomsProvider._();

/// Lights grouped by the room they stand in on the floor plan, in plan order. Lights that are not placed come last.

final class LightRoomsProvider extends $FunctionalProvider<List<LightRoom>, List<LightRoom>, List<LightRoom>>
    with $Provider<List<LightRoom>> {
  /// Lights grouped by the room they stand in on the floor plan, in plan order. Lights that are not placed come last.
  LightRoomsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightRoomsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightRoomsHash();

  @$internal
  @override
  $ProviderElement<List<LightRoom>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<LightRoom> create(Ref ref) {
    return lightRooms(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LightRoom> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<LightRoom>>(value));
  }
}

String _$lightRoomsHash() => r'3549fe53c84652c1a6e1bc4167bbf571f4afa2a0';

/// The color of the lights area: the colors of the rooms that are on; indigo when all are off.

@ProviderFor(lightsTint)
final lightsTintProvider = LightsTintProvider._();

/// The color of the lights area: the colors of the rooms that are on; indigo when all are off.

final class LightsTintProvider extends $FunctionalProvider<Color, Color, Color> with $Provider<Color> {
  /// The color of the lights area: the colors of the rooms that are on; indigo when all are off.
  LightsTintProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightsTintProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightsTintHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return lightsTint(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Color>(value));
  }
}

String _$lightsTintHash() => r'b51ca6ebf260d144824db71b39f507562661a5fb';
