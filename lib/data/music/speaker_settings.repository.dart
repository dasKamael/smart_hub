import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';

part 'speaker_settings.repository.g.dart';

class SpeakerSettingsRepository {
  SpeakerSettingsRepository({required this.database});

  final AppDatabase database;

  $SpeakerSettingsTableTable get _table => database.speakerSettingsTable;

  Stream<Map<String, SpeakerSetting>> watchAll() {
    return database.select(_table).watch().map((rows) => {for (final row in rows) row.id: _toSetting(row)});
  }

  Future<SpeakerSetting> get(String id) async {
    final row = await (database.select(_table)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? SpeakerSetting(id: id) : _toSetting(row);
  }

  /// `nullToAbsent: false`: clearing a name must reach the database.
  Future<void> save(SpeakerSetting setting) => database.into(_table).insertOnConflictUpdate(_toCompanion(setting));

  /// Makes [id] the only default.
  Future<void> setDefault(String id) {
    return database.transaction(() async {
      await database.update(_table).write(const SpeakerSettingsTableCompanion(isDefault: Value(false)));
      final current = await get(id);
      await save(current.copyWith(isDefault: true));
    });
  }

  static SpeakerSetting _toSetting(SpeakerSettingRow row) {
    return SpeakerSetting(id: row.id, displayName: row.displayName, hidden: row.hidden, isDefault: row.isDefault);
  }

  static SpeakerSettingsTableCompanion _toCompanion(SpeakerSetting setting) {
    return SpeakerSettingRow(
      id: setting.id,
      displayName: setting.displayName,
      hidden: setting.hidden,
      isDefault: setting.isDefault,
    ).toCompanion(false);
  }
}

/// Providers
@Riverpod(keepAlive: true)
SpeakerSettingsRepository speakerSettingsRepository(Ref ref) {
  return SpeakerSettingsRepository(database: ref.watch(appDatabaseProvider));
}
