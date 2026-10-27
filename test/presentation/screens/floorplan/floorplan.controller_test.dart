import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.state.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/riverpod.test_util.dart';

void main() {
  group('FloorplanController', () {
    late FakeLightsService lights;
    late FakeSpeakersService speakers;

    ProviderContainer createContainer() {
      lights = FakeLightsService(const [LightState(id: 'light.desk', name: 'Desk', isOn: true)]);
      speakers = FakeSpeakersService(const [
        SpeakerState(id: 'media_player.office', name: 'Office', playback: Playback.playing),
      ]);
      final container = createTestContainer(
        overrides: [
          lightsServiceProvider.overrideWith(() => lights),
          speakersServiceProvider.overrideWith(() => speakers),
          ...floorplanTestOverrides(),
        ],
      );
      container.listen(floorplanControllerProvider, (_, _) {});
      container.listen(planDevicesProvider, (_, _) {});
      return container;
    }

    test('Given all layers are visible, when toggling lights twice, then it is hidden and shown again', () {
      final container = createContainer();
      final controller = container.read(floorplanControllerProvider.notifier);

      controller.toggleLayer(PlanLayer.lights);
      expect(container.read(floorplanControllerProvider).layers, isNot(contains(PlanLayer.lights)));

      controller.toggleLayer(PlanLayer.lights);
      expect(container.read(floorplanControllerProvider).layers, contains(PlanLayer.lights));
    });

    test('Given nothing is selected, when tapping a room twice, then it is selected and deselected', () {
      final container = createContainer();
      final controller = container.read(floorplanControllerProvider.notifier);

      controller.tapRoom('kitchen');
      expect(container.read(floorplanControllerProvider).selection, const PlanSelection.room('kitchen'));

      controller.tapRoom('kitchen');
      expect(container.read(floorplanControllerProvider).selection, const PlanSelection.none());
    });

    test('Given a selected room, when tapping a device, then the device is selected', () {
      final container = createContainer();
      final controller = container.read(floorplanControllerProvider.notifier)..tapRoom('kitchen');

      controller.tapDevice('light.desk');

      expect(container.read(floorplanControllerProvider).selection, const PlanSelection.device('light.desk'));
    });

    test('Given a placed and selected device, '
        'when removing it, '
        'then it is back in the tray and nothing is selected', () async {
      // Given
      final container = createContainer();
      await container
          .read(placementServiceProvider.notifier)
          .place('light.desk', DeviceKind.light, const PlanPoint(100, 50));
      await pumpEventQueue();
      expect(container.read(planDevicesProvider).firstWhere((d) => d.id == 'light.desk').isPlaced, isTrue);
      final controller = container.read(floorplanControllerProvider.notifier)..tapDevice('light.desk');

      // When
      await controller.removeDevice('light.desk');
      await pumpEventQueue();

      // Then
      expect(container.read(planDevicesProvider).firstWhere((d) => d.id == 'light.desk').isPlaced, isFalse);
      expect(container.read(floorplanControllerProvider).selection, const PlanSelection.none());
    });

    test('Given lights, speakers and placements, '
        'when joining them, '
        'then every device is listed with its position or none', () async {
      // Given
      final container = createContainer();
      await container.read(placementServiceProvider.notifier).placeAllIfEmpty(const [
        Placement(deviceId: 'media_player.office', kind: DeviceKind.speaker, position: PlanPoint(60, 110)),
      ]);
      await pumpEventQueue();

      // When
      final devices = container.read(planDevicesProvider);

      // Then
      expect(devices.whereType<PlanLight>().single.position, isNull);
      expect(devices.whereType<PlanSpeaker>().single.position, const PlanPoint(60, 110));
    });

    test('Given a brightness slider is dragged, '
        'when many values arrive quickly and the slider is released, '
        'then few updates and the final value are sent', () {
      fakeAsync((async) {
        // Given
        final container = createContainer();
        final controller = container.read(floorplanControllerProvider.notifier);

        // When
        for (var percent = 10; percent <= 60; percent += 2) {
          controller.changeBrightness('light.desk', percent);
          async.elapse(const Duration(milliseconds: 16));
        }
        controller.endBrightness('light.desk', 61);
        async.elapse(const Duration(seconds: 1));

        // Then
        expect(lights.commands.length, lessThanOrEqualTo(4));
        expect(lights.commands.first, 'brightness light.desk 10');
        expect(lights.commands.last, 'brightness light.desk 61');
      });
    });

    test('Given device commands, when using them, then they reach the services', () async {
      final container = createContainer();
      final controller = container.read(floorplanControllerProvider.notifier);

      controller
        ..setLightsOn(['light.desk'], on: false)
        ..playPause('media_player.office')
        ..endVolume('media_player.office', 40)
        ..toggleGroup(const SpeakerState(id: 'media_player.office', name: 'Office', playback: Playback.playing));
      await pumpEventQueue();

      expect(lights.commands, ['off light.desk']);
      expect(speakers.commands, [
        'playPause media_player.office',
        'volume media_player.office 40',
        'join media_player.office',
      ]);
    });
  });
}
