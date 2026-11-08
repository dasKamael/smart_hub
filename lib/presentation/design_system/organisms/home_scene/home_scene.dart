import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/furnishing.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/wall_shape.util.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/furniture_meshes.dart';
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

  @override
  bool operator ==(Object other) =>
      other is SceneLight &&
      other.position == position &&
      other.r == r &&
      other.g == g &&
      other.b == b &&
      other.brightness == brightness;

  @override
  int get hashCode => Object.hash(position, r, g, b, brightness);
}

/// The apartment as 3D blocks: floors per room, walls cut open for doors and windows, and the furniture. Walls are
/// cut into short pieces so that drawing back to front stays right.
final class HomeScene {
  const HomeScene({
    required this.floors,
    required this.solids,
    required this.walls,
    this.meshes = const [],
    this.footprints = const [],
  });

  /// Wall height in cm.
  static const wallHeight = 250.0;
  static const sillHeight = 95.0;
  static const windowTop = 212.0;

  /// Outer walls facing the viewer are lowered to this height, to see into the rooms behind them.
  static const loweredHeight = 45.0;

  /// The model stands on a slab this thick, seen below the outer walls.
  static const slabDepth = 14.0;

  /// Longest wall piece in cm.
  static const _piece = 35.0;

  final List<SceneFloor> floors;

  /// Everything standing on the floors: walls, glass and furniture.
  final List<SceneSolid> solids;

  /// The wall pieces among [solids], for lighting walls by the room they face.
  final Set<SceneSolid> walls;

  /// Furniture with a model, as triangles.
  final List<SceneMesh> meshes;

  /// Where furniture stands, for the shadow it casts onto the floor right under it.
  final List<List<PlanPoint>> footprints;

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
    // Furniture by its outline and height; its many corners would only slow fitting down.
    for (final mesh in meshes) {
      for (final corner in FurnishingUtil.cornersOf(mesh.item)) {
        yield (corner.x, corner.y, 0);
        yield (corner.x, corner.y, mesh.item.kind.height);
      }
    }
  }

  /// The scene of [layout]; furniture with a model in [library] is drawn with it, the rest as blocks.
  static HomeScene of(HomeLayout layout, {FurnitureMeshLibrary? library}) {
    final outlines = LayoutRoomsUtil.outlines(layout);
    final floors = [
      for (final room in layout.rooms)
        if (outlines[room.id] case final outline?)
          SceneFloor(roomId: room.id, outline: outline, material: _floorOf(room.type)),
    ];
    final walls = <SceneSolid>[];
    final shapes = WallShapeUtil.shapesOf(layout);
    for (final wall in layout.walls) {
      if (shapes[wall.id] case final shape?) walls.addAll(_wallPieces(layout, wall, shape));
    }
    final meshes = <SceneMesh>[];
    final blocks = <SceneSolid>[];
    for (final item in layout.furniture) {
      if (library?.meshOf(item) case final mesh?) {
        meshes.add(mesh);
      } else {
        blocks.addAll(FurnitureModels.solidsOf(item));
      }
    }
    return HomeScene(
      floors: floors,
      solids: [...walls, ...blocks],
      walls: walls.toSet(),
      meshes: meshes,
      footprints: [
        for (final item in layout.furniture)
          if (!item.kind.isFlat) FurnishingUtil.cornersOf(item),
      ],
    );
  }

  static SceneMaterial _floorOf(RoomType type) => switch (type) {
    RoomType.bathroom || RoomType.wc => SceneMaterial.floorTile,
    RoomType.balcony => SceneMaterial.floorStone,
    _ => SceneMaterial.floorWood,
  };

  static List<SceneSolid> _wallPieces(HomeLayout layout, LayoutWall wall, WallShape shape) {
    final length = shape.length;
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
      bool pane = false,
      bool jambs = true,
    }) {
      if (to - from < 0.5 || top - bottom < 0.5) return;
      final count = math.max(1, ((to - from) / _piece).ceil());
      // Glass is a thin pane in the middle of the wall.
      final middle = (shape.left - shape.right) / 2;
      for (var i = 0; i < count; i++) {
        final s = from + (to - from) * i / count;
        final e = from + (to - from) * (i + 1) / count;
        final atStart = i == 0 && s < 0.5;
        final atEnd = i == count - 1 && e > length - 0.5;
        pieces.add(
          SceneSolid(
            base: pane ? shape.section(s, e, right: 1 - middle, left: 1 + middle) : shape.section(s, e),
            bottom: bottom,
            top: top,
            material: material,
            // Ends inside the wall – against the next piece, or joined to other walls at a junction – are not
            // drawn; free ends and the ends at a door or window (jambs) are.
            hiddenSides: {
              if (i < count - 1 || !jambs || atEnd && shape.end != null) ...WallShape.endSides,
              if (i > 0 || !jambs || atStart && shape.start != null) ...WallShape.startSides,
            },
            outside: shape.outside,
            nodeEnds: {
              if (atEnd)
                for (final side in WallShape.endSides) side: wall.to,
              if (atStart)
                for (final side in WallShape.startSides) side: wall.from,
            },
          ),
        );
      }
    }

    var cursor = 0.0;
    for (final opening in openings) {
      final from = (opening.offset - opening.width / 2).clamp(0.0, length);
      final to = (opening.offset + opening.width / 2).clamp(0.0, length);
      add(cursor, from, 0, wallHeight, SceneMaterial.wall);
      if (opening.type == DoorType.window) {
        add(from, to, 0, sillHeight, SceneMaterial.wall, jambs: false);
        add(from, to, windowTop, wallHeight, SceneMaterial.wall, jambs: false);
        add(from, to, sillHeight, windowTop, SceneMaterial.glass, pane: true, jambs: false);
      }
      cursor = math.max(cursor, to);
    }
    add(cursor, length, 0, wallHeight, SceneMaterial.wall);
    if (shape.outside != null) add(0, length, -slabDepth, 0, SceneMaterial.slab, jambs: false);
    return pieces;
  }
}
