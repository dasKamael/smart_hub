import 'dart:async';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/lights/hue/hue_bridge.repository.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/lights/model/light_bridge.dart';

part 'light_bridge.service.g.dart';

/// The light bridge the lights come from instead of Home Assistant; `null` when none is paired.
@Riverpod(keepAlive: true)
class LightBridgeService extends _$LightBridgeService {
  /// How long the bridge accepts pairing after its button was pressed, and how often it is asked meanwhile.
  static const pairingWindow = Duration(seconds: 60);
  static const pairingInterval = Duration(seconds: 2);

  @override
  Future<LightBridge?> build() => ref.watch(hueBridgeConfigProvider.future);

  /// Addresses of the bridges in the home network.
  Future<List<String>> discover() => ref.read(hueBridgeRepositoryProvider).discover();

  /// Waits until the button of the bridge at [host] is pressed, then keeps it as the light source. Returns `false`
  /// when the button was not pressed within [pairingWindow] or [isCancelled] says to stop.
  Future<bool> pair(String host, {bool Function()? isCancelled}) async {
    final repository = ref.read(hueBridgeRepositoryProvider);
    final until = clock.now().add(pairingWindow);
    while (clock.now().isBefore(until) && !(isCancelled?.call() ?? false)) {
      try {
        final bridge = await repository.pair(host);
        await ref.read(hueBridgeConfigProvider.notifier).set(bridge);
        return true;
      } on BridgeButtonNotPressedException {
        await Future<void>.delayed(pairingInterval);
      }
    }
    return false;
  }

  Future<void> disconnect() => ref.read(hueBridgeConfigProvider.notifier).set(null);
}

/// Whether the hub has lights: from Home Assistant (or the demo home) or a light bridge.
@riverpod
bool hasLights(Ref ref) => ref.watch(hasHomeAssistantProvider) || ref.watch(lightBridgeServiceProvider).value != null;

/// Whether the lights can be controlled right now: the bridge is reachable, or Home Assistant is online.
@riverpod
bool lightsOnline(Ref ref) {
  if (ref.watch(lightBridgeServiceProvider).value == null) {
    return ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false;
  }
  return ref.watch(_bridgeOnlineProvider).value ?? false;
}

@riverpod
Stream<bool> _bridgeOnline(Ref ref) => ref.watch(lightRepositoryProvider).watchOnline();
