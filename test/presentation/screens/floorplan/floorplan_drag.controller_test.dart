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
  group('FloorplanController dragging', () {
    late FakePlacementService placements;
    late ProviderContainer container;

    PlanDevice device(String id) => container.read(planDevicesProvider).firstWhere((d) => d.id == id);

    FloorplanController controller() => container.read(floorplanControllerProvider.notifier);

    PlanPoint? stored(String id) {
      return placements.state.requireValue.where((p) => p.deviceId == id).map((p) => p.position).firstOrNull;
    }

    setUp(() async {
      placements = FakePlacementService(const [
        Placement(deviceId: 'light.a', kind: DeviceKind.light, position: PlanPoint(100, 60)),
        Placement(deviceId: 'light.b', kind: DeviceKind.light, position: PlanPoint(300, 60)),
        Placement(deviceId: 'media_player.office', kind: DeviceKind.speaker, position: PlanPoint(320, 60)),
      ]);
      container = createTestContainer(
        overrides: [
          lightsServiceProvider.overrideWith(
            () => FakeLightsService(const [
              LightState(id: 'light.a', name: 'A', isOn: false),
              LightState(id: 'light.b', name: 'B', isOn: false),
              LightState(id: 'light.c', name: 'C', isOn: false),
            ]),
          ),
          speakersServiceProvider.overrideWith(
            () => FakeSpeakersService(const [
              SpeakerState(id: 'media_player.office', name: 'Office', playback: Playback.idle),
            ]),
          ),
          ...floorplanWidgetTestOverrides(placements),
        ],
      );
      container
        ..listen(floorplanControllerProvider, (_, _) {})
        ..listen(planDevicesProvider, (_, _) {})
        ..listen(planGroupsProvider, (_, _) {});
      await container.read(floorPlanServiceProvider.future);
      await pumpEventQueue();
    });

    test('Given a dragged light, '
        'when it comes within 40 cm of another device, '
        'then the nearest one is the drop target', () {
      // Given
      controller().startDrag(device('light.a'));

      // When
      controller().updateDrag(const PlanPoint(290, 70));

      // Then
      expect(container.read(floorplanControllerProvider).drag?.targetId, 'light.b');
    });

    test('Given speakers are hidden, '
        'when a light is dragged next to a speaker, '
        'then the hidden speaker is no drop target', () {
      // Given
      controller()
        ..toggleLayer(PlanLayer.speakers)
        ..toggleLayer(PlanLayer.lights)
        ..toggleLayer(PlanLayer.lights)
        ..startDrag(device('light.a'));

      // When
      controller().updateDrag(const PlanPoint(330, 70));

      // Then
      expect(container.read(floorplanControllerProvider).drag?.targetId, 'light.b');
    });

    test('Given a drop target, '
        'when dropping, '
        'then the device lands at target + (7, 5) cm', () async {
      // Given
      controller()
        ..startDrag(device('light.a'))
        ..updateDrag(const PlanPoint(290, 70));

      // When
      await controller().endDrag();

      // Then
      expect(stored('light.a'), const PlanPoint(307, 65));
      expect(container.read(floorplanControllerProvider).drag, isNull);
    });

    test('Given no drop target, '
        'when dropping outside of the plan bounds, '
        'then the position is clamped 20 cm inside', () async {
      // Given
      controller()
        ..startDrag(device('light.a'))
        ..updateDrag(const PlanPoint(-80, 900));

      // When
      await controller().endDrag();

      // Then
      expect(stored('light.a'), const PlanPoint(20, 430));
    });

    test('Given a device from the tray, '
        'when it is released before reaching the plan, '
        'then it stays unplaced', () async {
      // Given
      controller()
        ..startDrag(device('light.c'))
        ..updateDrag(null);

      // When
      await controller().endDrag();

      // Then
      expect(stored('light.c'), isNull);
      expect(device('light.c').isPlaced, isFalse);
    });

    test('Given a device from the tray, '
        'when it is dropped on the plan, '
        'then it is placed and immediately shown there', () async {
      // Given
      controller()
        ..startDrag(device('light.c'))
        ..updateDrag(const PlanPoint(600, 200));

      // When
      final drop = controller().endDrag();

      // Then
      expect(device('light.c').position, const PlanPoint(600, 200), reason: 'pending position before saving');
      await drop;
      await pumpEventQueue();
      expect(stored('light.c'), const PlanPoint(600, 200));
      expect(container.read(floorplanControllerProvider).pendingPositions, isEmpty);
    });

    test('Given a dragged device, when cancelling, then nothing moves', () async {
      // Given
      controller()
        ..startDrag(device('light.a'))
        ..updateDrag(const PlanPoint(500, 200));

      // When
      controller().cancelDrag();
      await pumpEventQueue();

      // Then
      expect(stored('light.a'), const PlanPoint(100, 60));
      expect(container.read(floorplanControllerProvider).drag, isNull);
    });

    test('Given a light next to the speaker, '
        'when computing groups, '
        'then they form a group unless the speakers layer is hidden or the light is dragged', () {
      expect(container.read(planGroupsProvider), [
        ['light.b', 'media_player.office'],
      ]);

      controller().toggleLayer(PlanLayer.speakers);
      expect(container.read(planGroupsProvider), isEmpty);

      controller()
        ..toggleLayer(PlanLayer.speakers)
        ..startDrag(device('light.b'));
      expect(container.read(planGroupsProvider), isEmpty);
    });

    test('Given an open group, when tapping a room, then the group closes', () {
      // Given
      controller().openGroup('light.b|media_player.office');

      // When
      controller().tapRoom('office');

      // Then
      expect(container.read(floorplanControllerProvider).openGroupKey, isNull);
    });
  });
}
