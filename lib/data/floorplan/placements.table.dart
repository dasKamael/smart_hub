import 'package:drift/drift.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';

/// Devices placed on the plan. Position in cm; the room is derived, never stored.
@DataClassName('PlacementRow')
class PlacementsTable extends Table {
  @override
  String get tableName => 'placements';

  TextColumn get deviceId => text()();

  TextColumn get kind => textEnum<DeviceKind>()();

  RealColumn get x => real()();

  RealColumn get y => real()();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}
