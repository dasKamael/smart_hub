import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/wall_shape.util.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/furniture_meshes.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_solid.dart';

/// A 4 × 3 m room with an 80 cm door in its top wall at x = 100 and a window in the bottom wall at x = 200.
HomeLayout _room() {
  final walls = LayoutGraphUtil.addRectangle(const HomeLayout(), PlanPoint.zero, const PlanPoint(400, 300));
  final top = LayoutGraphUtil.wallAt(walls, const PlanPoint(200, 0), radius: 2)!;
  final bottom = LayoutGraphUtil.wallAt(walls, const PlanPoint(200, 300), radius: 2)!;
  final (topStart, _) = LayoutGraphUtil.endsOf(walls, top);
  final (bottomStart, _) = LayoutGraphUtil.endsOf(walls, bottom);
  return walls.copyWith(
    rooms: const [LayoutRoom(id: 'r', name: 'Bedroom', type: RoomType.bedroom, anchor: PlanPoint(200, 150))],
    openings: [
      LayoutOpening(
        id: 'd',
        wallId: top.id,
        type: DoorType.door,
        offset: topStart.distanceTo(const PlanPoint(100, 0)),
        width: 80,
      ),
      LayoutOpening(
        id: 'w',
        wallId: bottom.id,
        type: DoorType.window,
        offset: bottomStart.distanceTo(const PlanPoint(200, 300)),
        width: 100,
      ),
    ],
    furniture: const [
      Furniture(id: 'bed', kind: FurnitureKind.bed, position: PlanPoint(200, 120), width: 160, depth: 205),
      Furniture(id: 'rug', kind: FurnitureKind.rug, position: PlanPoint(200, 200), width: 200, depth: 140),
    ],
  );
}

bool _covers(SceneSolid solid, PlanPoint point) {
  final xs = solid.base.map((p) => p.x);
  final ys = solid.base.map((p) => p.y);
  return point.x > xs.reduce((a, b) => a < b ? a : b) &&
      point.x < xs.reduce((a, b) => a > b ? a : b) &&
      point.y > ys.reduce((a, b) => a < b ? a : b) - 1 &&
      point.y < ys.reduce((a, b) => a > b ? a : b) + 1;
}

void main() {
  group('HomeScene.of', () {
    test('Given a door, when building the scene, then the wall is open there all the way up', () {
      // When
      final scene = HomeScene.of(_room());

      // Then
      expect(scene.walls.where((solid) => solid.top > 0 && _covers(solid, const PlanPoint(100, 0))), isEmpty);
      expect(scene.walls.where((solid) => _covers(solid, const PlanPoint(200, 0))), isNotEmpty);
    });

    test('Given a passage leaving 10 cm of wall at its start, when building the scene, then that sliver is left out '
        'instead of standing as a post', () {
      // Given
      final layout = LayoutGraphUtil.addWall(const HomeLayout(), PlanPoint.zero, const PlanPoint(200, 0));
      final wall = layout.walls.single;
      final open = layout.copyWith(
        openings: [LayoutOpening(id: 'o', wallId: wall.id, type: DoorType.open, offset: 85, width: 150)],
      );

      // When
      final scene = HomeScene.of(open);

      // Then
      expect(scene.walls.where((solid) => _covers(solid, const PlanPoint(5, 0))), isEmpty);
      expect(scene.walls.where((solid) => _covers(solid, const PlanPoint(195, 0))), isNotEmpty);
    });

    test('Given a window, when building the scene, then there is a sill, glass and a lintel', () {
      // When
      final scene = HomeScene.of(_room());

      // Then
      final atWindow = scene.solids.where((solid) => _covers(solid, const PlanPoint(200, 300))).toList();
      expect(atWindow.where((solid) => solid.material == SceneMaterial.glass), hasLength(1));
      expect(atWindow.map((solid) => solid.bottom), containsAll([0, HomeScene.sillHeight, HomeScene.windowTop]));
    });

    test('Given pieces of a long wall, when building the scene, then only the ends at openings are drawn', () {
      // When
      final scene = HomeScene.of(_room());

      // Then
      final beforeDoor = scene.walls.where((solid) => _covers(solid, const PlanPoint(55, 0)) && solid.top > 200).single;
      expect(beforeDoor.hiddenSides, isNot(containsAll(WallShape.endSides)));
      final middle = scene.walls.where((solid) => _covers(solid, const PlanPoint(250, 0)) && solid.top > 200).single;
      expect(middle.hiddenSides, containsAll({...WallShape.startSides, ...WallShape.endSides}));
    });

    test('Given furniture and no models, when building the scene, then it is made of blocks and casts shadows', () {
      // When
      final scene = HomeScene.of(_room());

      // Then
      expect(scene.meshes, isEmpty);
      expect(scene.solids.length, greaterThan(scene.walls.length));
      expect(scene.footprints, hasLength(1));
    });

    test('Given the furniture models, when building the scene, then furniture with a model is drawn with it', () {
      // Given
      final library = FurnitureMeshLibrary.parse(File(FurnitureMeshLibrary.asset).readAsStringSync());

      // When
      final scene = HomeScene.of(_room(), library: library);

      // Then
      expect(scene.meshes.map((mesh) => mesh.item.id), containsAll(['bed', 'rug']));
      expect(scene.solids.length, scene.walls.length);
    });
  });
}
