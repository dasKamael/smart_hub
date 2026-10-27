import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

part 'dashboard_layout.repository.g.dart';

class DashboardLayoutRepository {
  DashboardLayoutRepository({required this.database});

  final AppDatabase database;

  /// The widgets in their order; `null` before the dashboard was ever arranged. Rows of unknown kinds (e.g. from a
  /// newer app version) are left out.
  Future<List<DashboardWidget>?> load() async {
    final query = database.select(database.dashboardWidgetsTable)
      ..orderBy([(t) => OrderingTerm(expression: t.position)]);
    final rows = await query.get();
    if (rows.isEmpty && !await _arranged()) return null;
    return [
      for (final row in rows)
        if ((_kind(row.kind), _size(row.size)) case (final kind?, final size?))
          DashboardWidget(id: row.id, kind: kind, size: size, selection: _selection(row.selection), card: row.card),
    ];
  }

  /// Replaces the arrangement with [widgets] in this order.
  Future<void> save(List<DashboardWidget> widgets) {
    return database.transaction(() async {
      await database.delete(database.dashboardWidgetsTable).go();
      await database.batch((batch) {
        batch.insertAll(database.dashboardWidgetsTable, [
          for (final (position, widget) in widgets.indexed)
            DashboardWidgetsTableCompanion.insert(
              id: widget.id,
              kind: widget.kind.name,
              size: widget.size.name,
              position: position,
              selection: Value(widget.selection.isEmpty ? null : jsonEncode(widget.selection)),
              card: Value(widget.card),
            ),
        ]);
      });
      await _markArranged();
    });
  }

  // An emptied dashboard stays empty instead of getting the default widgets back.
  Future<bool> _arranged() async {
    final row = await (database.select(database.dashboardStateTable)..limit(1)).getSingleOrNull();
    return row?.arranged ?? false;
  }

  Future<void> _markArranged() {
    return database
        .into(database.dashboardStateTable)
        .insertOnConflictUpdate(DashboardStateTableCompanion.insert(id: const Value(0), arranged: const Value(true)));
  }

  static List<String> _selection(String? json) {
    if (json == null) return const [];
    return switch (jsonDecode(json)) {
      final List<Object?> ids => ids.whereType<String>().toList(),
      _ => const [],
    };
  }

  static DashboardWidgetKind? _kind(String name) =>
      DashboardWidgetKind.values.where((kind) => kind.name == name).firstOrNull;

  static DashboardWidgetSize? _size(String name) =>
      DashboardWidgetSize.values.where((size) => size.name == name).firstOrNull;
}

/// Providers
@Riverpod(keepAlive: true)
DashboardLayoutRepository dashboardLayoutRepository(Ref ref) {
  return DashboardLayoutRepository(database: ref.watch(appDatabaseProvider));
}
