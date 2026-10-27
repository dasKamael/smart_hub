import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

part 'placement.repository.g.dart';

/// Stores where devices are placed on the plan.
class PlacementRepository {
  PlacementRepository({required this.database});

  final AppDatabase database;

  $PlacementsTableTable get _table => database.placementsTable;

  Stream<List<Placement>> watchAll() => database.select(_table).watch().map((rows) => rows.map(_toPlacement).toList());

  Future<List<Placement>> all() async => (await database.select(_table).get()).map(_toPlacement).toList();

  Future<void> save(Placement placement) => database.into(_table).insertOnConflictUpdate(_toRow(placement));

  Future<void> saveAll(Iterable<Placement> placements) {
    return database.batch((batch) => batch.insertAllOnConflictUpdate(_table, placements.map(_toRow)));
  }

  Future<void> remove(String deviceId) => (database.delete(_table)..where((t) => t.deviceId.equals(deviceId))).go();

  static Placement _toPlacement(PlacementRow row) {
    return Placement(deviceId: row.deviceId, kind: row.kind, position: PlanPoint(row.x, row.y));
  }

  static PlacementRow _toRow(Placement placement) {
    return PlacementRow(
      deviceId: placement.deviceId,
      kind: placement.kind,
      x: placement.position.x,
      y: placement.position.y,
    );
  }
}

/// Providers
@Riverpod(keepAlive: true)
PlacementRepository placementRepository(Ref ref) {
  return PlacementRepository(database: ref.watch(appDatabaseProvider));
}
