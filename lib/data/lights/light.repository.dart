import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/data/lights/ha_light.repository.dart';
import 'package:smart_hub/data/lights/hue/hue_bridge.repository.dart';
import 'package:smart_hub/data/lights/hue/hue_light.repository.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

part 'light.repository.g.dart';

/// Where the lights come from: Home Assistant, or a light bridge in the home network directly.
abstract interface class LightRepository {
  Stream<List<LightState>> watchLights();

  /// Whether the lights can be controlled right now.
  Stream<bool> watchOnline();

  /// Turns [ids] on. Only the given values change; the light keeps the others.
  Future<void> turnOn(List<String> ids, {int? brightnessPercent, RgbColor? color, int? kelvin});

  Future<void> turnOff(List<String> ids);
}

/// Providers
/// A paired bridge provides the lights; otherwise Home Assistant does.
@Riverpod(keepAlive: true)
LightRepository lightRepository(Ref ref) {
  final bridge = ref.watch(hueBridgeConfigProvider).value;
  if (bridge == null) return HaLightRepository(session: ref.watch(haSessionRepositoryProvider));
  final repository = HueLightRepository(host: bridge.host, appKey: bridge.appKey, client: hueClientFor(bridge.host));
  ref.onDispose(repository.dispose);
  return repository;
}
