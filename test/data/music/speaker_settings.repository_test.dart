import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/music/speaker_settings.repository.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';

void main() {
  group('SpeakerSettingsRepository', () {
    late SpeakerSettingsRepository repository;

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = SpeakerSettingsRepository(database: database);
    });

    test('Given no saved setting, when reading it, then the defaults come back', () async {
      // When
      final setting = await repository.get('media_player.office');

      // Then
      expect(setting, const SpeakerSetting(id: 'media_player.office'));
    });

    test('Given a renamed speaker, when clearing the name, then the name is gone', () async {
      // Given
      await repository.save(const SpeakerSetting(id: 'media_player.office', displayName: 'Study', hidden: true));

      // When
      await repository.save(const SpeakerSetting(id: 'media_player.office', hidden: true));

      // Then
      expect(
        await repository.get('media_player.office'),
        const SpeakerSetting(id: 'media_player.office', hidden: true),
      );
    });

    test('Given a default speaker, when setting another default, then only the new one is default', () async {
      // Given
      await repository.save(const SpeakerSetting(id: 'media_player.office', displayName: 'Study', isDefault: true));

      // When
      await repository.setDefault('spotify:Pixel 9');

      // Then
      expect(await repository.watchAll().first, {
        'media_player.office': const SpeakerSetting(id: 'media_player.office', displayName: 'Study'),
        'spotify:Pixel 9': const SpeakerSetting(id: 'spotify:Pixel 9', isDefault: true),
      });
    });
  });
}
