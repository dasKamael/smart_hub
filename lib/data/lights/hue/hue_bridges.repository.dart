import 'dart:async';

import 'package:smart_hub/data/lights/hue/hue_light.repository.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

/// The lights of several bridges as one: their lists side by side, and each command sent to the bridge that owns
/// the light.
class HueBridgesRepository implements LightRepository {
  HueBridgesRepository(this.bridges);

  final List<HueLightRepository> bridges;

  /// Which bridge reported which light id last.
  final _owners = <String, HueLightRepository>{};

  @override
  Stream<List<LightState>> watchLights() {
    final latest = <HueLightRepository, List<LightState>>{};
    late final StreamController<List<LightState>> controller;
    final subscriptions = <StreamSubscription<List<LightState>>>[];
    controller = StreamController<List<LightState>>(
      onListen: () {
        for (final bridge in bridges) {
          subscriptions.add(
            bridge.watchLights().listen((lights) {
              latest[bridge] = lights;
              for (final light in lights) {
                _owners[light.id] = bridge;
              }
              controller.add([for (final bridge in bridges) ...?latest[bridge]]);
            }, onError: controller.addError),
          );
        }
      },
      onCancel: () => Future.wait([for (final subscription in subscriptions) subscription.cancel()]),
    );
    return controller.stream;
  }

  /// Online while any bridge is reachable.
  @override
  Stream<bool> watchOnline() {
    final online = <HueLightRepository, bool>{};
    late final StreamController<bool> controller;
    final subscriptions = <StreamSubscription<bool>>[];
    controller = StreamController<bool>(
      onListen: () {
        for (final bridge in bridges) {
          subscriptions.add(
            bridge.watchOnline().listen((value) {
              online[bridge] = value;
              controller.add(online.values.any((value) => value));
            }),
          );
        }
      },
      onCancel: () => Future.wait([for (final subscription in subscriptions) subscription.cancel()]),
    );
    return controller.stream.distinct();
  }

  @override
  Future<void> turnOn(List<String> ids, {int? brightnessPercent, RgbColor? color, int? kelvin}) {
    return Future.wait([
      for (final MapEntry(key: bridge, value: owned) in _byBridge(ids).entries)
        bridge.turnOn(owned, brightnessPercent: brightnessPercent, color: color, kelvin: kelvin),
    ]);
  }

  @override
  Future<void> turnOff(List<String> ids) {
    return Future.wait([
      for (final MapEntry(key: bridge, value: owned) in _byBridge(ids).entries) bridge.turnOff(owned),
    ]);
  }

  void dispose() {
    for (final bridge in bridges) {
      bridge.dispose();
    }
  }

  Map<HueLightRepository, List<String>> _byBridge(List<String> ids) {
    final byBridge = <HueLightRepository, List<String>>{};
    for (final id in ids) {
      if (_owners[id] case final bridge?) byBridge.putIfAbsent(bridge, () => []).add(id);
    }
    return byBridge;
  }
}
