import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/floorplan/placement.repository.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

void main() {
  group('PlacementRepository', () {
    late PlacementRepository repository;
    const desk = Placement(deviceId: 'light.desk', kind: DeviceKind.light, position: PlanPoint(100, 50));
    const fern = Placement(deviceId: 'plant-1', kind: DeviceKind.plant, position: PlanPoint(600, 200));

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = PlacementRepository(database: database);
    });

    test('Given placements were saved, when reading all, then they come back unchanged', () async {
      // Given
      await repository.saveAll([desk, fern]);

      // When / Then
      expect(await repository.all(), unorderedEquals([desk, fern]));
    });

    test('Given a placed device, when saving it at a new position, then it is moved, not duplicated', () async {
      // Given
      await repository.save(desk);

      // When
      await repository.save(desk.copyWith(position: const PlanPoint(120.5, 60.25)));

      // Then
      expect(await repository.all(), [desk.copyWith(position: const PlanPoint(120.5, 60.25))]);
    });

    test('Given a placed device, when removing it, then it is gone', () async {
      // Given
      await repository.saveAll([desk, fern]);

      // When
      await repository.remove('light.desk');

      // Then
      expect(await repository.all(), [fern]);
    });

    test('Given a watcher, when a device is placed, then the watcher gets the new list', () async {
      // Given
      final updates = <List<Placement>>[];
      final subscription = repository.watchAll().listen(updates.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      // When
      await repository.save(desk);
      await pumpEventQueue();

      // Then
      expect(updates, [
        isEmpty,
        [desk],
      ]);
    });
  });
}
