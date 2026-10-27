import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/lights/widgets/lights_widget.dart';

import '../../../../mocks/devices.mock.dart';
import '../../../../mocks/floorplan.mock.dart';
import '../../../../utils/widget.test_util.dart';

void main() {
  group('LightsWidget', () {
    const dimmable = {LightCapability.brightness};
    late FakeLightsService lights;

    Future<void> load(
      WidgetTester tester,
      WidgetSize size, {
      bool hasHomeAssistant = true,
      ConnectionStatus status = ConnectionStatus.online,
      List<String> roomIds = const [],
    }) async {
      lights = FakeLightsService(const [
        LightState(id: 'light.desk', name: 'Desk', isOn: true, brightnessPercent: 80, capabilities: dimmable),
        LightState(id: 'light.ceiling', name: 'Ceiling', isOn: false, capabilities: dimmable),
        LightState(id: 'light.pendant', name: 'Pendant', isOn: false, capabilities: dimmable),
      ]);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            ...floorplanWidgetTestOverrides(
              FakePlacementService(const [
                Placement(deviceId: 'light.desk', kind: DeviceKind.light, position: PlanPoint(100, 60)),
                Placement(deviceId: 'light.ceiling', kind: DeviceKind.light, position: PlanPoint(300, 60)),
                Placement(deviceId: 'light.pendant', kind: DeviceKind.light, position: PlanPoint(600, 200)),
              ]),
              hasHomeAssistant: hasHomeAssistant,
            ),
            lightsServiceProvider.overrideWith(() => lights),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(status)),
          ],
        ),
        underTestWidget: Center(
          child: LightsWidget(size: size, roomIds: roomIds),
        ),
      );
    }

    testWidgets('Given the office is lit, when tapping the bulb of the small widget, then all lights go off', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.small);
      final summary = find.text('1 of 2 rooms on').evaluate().length;

      // When
      await tester.tap(find.bySemanticsLabel('Turn all lights off'));
      await tester.pump();

      // Then
      expect(summary, 1);
      expect(lights.commands, ['off light.desk,light.ceiling,light.pendant']);
    });

    testWidgets('Given the kitchen is off, when tapping it in the medium widget, then it is switched on', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.medium);

      // When
      await tester.tap(find.bySemanticsLabel('Kitchen'));
      await tester.pump();

      // Then
      expect(find.text('1 on'), findsOneWidget);
      expect(lights.commands, ['on light.pendant']);
    });

    testWidgets('Given a lit room, when tapping All off in the large widget, then every light goes off', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.large);
      final office = find.text('80%').evaluate().length;

      // When
      await tester.tap(find.text('All off'));
      await tester.pump();

      // Then
      expect(office, 1);
      expect(lights.commands, ['off light.desk,light.ceiling,light.pendant']);
    });

    testWidgets('Given the extra large widget, when picking the kitchen and a scene, then the scene is applied there', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.extraLarge);

      // When
      await tester.tap(find.text('Kitchen'));
      await tester.pump();
      await tester.tap(find.text('Night'));
      await tester.pump();

      // Then
      expect(lights.commands, ['scene Night light.pendant']);
    });

    testWidgets('Given the hub is offline, when tapping a bulb, then nothing is sent', (tester) async {
      // Given
      await load(tester, WidgetSize.medium, status: ConnectionStatus.offline);

      // When
      await tester.tap(find.bySemanticsLabel('Kitchen'));
      await tester.pump();

      // Then
      expect(lights.commands, isEmpty);
    });

    testWidgets('Given no Home Assistant, when shown, then it says what the lights need', (tester) async {
      // Given / When
      await load(tester, WidgetSize.medium, hasHomeAssistant: false);

      // Then
      expect(find.text('No lights yet'), findsOneWidget);
    });

    testWidgets('Given the kitchen and the office chosen, when shown medium, then only they show, kitchen first', (
      tester,
    ) async {
      // Given / When
      await load(tester, WidgetSize.medium, roomIds: const ['kitchen', 'gone', 'office']);

      // Then
      final kitchen = tester.getCenter(find.text('Kitchen'));
      final office = tester.getCenter(find.text('Office'));
      expect(kitchen.dx, lessThan(office.dx));
      expect(find.text('Not placed'), findsNothing);
    });

    testWidgets('Given only the kitchen chosen, when tapping the small widget, then the kitchen is switched on', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.small, roomIds: const ['kitchen']);

      // When
      await tester.tap(find.bySemanticsLabel('Turn Kitchen on'));
      await tester.pump();

      // Then
      expect(find.text('Kitchen'), findsOneWidget);
      expect(lights.commands, ['on light.pendant']);
    });
  });
}
