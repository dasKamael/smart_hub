import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/furniture_models.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_solid.dart';

/// The floor of one room.
final class SceneFloor {
  const SceneFloor({required this.roomId, required this.outline, required this.material});

  final String roomId;
  final List<PlanPoint> outline;
  final SceneMaterial material;
}

/// A lamp shining into the 3D home: where it hangs, its color (0–1 per channel) and brightness (0–1).
final class SceneLight {
  const SceneLight({
    required this.position,
    required this.r,
    required this.g,
    required this.b,
    required this.brightness,
  });

  final PlanPoint position;
  final double r;
  final double g;
  final double b;
  final double brightness;
}

/// The apartment as 3D blocks: floors per room, walls cut open for doors and windows, and the furniture. Walls are
/// cut into short pieces so that drawing back to front stays right.
final class HomeScene {
  const HomeScene({required this.floors, required this.solids, required this.walls});

  /// Wall height in cm.
  static const wallHeight = 250.0;
  static const sillHeight = 95.0;
  static const windowTop = 212.0;

  /// The model stands on a slab this thick, seen below the outer walls.
  static const slabDepth = 14.0;

  /// Longest wall piece in cm.
  static const _piece = 35.0;

  final List<SceneFloor> floors;

  /// Everything standing on the floors: walls, glass and furniture.
  final List<SceneSolid> solids;

  /// The wall pieces among [solids], for lighting walls by the room they face.
  final Set<SceneSolid> walls;

  /// Every corner of the model, for fitting it into view.
  Iterable<(double, double, double)> get corners sync* {
    for (final solid in solids) {
      for (final point in solid.base) {
        yield (point.x, point.y, solid.bottom);
        yield (point.x, point.y, solid.top);
      }
    }
    for (final floor in floors) {
      for (final point in floor.outline) {
        yield (point.x, point.y, 0);
      }
    }
  }

  static HomeScene of(HomeLayout layout) {
    final outlines = LayoutRoomsUtil.outlines(layout);
    final floors = [
      for (final room in layout.rooms)
        if (outlines[room.id] case final outline?)
          SceneFloor(roomId: room.id, outline: outline, material: _floorOf(room.type)),
    ];
    final walls = <SceneSolid>[];
    final positions = {for (final node in layout.nodes) node.id: node.position};
    for (final wall in layout.walls) {
      walls.addAll(_wallPieces(layout, wall, positions[wall.from]!, positions[wall.to]!));
    }
    for (final node in layout.nodes) {
      final attached = layout.walls.where((wall) => wall.from == node.id || wall.to == node.id).toList();
      if (attached.isEmpty) continue;
      walls.add(_pillar(node.position, attached, positions));
    }
    final furniture = [for (final item in layout.furniture) ...FurnitureModels.solidsOf(item)];
    return HomeScene(floors: floors, solids: [...walls, ...furniture], walls: walls.toSet());
  }

  static SceneMaterial _floorOf(RoomType type) => switch (type) {
    RoomType.bathroom || RoomType.wc => SceneMaterial.floorTile,
    RoomType.balcony => SceneMaterial.floorStone,
    _ => SceneMaterial.floorWood,
  };

  static List<SceneSolid> _wallPieces(HomeLayout layout, LayoutWall wall, PlanPoint a, PlanPoint b) {
    final length = a.distanceTo(b);
    if (length < 1) return const [];
    final u = PlanPoint((b.x - a.x) / length, (b.y - a.y) / length);
    final n = PlanPoint(-u.y * wall.thickness / 2, u.x * wall.thickness / 2);
    final openings = [
      for (final opening in layout.openings)
        if (opening.wallId == wall.id) opening,
    ]..sort((x, y) => x.offset.compareTo(y.offset));

    final pieces = <SceneSolid>[];
    void add(
      double from,
      double to,
      double bottom,
      double top,
      SceneMaterial material, {
      double thin = 1,
      bool jambs = true,
    }) {
      if (to - from < 0.5 || top - bottom < 0.5) return;
      final count = math.max(1, ((to - from) / _piece).ceil());
      final half = PlanPoint(n.x * thin, n.y * thin);
      for (var i = 0; i < count; i++) {
        final s = from + (to - from) * i / count;
        final e = from + (to - from) * (i + 1) / count;
        final p = PlanPoint(a.x + u.x * s, a.y + u.y * s);
        final q = PlanPoint(a.x + u.x * e, a.y + u.y * e);
        pieces.add(
          SceneSolid(
            base: [p - half, q - half, q + half, p + half],
            bottom: bottom,
            top: top,
            material: material,
            // Ends inside the wall – against the next piece or the corner block at a junction – are not drawn; the
            // ends at a door or window are.
            hiddenSides: {if (i < count - 1 || to > length - 0.5 || !jambs) 1, if (i > 0 || from < 0.5 || !jambs) 3},
          ),
        );
      }
    }

    var cursor = 0.0;
    for (final opening in openings) {
      final start = (opening.offset - opening.width / 2).clamp(0.0, length);
      final end = (opening.offset + opening.width / 2).clamp(0.0, length);
      add(cursor, start, 0, wallHeight, SceneMaterial.wall);
      switch (opening.type) {
        case DoorType.door:
        case DoorType.open:
          // Cut open to the top, as a model house: the room behind stays visible.
          break;
        case DoorType.window:
          add(start, end, 0, sillHeight, SceneMaterial.wall, jambs: false);
          add(start, end, windowTop, wallHeight, SceneMaterial.wall, jambs: false);
          add(start, end, sillHeight, windowTop, SceneMaterial.glass, thin: 0.25, jambs: false);
      }
      cursor = math.max(cursor, end);
    }
    add(cursor, length, 0, wallHeight, SceneMaterial.wall);
    if (wall.thickness >= LayoutWall.outerThickness) add(0, length, -slabDepth, 0, SceneMaterial.slab, jambs: false);
    return pieces;
  }

  /// Fills the corner where walls meet with a block as thick as the thickest of them.
  static SceneSolid _pillar(PlanPoint at, List<LayoutWall> attached, Map<String, PlanPoint> positions) {
    final thickest = attached.reduce((x, y) => x.thickness >= y.thickness ? x : y);
    final from = positions[thickest.from]!;
    final to = positions[thickest.to]!;
    final length = from.distanceTo(to);
    final u = length == 0 ? const PlanPoint(1, 0) : PlanPoint((to.x - from.x) / length, (to.y - from.y) / length);
    final h = thickest.thickness / 2;
    final x = PlanPoint(u.x * h, u.y * h);
    final y = PlanPoint(-u.y * h, u.x * h);
    return SceneSolid(
      base: [at - x - y, at + x - y, at + x + y, at - x + y],
      bottom: 0,
      top: wallHeight,
      material: SceneMaterial.wall,
    );
  }
}
