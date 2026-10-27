import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/zen/zen_settings.repository.dart';

void main() {
  group('ZenSettingsRepository', () {
    late ZenSettingsRepository repository;

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = ZenSettingsRepository(database: database);
    });

    test('Given nothing saved, when reading the idle time, then it is 5 minutes', () async {
      expect(await repository.watchIdleMinutes().first, 5);
    });

    test('Given a saved idle time, when changing it, then the new one is read', () async {
      // Given
      await repository.setIdleMinutes(2);

      // When
      await repository.setIdleMinutes(0);

      // Then
      expect(await repository.watchIdleMinutes().first, 0);
    });
  });
}
