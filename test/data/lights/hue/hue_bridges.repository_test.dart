import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_hub/data/lights/hue/hue_bridges.repository.dart';
import 'package:smart_hub/data/lights/hue/hue_light.repository.dart';

void main() {
  group('HueBridgesRepository', () {
    HueLightRepository bridge(String host, String lightId, List<String> commands) {
      final client = MockClient.streaming((request, body) async {
        if (request.method == 'PUT') {
          commands.add('$host ${request.url.pathSegments.last}');
          return http.StreamedResponse(Stream.value(utf8.encode('{}')), 200);
        }
        if (request.url.path == '/clip/v2/resource/light') {
          final lamp = {
            'id': lightId,
            'metadata': {'name': lightId},
            'on': {'on': true},
          };
          return http.StreamedResponse(
            Stream.value(
              utf8.encode(
                jsonEncode({
                  'data': [lamp],
                }),
              ),
            ),
            200,
          );
        }
        return http.StreamedResponse(const Stream.empty(), 200);
      });
      return HueLightRepository(host: host, appKey: 'key', client: client);
    }

    test('Given two bridges, when reading and switching, then all lamps show and each bridge gets its own', () async {
      // Given
      final commands = <String>[];
      final repository = HueBridgesRepository([bridge('a', 'lamp-a', commands), bridge('b', 'lamp-b', commands)]);
      final seen = <List<String>>[];
      final subscription = repository.watchLights().listen((lights) => seen.add([for (final l in lights) l.id]));
      await pumpEventQueue();

      // When
      await repository.turnOff(['lamp-a', 'lamp-b']);

      // Then
      expect(seen.last, ['lamp-a', 'lamp-b']);
      expect(commands, unorderedEquals(['a lamp-a', 'b lamp-b']));
      await subscription.cancel();
      repository.dispose();
    });
  });
}
