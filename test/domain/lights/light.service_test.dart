import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_scene.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/scene.util.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

import '../../utils/riverpod.test_util.dart';

class _MockLightRepository extends Mock implements LightRepository {}

void main() {
  group('LightsService', () {
    late _MockLightRepository repository;

    setUp(() {
      repository = _MockLightRepository();
      when(() => repository.watchLights()).thenAnswer(
        (_) => Stream.value(const [
          LightState(id: 'light.b', name: 'bedside', isOn: false),
          LightState(id: 'light.a', name: 'Desk', isOn: true),
        ]),
      );
      when(
        () => repository.turnOn(
          any(),
          brightnessPercent: any(named: 'brightnessPercent'),
          color: any(named: 'color'),
          kelvin: any(named: 'kelvin'),
        ),
      ).thenAnswer((_) async {});
      when(() => repository.turnOff(any())).thenAnswer((_) async {});
    });

    LightsService createService() {
      final container = createTestContainer(overrides: [lightRepositoryProvider.overrideWithValue(repository)]);
      container.listen(lightsServiceProvider, (_, _) {});
      return container.read(lightsServiceProvider.notifier);
    }

    test('Given lights, when listing, then they are sorted by name ignoring case', () async {
      final service = createService();
      await pumpEventQueue();

      expect(service.state.value?.map((l) => l.name), ['bedside', 'Desk']);
    });

    test('Given lights, when switching them on and off, then the repository is called', () async {
      final service = createService();

      await service.setOn(['light.a'], on: true);
      await service.setOn(['light.a', 'light.b'], on: false);

      verify(() => repository.turnOn(['light.a'])).called(1);
      verify(() => repository.turnOff(['light.a', 'light.b'])).called(1);
    });

    test('Given no lights, when switching, then nothing is sent', () async {
      await createService().setOn([], on: true);

      verifyNever(() => repository.turnOn(any()));
    });

    test('Given brightness out of range, when setting it, then it is clamped to 1–100', () async {
      final service = createService();

      await service.setBrightness('light.a', 0);
      await service.setBrightness('light.a', 140);

      verify(() => repository.turnOn(['light.a'], brightnessPercent: 1)).called(1);
      verify(() => repository.turnOn(['light.a'], brightnessPercent: 100)).called(1);
    });

    test('Given a color, when setting it, then the light turns on in that color', () async {
      await createService().setColor('light.a', const RgbColor(1, 2, 3));

      verify(() => repository.turnOn(['light.a'], color: const RgbColor(1, 2, 3))).called(1);
    });

    test('Given lights with different capabilities, '
        'when applying a scene, '
        'then each gets color, color temperature, brightness or just power', () async {
      // Given
      final service = createService();
      const lights = [
        LightState(
          id: 'light.color',
          name: 'Color',
          isOn: false,
          capabilities: {LightCapability.brightness, LightCapability.color},
        ),
        LightState(
          id: 'light.white',
          name: 'White',
          isOn: false,
          maxKelvin: 3000,
          capabilities: {LightCapability.brightness, LightCapability.colorTemperature},
        ),
        LightState(id: 'light.dim', name: 'Dim', isOn: false, capabilities: {LightCapability.brightness}),
        LightState(id: 'light.plain', name: 'Plain', isOn: false),
      ];

      // When
      await service.applyScene(lights, SceneUtil.templates('office')[1]);

      // Then: the white light only goes up to 3000 K.
      verify(() => repository.turnOn(['light.color'], brightnessPercent: 85, color: LightScene.read.color)).called(1);
      verify(() => repository.turnOn(['light.white'], brightnessPercent: 85, kelvin: 3000)).called(1);
      verify(() => repository.turnOn(['light.dim'], brightnessPercent: 85)).called(1);
      verify(() => repository.turnOn(['light.plain'])).called(1);
    });

    test('Given a room, when setting its brightness, then every light gets it', () async {
      await createService().setBrightnessOf(['light.a', 'light.b'], 30);

      verify(() => repository.turnOn(['light.a'], brightnessPercent: 30)).called(1);
      verify(() => repository.turnOn(['light.b'], brightnessPercent: 30)).called(1);
    });
  });
}
