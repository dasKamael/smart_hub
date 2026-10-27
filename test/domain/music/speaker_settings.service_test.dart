import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/music/speaker_settings.repository.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';

import '../../utils/riverpod.test_util.dart';

void main() {
  group('SpeakerSettingsService', () {
    late SpeakerSettingsRepository repository;
    late SpeakerSettingsService service;

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = SpeakerSettingsRepository(database: database);
      final container = createTestContainer(
        overrides: [speakerSettingsRepositoryProvider.overrideWithValue(repository)],
      );
      service = container.read(speakerSettingsServiceProvider.notifier);
    });

    test(
      'Given a hidden speaker, when renaming it with spaces, then the trimmed name is kept and it stays hidden',
      () async {
        // Given
        await service.setHidden('media_player.office', hidden: true);

        // When
        await service.rename('media_player.office', '  Study  ');

        // Then
        expect(
          await repository.get('media_player.office'),
          const SpeakerSetting(id: 'media_player.office', displayName: 'Study', hidden: true),
        );
      },
    );

    test('Given a renamed speaker, when renaming it to a blank name, then the reported name is used again', () async {
      // Given
      await service.rename('media_player.office', 'Study');

      // When
      await service.rename('media_player.office', ' ');

      // Then
      expect((await repository.get('media_player.office')).displayName, isNull);
    });

    test('Given a Spotify device name, when building its settings id, then the name is the key', () {
      expect(SpeakerSettingsService.spotifyId('Pixel 9'), 'spotify:Pixel 9');
    });
  });
}
