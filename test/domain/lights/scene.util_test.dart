import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/lights/color_temperature.util.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';
import 'package:smart_hub/domain/lights/scene.util.dart';

void main() {
  group('SceneUtil', () {
    final focus = SceneUtil.templates('hall').firstWhere((scene) => scene.name == 'Focus');
    const white = {LightCapability.brightness, LightCapability.colorTemperature};
    const color = {LightCapability.brightness, LightCapability.color};

    LightState lamp({
      String id = 'light.a',
      Set<LightCapability> caps = white,
      bool on = true,
      int? brightness,
      int? kelvin,
      RgbColor? rgb,
      int maxKelvin = 6500,
    }) => LightState(
      id: id,
      name: id,
      isOn: on,
      brightnessPercent: brightness,
      kelvin: kelvin,
      color: rgb,
      maxKelvin: maxKelvin,
      capabilities: caps,
    );

    test('Given a white lamp that only goes to 4000 K, when applying Focus, then it gets its coolest white', () {
      expect(
        SceneUtil.settingFor(lamp(maxKelvin: 4000), focus),
        const SceneLight(on: true, brightnessPercent: 100, kelvin: 4000),
      );
    });

    test('Given lamps of every kind, when applying Focus, then each gets what it can do', () {
      expect(SceneUtil.settingFor(lamp(caps: color), focus).color, focus.color);
      expect(
        SceneUtil.settingFor(lamp(caps: const {LightCapability.brightness}), focus),
        const SceneLight(on: true, brightnessPercent: 100),
      );
      expect(SceneUtil.settingFor(lamp(caps: const {}), focus), const SceneLight(on: true));
    });

    test('Given the lamp at its coolest white and full brightness, when asking, then Focus is active', () {
      expect(SceneUtil.isActive([lamp(maxKelvin: 4000, brightness: 100, kelvin: 3950)], focus), isTrue);
    });

    test('Given the lamp at full brightness but warm, when asking, then Focus is not active', () {
      expect(SceneUtil.isActive([lamp(brightness: 100, kelvin: 2700)], focus), isFalse);
    });

    test('Given a lamp that cannot do cool white, when coloring the Focus dot, then it shows the coolest it can', () {
      expect(SceneUtil.colorOf([lamp(maxKelvin: 4000)], focus), ColorTemperatureUtil.toRgb(4000));
    });

    test('Given a warm desk lamp and a ceiling lamp that is off, '
        'when saving a scene from now, '
        'then it brings back exactly that, also as active', () {
      // Given
      final lights = [lamp(id: 'light.desk', brightness: 40, kelvin: 2700), lamp(id: 'light.ceiling', on: false)];

      // When
      final scene = SceneUtil.snapshot(id: 'x', roomId: 'office', name: 'Evening', lights: lights);

      // Then
      expect(
        SceneUtil.settingFor(lights.first, scene),
        const SceneLight(on: true, brightnessPercent: 40, kelvin: 2700),
      );
      expect(SceneUtil.settingFor(lights.last, scene), const SceneLight(on: false));
      expect(SceneUtil.isActive(lights, scene), isTrue);
    });

    test('Given a saved scene, when a new lamp joins the room, then it gets the scene\'s average', () {
      // Given
      final scene = SceneUtil.snapshot(
        id: 'x',
        roomId: 'office',
        name: 'Evening',
        lights: [lamp(id: 'light.desk', brightness: 40, kelvin: 2700)],
      );

      // When / Then
      expect(
        SceneUtil.settingFor(lamp(id: 'light.new'), scene),
        const SceneLight(on: true, brightnessPercent: 40, kelvin: 2700),
      );
    });
  });
}
