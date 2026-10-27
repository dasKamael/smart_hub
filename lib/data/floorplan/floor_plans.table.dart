import 'package:drift/drift.dart';

/// The floor plan as editor JSON (units: cm). One row with id 1 for now.
@DataClassName('FloorPlanRow')
class FloorPlansTable extends Table {
  @override
  String get tableName => 'floor_plans';

  IntColumn get id => integer()();

  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
