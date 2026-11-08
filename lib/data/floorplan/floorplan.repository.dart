import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';

part 'floorplan.repository.g.dart';

/// What is stored: the apartment drawn with walls, or a plan in the first format (room outlines) that still has to
/// be turned into walls. On first start that is the bundled plan.
sealed class StoredPlan {
  const StoredPlan();
}

final class StoredLayout extends StoredPlan {
  const StoredLayout(this.layout);

  final HomeLayout layout;
}

final class StoredOutlines extends StoredPlan {
  const StoredOutlines(this.plan);

  final FloorPlan plan;
}

/// Loads and stores the apartment as JSON in one row (units: cm).
class FloorplanRepository {
  FloorplanRepository({required this.database, required this.assets});

  static const initialPlanAsset = 'assets/floorplan/floorplan.json';
  static const format = 'smart-hub-home';
  static const version = 2;
  static const _planId = 1;

  /// Row keeping the plan as it was before it was turned into walls, in case the conversion lost something.
  static const _backupId = 2;

  final AppDatabase database;
  final AssetBundle assets;

  Future<StoredPlan> load() async {
    final table = database.floorPlansTable;
    final row = await (database.select(table)..where((t) => t.id.equals(_planId))).getSingleOrNull();
    final json = jsonDecode(row?.json ?? await assets.loadString(initialPlanAsset)) as Map<String, Object?>;
    return json['format'] == format ? StoredLayout(parseLayout(json)) : StoredOutlines(parse(json));
  }

  /// Stores [layout]; it replaces whatever was stored before. With [keepPrevious], the stored plan it replaces is
  /// kept as a backup first (see [loadBackup]).
  Future<void> save(HomeLayout layout, {bool keepPrevious = false}) async {
    final table = database.floorPlansTable;
    await database.transaction(() async {
      if (keepPrevious) {
        final previous = await (database.select(table)..where((t) => t.id.equals(_planId))).getSingleOrNull();
        if (previous != null) {
          await database.into(table).insertOnConflictUpdate(FloorPlanRow(id: _backupId, json: previous.json));
        }
      }
      await database.into(table).insertOnConflictUpdate(FloorPlanRow(id: _planId, json: encode(layout)));
    });
  }

  /// The JSON of the plan kept by `save(…, keepPrevious: true)`, or `null` when none was kept.
  Future<String?> loadBackup() async {
    final table = database.floorPlansTable;
    return (await (database.select(table)..where((t) => t.id.equals(_backupId))).getSingleOrNull())?.json;
  }

  /// [layout] as readable JSON, e.g. for a backup.
  static String encode(HomeLayout layout) => const JsonEncoder.withIndent('  ').convert(toJson(layout));

  static Map<String, Object?> toJson(HomeLayout layout) => {
    'format': format,
    'version': version,
    'unit': 'cm',
    'nodes': [
      for (final node in layout.nodes) {'id': node.id, 'at': _pointJson(node.position)},
    ],
    'walls': [
      for (final wall in layout.walls)
        {'id': wall.id, 'from': wall.from, 'to': wall.to, 'thickness': _number(wall.thickness)},
    ],
    'openings': [
      for (final opening in layout.openings)
        {
          'id': opening.id,
          'wall': opening.wallId,
          'type': opening.type.name,
          'offset': _number(opening.offset),
          'width': _number(opening.width),
          if (opening.swing != 0) 'swing': opening.swing,
        },
    ],
    'rooms': [
      for (final room in layout.rooms)
        {'id': room.id, 'name': room.name, 'type': room.type.name, 'anchor': _pointJson(room.anchor)},
    ],
    'furniture': [
      for (final item in layout.furniture)
        {
          'id': item.id,
          'kind': item.kind.name,
          'at': _pointJson(item.position),
          'rotation': _number(item.rotation),
          'width': _number(item.width),
          'depth': _number(item.depth),
        },
    ],
  };

  /// Parses the JSON written by [toJson]. Entries of unknown kinds are skipped.
  static HomeLayout parseLayout(Map<String, Object?> json) {
    List<Map<String, Object?>> list(String key) => (json[key] as List<Object?>? ?? const []).cast();
    double number(Object? value) => (value as num).toDouble();
    T? byName<T extends Enum>(List<T> values, Object? name) => values.where((value) => value.name == name).firstOrNull;

    return HomeLayout(
      nodes: [for (final node in list('nodes')) LayoutNode(id: node['id'] as String, position: _point(node['at']))],
      walls: [
        for (final wall in list('walls'))
          LayoutWall(
            id: wall['id'] as String,
            from: wall['from'] as String,
            to: wall['to'] as String,
            thickness: number(wall['thickness'] ?? LayoutWall.innerThickness),
          ),
      ],
      openings: [
        for (final opening in list('openings'))
          if (byName(DoorType.values, opening['type']) case final type?)
            LayoutOpening(
              id: opening['id'] as String,
              wallId: opening['wall'] as String,
              type: type,
              offset: number(opening['offset']),
              width: number(opening['width']),
              swing: (opening['swing'] as num?)?.toInt() ?? 0,
            ),
      ],
      rooms: [
        for (final room in list('rooms'))
          LayoutRoom(
            id: room['id'] as String,
            name: room['name'] as String,
            type: byName(RoomType.values, room['type']) ?? RoomType.other,
            anchor: _point(room['anchor']),
          ),
      ],
      furniture: [
        for (final item in list('furniture'))
          if (byName(FurnitureKind.values, item['kind']) case final kind?)
            Furniture(
              id: item['id'] as String,
              kind: kind,
              position: _point(item['at']),
              rotation: number(item['rotation'] ?? 0),
              width: number(item['width'] ?? kind.width),
              depth: number(item['depth'] ?? kind.depth),
            ),
      ],
    );
  }

  /// Parses the first format: room outlines and door segments (units: cm).
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

  /// Whole centimeters stay integers; the rest is kept to the millimeter.
  static List<num> _pointJson(PlanPoint point) => [_number(point.x), _number(point.y)];

  static num _number(double value) {
    final rounded = (value * 10).round() / 10;
    return rounded == rounded.roundToDouble() ? rounded.toInt() : rounded;
  }
}

/// Providers
@Riverpod(keepAlive: true)
FloorplanRepository floorplanRepository(Ref ref) {
  return FloorplanRepository(database: ref.watch(appDatabaseProvider), assets: rootBundle);
}
