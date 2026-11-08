import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_solid.dart';

/// A block of a furniture model, in the piece's own frame at its usual size: x across ([FurnitureKind.width]),
/// y from the back (0) to the front ([FurnitureKind.depth]), z up from the floor. All in cm.
final class _Block {
  const _Block(this.x0, this.y0, this.x1, this.y1, this.z0, this.z1, this.material);

  final double x0;
  final double y0;
  final double x1;
  final double y1;
  final double z0;
  final double z1;
  final SceneMaterial material;
}

/// Simple block models of the furniture, for the 3D home and the editor's top view.
abstract final class FurnitureModels {
  /// [item] as solids on the plan: its model stretched to the item's size, turned and moved into place.
  static List<SceneSolid> solidsOf(Furniture item) {
    final kind = item.kind;
    final sx = item.width / kind.width;
    final sy = item.depth / kind.depth;
    final angle = item.rotation * math.pi / 180;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    PlanPoint place(double x, double y) {
      final lx = x * sx - item.width / 2;
      final ly = y * sy - item.depth / 2;
      return PlanPoint(item.position.x + lx * cos - ly * sin, item.position.y + lx * sin + ly * cos);
    }

    return [
      for (final block in _blocks(kind))
        SceneSolid(
          base: [
            place(block.x0, block.y0),
            place(block.x1, block.y0),
            place(block.x1, block.y1),
            place(block.x0, block.y1),
          ],
          bottom: block.z0,
          top: block.z1,
          material: block.material,
        ),
    ];
  }

  static List<_Block> _blocks(FurnitureKind kind) {
    final w = kind.width;
    final d = kind.depth;
    final h = kind.height;
    List<_Block> legs(double inset, double size, double z1, SceneMaterial material) => [
      _Block(inset, inset, inset + size, inset + size, 0, z1, material),
      _Block(w - inset - size, inset, w - inset, inset + size, 0, z1, material),
      _Block(inset, d - inset - size, inset + size, d - inset, 0, z1, material),
      _Block(w - inset - size, d - inset - size, w - inset, d - inset, 0, z1, material),
    ];

    switch (kind) {
      case FurnitureKind.bed:
      case FurnitureKind.singleBed:
        final pillows = kind == FurnitureKind.bed
            ? [
                _Block(12, 14, w / 2 - 5, 52, 46, 58, SceneMaterial.pillow),
                _Block(w / 2 + 5, 14, w - 12, 52, 46, 58, SceneMaterial.pillow),
              ]
            : [_Block(12, 14, w - 12, 52, 46, 58, SceneMaterial.pillow)];
        return [
          _Block(0, 0, w, d, 0, 28, SceneMaterial.woodDark),
          _Block(0, 0, w, 7, 0, 95, SceneMaterial.woodDark),
          _Block(3, 7, w - 3, d - 3, 28, 46, SceneMaterial.linen),
          ...pillows,
          _Block(1, d * 0.38, w - 1, d - 1, 28, 50, SceneMaterial.fabric),
        ];
      case FurnitureKind.nightstand:
        return [
          _Block(0, 0, w, d, 0, h, SceneMaterial.wood),
          _Block(w / 2 - 7, d / 2 - 7, w / 2 + 7, d / 2 + 7, h, h + 22, SceneMaterial.lampShade),
        ];
      case FurnitureKind.wardrobe:
        return [
          _Block(0, 0, w / 2 - 0.5, d, 0, h, SceneMaterial.woodLight),
          _Block(w / 2 + 0.5, 0, w, d, 0, h, SceneMaterial.woodLight),
        ];
      case FurnitureKind.dresser:
        return [_Block(0, 0, w, d, 0, h, SceneMaterial.wood)];
      case FurnitureKind.sofa:
      case FurnitureKind.armchair:
        final material = kind == FurnitureKind.armchair ? SceneMaterial.fabricRed : SceneMaterial.fabric;
        final arm = kind == FurnitureKind.armchair ? 14.0 : 18.0;
        return [
          _Block(0, 8, w, d, 0, 40, material),
          _Block(0, 0, w, 22, 0, h, material),
          _Block(0, 0, arm, d, 0, 60, material),
          _Block(w - arm, 0, w, d, 0, 60, material),
          _Block(
            arm,
            22,
            w - arm,
            d - 2,
            40,
            48,
            kind == FurnitureKind.armchair ? material : SceneMaterial.fabricLight,
          ),
        ];
      case FurnitureKind.coffeeTable:
        return [...legs(4, 4, h - 4, SceneMaterial.steel), _Block(0, 0, w, d, h - 4, h, SceneMaterial.wood)];
      case FurnitureKind.tvUnit:
        return [
          _Block(0, 0, w, d, 0, 45, SceneMaterial.woodDark),
          _Block(w * 0.12, d * 0.35, w * 0.88, d * 0.5, 45, 118, SceneMaterial.screen),
        ];
      case FurnitureKind.rug:
        return [_Block(0, 0, w, d, 0, 1, SceneMaterial.rug)];
      case FurnitureKind.diningTable:
        return [...legs(6, 5, h - 4, SceneMaterial.woodDark), _Block(0, 0, w, d, h - 4, h, SceneMaterial.wood)];
      case FurnitureKind.chair:
        return [
          ...legs(3, 3, 42, SceneMaterial.black),
          _Block(0, 0, w, d, 42, 47, SceneMaterial.fabricDark),
          _Block(0, 0, w, 5, 47, h, SceneMaterial.fabricDark),
        ];
      case FurnitureKind.desk:
        return [
          _Block(0, 0, 4, d, 0, h - 3, SceneMaterial.white),
          _Block(w - 4, 0, w, d, 0, h - 3, SceneMaterial.white),
          _Block(0, 0, w, d, h - 3, h, SceneMaterial.woodLight),
          _Block(w * 0.3, 6, w * 0.7, 10, h, h + 38, SceneMaterial.screen),
        ];
      case FurnitureKind.officeChair:
        return [
          _Block(w / 2 - 4, d / 2 - 4, w / 2 + 4, d / 2 + 4, 0, 42, SceneMaterial.steel),
          _Block(8, 10, w - 8, d - 6, 42, 52, SceneMaterial.fabricDark),
          _Block(10, 2, w - 10, 10, 52, h, SceneMaterial.fabricDark),
        ];
      case FurnitureKind.shelf:
        return [_Block(0, 0, w, d, 0, h, SceneMaterial.woodLight)];
      case FurnitureKind.counter:
        return [
          _Block(0, 0, w, d - 2, 0, h - 4, SceneMaterial.white),
          _Block(0, 0, w, d, h - 4, h, SceneMaterial.counterTop),
        ];
      case FurnitureKind.fridge:
        return [_Block(0, 0, w, d, 0, h, SceneMaterial.steel)];
      case FurnitureKind.toilet:
        return [
          _Block(4, 0, w - 4, 18, 0, h, SceneMaterial.white),
          _Block(6, 18, w - 6, d, 0, 40, SceneMaterial.white),
        ];
      case FurnitureKind.washbasin:
        return [
          _Block(0, 0, w, d, 0, h - 8, SceneMaterial.wood),
          _Block(0, 0, w, d, h - 8, h, SceneMaterial.white),
          _Block(8, 8, w - 8, d - 8, h - 1, h + 0.5, SceneMaterial.basinInner),
        ];
      case FurnitureKind.shower:
        return [
          _Block(0, 0, w, d, 0, 5, SceneMaterial.white),
          _Block(0, d - 1, w, d, 5, h, SceneMaterial.glass),
          _Block(w - 1, 0, w, d, 5, h, SceneMaterial.glass),
        ];
      case FurnitureKind.bathtub:
        return [
          _Block(0, 0, w, d, 0, h, SceneMaterial.white),
          _Block(7, 7, w - 7, d - 7, h - 1, h + 0.5, SceneMaterial.basinInner),
        ];
      case FurnitureKind.washingMachine:
        return [_Block(0, 0, w, d, 0, h, SceneMaterial.white)];
      case FurnitureKind.coatRack:
        return [
          _Block(0, 0, w, 4, 95, h, SceneMaterial.wood),
          _Block(0, 0, w, d, 40, 45, SceneMaterial.wood),
          _Block(0, 0, 4, d, 0, 40, SceneMaterial.wood),
          _Block(w - 4, 0, w, d, 0, 40, SceneMaterial.wood),
        ];
      case FurnitureKind.plant:
        return [
          _Block(w * 0.22, d * 0.22, w * 0.78, d * 0.78, 0, 32, SceneMaterial.pot),
          _Block(0, 0, w, d, 32, h * 0.72, SceneMaterial.leaf),
          _Block(w * 0.18, d * 0.18, w * 0.82, d * 0.82, h * 0.72, h, SceneMaterial.leaf),
        ];
      case FurnitureKind.floorLamp:
        return [
          _Block(w * 0.15, d * 0.15, w * 0.85, d * 0.85, 0, 3, SceneMaterial.steel),
          _Block(w / 2 - 1.5, d / 2 - 1.5, w / 2 + 1.5, d / 2 + 1.5, 3, h - 25, SceneMaterial.steel),
          _Block(0, 0, w, d, h - 25, h, SceneMaterial.lampShade),
        ];
    }
  }
}
