import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';

import '../../fixtures/floorplan.fixture.dart';

void main() {
  final plan = loadApartmentPlan();

  group('RoomLookupUtil.roomAt', () {
    final expectations = {
      const PlanPoint(100, 50): 'office',
      const PlanPoint(420, 250): 'office',
      const PlanPoint(320, 300): 'storage',
      const PlanPoint(410, 300): 'storage2',
      const PlanPoint(100, 200): 'hall',
      const PlanPoint(300, 420): 'hall',
      const PlanPoint(600, 200): 'kitchen',
      const PlanPoint(800, 420): 'kitchen',
      const PlanPoint(770, 100): 'wc',
      const PlanPoint(900, 300): 'sleep',
    };
    for (final MapEntry(key: point, value: roomId) in expectations.entries) {
      test('Given the apartment, when looking up $point, then the room is $roomId', () {
        expect(RoomLookupUtil.roomAt(plan, point)?.id, roomId);
      });
    }

    test('Given the apartment, '
        'when looking up a point in the cut-out next to the hall, '
        'then it is outside of every room', () {
      expect(RoomLookupUtil.roomAt(plan, const PlanPoint(100, 350)), isNull);
    });

    test('Given the apartment, when looking up a point outside, then there is no room', () {
      expect(RoomLookupUtil.roomAt(plan, const PlanPoint(1100, 100)), isNull);
    });

    test('Given the apartment, '
        'when looking up points exactly on the office/kitchen wall, '
        'then each belongs to exactly one room', () {
      for (var y = 10.0; y < 270; y += 20) {
        final rooms = plan.rooms.where((room) => RoomLookupUtil.devicesIn(room, {'p': PlanPoint(450, y)}).isNotEmpty);
        expect(rooms, hasLength(1), reason: 'y = $y');
      }
    });
  });

  group('RoomLookupUtil.devicesIn', () {
    test('Given devices in several rooms, when asking for the kitchen, then only kitchen devices are returned', () {
      final kitchen = plan.rooms.firstWhere((room) => room.id == 'kitchen');
      final positions = {
        'light.counter': const PlanPoint(600, 100),
        'light.pendant': const PlanPoint(550, 300),
        'light.desk': const PlanPoint(100, 50),
      };

      expect(RoomLookupUtil.devicesIn(kitchen, positions), {'light.counter', 'light.pendant'});
    });
  });
}
