import 'package:drift/drift.dart';

/// The widgets on the dashboard in their order.
@DataClassName('DashboardWidgetRow')
class DashboardWidgetsTable extends Table {
  @override
  String get tableName => 'dashboard_widgets';

  TextColumn get id => text()();

  /// `DashboardWidgetKind` name.
  TextColumn get kind => text()();

  /// `DashboardWidgetSize` name.
  TextColumn get size => text()();

  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
