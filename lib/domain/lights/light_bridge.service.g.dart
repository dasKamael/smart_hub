// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_bridge.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The light bridges the lights come from instead of Home Assistant; empty when none is paired.

@ProviderFor(LightBridgeService)
final lightBridgeServiceProvider = LightBridgeServiceProvider._();

/// The light bridges the lights come from instead of Home Assistant; empty when none is paired.
final class LightBridgeServiceProvider
    extends $AsyncNotifierProvider<LightBridgeService, List<LightBridge>> {
  /// The light bridges the lights come from instead of Home Assistant; empty when none is paired.
  LightBridgeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightBridgeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightBridgeServiceHash();

  @$internal
  @override
  LightBridgeService create() => LightBridgeService();
}

String _$lightBridgeServiceHash() =>
    r'58aa7691bc0b25b0968853f14df44ec6905b863e';

/// The light bridges the lights come from instead of Home Assistant; empty when none is paired.

abstract class _$LightBridgeService extends $AsyncNotifier<List<LightBridge>> {
  FutureOr<List<LightBridge>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LightBridge>>, List<LightBridge>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LightBridge>>, List<LightBridge>>,
              AsyncValue<List<LightBridge>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the hub has lights: from Home Assistant (or the demo home) or a light bridge.

@ProviderFor(hasLights)
final hasLightsProvider = HasLightsProvider._();

/// Whether the hub has lights: from Home Assistant (or the demo home) or a light bridge.

final class HasLightsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the hub has lights: from Home Assistant (or the demo home) or a light bridge.
  HasLightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasLightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasLightsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasLights(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasLightsHash() => r'58b5287e8d6a73198048baa5dff138c3001b6e27';

/// Whether the lights can be controlled right now: the bridge is reachable, or Home Assistant is online.

@ProviderFor(lightsOnline)
final lightsOnlineProvider = LightsOnlineProvider._();

/// Whether the lights can be controlled right now: the bridge is reachable, or Home Assistant is online.

final class LightsOnlineProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the lights can be controlled right now: the bridge is reachable, or Home Assistant is online.
  LightsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightsOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightsOnlineHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return lightsOnline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$lightsOnlineHash() => r'4bede5b0afeb325018940661a37a030a2ed17384';

@ProviderFor(_bridgeOnline)
final _bridgeOnlineProvider = _BridgeOnlineProvider._();

final class _BridgeOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  _BridgeOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_bridgeOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_bridgeOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return _bridgeOnline(ref);
  }
}

String _$_bridgeOnlineHash() => r'd7dae56b3dbe6ca7408ffc56a1ab4979c0af4fbe';
