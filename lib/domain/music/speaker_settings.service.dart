import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/music/speaker_settings.repository.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';

part 'speaker_settings.service.g.dart';

/// Local names, hidden speakers and the default speaker, by speaker id.
@Riverpod(keepAlive: true)
class SpeakerSettingsService extends _$SpeakerSettingsService {
  @override
  Stream<Map<String, SpeakerSetting>> build() => ref.watch(speakerSettingsRepositoryProvider).watchAll();

  /// Id under which the settings of a Spotify Connect device are kept (its id may change between sessions).
  static String spotifyId(String deviceName) => 'spotify:$deviceName';

  /// [name] `null` or blank goes back to the reported name.
  Future<void> rename(String id, String? name) async {
    final repository = ref.read(speakerSettingsRepositoryProvider);
    final trimmed = name?.trim();
    await repository.save(
      (await repository.get(id)).copyWith(displayName: trimmed == null || trimmed.isEmpty ? null : trimmed),
    );
  }

  Future<void> setHidden(String id, {required bool hidden}) async {
    final repository = ref.read(speakerSettingsRepositoryProvider);
    await repository.save((await repository.get(id)).copyWith(hidden: hidden));
  }

  Future<void> setDefault(String id) => ref.read(speakerSettingsRepositoryProvider).setDefault(id);
}
