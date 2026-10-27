import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/grouping.util.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

void main() {
  group('GroupingUtil.groups', () {
    test('Given devices far apart, when grouping, then there are no groups', () {
      final groups = GroupingUtil.groups({'a': const PlanPoint(0, 0), 'b': const PlanPoint(100, 0)});

      expect(groups, isEmpty);
    });

    test('Given two devices closer than 34 cm, when grouping, then they form one group', () {
      final groups = GroupingUtil.groups({'b': const PlanPoint(0, 0), 'a': const PlanPoint(33.9, 0)});

      expect(groups, [
        ['a', 'b'],
      ]);
    });

    test('Given two devices exactly 34 cm apart, when grouping, then they are not grouped', () {
      final groups = GroupingUtil.groups({'a': const PlanPoint(0, 0), 'b': const PlanPoint(34, 0)});

      expect(groups, isEmpty);
    });

    test('Given a chain a–b–c where only neighbours are close, '
        'when grouping, '
        'then single linkage puts all three into one group', () {
      final groups = GroupingUtil.groups({
        'a': const PlanPoint(0, 0),
        'b': const PlanPoint(30, 0),
        'c': const PlanPoint(60, 0),
      });

      expect(groups, [
        ['a', 'b', 'c'],
      ]);
    });

    test('Given two separate clusters and a single device, '
        'when grouping, '
        'then two groups are returned and the single device is left out', () {
      final groups = GroupingUtil.groups({
        'z1': const PlanPoint(500, 100),
        'z2': const PlanPoint(510, 110),
        'a1': const PlanPoint(0, 0),
        'a2': const PlanPoint(5, 5),
        'single': const PlanPoint(300, 300),
      });

      expect(groups, [
        ['a1', 'a2'],
        ['z1', 'z2'],
      ]);
    });
  });

  group('GroupingUtil.groupKey', () {
    test('Given member ids in any order, when building the key, then it is sorted and joined with |', () {
      expect(GroupingUtil.groupKey(['light.b', 'light.a', 'plant.c']), 'light.a|light.b|plant.c');
    });
  });

  group('GroupingUtil.dropTarget', () {
    final others = {'near': const PlanPoint(30, 0), 'nearer': const PlanPoint(0, 20), 'far': const PlanPoint(100, 100)};

    test('Given several devices within 40 cm, when dragging, then the nearest is the target', () {
      expect(GroupingUtil.dropTarget('dragged', PlanPoint.zero, others), 'nearer');
    });

    test('Given the dragged device itself is nearest, when dragging, then it is ignored', () {
      final withSelf = {...others, 'dragged': PlanPoint.zero};

      expect(GroupingUtil.dropTarget('dragged', PlanPoint.zero, withSelf), 'nearer');
    });

    test('Given a device exactly 40 cm away, when dragging, then it is a target', () {
      expect(GroupingUtil.dropTarget('dragged', PlanPoint.zero, {'edge': const PlanPoint(40, 0)}), 'edge');
    });

    test('Given no device within 40 cm, when dragging, then there is no target', () {
      expect(GroupingUtil.dropTarget('dragged', PlanPoint.zero, {'far': const PlanPoint(40.1, 0)}), isNull);
    });
  });

  group('GroupingUtil.dropPosition', () {
    test('Given a drop target, when dropping, then the device lands at target + (7, 5) and groups with it', () {
      const target = PlanPoint(200, 100);

      final position = GroupingUtil.dropPosition(target);

      expect(position, const PlanPoint(207, 105));
      expect(GroupingUtil.groups({'target': target, 'dropped': position}), hasLength(1));
    });
  });
}
