// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_bridge.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The light bridge the lights come from instead of Home Assistant; `null` when none is paired.

@ProviderFor(LightBridgeService)
final lightBridgeServiceProvider = LightBridgeServiceProvider._();

/// The light bridge the lights come from instead of Home Assistant; `null` when none is paired.
final class LightBridgeServiceProvider extends $AsyncNotifierProvider<LightBridgeService, LightBridge?> {
  /// The light bridge the lights come from instead of Home Assistant; `null` when none is paired.
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

String _$lightBridgeServiceHash() => r'54df1f6418a5b8675c97ac2b0f0df98ef4a1b5e2';

/// The light bridge the lights come from instead of Home Assistant; `null` when none is paired.

abstract class _$LightBridgeService extends $AsyncNotifier<LightBridge?> {
  FutureOr<LightBridge?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LightBridge?>, LightBridge?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LightBridge?>, LightBridge?>,
              AsyncValue<LightBridge?>,
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

final class HasLightsProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
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
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasLights(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$hasLightsHash() => r'c65d96f16d0c91e94e84d42a70c722eb10f3c2d2';

/// Whether the lights can be controlled right now: the bridge is reachable, or Home Assistant is online.

@ProviderFor(lightsOnline)
final lightsOnlineProvider = LightsOnlineProvider._();

/// Whether the lights can be controlled right now: the bridge is reachable, or Home Assistant is online.

final class LightsOnlineProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
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
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return lightsOnline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$lightsOnlineHash() => r'fa67a6fac19c6fa716117dbed780f12955eac577';

@ProviderFor(_bridgeOnline)
final _bridgeOnlineProvider = _BridgeOnlineProvider._();

final class _BridgeOnlineProvider extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
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
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return _bridgeOnline(ref);
  }
}

String _$_bridgeOnlineHash() => r'd7dae56b3dbe6ca7408ffc56a1ab4979c0af4fbe';
