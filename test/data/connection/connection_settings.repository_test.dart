import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/connection/connection_settings.repository.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';

import '../../mocks/connection.mock.dart';

void main() {
  group('ConnectionSettingsRepository', () {
    late MockFlutterSecureStorage storage;
    late ConnectionSettingsRepository repository;
    String? stored;

    setUp(() {
      stored = null;
      storage = MockFlutterSecureStorage();
      when(() => storage.read(key: any(named: 'key'))).thenAnswer((_) async => stored);
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((invocation) async {
        stored = invocation.namedArguments[#value] as String?;
      });
      when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async => stored = null);
      repository = ConnectionSettingsRepository(storage: storage);
    });

    test('Given nothing is stored, '
        'when loading, '
        'then there is no config', () async {
      expect(await repository.load(), isNull);
    });

    test('Given a Home Assistant config was saved, '
        'when loading, '
        'then the same config comes back', () async {
      // Given
      final config = ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha.local:8123'), token: 'secret');
      await repository.save(config);

      // When
      final loaded = await repository.load();

      // Then
      expect(loaded, config);
      verify(
        () => storage.write(
          key: ConnectionSettingsRepository.storageKey,
          value: any(named: 'value'),
        ),
      ).called(1);
    });

    test('Given the demo config was saved, '
        'when loading, '
        'then the demo config comes back', () async {
      // Given
      await repository.save(const ConnectionConfig.demo());

      // When / Then
      expect(await repository.load(), const ConnectionConfig.demo());
    });

    test('Given unreadable data is stored, '
        'when loading, '
        'then it is ignored', () async {
      // Given
      stored = '{"type": 42';

      // When / Then
      expect(await repository.load(), isNull);
    });

    test('Given a saved config, '
        'when clearing, '
        'then nothing is stored anymore', () async {
      // Given
      await repository.save(const ConnectionConfig.demo());

      // When
      await repository.clear();

      // Then
      expect(await repository.load(), isNull);
    });

    test('Given the hub runs without Home Assistant, when loading, then that is remembered', () async {
      // Given
      await repository.save(const ConnectionConfig.standalone());

      // When / Then
      expect(await repository.load(), const ConnectionConfig.standalone());
    });
  });
}
