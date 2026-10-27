import 'package:drift/drift.dart';

/// Whether the dashboard was arranged once; a single row.
@DataClassName('DashboardStateRow')
class DashboardStateTable extends Table {
  @override
  String get tableName => 'dashboard_state';

  IntColumn get id => integer()();

  BoolColumn get arranged => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
