import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/lights/hue/hue_bridge.repository.dart';
import 'package:smart_hub/domain/lights/model/light_bridge.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('HueBridgeRepository', () {
    late _MockStorage storage;
    final values = <String, String>{};

    HueBridgeRepository repository({required http.Client bridge, http.Client? internet}) {
      return HueBridgeRepository(
        storage: storage,
        client: internet ?? MockClient((_) async => http.Response('[]', 200)),
        bridgeClientFor: (_) => bridge,
      );
    }

    setUp(() {
      values.clear();
      storage = _MockStorage();
      when(() => storage.read(key: any(named: 'key'))).thenAnswer((i) async => values[i.namedArguments[#key]]);
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((i) async {
        values[i.namedArguments[#key] as String] = i.namedArguments[#value] as String;
      });
    });

    test('Given the button was not pressed, when pairing, then it says so', () async {
      final bridge = MockClient(
        (_) async => http.Response(
          jsonEncode([
            {
              'error': {'type': 101},
            },
          ]),
          200,
        ),
      );

      await expectLater(
        repository(bridge: bridge).pair('192.168.1.20'),
        throwsA(isA<BridgeButtonNotPressedException>()),
      );
    });

    test('Given the button was pressed, when pairing and restarting, then the key and name are kept', () async {
      // Given
      final bridge = MockClient(
        (request) async => request.url.path == '/api'
            ? http.Response(
                jsonEncode([
                  {
                    'success': {'username': 'secret-key'},
                  },
                ]),
                200,
              )
            : http.Response(jsonEncode({'name': 'Living room bridge'}), 200),
      );
      final repo = repository(bridge: bridge);

      // When
      final paired = await repo.pair('192.168.1.20');
      await repo.save(paired);
      final loaded = await repo.load();

      // Then
      expect(loaded, const LightBridge(host: '192.168.1.20', appKey: 'secret-key', name: 'Living room bridge'));
    });

    test('Given the discovery service lists a bridge, when discovering, then its address is found', () async {
      final internet = MockClient(
        (_) async => http.Response(
          jsonEncode([
            {'id': 'x', 'internalipaddress': '192.168.1.20'},
          ]),
          200,
        ),
      );

      expect(await repository(bridge: MockClient((_) async => http.Response('', 404)), internet: internet).discover(), [
        '192.168.1.20',
      ]);
    });
  });
}
