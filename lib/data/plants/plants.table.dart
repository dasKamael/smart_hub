import 'package:drift/drift.dart';

@DataClassName('PlantRow')
class PlantsTable extends Table {
  @override
  String get tableName => 'plants';

  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get everyDays => integer()();

  DateTimeColumn get lastWatered => dateTime()();

  DateTimeColumn get previousWatered => dateTime().nullable()();

  TextColumn get photoPath => text().nullable()();

  /// Weeks between fertilizing in the growing season; `null` = not fertilized.
  IntColumn get fertilizeEveryWeeks => integer().nullable()();

  DateTimeColumn get lastFertilized => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
