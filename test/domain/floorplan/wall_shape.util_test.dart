import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/domain/floorplan/wall_shape.util.dart';

/// A 4 × 3 m room with outer walls and an inner wall from the top wall down to y = 200.
HomeLayout _room() {
  var layout = LayoutGraphUtil.addRectangle(
    const HomeLayout(),
    PlanPoint.zero,
    const PlanPoint(400, 300),
    thickness: LayoutWall.outerThickness,
  );
  layout = LayoutGraphUtil.addWall(layout, const PlanPoint(200, 0), const PlanPoint(200, 200));
  return layout;
}

void main() {
  group('WallShapeUtil.shapesOf', () {
    test('Given outer walls, when shaping them, then they grow outwards only: the inside face stays where an inner '
        'wall would have it', () {
      // When
      final shapes = WallShapeUtil.shapesOf(_room());

      // Then
      final top = shapes[LayoutGraphUtil.wallAt(_room(), const PlanPoint(100, 0), radius: 2)!.id]!;
      final (right, _, left) = top.start!;
      expect(
        {right.y, left.y},
        {closeTo(-(LayoutWall.outerThickness - LayoutWall.innerThickness / 2), 0.01), closeTo(5, 0.01)},
      );
      expect(
        {top.left, top.right},
        {LayoutWall.outerThickness - LayoutWall.innerThickness / 2, LayoutWall.innerThickness / 2},
      );
    });

    test('Given a corner of two outer walls, when shaping them, then each reaches the other\'s outer face, so the '
        'corner is closed without a block', () {
      // When
      final shapes = WallShapeUtil.shapesOf(_room());

      // Then
      final left = shapes[LayoutGraphUtil.wallAt(_room(), const PlanPoint(0, 150), radius: 2)!.id]!;
      final outer = LayoutWall.outerThickness - LayoutWall.innerThickness / 2;
      expect(left.corners.map((p) => p.y).reduce((a, b) => a < b ? a : b), closeTo(-outer, 0.01));
      expect(left.corners.map((p) => p.x).reduce((a, b) => a < b ? a : b), closeTo(-outer, 0.01));
    });

    test('Given an inner wall ending on an outer wall, when shaping it, then it ends at that wall\'s inner face', () {
      // When
      final shapes = WallShapeUtil.shapesOf(_room());

      // Then
      final inner = shapes[LayoutGraphUtil.wallAt(_room(), const PlanPoint(200, 100), radius: 2)!.id]!;
      final (right, center, left) = inner.start ?? inner.end!;
      expect({right.y, left.y}, {closeTo(LayoutWall.innerThickness / 2, 0.01)});
      expect(center, const PlanPoint(200, 0));
      expect(inner.outside, isNull);
    });

    test('Given a slanted wall meeting a straight one, when shaping them, then their corners meet exactly', () {
      // Given
      var layout = LayoutGraphUtil.addWall(const HomeLayout(), PlanPoint.zero, const PlanPoint(300, 0));
      layout = LayoutGraphUtil.addWall(layout, const PlanPoint(300, 0), const PlanPoint(400, 250));

      // When
      final shapes = WallShapeUtil.shapesOf(layout).values.toList();

      // Then
      final first = shapes.firstWhere((shape) => shape.to == const PlanPoint(300, 0));
      final second = shapes.firstWhere((shape) => shape.from == const PlanPoint(300, 0));
      final (firstRight, _, firstLeft) = first.end!;
      final (secondRight, _, secondLeft) = second.start!;
      expect({firstRight, firstLeft}, {secondRight, secondLeft});
    });

    test('Given an outer wall, when shaping it, then it knows which way is out', () {
      // When
      final shapes = WallShapeUtil.shapesOf(_room());

      // Then
      final top = shapes[LayoutGraphUtil.wallAt(_room(), const PlanPoint(100, 0), radius: 2)!.id]!;
      expect(top.outside, const PlanPoint(0, -1));
      expect(PlanGeometryUtil.areaInSquareMeters(top.corners), greaterThan(0));
    });
  });
}
