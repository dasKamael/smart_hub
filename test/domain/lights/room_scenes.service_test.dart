import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/lights/room_scene.repository.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/room_scenes.service.dart';

import '../../utils/riverpod.test_util.dart';

void main() {
  group('RoomScenesService', () {
    late AppDatabase database;

    ProviderContainer createContainer() {
      final container = createTestContainer(
        overrides: [roomSceneRepositoryProvider.overrideWithValue(RoomSceneRepository(database: database))],
      );
      container.listen(roomScenesServiceProvider, (_, _) {});
      return container;
    }

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
    });

    const desk = LightState(
      id: 'light.desk',
      name: 'Desk',
      isOn: true,
      brightnessPercent: 40,
      kelvin: 2700,
      capabilities: {LightCapability.brightness, LightCapability.colorTemperature},
    );

    test('Given a new hub, when reading the office scenes, then they are the four templates', () async {
      // Given
      final container = createContainer();
      await container.read(roomScenesServiceProvider.future);

      // When / Then
      expect(container.read(roomScenesServiceProvider.notifier).scenesOf('office').map((scene) => scene.name), [
        'Relax',
        'Read',
        'Focus',
        'Night',
      ]);
    });

    test(
      'Given the office, when adding a scene from now and deleting Focus, then that is kept after a restart',
      () async {
        // Given
        final container = createContainer();
        await container.read(roomScenesServiceProvider.future);
        final service = container.read(roomScenesServiceProvider.notifier);

        // When
        await service.addFromCurrent('office', 'Evening', const [desk]);
        await service.delete(service.scenesOf('office').firstWhere((scene) => scene.name == 'Focus'));
        final restarted = createContainer();
        await restarted.read(roomScenesServiceProvider.future);

        // Then
        final scenes = restarted.read(roomScenesServiceProvider.notifier).scenesOf('office');
        expect(scenes.map((scene) => scene.name), ['Relax', 'Read', 'Night', 'Evening']);
        expect(scenes.last.lights['light.desk']?.kelvin, 2700);
        expect(restarted.read(roomScenesServiceProvider.notifier).scenesOf('kitchen'), hasLength(4));
      },
    );

    test('Given a room with one scene left, when deleting it, then it stays', () async {
      // Given
      final container = createContainer();
      await container.read(roomScenesServiceProvider.future);
      final service = container.read(roomScenesServiceProvider.notifier);
      for (final scene in service.scenesOf('wc').skip(1).toList()) {
        await service.delete(scene);
      }

      // When
      await service.delete(service.scenesOf('wc').single);

      // Then
      expect(service.scenesOf('wc'), hasLength(1));
    });
  });
}
