import 'package:flutter_test/flutter_test.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/data/lights/ha_light.repository.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

HaEntityState _light(String state, Map<String, Object?> attributes, {String id = 'light.desk'}) {
  final time = DateTime.utc(2026, 10, 26);
  return HaEntityState(entityId: id, state: state, attributes: attributes, lastChanged: time, lastUpdated: time);
}

void main() {
  group('HaLightRepository.toLight', () {
    test('Given a color light that is on, '
        'when mapping, '
        'then brightness is in percent and the color is taken from rgb_color', () {
      // When
      final light = HaLightRepository.toLight(
        _light('on', {
          'friendly_name': 'Desk lamp',
          'supported_color_modes': ['xy', 'color_temp'],
          'color_mode': 'xy',
          'brightness': 204,
          'rgb_color': [255, 0, 128],
        }),
      );

      // Then
      expect(light.name, 'Desk lamp');
      expect(light.isOn, isTrue);
      expect(light.brightnessPercent, 80);
      expect(light.color, const RgbColor(255, 0, 128));
      expect(light.kelvin, isNull);
      expect(light.displayColor, const RgbColor(255, 0, 128));
    });

    test('Given a light in white mode, '
        'when mapping, '
        'then kelvin is set, there is no color and the display color is warm white', () {
      // When
      final light = HaLightRepository.toLight(
        _light('on', {
          'supported_color_modes': ['color_temp', 'xy'],
          'color_mode': 'color_temp',
          'brightness': 255,
          'color_temp_kelvin': 2700,
          'rgb_color': [255, 167, 87],
        }),
      );

      // Then
      expect(light.kelvin, 2700);
      expect(light.color, isNull);
      expect(light.displayColor?.red, 255);
      expect(light.displayColor!.blue, lessThan(light.displayColor!.green));
    });

    test('Given a light that is off, '
        'when mapping, '
        'then brightness, color and kelvin are empty', () {
      // When
      final light = HaLightRepository.toLight(
        _light('off', {
          'supported_color_modes': ['brightness'],
          'brightness': null,
        }),
      );

      // Then
      expect(light.isOn, isFalse);
      expect(light.brightnessPercent, isNull);
      expect(light.displayColor, isNull);
    });

    test('Given an unavailable light, when mapping, then it is not available and off', () {
      final light = HaLightRepository.toLight(_light('unavailable', {}));

      expect(light.isAvailable, isFalse);
      expect(light.isOn, isFalse);
      expect(light.name, 'light.desk');
    });

    test('Given a very dim light, when mapping, then brightness is at least 1 %', () {
      final light = HaLightRepository.toLight(
        _light('on', {
          'supported_color_modes': ['brightness'],
          'brightness': 1,
        }),
      );

      expect(light.brightnessPercent, 1);
    });
  });

  group('HaLightRepository.capabilitiesOf', () {
    final cases = <List<String>, Set<LightCapability>>{
      ['onoff']: {},
      ['brightness']: {LightCapability.brightness},
      ['color_temp']: {LightCapability.brightness, LightCapability.colorTemperature},
      ['hs']: {LightCapability.brightness, LightCapability.color},
      ['xy', 'color_temp']: {LightCapability.brightness, LightCapability.color, LightCapability.colorTemperature},
      ['rgbww']: {LightCapability.brightness, LightCapability.color},
      ['white', 'rgb']: {LightCapability.brightness, LightCapability.color},
    };
    for (final MapEntry(key: modes, value: expected) in cases.entries) {
      test('Given color modes $modes, when mapping, then the capabilities are $expected', () {
        expect(HaLightRepository.capabilitiesOf(modes), expected);
      });
    }
  });

  group('HaLightRepository commands', () {
    late FakeHomeAssistant server;
    late HaLightRepository repository;

    setUp(() async {
      server = FakeHomeAssistant(states: [_light('off', {})]);
      final session = HaSessionRepository(transportFor: (_) => server);
      addTearDown(session.dispose);
      final online = session.watchStatus().firstWhere((s) => s == ConnectionStatus.online);
      await session.connect(ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha:8123'), token: 'test-token'));
      await online;
      repository = HaLightRepository(session: session);
    });

    test('Given lights, when turning them on with values, then only the given values are sent', () async {
      // When
      await repository.turnOn(['light.desk', 'light.hall'], brightnessPercent: 40, color: const RgbColor(1, 2, 3));

      // Then
      final call = server.serviceCalls.single;
      expect('${call.domain}.${call.service}', 'light.turn_on');
      expect(call.entityIds, ['light.desk', 'light.hall']);
      expect(call.data, {
        'brightness_pct': 40,
        'rgb_color': [1, 2, 3],
      });
    });

    test('Given a light, when turning it on without values, then no service data is sent', () async {
      // When
      await repository.turnOn(['light.desk']);

      // Then
      expect(server.serviceCalls.single.data, isEmpty);
    });

    test('Given a light, when turning it off, then light.turn_off is called', () async {
      // When
      await repository.turnOff(['light.desk']);

      // Then
      expect(server.serviceCalls.single.service, 'turn_off');
    });

    test('Given the session, when a light changes, then watchLights emits the mapped state', () async {
      // Given
      final next = repository.watchLights().skip(1).first;

      // When
      server.setState('light.desk', 'on', attributes: {'brightness': 128});

      // Then
      expect((await next).single.isOn, isTrue);
    });
  });
}
