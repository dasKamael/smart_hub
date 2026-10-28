import 'package:drift/drift.dart';

@DataClassName('FocusPointRow')
class FocusPointsTable extends Table {
  @override
  String get tableName => 'focus_points';

  TextColumn get id => text()();

  TextColumn get title => text()();

  /// The day it has to be done, local midnight.
  DateTimeColumn get dueDate => dateTime()();

  /// Order in the widget, smallest first.
  IntColumn get position => integer()();

  DateTimeColumn get createdAt => dateTime()();

  /// Done; the point moves out of the active three.
  DateTimeColumn get achievedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
