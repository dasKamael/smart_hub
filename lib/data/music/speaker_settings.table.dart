import 'package:drift/drift.dart';

/// Local settings per speaker: Home Assistant entity id, or `spotify:<device name>` for Spotify Connect devices.
@DataClassName('SpeakerSettingRow')
class SpeakerSettingsTable extends Table {
  @override
  String get tableName => 'speaker_settings';

  TextColumn get id => text()();

  /// Shown instead of the name the device reports.
  TextColumn get displayName => text().nullable()();

  BoolColumn get hidden => boolean().withDefault(const Constant(false))();

  /// Plays "Jump back in" when nothing is playing.
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
