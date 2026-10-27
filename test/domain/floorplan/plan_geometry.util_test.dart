import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

import '../../fixtures/floorplan.fixture.dart';

void main() {
  const square = [PlanPoint(0, 0), PlanPoint(100, 0), PlanPoint(100, 100), PlanPoint(0, 100)];
  // L-shape: the inner corner at (50, 50) is cut out.
  const lShape = [
    PlanPoint(0, 0),
    PlanPoint(100, 0),
    PlanPoint(100, 50),
    PlanPoint(50, 50),
    PlanPoint(50, 100),
    PlanPoint(0, 100),
  ];

  group('PlanGeometryUtil.containsPoint', () {
    test('Given a square, when checking a point in the middle, then it is inside', () {
      expect(PlanGeometryUtil.containsPoint(square, const PlanPoint(50, 50)), isTrue);
    });

    test('Given a square, when checking points outside, then they are outside', () {
      for (final point in const [PlanPoint(-1, 50), PlanPoint(101, 50), PlanPoint(50, -1), PlanPoint(50, 101)]) {
        expect(PlanGeometryUtil.containsPoint(square, point), isFalse, reason: '$point');
      }
    });

    test('Given an L-shaped room, when checking the cut-out corner, then it is outside', () {
      expect(PlanGeometryUtil.containsPoint(lShape, const PlanPoint(75, 75)), isFalse);
      expect(PlanGeometryUtil.containsPoint(lShape, const PlanPoint(25, 75)), isTrue);
      expect(PlanGeometryUtil.containsPoint(lShape, const PlanPoint(75, 25)), isTrue);
    });

    test('Given two rooms sharing a wall, '
        'when checking a point exactly on the wall, '
        'then it belongs to exactly one of them', () {
      const left = [PlanPoint(0, 0), PlanPoint(100, 0), PlanPoint(100, 100), PlanPoint(0, 100)];
      const right = [PlanPoint(100, 0), PlanPoint(200, 0), PlanPoint(200, 100), PlanPoint(100, 100)];
      const onWall = PlanPoint(100, 50);

      final inLeft = PlanGeometryUtil.containsPoint(left, onWall);
      final inRight = PlanGeometryUtil.containsPoint(right, onWall);

      expect(inLeft != inRight, isTrue);
    });
  });

  group('PlanGeometryUtil.bounds', () {
    test('Given the apartment, when computing the bounds, then they span 1030 × 450 cm', () {
      expect(PlanGeometryUtil.bounds(loadApartmentPlan()), const PlanRect(left: 0, top: 0, right: 1030, bottom: 450));
    });
  });

  group('PlanGeometryUtil.clampInside', () {
    const bounds = PlanRect(left: 0, top: 0, right: 1030, bottom: 450);

    test('Given a point inside the margin, when clamping, then it is unchanged', () {
      expect(PlanGeometryUtil.clampInside(const PlanPoint(500, 200), bounds), const PlanPoint(500, 200));
    });

    test('Given points beyond the borders, when clamping, then they stay 20 cm inside', () {
      expect(PlanGeometryUtil.clampInside(const PlanPoint(-50, 600), bounds), const PlanPoint(20, 430));
      expect(PlanGeometryUtil.clampInside(const PlanPoint(1100, 5), bounds), const PlanPoint(1010, 20));
    });
  });

  group('PlanGeometryUtil.areaInSquareMeters', () {
    test('Given the rooms of the apartment, when computing their areas, then they match the plan', () {
      final areas = {
        for (final room in loadApartmentPlan().rooms) room.id: PlanGeometryUtil.areaInSquareMeters(room.polygon),
      };

      expect(areas['office'], closeTo(9.03, 0.001));
      expect(areas['kitchen'], closeTo(12.86, 0.001));
      expect(areas['hall'], closeTo(5.71, 0.001));
      expect(areas.values.fold<double>(0, (sum, area) => sum + area), closeTo(42.455, 0.001));
    });
  });
}
