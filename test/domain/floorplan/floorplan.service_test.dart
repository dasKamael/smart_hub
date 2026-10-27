import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/floorplan/floorplan.repository.dart';
import 'package:smart_hub/data/floorplan/placement.repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

import '../../fixtures/floorplan.fixture.dart';
import '../../utils/riverpod.test_util.dart';

class _MockFloorplanRepository extends Mock implements FloorplanRepository {}

void main() {
  group('floorPlanService', () {
    test('Given the repository has a plan, when reading the service, then the plan is returned', () async {
      // Given
      final repository = _MockFloorplanRepository();
      when(repository.load).thenAnswer((_) async => loadApartmentPlan());
      final container = createTestContainer(overrides: [floorplanRepositoryProvider.overrideWithValue(repository)]);

      // When
      final plan = await container.read(floorPlanServiceProvider.future);

      // Then
      expect(plan.rooms, hasLength(7));
    });
  });

  group('PlacementService', () {
    late ProviderContainer container;

    setUp(() async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      container = createTestContainer(
        overrides: [
          floorPlanServiceProvider.overrideWith((ref) async => loadApartmentPlan()),
          placementRepositoryProvider.overrideWithValue(PlacementRepository(database: database)),
        ],
      );
      container.listen(placementServiceProvider, (_, _) {});
      await container.read(placementServiceProvider.future);
    });

    Future<List<Placement>> placements() async {
      await pumpEventQueue();
      return container.read(placementServiceProvider).requireValue;
    }

    test('Given an empty plan, when placing a device, then it is stored at that position', () async {
      // When
      await container
          .read(placementServiceProvider.notifier)
          .place('light.desk', DeviceKind.light, const PlanPoint(100, 50));

      // Then
      expect(await placements(), [
        const Placement(deviceId: 'light.desk', kind: DeviceKind.light, position: PlanPoint(100, 50)),
      ]);
    });

    test('Given a position outside the plan, when placing, then it is clamped 20 cm inside', () async {
      // When
      await container
          .read(placementServiceProvider.notifier)
          .place('light.desk', DeviceKind.light, const PlanPoint(-30, 999));

      // Then
      expect((await placements()).single.position, const PlanPoint(20, 430));
    });

    test('Given a placed device, when removing it, then it is back in the tray', () async {
      // Given
      final service = container.read(placementServiceProvider.notifier);
      await service.place('plant-1', DeviceKind.plant, const PlanPoint(600, 200));

      // When
      await service.remove('plant-1');

      // Then
      expect(await placements(), isEmpty);
    });
  });
}
