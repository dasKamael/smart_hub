import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';

part 'zen_settings.repository.g.dart';

class ZenSettingsRepository {
  ZenSettingsRepository({required this.database});

  static const _id = 0;
  static const defaultIdleMinutes = 5;

  final AppDatabase database;

  Stream<int> watchIdleMinutes() {
    final query = database.select(database.zenSettingsTable)..where((t) => t.id.equals(_id));
    return query.watchSingleOrNull().map((row) => row?.idleMinutes ?? defaultIdleMinutes);
  }

  Future<void> setIdleMinutes(int minutes) {
    return database
        .into(database.zenSettingsTable)
        .insertOnConflictUpdate(ZenSettingsTableCompanion.insert(id: const Value(_id), idleMinutes: Value(minutes)));
  }
}

/// Providers
@Riverpod(keepAlive: true)
ZenSettingsRepository zenSettingsRepository(Ref ref) {
  return ZenSettingsRepository(database: ref.watch(appDatabaseProvider));
}
