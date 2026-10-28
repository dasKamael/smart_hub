import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';

part 'focus.repository.g.dart';

class FocusRepository {
  FocusRepository({required this.database});

  final AppDatabase database;

  $FocusPointsTableTable get _table => database.focusPointsTable;

  Stream<List<FocusPoint>> watchAll() {
    return (database.select(
      _table,
    )..orderBy([(t) => OrderingTerm(expression: t.position)])).watch().map((rows) => rows.map(_toPoint).toList());
  }

  Future<List<FocusPoint>> all() async {
    final rows = await (database.select(_table)..orderBy([(t) => OrderingTerm(expression: t.position)])).get();
    return rows.map(_toPoint).toList();
  }

  Future<void> save(FocusPoint point) => database.into(_table).insertOnConflictUpdate(_toCompanion(point));

  Future<void> saveAll(Iterable<FocusPoint> points) {
    return database.batch((batch) => batch.insertAllOnConflictUpdate(_table, points.map(_toCompanion)));
  }

  Future<void> delete(String id) => (database.delete(_table)..where((t) => t.id.equals(id))).go();

  static FocusPoint _toPoint(FocusPointRow row) {
    return FocusPoint(
      id: row.id,
      title: row.title,
      dueDate: row.dueDate,
      createdAt: row.createdAt,
      position: row.position,
      achievedAt: row.achievedAt,
    );
  }

  /// `nullToAbsent: false`: an upsert must clear fields that became `null` again, e.g. a point taken back up.
  static FocusPointsTableCompanion _toCompanion(FocusPoint point) {
    return FocusPointRow(
      id: point.id,
      title: point.title,
      dueDate: point.dueDate,
      createdAt: point.createdAt,
      position: point.position,
      achievedAt: point.achievedAt,
    ).toCompanion(false);
  }
}

/// Providers
@Riverpod(keepAlive: true)
FocusRepository focusRepository(Ref ref) => FocusRepository(database: ref.watch(appDatabaseProvider));
