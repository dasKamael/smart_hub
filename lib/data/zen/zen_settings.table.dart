import 'package:drift/drift.dart';

/// Settings of the zen mode; a single row.
@DataClassName('ZenSettingsRow')
class ZenSettingsTable extends Table {
  @override
  String get tableName => 'zen_settings';

  IntColumn get id => integer()();

  /// Minutes without a touch until the zen mode starts; 0 = only by hand.
  IntColumn get idleMinutes => integer().withDefault(const Constant(5))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
