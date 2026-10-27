import 'package:flutter_test/flutter_test.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';

void main() {
  group('HaSessionRepository', () {
    late FakeHomeAssistant server;
    late HaSessionRepository repository;
    final config = ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha.local:8123'), token: 'test-token');

    HaEntityState entity(String id, String state, [Map<String, Object?> attributes = const {}]) {
      final time = DateTime.utc(2026, 10, 26);
      return HaEntityState(entityId: id, state: state, attributes: attributes, lastChanged: time, lastUpdated: time);
    }

    setUp(() {
      server = FakeHomeAssistant(
        states: [
          entity('light.desk', 'on', {'friendly_name': 'Desk lamp'}),
          entity('media_player.kitchen', 'idle'),
        ],
      );
      repository = HaSessionRepository(transportFor: (_) => server);
      addTearDown(repository.dispose);
    });

    Future<void> connectAndWait(ConnectionConfig config) async {
      final online = repository.watchStatus().firstWhere((s) => s == ConnectionStatus.online);
      await repository.connect(config);
      await online;
    }

    test('Given no connection, '
        'when reading the status, '
        'then it is notConfigured', () {
      expect(repository.status, ConnectionStatus.notConfigured);
    });

    test('Given a Home Assistant config, '
        'when connecting, '
        'then the status goes connecting → online and the entities are mapped', () async {
      // Given
      final statuses = <ConnectionStatus>[];
      repository.watchStatus().listen(statuses.add);

      // When
      await connectAndWait(config);

      // Then
      expect(statuses, [ConnectionStatus.notConfigured, ConnectionStatus.connecting, ConnectionStatus.online]);
      final desk = repository.entities().firstWhere((e) => e.id == 'light.desk');
      expect(desk.name, 'Desk lamp');
      expect(desk.domain, 'light');
      expect(desk.state, 'on');
      expect(repository.entities().firstWhere((e) => e.id == 'media_player.kitchen').name, 'media_player.kitchen');
    });

    test('Given a rejected token, '
        'when connecting, '
        'then the status becomes authFailed', () async {
      // Given
      final failing = ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha.local:8123'), token: 'wrong');
      final authFailed = repository.watchStatus().firstWhere((s) => s == ConnectionStatus.authFailed);

      // When
      await repository.connect(failing);

      // Then
      await authFailed;
    });

    test('Given an online session, '
        'when the connection drops, '
        'then the status becomes offline and the last states are kept', () async {
      // Given
      await connectAndWait(config);
      final offline = repository.watchStatus().firstWhere((s) => s == ConnectionStatus.offline);
      server.reachable = false;

      // When
      await server.dropConnections();

      // Then
      await offline;
      expect(repository.states.keys, contains('light.desk'));
    });

    test('Given an online session, '
        'when an entity changes, '
        'then watchEntities emits the new state', () async {
      // Given
      await connectAndWait(config);
      final next = repository.watchEntities().skip(1).first;

      // When
      server.setState('light.desk', 'off');

      // Then
      final entities = await next;
      expect(entities.firstWhere((e) => e.id == 'light.desk').state, 'off');
    });

    test('Given an online session, '
        'when calling a service, '
        'then it reaches Home Assistant', () async {
      // Given
      await connectAndWait(config);

      // When
      await repository.callService('light', 'turn_off', entityIds: ['light.desk']);

      // Then
      expect(server.serviceCalls.single.service, 'turn_off');
    });

    test('Given an online session, '
        'when disconnecting, '
        'then the status is notConfigured and no entities are left', () async {
      // Given
      await connectAndWait(config);

      // When
      await repository.disconnect();

      // Then
      expect(repository.status, ConnectionStatus.notConfigured);
      expect(repository.entities(), isEmpty);
      expect(server.openConnections, 0);
    });

    test('Given no session, '
        'when calling a service, '
        'then HaNotConnectedException is thrown', () {
      expect(() => repository.callService('light', 'turn_on'), throwsA(isA<HaNotConnectedException>()));
    });

    test('Given the demo config, '
        'when connecting with the default transport, '
        'then the demo home is online with lights and speakers', () async {
      // Given
      final demoRepository = HaSessionRepository();
      addTearDown(demoRepository.dispose);
      final online = demoRepository.watchStatus().firstWhere((s) => s == ConnectionStatus.online);

      // When
      await demoRepository.connect(const ConnectionConfig.demo());
      await online;

      // Then
      final domains = demoRepository.entities().map((e) => e.domain).toSet();
      expect(domains, containsAll(['light', 'media_player']));
    });

    test('Given base URLs, '
        'when building the websocket URI, '
        'then http maps to ws and https to wss with the API path', () {
      expect(
        HaSessionRepository.websocketUri(Uri.parse('http://ha.local:8123')).toString(),
        'ws://ha.local:8123/api/websocket',
      );
      expect(
        HaSessionRepository.websocketUri(Uri.parse('https://home.example.com')).toString(),
        'wss://home.example.com/api/websocket',
      );
    });
  });
}
