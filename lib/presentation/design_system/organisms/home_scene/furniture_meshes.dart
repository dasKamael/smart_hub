import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';

part 'furniture_meshes.g.dart';

/// A furniture model from the Kenney Furniture Kit (CC0, `assets/furniture/`): corners normalized to 0–1 in the
/// piece's frame (x across, y from the back to the front, z up), triangles, and a color per triangle.
final class FurnitureMesh {
  const FurnitureMesh({required this.positions, required this.triangles, required this.triangleColors});

  final Float32List positions;
  final Uint16List triangles;
  final List<Color> triangleColors;
}

/// One model placed in a piece of furniture: within [x0]–[x1] across and [y0]–[y1] from back to front (fractions of
/// the piece), from [z0] to [z1] cm above the floor.
final class MeshPart {
  const MeshPart(this.model, {this.x0 = 0, this.x1 = 1, this.y0 = 0, this.y1 = 1, required this.z0, required this.z1});

  final String model;
  final double x0;
  final double x1;
  final double y0;
  final double y1;
  final double z0;
  final double z1;
}

/// Triangles of a placed piece of furniture in plan coordinates (cm), ready to draw.
final class SceneMesh {
  const SceneMesh({required this.item, required this.positions, required this.triangles, required this.colors});

  final Furniture item;

  /// x, y, z of every corner, one after another.
  final Float32List positions;
  final Uint16List triangles;

  /// Color of every triangle.
  final List<Color> colors;
}

/// The furniture models, loaded once.
final class FurnitureMeshLibrary {
  const FurnitureMeshLibrary(this.models);

  static const asset = 'assets/furniture/furniture_models.json';

  final Map<String, FurnitureMesh> models;

  static FurnitureMeshLibrary parse(String json) {
    final data = jsonDecode(json) as Map<String, Object?>;
    final models = (data['models']! as Map<String, Object?>).cast<String, Map<String, Object?>>();
    return FurnitureMeshLibrary({
      for (final MapEntry(key: name, value: model) in models.entries)
        name: FurnitureMesh(
          positions: Float32List.fromList([
            for (final v in model['positions']! as List<Object?>) (v! as num).toDouble(),
          ]),
          triangles: Uint16List.fromList([for (final i in model['triangles']! as List<Object?>) i! as int]),
          triangleColors: () {
            final palette = [for (final color in model['colors']! as List<Object?>) _color(color)];
            return [for (final i in model['triangleColors']! as List<Object?>) palette[i! as int]];
          }(),
        ),
    });
  }

  static Color _color(Object? json) {
    final [r, g, b] = [for (final value in json! as List<Object?>) (value! as num).toDouble()];
    return Color.from(alpha: 1, red: r, green: g, blue: b);
  }

  /// The models making up a piece of [kind] that is [width] cm wide; `null` when there is none, so the block model
  /// is used.
  static List<MeshPart>? partsOf(FurnitureKind kind, double width) {
    final h = kind.height;
    return switch (kind) {
      FurnitureKind.bed => [MeshPart('bedDouble', z0: 0, z1: h + 15)],
      FurnitureKind.singleBed => [MeshPart('bedSingle', z0: 0, z1: h + 15)],
      FurnitureKind.nightstand => [
        MeshPart('cabinetBedDrawer', z0: 0, z1: h),
        MeshPart('lampRoundTable', x0: 0.25, x1: 0.75, y0: 0.2, y1: 0.8, z0: h, z1: h + 35),
      ],
      FurnitureKind.wardrobe => [MeshPart('bookcaseClosedDoors', z0: 0, z1: h)],
      FurnitureKind.dresser => [MeshPart('sideTableDrawers', z0: 0, z1: h)],
      FurnitureKind.sofa => [MeshPart('loungeSofa', z0: 0, z1: h)],
      FurnitureKind.armchair => [MeshPart('loungeChair', z0: 0, z1: h)],
      FurnitureKind.coffeeTable => [MeshPart('tableCoffee', z0: 0, z1: h)],
      FurnitureKind.tvUnit => [
        MeshPart('cabinetTelevision', z0: 0, z1: 45),
        MeshPart('televisionModern', x0: 0.12, x1: 0.88, y0: 0.2, y1: 0.7, z0: 45, z1: 115),
      ],
      FurnitureKind.rug => [MeshPart('rugRectangle', z0: 0, z1: 1)],
      FurnitureKind.diningTable => [MeshPart('table', z0: 0, z1: h)],
      FurnitureKind.chair => [MeshPart('chair', z0: 0, z1: h)],
      FurnitureKind.desk => [
        MeshPart('desk', z0: 0, z1: h),
        MeshPart('computerScreen', x0: 0.3, x1: 0.7, y0: 0.05, y1: 0.35, z0: h, z1: h + 40),
      ],
      FurnitureKind.officeChair => [MeshPart('chairDesk', z0: 0, z1: h)],
      FurnitureKind.shelf => [MeshPart('bookcaseOpen', z0: 0, z1: h)],
      FurnitureKind.counter => _counterParts(width),
      FurnitureKind.fridge => [MeshPart('kitchenFridgeLarge', z0: 0, z1: h)],
      FurnitureKind.toilet => [MeshPart('toilet', z0: 0, z1: h)],
      FurnitureKind.washbasin => [MeshPart('bathroomSink', z0: 0, z1: h)],
      FurnitureKind.shower => [MeshPart('shower', z0: 0, z1: h)],
      FurnitureKind.bathtub => [MeshPart('bathtub', z0: 0, z1: h)],
      FurnitureKind.washingMachine => [MeshPart('washer', z0: 0, z1: h)],
      FurnitureKind.coatRack => [MeshPart('coatRackStanding', x0: 0.3, x1: 0.7, z0: 0, z1: h)],
      FurnitureKind.plant => [MeshPart('pottedPlant', z0: 0, z1: h)],
      FurnitureKind.floorLamp => [MeshPart('lampRoundFloor', z0: 0, z1: h)],
    };
  }

  /// Kitchen units of about 60 cm, with the sink second and the stove second to last.
  static List<MeshPart> _counterParts(double width) {
    final count = math.max(1, (width / 60).round());
    return [
      for (var i = 0; i < count; i++)
        MeshPart(
          switch (i) {
            1 => 'kitchenSink',
            _ when count >= 4 && i == count - 2 => 'kitchenStove',
            _ => 'kitchenCabinet',
          },
          x0: i / count,
          x1: (i + 1) / count,
          z0: 0,
          z1: FurnitureKind.counter.height,
        ),
    ];
  }

  /// [item] as triangles on the plan, or `null` when there is no model for it.
  SceneMesh? meshOf(Furniture item) {
    final parts = partsOf(item.kind, item.width);
    if (parts == null || parts.any((part) => !models.containsKey(part.model))) return null;
    final angle = item.rotation * math.pi / 180;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    final positions = <double>[];
    final triangles = <int>[];
    final colors = <Color>[];
    for (final part in parts) {
      final mesh = models[part.model]!;
      final offset = positions.length ~/ 3;
      for (var i = 0; i < mesh.positions.length; i += 3) {
        final lx = (part.x0 + mesh.positions[i] * (part.x1 - part.x0) - 0.5) * item.width;
        final ly = (part.y0 + mesh.positions[i + 1] * (part.y1 - part.y0) - 0.5) * item.depth;
        positions
          ..add(item.position.x + lx * cos - ly * sin)
          ..add(item.position.y + lx * sin + ly * cos)
          ..add(part.z0 + mesh.positions[i + 2] * (part.z1 - part.z0));
      }
      triangles.addAll([for (final index in mesh.triangles) index + offset]);
      colors.addAll(mesh.triangleColors);
    }
    return SceneMesh(
      item: item,
      positions: Float32List.fromList(positions),
      triangles: Uint16List.fromList(triangles),
      colors: colors,
    );
  }
}

/// The furniture models, loaded from the app's assets once.
@Riverpod(keepAlive: true)
Future<FurnitureMeshLibrary> furnitureMeshes(Ref ref) async =>
    FurnitureMeshLibrary.parse(await rootBundle.loadString(FurnitureMeshLibrary.asset));
