import 'package:ha_client/ha_client.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

/// Lights are `light.*` entities in Home Assistant – any brand HA supports.
class HaLightRepository implements LightRepository {
  HaLightRepository({required this.session});

  final HaSessionRepository session;

  @override
  Stream<List<LightState>> watchLights() => session.watchDomain('light').map((states) => states.map(toLight).toList());

  @override
  Stream<bool> watchOnline() => session.watchStatus().map((status) => status.isOnline);

  @override
  Future<void> turnOn(List<String> ids, {int? brightnessPercent, RgbColor? color, int? kelvin}) {
    return session.callService(
      'light',
      'turn_on',
      entityIds: ids,
      data: {
        'brightness_pct': ?brightnessPercent,
        if (color != null) 'rgb_color': [color.red, color.green, color.blue],
        'color_temp_kelvin': ?kelvin,
      },
    );
  }

  @override
  Future<void> turnOff(List<String> ids) => session.callService('light', 'turn_off', entityIds: ids);

  static LightState toLight(HaEntityState state) {
    final attributes = state.attributes;
    final isOn = state.state == 'on';
    final modes = (attributes['supported_color_modes'] as List<Object?>? ?? const []).whereType<String>();
    final brightness = attributes['brightness'] as num?;
    final kelvin = (attributes['color_temp_kelvin'] as num?)?.round();
    final rgb = (attributes['rgb_color'] as List<Object?>?)?.whereType<num>().toList();
    final colorMode = attributes['color_mode'] as String?;
    final isWhiteMode = colorMode == 'color_temp' && kelvin != null;
    return LightState(
      id: state.entityId,
      name: (attributes['friendly_name'] as String?) ?? state.entityId,
      isOn: isOn,
      isAvailable: state.state != 'unavailable',
      brightnessPercent: isOn && brightness != null ? (brightness * 100 / 255).round().clamp(1, 100) : null,
      color: isOn && !isWhiteMode && rgb != null && rgb.length == 3
          ? RgbColor(rgb[0].round(), rgb[1].round(), rgb[2].round())
          : null,
      kelvin: isOn && isWhiteMode ? kelvin : null,
      minKelvin: (attributes['min_color_temp_kelvin'] as num?)?.round() ?? 2000,
      maxKelvin: (attributes['max_color_temp_kelvin'] as num?)?.round() ?? 6500,
      capabilities: capabilitiesOf(modes),
    );
  }

  static const _colorModes = {'hs', 'rgb', 'rgbw', 'rgbww', 'xy'};

  /// Maps HA's `supported_color_modes` to the controls the hub shows (`README` → "Capability model").
  static Set<LightCapability> capabilitiesOf(Iterable<String> modes) {
    final set = modes.toSet();
    return {
      // Every mode except plain on/off can be dimmed.
      if (set.any((mode) => mode != 'onoff' && mode != 'unknown')) LightCapability.brightness,
      if (set.contains('color_temp')) LightCapability.colorTemperature,
      if (set.any(_colorModes.contains)) LightCapability.color,
    };
  }
}
