import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/editing/furniture_editing.util.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// A desk 120 × 60 cm at (200, 100), turned [rotation] degrees clockwise.
Furniture _desk({double rotation = 0}) => Furniture(
  id: 'f1',
  kind: FurnitureKind.desk,
  position: const PlanPoint(200, 100),
  rotation: rotation,
  width: 120,
  depth: 60,
);

Matcher _near(PlanPoint point) => predicate<PlanPoint>((p) => p.distanceTo(point) < 0.01, '$point');

void main() {
  group('FurnitureEditingUtil.handlesOf', () {
    test('Given an unturned desk, when asking for its handles, then width sits on its right side, depth on its front '
        'and turn further out in front', () {
      // When
      final handles = FurnitureEditingUtil.handlesOf(_desk(), turnReach: 30);

      // Then
      expect(handles[FurnitureHandle.width], _near(const PlanPoint(260, 100)));
      expect(handles[FurnitureHandle.depth], _near(const PlanPoint(200, 130)));
      expect(handles[FurnitureHandle.turn], _near(const PlanPoint(200, 160)));
    });

    test('Given a desk turned a quarter, when asking for its handles, then they turn with it', () {
      // When
      final handles = FurnitureEditingUtil.handlesOf(_desk(rotation: 90), turnReach: 30);

      // Then
      expect(handles[FurnitureHandle.width], _near(const PlanPoint(200, 160)));
      expect(handles[FurnitureHandle.depth], _near(const PlanPoint(170, 100)));
    });
  });

  group('FurnitureEditingUtil.handleAt', () {
    test('Given a point within the radius of the width handle, when hit testing, then it is the width handle', () {
      // When
      final handle = FurnitureEditingUtil.handleAt(_desk(), const PlanPoint(268, 100), radius: 10, turnReach: 30);

      // Then
      expect(handle, FurnitureHandle.width);
    });

    test('Given a point in the middle of the desk, when hit testing, then no handle is hit', () {
      // When
      final handle = FurnitureEditingUtil.handleAt(_desk(), const PlanPoint(200, 100), radius: 10, turnReach: 30);

      // Then
      expect(handle, isNull);
    });
  });

  group('FurnitureEditingUtil.turnedTowards', () {
    test('Given a finger to the left of the desk, when turning towards it, then the front faces left (90°)', () {
      // When
      final turned = FurnitureEditingUtil.turnedTowards(_desk(), const PlanPoint(100, 100));

      // Then
      expect(turned.rotation, 90);
    });

    test('Given a finger slightly off a quarter, when turning towards it, then the turn snaps to 15° steps', () {
      // When
      final turned = FurnitureEditingUtil.turnedTowards(_desk(), const PlanPoint(195, 300));

      // Then
      expect(turned.rotation, 0);
    });

    test('Given a finger up and to the right, when turning towards it, then the angle stays within 0–360', () {
      // When
      final turned = FurnitureEditingUtil.turnedTowards(_desk(), const PlanPoint(300, 0));

      // Then
      expect(turned.rotation, 225);
    });
  });

  group('FurnitureEditingUtil.resized', () {
    test('Given the width handle dragged 20 cm out, when resizing, then the desk is 20 cm wider and its left side '
        'stays', () {
      // When
      final resized = FurnitureEditingUtil.resized(_desk(), FurnitureHandle.width, const PlanPoint(281, 100));

      // Then
      expect(resized.width, 140);
      expect(resized.position, _near(const PlanPoint(210, 100)));
    });

    test('Given the depth handle of a turned desk dragged towards its back, when resizing, then it gets shallower '
        'and its back stays', () {
      // When
      final resized = FurnitureEditingUtil.resized(
        _desk(rotation: 90),
        FurnitureHandle.depth,
        const PlanPoint(190, 100),
      );

      // Then
      expect(resized.depth, 40);
      expect(resized.position, _near(const PlanPoint(210, 100)));
    });

    test('Given a handle dragged past the other side, when resizing, then the piece keeps its smallest size', () {
      // When
      final resized = FurnitureEditingUtil.resized(_desk(), FurnitureHandle.width, const PlanPoint(0, 100));

      // Then
      expect(resized.width, FurnitureEditingUtil.minSide);
    });
  });

  group('FurnitureEditingUtil.withSize', () {
    test('Given a deeper size, when resizing by the numbers, then the back stays where it is (against its wall) and '
        'the width grows on both sides', () {
      // When
      final resized = FurnitureEditingUtil.withSize(_desk(), width: 140, depth: 80);

      // Then
      expect((resized.width, resized.depth), (140, 80));
      expect(resized.position, _near(const PlanPoint(200, 110)));
    });

    test('Given a size below the smallest, when resizing by the numbers, then it stops at the smallest', () {
      // When
      final resized = FurnitureEditingUtil.withSize(_desk(), width: 5);

      // Then
      expect(resized.width, FurnitureEditingUtil.minSide);
      expect(resized.depth, 60);
    });
  });

  group('FurnitureEditingUtil.copyBeside', () {
    test('Given a turned desk, when copying it, then the copy stands beside it, turned the same way', () {
      // When
      final copy = FurnitureEditingUtil.copyBeside(_desk(rotation: 90), id: 'f2');

      // Then
      expect(copy.id, 'f2');
      expect(copy.rotation, 90);
      expect(copy.position, _near(const PlanPoint(200, 230)));
    });
  });
}
