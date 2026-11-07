import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

part 'floorplan.repository.g.dart';

/// Loads the floor plan. On first start it is seeded from the bundled editor export.
class FloorplanRepository {
  FloorplanRepository({required this.database, required this.assets});

  static const initialPlanAsset = 'assets/floorplan/floorplan.json';
  static const _planId = 1;

  final AppDatabase database;
  final AssetBundle assets;

  Future<FloorPlan> load() async {
    final table = database.floorPlansTable;
    final row = await (database.select(table)..where((t) => t.id.equals(_planId))).getSingleOrNull();
    final json = row?.json ?? await assets.loadString(initialPlanAsset);
    if (row == null) await database.into(table).insert(FloorPlanRow(id: _planId, json: json));
    return parse(jsonDecode(json) as Map<String, Object?>);
  }

  /// Stores [plan]; it replaces the bundled one from now on.
  Future<void> save(FloorPlan plan) async {
    await database.into(database.floorPlansTable).insertOnConflictUpdate(FloorPlanRow(id: _planId, json: encode(plan)));
  }

  /// [plan] as editor JSON (units: cm), readable for a backup.
  static String encode(FloorPlan plan) => const JsonEncoder.withIndent('  ').convert(toJson(plan));

  static Map<String, Object?> toJson(FloorPlan plan) => {
    'unit': 'cm',
    'rooms': [
      for (final room in plan.rooms) {'id': room.id, 'name': room.name, 'polygon': _polygonJson(room.polygon)},
    ],
    'walls': [
      for (final wall in plan.walls) {'id': wall.id, 'polygon': _polygonJson(wall.polygon)},
    ],
    'doors': [
      for (final door in plan.doors)
        {'id': door.id, 'type': door.type.name, 'a': _pointJson(door.a), 'b': _pointJson(door.b)},
    ],
  };

  static List<Object?> _polygonJson(List<PlanPoint> polygon) => [for (final point in polygon) _pointJson(point)];

  /// Whole centimeters stay integers, as in the editor export.
  static List<num> _pointJson(PlanPoint point) => [_number(point.x), _number(point.y)];

  static num _number(double value) => value == value.roundToDouble() ? value.toInt() : value;

  /// Parses the JSON export of the floor plan editor (units: cm).
  static FloorPlan parse(Map<String, Object?> json) {
    final unit = json['unit'] as String? ?? 'cm';
    if (unit != 'cm') throw FormatException('Unsupported floor plan unit "$unit"');

    List<Map<String, Object?>> list(String key) => (json[key] as List<Object?>? ?? const []).cast();

    return FloorPlan(
      rooms: [
        for (final room in list('rooms'))
          Room(id: room['id'] as String, name: room['name'] as String, polygon: _polygon(room['polygon'])),
      ],
      walls: [for (final wall in list('walls')) Wall(id: wall['id'] as String, polygon: _polygon(wall['polygon']))],
      doors: [
        for (final door in list('doors'))
          Door(
            id: door['id'] as String,
            type: DoorType.values.byName(door['type'] as String),
            a: _point(door['a']),
            b: _point(door['b']),
          ),
      ],
    );
  }

  static List<PlanPoint> _polygon(Object? json) => [for (final point in json as List<Object?>) _point(point)];

  static PlanPoint _point(Object? json) {
    final [x, y] = (json as List<Object?>).cast<num>();
    return PlanPoint(x.toDouble(), y.toDouble());
  }
}

/// Providers
@Riverpod(keepAlive: true)
FloorplanRepository floorplanRepository(Ref ref) {
  return FloorplanRepository(database: ref.watch(appDatabaseProvider), assets: rootBundle);
}
