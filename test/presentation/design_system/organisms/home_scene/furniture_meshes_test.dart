import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/furniture_meshes.dart';

void main() {
  group('FurnitureMeshLibrary', () {
    final library = FurnitureMeshLibrary.parse(File(FurnitureMeshLibrary.asset).readAsStringSync());

    test('Given the bundled models, when parsing, then every kind of furniture has its models', () {
      for (final kind in FurnitureKind.values) {
        final parts = FurnitureMeshLibrary.partsOf(kind, kind.width)!;
        expect(parts.every((part) => library.models.containsKey(part.model)), isTrue, reason: kind.name);
      }
    });

    test('Given a 300 cm counter, when picking its models, then five units with a sink second and a stove fourth', () {
      // When
      final parts = FurnitureMeshLibrary.partsOf(FurnitureKind.counter, 300)!;

      // Then
      expect(parts.map((part) => part.model), [
        'kitchenCabinet',
        'kitchenSink',
        'kitchenCabinet',
        'kitchenStove',
        'kitchenCabinet',
      ]);
    });

    test('Given a bed turned a quarter, when placing its model, then it fills its turned outline and height', () {
      // Given
      const bed = Furniture(
        id: 'b',
        kind: FurnitureKind.bed,
        position: PlanPoint(300, 200),
        rotation: 90,
        width: 160,
        depth: 205,
      );

      // When
      final mesh = library.meshOf(bed)!;

      // Then
      final xs = [for (var i = 0; i < mesh.positions.length; i += 3) mesh.positions[i]];
      final ys = [for (var i = 1; i < mesh.positions.length; i += 3) mesh.positions[i]];
      final zs = [for (var i = 2; i < mesh.positions.length; i += 3) mesh.positions[i]];
      expect(xs.reduce((a, b) => a < b ? a : b), closeTo(300 - 102.5, 0.5));
      expect(xs.reduce((a, b) => a > b ? a : b), closeTo(300 + 102.5, 0.5));
      expect(ys.reduce((a, b) => a < b ? a : b), closeTo(200 - 80, 0.5));
      expect(zs.reduce((a, b) => a > b ? a : b), closeTo(FurnitureKind.bed.height + 15, 0.5));
      expect(mesh.colors, hasLength(mesh.triangles.length ~/ 3));
    });
  });
}
