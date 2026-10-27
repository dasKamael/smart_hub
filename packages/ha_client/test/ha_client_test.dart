import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  group('HaClient', () {
    late FakeHomeAssistant server;

    setUp(() {
      server = FakeHomeAssistant(
        states: [entity('light.desk', 'on'), entity('light.sofa', 'off'), entity('media_player.kitchen', 'idle')],
      );
    });

    HaClient createClient({String token = 'test-token'}) {
      final client = HaClient(uri: testUri, accessToken: token, transport: server);
      addTearDown(client.dispose);
      return client;
    }

    Future<void> startAndWaitForConnection(HaClient client) async {
      final connected = client.statusChanges.firstWhere((s) => s == HaConnectionStatus.connected);
      client.start();
      await connected;
    }

    /// Runs [body] in fake time with a started client and disposes it afterwards.
    void withFakeClient(void Function(FakeAsync async, HaClient client) body, {bool start = true}) {
      fakeAsync((async) {
        final client = HaClient(uri: testUri, accessToken: 'test-token', transport: server);
        if (start) {
          client.start();
          async.flushMicrotasks();
        }
        body(async, client);
        unawaited(client.dispose());
        async.flushMicrotasks();
      });
    }

    group('connecting', () {
      test('Given a reachable HA, '
          'when the client starts, '
          'then it becomes connected and mirrors all states', () async {
        // Given
        final client = createClient();

        // When
        await startAndWaitForConnection(client);

        // Then
        expect(client.status, HaConnectionStatus.connected);
        expect(client.states.keys, unorderedEquals(['light.desk', 'light.sofa', 'media_player.kitchen']));
        expect(client.haVersion, '2026.10.0');
      });

      test('Given a fresh client, '
          'when it connects, '
          'then every loaded entity is reported as a new entity', () async {
        // Given
        final client = createClient();
        final changes = <HaStateChange>[];
        client.stateChanges.listen(changes.add);

        // When
        await startAndWaitForConnection(client);

        // Then
        expect(changes.map((c) => c.entityId), unorderedEquals(['light.desk', 'light.sofa', 'media_player.kitchen']));
        expect(changes.every((c) => c.oldState == null), isTrue);
      });

      test('Given an invalid token, '
          'when the client starts, '
          'then the status is authFailed and it does not retry', () {
        fakeAsync((async) {
          // Given
          final client = HaClient(uri: testUri, accessToken: 'wrong', transport: server);

          // When
          client.start();
          async.elapse(const Duration(minutes: 1));

          // Then
          expect(client.status, HaConnectionStatus.authFailed);
          expect(server.connectAttempts, 1);
          unawaited(client.dispose());
          async.flushMicrotasks();
        });
      });
    });

    group('state changes', () {
      test('Given a connected client, '
          'when an entity changes in HA, '
          'then the change is emitted and the mirrored state is updated', () async {
        // Given
        final client = createClient();
        await startAndWaitForConnection(client);
        final next = client.stateChanges.first;

        // When
        server.setState('light.sofa', 'on', attributes: {'brightness': 128});

        // Then
        final change = await next;
        expect(change.entityId, 'light.sofa');
        expect(change.oldState?.state, 'off');
        expect(change.newState?.state, 'on');
        expect(client.states['light.sofa']?.attributes['brightness'], 128);
      });

      test('Given a connected client, '
          'when an entity is removed in HA, '
          'then a change without new state is emitted and the entity is gone', () async {
        // Given
        final client = createClient();
        await startAndWaitForConnection(client);
        final next = client.stateChanges.first;

        // When
        server.removeState('light.desk');

        // Then
        final change = await next;
        expect(change.newState, isNull);
        expect(client.states.containsKey('light.desk'), isFalse);
      });
    });

    group('service calls', () {
      test('Given a connected client, '
          'when calling a service, '
          'then HA receives domain, service, targets and data', () async {
        // Given
        final client = createClient();
        await startAndWaitForConnection(client);

        // When
        await client.callService('light', 'turn_on', entityIds: ['light.desk'], data: {'brightness_pct': 80});

        // Then
        final call = server.serviceCalls.single;
        expect(call.domain, 'light');
        expect(call.service, 'turn_on');
        expect(call.entityIds, ['light.desk']);
        expect(call.data, {'brightness_pct': 80});
      });

      test('Given a service with a response, '
          'when calling it with returnResponse, '
          'then the response comes back', () async {
        // Given
        server.onServiceCall = (call) => {
          'media_player.kitchen': {
            'queue': [
              {'media_title': 'Song'},
            ],
          },
        };
        final client = createClient();
        await startAndWaitForConnection(client);

        // When
        final response = await client.callService(
          'sonos',
          'get_queue',
          entityIds: ['media_player.kitchen'],
          returnResponse: true,
        );

        // Then
        expect(response, {
          'media_player.kitchen': {
            'queue': [
              {'media_title': 'Song'},
            ],
          },
        });
      });

      test('Given a handler for a command, '
          'when sending it, '
          'then its result comes back; unknown commands fail', () async {
        // Given
        server.commandHandlers['media_player/browse_media'] = (message) => {
          'title': 'Root',
          'entity': message['entity_id'],
        };
        final client = createClient();
        await startAndWaitForConnection(client);

        // When
        final result = await client.sendCommand('media_player/browse_media', {'entity_id': 'media_player.kitchen'});

        // Then
        expect(result, {'title': 'Root', 'entity': 'media_player.kitchen'});
        await expectLater(client.sendCommand('nope'), throwsA(isA<HaCommandException>()));
      });

      test('Given a client that is not connected, '
          'when calling a service, '
          'then HaNotConnectedException is thrown', () async {
        // Given
        final client = createClient();

        // When / Then
        await expectLater(client.callService('light', 'turn_off'), throwsA(isA<HaNotConnectedException>()));
      });
    });

    group('reconnecting', () {
      test('Given a connected client, '
          'when the connection drops and HA comes back, '
          'then it reconnects after the backoff and reports changes made while offline', () {
        withFakeClient((async, client) {
          // Given
          expect(client.status, HaConnectionStatus.connected);
          final changes = <HaStateChange>[];
          client.stateChanges.listen(changes.add);

          // When
          unawaited(server.dropConnections());
          async.flushMicrotasks();
          expect(client.status, HaConnectionStatus.disconnected);
          expect(client.states['light.desk']?.state, 'on', reason: 'last known state is kept while offline');

          async.elapse(const Duration(milliseconds: 500));
          server.setState('light.desk', 'off');
          async.elapse(const Duration(milliseconds: 600));

          // Then
          expect(client.status, HaConnectionStatus.connected);
          expect(client.states['light.desk']?.state, 'off');
          expect(changes.map((c) => c.entityId), ['light.desk']);
        });
      });

      test('Given HA is unreachable, '
          'when the client keeps retrying, '
          'then the delays grow exponentially', () {
        server.reachable = false;
        withFakeClient((async, client) {
          // When
          final attemptsAt = <int>[];
          for (var second = 0; second <= 15; second++) {
            attemptsAt.add(server.connectAttempts);
            async.elapse(const Duration(seconds: 1));
          }

          // Then – attempts at t = 0, 1, 3, 7, 15 s
          expect([attemptsAt[0], attemptsAt[1], attemptsAt[3], attemptsAt[7], attemptsAt[15]], [1, 2, 3, 4, 5]);
          expect(client.status, HaConnectionStatus.disconnected);
        });
      });

      test('Given a connected client, '
          'when HA stops answering pings, '
          'then the client drops the connection and reconnects', () {
        withFakeClient((async, client) {
          // Given
          final statuses = <HaConnectionStatus>[];
          client.statusChanges.listen(statuses.add);

          // When
          server.respondToPings = false;
          async.elapse(const Duration(seconds: 30 + 10));
          server.respondToPings = true;
          async.elapse(const Duration(seconds: 2));

          // Then
          expect(statuses, [
            HaConnectionStatus.disconnected,
            HaConnectionStatus.connecting,
            HaConnectionStatus.connected,
          ]);
          expect(server.connectAttempts, 2);
        });
      });

      test('Given a running client, '
          'when it is stopped, '
          'then it disconnects and does not reconnect', () {
        withFakeClient((async, client) {
          // When
          unawaited(client.stop());
          async.elapse(const Duration(minutes: 5));

          // Then
          expect(client.status, HaConnectionStatus.disconnected);
          expect(server.openConnections, 0);
          expect(server.connectAttempts, 1);
        });
      });
    });
  });
}
