import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ha_client/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/connection/connection_settings.repository.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connect_result.enum.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';

import '../../mocks/connection.mock.dart';
import '../../utils/riverpod.test_util.dart';

void main() {
  setUpAll(() => registerFallbackValue(const ConnectionConfig.demo()));

  group('ConnectionConfigService', () {
    late FakeHomeAssistant server;
    late MockConnectionSettingsRepository settings;
    late HaSessionRepository session;
    final config = ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha.local:8123'), token: 'test-token');

    setUp(() {
      server = FakeHomeAssistant();
      settings = MockConnectionSettingsRepository();
      when(() => settings.load()).thenAnswer((_) async => null);
      when(() => settings.save(any())).thenAnswer((_) async {});
      when(() => settings.clear()).thenAnswer((_) async {});
      session = HaSessionRepository(transportFor: (_) => server);
    });

    ProviderContainer createContainer() {
      final container = createTestContainer(
        overrides: [
          connectionSettingsRepositoryProvider.overrideWithValue(settings),
          haSessionRepositoryProvider.overrideWithValue(session),
        ],
      );
      addTearDown(session.dispose);
      return container;
    }

    test('Given nothing is saved, '
        'when the service starts, '
        'then there is no config and no connection', () async {
      // Given
      final container = createContainer();

      // When
      final loaded = await container.read(connectionConfigServiceProvider.future);

      // Then
      expect(loaded, isNull);
      expect(session.status, ConnectionStatus.notConfigured);
    });

    test('Given a saved config, '
        'when the service starts, '
        'then it connects with it', () async {
      // Given
      when(() => settings.load()).thenAnswer((_) async => config);
      final container = createContainer();

      // When
      final loaded = await container.read(connectionConfigServiceProvider.future);

      // Then
      expect(loaded, config);
      expect(session.status, isNot(ConnectionStatus.notConfigured));
    });

    test('Given no Home Assistant, '
        'when starting without it, '
        'then it is saved right away, nothing connects and Home Assistant parts are off', () async {
      // Given
      final container = createContainer();
      await container.read(connectionConfigServiceProvider.future);

      // When
      final result = await container
          .read(connectionConfigServiceProvider.notifier)
          .connect(const ConnectionConfig.standalone());

      // Then
      expect(result, ConnectResult.connected);
      verify(() => settings.save(const ConnectionConfig.standalone())).called(1);
      expect(session.status, ConnectionStatus.notConfigured);
      expect(container.read(hasHomeAssistantProvider), isFalse);
    });

    test('Given a working Home Assistant, '
        'when connecting, '
        'then the result is connected and the config is saved', () async {
      // Given
      final container = createContainer();
      await container.read(connectionConfigServiceProvider.future);

      // When
      final result = await container.read(connectionConfigServiceProvider.notifier).connect(config);

      // Then
      expect(result, ConnectResult.connected);
      expect(container.read(connectionConfigServiceProvider).value, config);
      verify(() => settings.save(config)).called(1);
    });

    test('Given a wrong token, '
        'when connecting, '
        'then the result is authFailed and nothing is saved', () async {
      // Given
      final container = createContainer();
      await container.read(connectionConfigServiceProvider.future);
      final wrong = ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha.local:8123'), token: 'wrong');

      // When
      final result = await container.read(connectionConfigServiceProvider.notifier).connect(wrong);

      // Then
      expect(result, ConnectResult.authFailed);
      expect(container.read(connectionConfigServiceProvider).value, isNull);
      expect(session.status, ConnectionStatus.notConfigured);
      verifyNever(() => settings.save(any()));
    });

    test('Given an unreachable Home Assistant, '
        'when connecting, '
        'then the result is unreachable after the timeout and nothing is saved', () {
      fakeAsync((async) {
        // Given – streams and timers must be created inside the fake zone
        final unreachable = FakeHomeAssistant()..reachable = false;
        final session = HaSessionRepository(transportFor: (_) => unreachable);
        final container = ProviderContainer(
          overrides: [
            connectionSettingsRepositoryProvider.overrideWithValue(settings),
            haSessionRepositoryProvider.overrideWithValue(session),
          ],
          retry: (_, _) => null,
        );
        unawaited(container.read(connectionConfigServiceProvider.future));
        async.flushMicrotasks();

        // When
        ConnectResult? result;
        unawaited(container.read(connectionConfigServiceProvider.notifier).connect(config).then((r) => result = r));
        async.elapse(ConnectionConfigService.connectTimeout + const Duration(seconds: 1));

        // Then
        expect(result, ConnectResult.unreachable);
        verifyNever(() => settings.save(any()));
        container.dispose();
        unawaited(session.dispose());
        async.flushMicrotasks();
      });
    });

    test('Given a connected hub, '
        'when clearing, '
        'then it disconnects and forgets the config', () async {
      // Given
      final container = createContainer();
      await container.read(connectionConfigServiceProvider.future);
      await container.read(connectionConfigServiceProvider.notifier).connect(config);

      // When
      await container.read(connectionConfigServiceProvider.notifier).clear();

      // Then
      expect(container.read(connectionConfigServiceProvider).value, isNull);
      expect(session.status, ConnectionStatus.notConfigured);
      verify(() => settings.clear()).called(1);
    });
  });

  group('connection streams', () {
    test('Given a demo session, '
        'when watching the entities, '
        'then they are sorted by kind and then by name', () async {
      // Given
      final session = HaSessionRepository();
      addTearDown(session.dispose);
      final container = createTestContainer(overrides: [haSessionRepositoryProvider.overrideWithValue(session)]);
      final online = session.watchStatus().firstWhere((s) => s == ConnectionStatus.online);
      await session.connect(const ConnectionConfig.demo());
      await online;

      // When
      container.listen(hubEntitiesServiceProvider, (_, _) {});
      final entities = await container.read(hubEntitiesServiceProvider.future);

      // Then
      final lights = entities.where((e) => e.domain == 'light').map((e) => e.name).toList();
      expect(lights, [...lights]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())));
      expect(entities.map((e) => e.domain).toList(), [...entities.map((e) => e.domain)]..sort());
    });

    test('Given no connection, '
        'when watching the status, '
        'then it is notConfigured', () async {
      // Given
      final session = HaSessionRepository();
      addTearDown(session.dispose);
      final container = createTestContainer(overrides: [haSessionRepositoryProvider.overrideWithValue(session)]);

      // When
      container.listen(connectionStatusServiceProvider, (_, _) {});
      final status = await container.read(connectionStatusServiceProvider.future);

      // Then
      expect(status, ConnectionStatus.notConfigured);
    });
  });
}
