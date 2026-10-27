import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  group('HaSession', () {
    late FakeHomeAssistant server;

    setUp(() {
      server = FakeHomeAssistant(states: [entity('light.desk', 'on'), entity('media_player.kitchen', 'idle')]);
    });

    Future<HaSession> connect({String token = 'test-token'}) async {
      final session = await HaSession.connect(await server.connect(testUri), accessToken: token);
      addTearDown(session.close);
      return session;
    }

    test('Given a valid token, '
        'when connecting, '
        'then the session is authenticated and knows the HA version', () async {
      // When
      final session = await connect();

      // Then
      expect(session.isClosed, isFalse);
      expect(session.haVersion, '2026.10.0');
    });

    test('Given an invalid token, '
        'when connecting, '
        'then HaAuthException is thrown', () async {
      // When / Then
      await expectLater(connect(token: 'wrong'), throwsA(isA<HaAuthException>()));
    });

    test('Given a session, '
        'when sending get_states, '
        'then the result contains all entities', () async {
      // Given
      final session = await connect();

      // When
      final result = await session.sendCommand('get_states') as List<Object?>;

      // Then
      final ids = result.cast<Map<String, Object?>>().map((e) => e['entity_id']);
      expect(ids, unorderedEquals(['light.desk', 'media_player.kitchen']));
    });

    test('Given HA rejects a service call, '
        'when calling it, '
        'then HaCommandException carries code and message', () async {
      // Given
      server.onServiceCall = (_) => throw const FakeHomeAssistantError(code: 'service_not_found', message: 'nope');
      final session = await connect();

      // When / Then
      await expectLater(
        session.sendCommand('call_service', {'domain': 'light', 'service': 'explode'}),
        throwsA(isA<HaCommandException>().having((e) => e.code, 'code', 'service_not_found')),
      );
    });

    test('Given a subscription to state_changed, '
        'when an entity changes, '
        'then the event is delivered with old and new state', () async {
      // Given
      final session = await connect();
      final events = await session.subscribeEvents('state_changed');
      final first = events.first;

      // When
      server.setState('light.desk', 'off');

      // Then
      final event = await first;
      final data = event['data']! as Map<String, Object?>;
      expect(data['entity_id'], 'light.desk');
      expect((data['old_state']! as Map<String, Object?>)['state'], 'on');
      expect((data['new_state']! as Map<String, Object?>)['state'], 'off');
    });

    test('Given a pending command, '
        'when the server closes the connection, '
        'then the command fails with HaConnectionClosedException and done completes', () async {
      // Given
      server.respondToCommands = false;
      final session = await connect();
      final pending = session.sendCommand('get_states');

      // When
      await server.dropConnections();

      // Then
      await expectLater(pending, throwsA(isA<HaConnectionClosedException>()));
      await expectLater(session.done, completes);
      expect(session.isClosed, isTrue);
    });

    test('Given HA does not answer, '
        'when the command timeout passes, '
        'then the command fails with HaTimeoutException', () {
      fakeAsync((async) {
        // Given
        server.respondToCommands = false;
        HaSession? session;
        unawaited(
          server
              .connect(testUri)
              .then((channel) => HaSession.connect(channel, accessToken: 'test-token'))
              .then((s) => session = s),
        );
        async.flushMicrotasks();
        Object? error;
        unawaited(session!.sendCommand('get_states').catchError((Object e) => error = e));

        // When
        async.elapse(const Duration(seconds: 11));

        // Then
        expect(error, isA<HaTimeoutException>());
        unawaited(session!.close());
        async.flushMicrotasks();
      });
    });

    test('Given a closed session, '
        'when sending a command, '
        'then it fails immediately with HaConnectionClosedException', () async {
      // Given
      final session = await connect();
      await session.close();

      // When / Then
      await expectLater(session.sendCommand('get_states'), throwsA(isA<HaConnectionClosedException>()));
    });
  });
}
