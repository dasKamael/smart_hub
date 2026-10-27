import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_hub/data/weather/place_name.repository.dart';

void main() {
  group('PlaceNameRepository', () {
    test(
      'Given a position in Mainz, when asking for its name, then the town comes with an identifying agent',
      () async {
        // Given
        late http.Request asked;
        final repository = PlaceNameRepository(
          client: MockClient((request) async {
            asked = request;
            return http.Response(File('test/fixtures/weather/reverse.json').readAsStringSync(), 200);
          }),
        );

        // When
        final name = await repository.nameAt(49.99, 8.27);

        // Then
        expect(name, 'Mainz');
        expect(asked.headers['User-Agent'], PlaceNameRepository.userAgent);
      },
    );

    test('Given Nominatim refuses, when asking, then there is no name', () async {
      final repository = PlaceNameRepository(client: MockClient((_) async => http.Response('', 403)));

      expect(await repository.nameAt(49.99, 8.27), isNull);
    });
  });
}
