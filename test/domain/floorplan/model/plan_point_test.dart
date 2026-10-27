import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

void main() {
  group('PlanPoint', () {
    test('Given two points, when adding and subtracting, then the coordinates are combined', () {
      expect(const PlanPoint(10, 20) + const PlanPoint(1, 2), const PlanPoint(11, 22));
      expect(const PlanPoint(10, 20) - const PlanPoint(1, 2), const PlanPoint(9, 18));
    });

    test('Given two points, when measuring the distance, then it is euclidean', () {
      expect(PlanPoint.zero.distanceTo(const PlanPoint(30, 40)), 50);
    });

    test('Given equal coordinates, when comparing, then points are equal with the same hash', () {
      expect(const PlanPoint(1, 2), const PlanPoint(1, 2));
      expect(const PlanPoint(1, 2).hashCode, const PlanPoint(1, 2).hashCode);
      expect(const PlanPoint(1, 2), isNot(const PlanPoint(2, 1)));
      expect(const PlanPoint(1, 2).toString(), 'PlanPoint(1.0, 2.0)');
    });
  });

  group('PlanRect', () {
    test('Given a rect, when reading its size, then width and height are derived from the edges', () {
      const rect = PlanRect(left: 10, top: 20, right: 110, bottom: 70);

      expect(rect.width, 100);
      expect(rect.height, 50);
      expect(rect, const PlanRect(left: 10, top: 20, right: 110, bottom: 70));
      expect(rect.hashCode, const PlanRect(left: 10, top: 20, right: 110, bottom: 70).hashCode);
      expect(rect.toString(), 'PlanRect(10.0, 20.0, 110.0, 70.0)');
    });
  });
}
