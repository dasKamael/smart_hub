import 'package:drift/drift.dart';

/// Light scenes per room; a room without rows offers the templates.
@DataClassName('RoomSceneRow')
class RoomScenesTable extends Table {
  @override
  String get tableName => 'room_scenes';

  TextColumn get id => text()();
  TextColumn get roomId => text()();
  TextColumn get name => text()();
  IntColumn get position => integer()();
  IntColumn get brightnessPercent => integer()();

  /// `0xFFRRGGBB`.
  IntColumn get color => integer()();
  IntColumn get kelvin => integer()();

  /// `RoomScene.lights` as JSON: light id → {on, brightness, color, kelvin}.
  TextColumn get lights => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
