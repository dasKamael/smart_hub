import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_hub/data/lights/hue/hue_light.repository.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

void main() {
  Map<String, Object?> lamp(String id, {bool on = true, double brightness = 60, int? mirek = 370, bool color = true}) =>
      {
        'id': id,
        'type': 'light',
        'metadata': {'name': 'Desk $id'},
        'on': {'on': on},
        'dimming': {'brightness': brightness},
        'color_temperature': {
          'mirek': mirek,
          'mirek_valid': mirek != null,
          'mirek_schema': {'mirek_minimum': 153, 'mirek_maximum': 454},
        },
        if (color)
          'color': {
            'xy': {'x': 0.5, 'y': 0.41},
          },
      };

  group('HueLightRepository.toLight', () {
    test('Given a white lamp at 370 mirek, when mapping, then it is on at 60 % and 2703 K with its range', () {
      final light = HueLightRepository.toLight(lamp('a'));

      expect((light.name, light.isOn, light.brightnessPercent, light.kelvin), ('Desk a', true, 60, 2703));
      expect((light.minKelvin, light.maxKelvin), (2203, 6536));
      expect(light.capabilities, {LightCapability.brightness, LightCapability.colorTemperature, LightCapability.color});
    });

    test('Given a lamp in color mode, when mapping, then it has a color and no color temperature', () {
      final light = HueLightRepository.toLight(lamp('a', mirek: null));

      expect(light.kelvin, isNull);
      expect(light.color, const RgbColor(255, 187, 90));
    });

    test('Given a lamp that is off, when mapping, then it has no brightness, color or temperature', () {
      final light = HueLightRepository.toLight(lamp('a', on: false));

      expect((light.isOn, light.brightnessPercent, light.kelvin, light.color), (false, null, null, null));
    });
  });

  group('HueLightRepository colors', () {
    test(
      'Given the scene colors, when sending them as xy and reading them back, then they stay within 30 per channel',
      () {
        for (final color in const [
          RgbColor(255, 179, 64),
          RgbColor(255, 224, 138),
          RgbColor(191, 227, 255),
          RgbColor(255, 159, 107),
        ]) {
          final xy = HueLightRepository.xyOf(color);
          final back = HueLightRepository.rgbOf(xy['x']!, xy['y']!);
          expect((back.red - color.red).abs(), lessThanOrEqualTo(30), reason: '$color → $back');
          expect((back.green - color.green).abs(), lessThanOrEqualTo(30), reason: '$color → $back');
          expect((back.blue - color.blue).abs(), lessThanOrEqualTo(30), reason: '$color → $back');
        }
      },
    );
  });

  group('HueLightRepository with a bridge', () {
    test('Given a lamp, when turning it on at 40 % and 2700 K, then the bridge gets brightness and mirek', () async {
      // Given
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        return http.Response('{"data":[],"errors":[]}', 200);
      });
      final repository = HueLightRepository(host: '192.168.1.20', appKey: 'key', client: client);

      // When
      await repository.turnOn(['a'], brightnessPercent: 40, kelvin: 2700);

      // Then
      expect(requests.single.url.toString(), 'https://192.168.1.20/clip/v2/resource/light/a');
      expect(requests.single.headers['hue-application-key'], 'key');
      expect(jsonDecode(requests.single.body), {
        'on': {'on': true},
        'dimming': {'brightness': 40.0},
        'color_temperature': {'mirek': 370},
      });
    });

    test(
      'Given the lights are read, when the bridge reports a switch turned one off, then it shows off at once',
      () async {
        // Given
        final events = StreamController<List<int>>();
        final client = MockClient.streaming((request, body) async {
          if (request.url.path == '/clip/v2/resource/light') {
            return http.StreamedResponse(
              Stream.value(
                utf8.encode(
                  jsonEncode({
                    'data': [lamp('a')],
                  }),
                ),
              ),
              200,
            );
          }
          return http.StreamedResponse(events.stream, 200);
        });
        final repository = HueLightRepository(host: 'bridge', appKey: 'key', client: client);
        final seen = <bool>[];
        final subscription = repository.watchLights().listen((lights) => seen.add(lights.single.isOn));
        await pumpEventQueue();

        // When
        events.add(utf8.encode(': hi\n\n'));
        events.add(
          utf8.encode(
            'data: ${jsonEncode([
              {
                'type': 'update',
                'data': [
                  {
                    'id': 'a',
                    'type': 'light',
                    'on': {'on': false},
                  },
                ],
              },
            ])}\n\n',
          ),
        );
        await pumpEventQueue();

        // Then
        expect(seen, [true, false]);
        await subscription.cancel();
        repository.dispose();
        await events.close();
      },
    );
  });
}
