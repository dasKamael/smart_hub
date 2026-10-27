import 'dart:async';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/lights/hue/hue_bridge.repository.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/lights/model/light_bridge.dart';

part 'light_bridge.service.g.dart';

/// The light bridges the lights come from instead of Home Assistant; empty when none is paired.
@Riverpod(keepAlive: true)
class LightBridgeService extends _$LightBridgeService {
  /// How long the bridge accepts pairing after its button was pressed, and how often it is asked meanwhile.
  static const pairingWindow = Duration(seconds: 60);
  static const pairingInterval = Duration(seconds: 2);

  @override
  Future<List<LightBridge>> build() => ref.watch(hueBridgeConfigProvider.future);

  /// Addresses of the bridges in the home network.
  Future<List<String>> discover() => ref.read(hueBridgeRepositoryProvider).discover();

  /// Waits until the button of the bridge at [host] is pressed, then adds it to the light sources. Returns `false`
  /// when the button was not pressed within [pairingWindow] or [isCancelled] says to stop.
  Future<bool> pair(String host, {bool Function()? isCancelled}) async {
    final repository = ref.read(hueBridgeRepositoryProvider);
    final until = clock.now().add(pairingWindow);
    while (clock.now().isBefore(until) && !(isCancelled?.call() ?? false)) {
      try {
        final bridge = await repository.pair(host);
        final others = [
          for (final other in await future)
            if (other.host != host) other,
        ];
        await ref.read(hueBridgeConfigProvider.notifier).set([...others, bridge]);
        return true;
      } on BridgeButtonNotPressedException {
        await Future<void>.delayed(pairingInterval);
      }
    }
    return false;
  }

  /// Forgets the bridge at [host]; its lights are gone from the hub.
  Future<void> disconnect(String host) async {
    await ref.read(hueBridgeConfigProvider.notifier).set([
      for (final bridge in await future)
        if (bridge.host != host) bridge,
    ]);
  }
}

/// Whether the hub has lights: from Home Assistant (or the demo home) or a light bridge.
@riverpod
bool hasLights(Ref ref) =>
    ref.watch(hasHomeAssistantProvider) || (ref.watch(lightBridgeServiceProvider).value?.isNotEmpty ?? false);

/// Whether the lights can be controlled right now: the bridge is reachable, or Home Assistant is online.
@riverpod
bool lightsOnline(Ref ref) {
  if (ref.watch(lightBridgeServiceProvider).value?.isEmpty ?? true) {
    return ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false;
  }
  return ref.watch(_bridgeOnlineProvider).value ?? false;
}

@riverpod
Stream<bool> _bridgeOnline(Ref ref) => ref.watch(lightRepositoryProvider).watchOnline();
