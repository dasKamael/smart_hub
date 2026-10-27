import 'package:smart_hub/domain/lights/color_temperature.util.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_scene.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';

abstract final class SceneUtil {
  /// Scenes a room offers at most, so the list stays compact.
  static const maxScenes = 6;

  /// Differences up to these still count as the scene: lights report back rounded values.
  static const brightnessTolerance = 3;
  static const kelvinTolerance = 150;
  static const colorTolerance = 30;

  /// The scenes every room starts with.
  static List<RoomScene> templates(String roomId) => [
    for (final scene in LightScene.all)
      RoomScene(
        id: '$roomId/${scene.name.toLowerCase()}',
        roomId: roomId,
        name: scene.name,
        brightnessPercent: scene.brightnessPercent,
        color: scene.color,
        kelvin: scene.kelvin,
      ),
  ];

  /// What [light] does in [scene]: its saved setting, or the scene's base values – in both cases only what the light
  /// can do, e.g. the coolest white it has instead of a blue it cannot show.
  static SceneLight settingFor(LightState light, RoomScene scene) {
    final saved = scene.lights[light.id];
    if (saved != null && !saved.on) return const SceneLight(on: false);
    final brightness = saved?.brightnessPercent ?? scene.brightnessPercent;
    final caps = light.capabilities;
    final savedKelvin = saved?.kelvin;
    int kelvinOf(int kelvin) => kelvin.clamp(light.minKelvin, light.maxKelvin);
    // A saved white stays white where the light can; otherwise color lights take the color.
    if (savedKelvin != null && caps.contains(LightCapability.colorTemperature)) {
      return SceneLight(on: true, brightnessPercent: brightness, kelvin: kelvinOf(savedKelvin));
    }
    if (caps.contains(LightCapability.color)) {
      final color = saved?.color ?? (savedKelvin == null ? scene.color : ColorTemperatureUtil.toRgb(savedKelvin));
      return SceneLight(on: true, brightnessPercent: brightness, color: color);
    }
    if (caps.contains(LightCapability.colorTemperature)) {
      return SceneLight(on: true, brightnessPercent: brightness, kelvin: kelvinOf(scene.kelvin));
    }
    if (caps.contains(LightCapability.brightness)) return SceneLight(on: true, brightnessPercent: brightness);
    return const SceneLight(on: true);
  }

  /// Every light of the room shines as [scene] says.
  static bool isActive(List<LightState> lights, RoomScene scene) {
    return lights.isNotEmpty && lights.every((light) => _shows(light, settingFor(light, scene)));
  }

  static bool _shows(LightState light, SceneLight setting) {
    if (!setting.on) return !light.isOn;
    if (!light.isOn) return false;
    if (setting.brightnessPercent case final brightness? when light.capabilities.contains(LightCapability.brightness)) {
      if (((light.brightnessPercent ?? 100) - brightness).abs() > brightnessTolerance) return false;
    }
    if (setting.kelvin case final kelvin?) {
      return light.kelvin != null && (light.kelvin! - kelvin).abs() <= kelvinTolerance;
    }
    if (setting.color case final color?) {
      final shown = light.color;
      return shown != null && _near(shown, color);
    }
    return true;
  }

  static bool _near(RgbColor a, RgbColor b) =>
      (a.red - b.red).abs() <= colorTolerance &&
      (a.green - b.green).abs() <= colorTolerance &&
      (a.blue - b.blue).abs() <= colorTolerance;

  /// The color [scene] gives the room, for its dot: of the first light it turns on, as that light can show it.
  static RgbColor colorOf(List<LightState> lights, RoomScene scene) {
    for (final light in lights) {
      final setting = settingFor(light, scene);
      if (!setting.on) continue;
      if (setting.color case final color?) return color;
      if (setting.kelvin case final kelvin?) return ColorTemperatureUtil.toRgb(kelvin);
    }
    return scene.lights.isEmpty && lights.isEmpty ? scene.color : ColorTemperatureUtil.toRgb(2700);
  }

  /// A scene of how [lights] shine right now; lights added to the room later get its average.
  static RoomScene snapshot({
    required String id,
    required String roomId,
    required String name,
    required List<LightState> lights,
  }) {
    final on = [
      for (final light in lights)
        if (light.isOn) light,
    ];
    final brightness = on.isEmpty
        ? 100
        : (on.map((light) => light.brightnessPercent ?? 100).reduce((a, b) => a + b) / on.length).round();
    final kelvin = on.map((light) => light.kelvin).nonNulls.firstOrNull ?? 2700;
    return RoomScene(
      id: id,
      roomId: roomId,
      name: name,
      brightnessPercent: brightness,
      color: on.map((light) => light.color).nonNulls.firstOrNull ?? ColorTemperatureUtil.toRgb(kelvin),
      kelvin: kelvin,
      lights: {
        for (final light in lights)
          light.id: light.isOn
              ? SceneLight(
                  on: true,
                  brightnessPercent: light.brightnessPercent,
                  color: light.color,
                  kelvin: light.kelvin,
                )
              : const SceneLight(on: false),
      },
    );
  }
}
