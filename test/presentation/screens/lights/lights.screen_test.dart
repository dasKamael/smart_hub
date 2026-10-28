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
import 'package:smart_hub/presentation/design_system/atoms/vertical_slider.dart';
import 'package:smart_hub/presentation/screens/lights/lights.screen.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('LightsScreen', () {
    const dimmable = {LightCapability.brightness};
    late FakeLightsService lights;

    Future<void> pumpScreen(WidgetTester tester, {ConnectionStatus status = ConnectionStatus.online}) async {
      lights = FakeLightsService(const [
        LightState(id: 'light.desk', name: 'Desk', isOn: true, brightnessPercent: 80, capabilities: dimmable),
        LightState(id: 'light.ceiling', name: 'Ceiling', isOn: false, capabilities: dimmable),
        LightState(id: 'light.pendant', name: 'Pendant', isOn: true, brightnessPercent: 12, capabilities: dimmable),
        LightState(id: 'light.spare', name: 'Spare', isOn: false),
      ]);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            lightsServiceProvider.overrideWith(() => lights),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(status)),
            ...floorplanWidgetTestOverrides(
              FakePlacementService(const [
                Placement(deviceId: 'light.desk', kind: DeviceKind.light, position: PlanPoint(100, 60)),
                Placement(deviceId: 'light.ceiling', kind: DeviceKind.light, position: PlanPoint(300, 60)),
                Placement(deviceId: 'light.pendant', kind: DeviceKind.light, position: PlanPoint(600, 200)),
              ]),
            ),
          ],
        ),
        underTestWidget: const LightsScreen(),
      );
    }

    /// A screen with [lights] of which [placed] stand on the plan, online or not.
    Future<void> pumpWith(
      WidgetTester tester, {
      List<LightState> lights = const [],
      List<String> placed = const [],
      ConnectionStatus status = ConnectionStatus.online,
    }) async {
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            lightsServiceProvider.overrideWith(() => FakeLightsService(lights)),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(status)),
            ...floorplanWidgetTestOverrides(
              FakePlacementService([
                for (final id in placed)
                  Placement(deviceId: id, kind: DeviceKind.light, position: const PlanPoint(100, 60)),
              ]),
            ),
          ],
        ),
        underTestWidget: const LightsScreen(),
      );
    }

    testWidgets('Given no lamp and no connection, '
        'when opening the page, '
        'then it says the lights cannot be reached', (tester) async {
      // Given / When
      await pumpWith(tester, status: ConnectionStatus.offline);

      // Then
      expect(find.text('The lights cannot be reached'), findsOneWidget);
    });

    testWidgets('Given a connection but no lamp at all, '
        'when opening the page, '
        'then it says that nothing reported a lamp', (tester) async {
      // Given / When
      await pumpWith(tester);

      // Then
      expect(find.text('No lamps reported'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Given lights in two rooms and one unplaced, '
        'when rendering, '
        'then there is a tile per room with its summary', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(find.text('Office'), findsNWidgets(2), reason: 'tile and selected room card');
      expect(find.text('1 of 2 on · 80%'), findsOneWidget);
      expect(find.text('Kitchen'), findsOneWidget);
      expect(find.text('1 of 1 on · 12%'), findsOneWidget);
      expect(find.text('Not placed'), findsOneWidget);
      expect(find.text('2 of 3 rooms on'), findsOneWidget);
    });

    testWidgets('Given the kitchen at 12 %, '
        'when long pressing it, '
        'then the room card shows its brightness and Night as active scene', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.longPress(find.text('Kitchen'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('On · 12% brightness'), findsOneWidget);
      expect(tester.widget<VerticalSlider>(find.byType(VerticalSlider)).value, 12);
      expect(tester.getSemantics(find.bySemanticsLabel('Night')), isSemantics(isSelected: true));
    });

    testWidgets('Given the kitchen is on, '
        'when tapping anywhere on its tile, '
        'then the kitchen is switched off and selected', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('1 of 1 on · 12%'));
      await tester.pumpAndSettle();

      // Then
      expect(lights.commands, ['off light.pendant']);
      expect(find.text('Kitchen'), findsNWidgets(2), reason: 'tile and selected room card');
    });

    testWidgets('Given the office, '
        'when tapping a scene, the room icon and All off, '
        'then the matching commands are sent', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Relax'));
      await tester.tap(find.text('1 of 2 on · 80%'));
      await tester.tap(find.text('All off'));
      await tester.pump();

      // Then
      expect(lights.commands, [
        'scene Relax light.desk,light.ceiling',
        'off light.desk,light.ceiling',
        'off light.desk,light.ceiling,light.pendant,light.spare',
      ]);
    });

    testWidgets('Given the hub is offline, '
        'when tapping a scene, '
        'then nothing is sent and the slider is disabled', (tester) async {
      // Given
      await pumpScreen(tester, status: ConnectionStatus.offline);

      // When
      await tester.tap(find.text('Relax'));
      await tester.pump();

      // Then
      expect(lights.commands, isEmpty);
      expect(tester.widget<VerticalSlider>(find.byType(VerticalSlider)).onChanged, isNull);
    });

    testWidgets('Given the office, when long pressing Focus and deleting it, then the office has three scenes', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.longPress(find.text('Focus'));
      await tester.pump();
      await tester.tap(find.bySemanticsLabel('Delete'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Focus'), findsNothing);
      expect(find.text('Relax'), findsOneWidget);
    });

    testWidgets('Given the office, when adding a scene from the current light, then it shows in the list', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('New scene'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Evening');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Evening'), findsOneWidget);
    });
  });
}
