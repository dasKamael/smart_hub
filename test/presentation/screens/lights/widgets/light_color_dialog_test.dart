import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/presentation/screens/lights/widgets/light_color_dialog.dart';

import '../../../../mocks/devices.mock.dart';
import '../../../../mocks/floorplan.mock.dart';
import '../../../../utils/widget.test_util.dart';

void main() {
  group('LightColorDialog', () {
    late FakeLightsService lights;

    Future<void> load(WidgetTester tester) async {
      lights = FakeLightsService(const [
        LightState(
          id: 'light.desk',
          name: 'Desk',
          isOn: true,
          brightnessPercent: 80,
          kelvin: 2700,
          maxKelvin: 4000,
          capabilities: {LightCapability.brightness, LightCapability.colorTemperature},
        ),
        LightState(
          id: 'light.ceiling',
          name: 'Ceiling',
          isOn: false,
          capabilities: {LightCapability.brightness, LightCapability.color, LightCapability.colorTemperature},
        ),
      ]);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            lightsServiceProvider.overrideWith(() => lights),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.online)),
            ...floorplanWidgetTestOverrides(
              FakePlacementService(const [
                Placement(deviceId: 'light.desk', kind: DeviceKind.light, position: PlanPoint(100, 60)),
                Placement(deviceId: 'light.ceiling', kind: DeviceKind.light, position: PlanPoint(300, 60)),
              ]),
            ),
          ],
        ),
        underTestWidget: const LightColorDialog(roomId: 'office'),
      );
    }

    testWidgets('Given the desk lamp warm and the ceiling off, '
        'when dragging the ceiling onto the desk lamp, '
        'then they become one group and the ceiling takes on its warm white', (tester) async {
      // Given
      await load(tester);
      final separate = find.bySemanticsLabel('Ceiling').evaluate().length;

      // When
      await tester.drag(
        find.bySemanticsLabel('Ceiling'),
        tester.getCenter(find.bySemanticsLabel('Desk')) - tester.getCenter(find.bySemanticsLabel('Ceiling')),
      );
      await tester.pump(const Duration(milliseconds: 400));

      // Then
      expect(separate, 1);
      expect(find.bySemanticsLabel('2 lights'), findsOneWidget);
      expect(lights.commands.last, 'kelvin light.ceiling 2700');
      expect(lights.commands, everyElement(startsWith('kelvin light.ceiling')));
    });

    testWidgets('Given both lamps grouped, when dragging the group to the top, then both get cool white within their '
        'range', (tester) async {
      // Given
      await load(tester);
      await tester.tap(find.text('Group all'));
      await tester.pump(const Duration(milliseconds: 400));
      lights.commands.clear();

      // When
      await tester.drag(find.bySemanticsLabel('2 lights'), const Offset(0, -200));
      await tester.pump(const Duration(milliseconds: 400));

      // Then: the desk lamp only goes up to 4000 K.
      expect(lights.commands, containsAll(['kelvin light.desk 4000', startsWith('kelvin light.ceiling')]));
    });

    testWidgets('Given a group, when tapping it, then its lamps are single pins again', (tester) async {
      // Given
      await load(tester);
      await tester.tap(find.text('Group all'));
      await tester.pump(const Duration(milliseconds: 400));

      // When
      await tester.tap(find.bySemanticsLabel('2 lights'));
      await tester.pump(const Duration(milliseconds: 400));

      // Then
      expect(find.bySemanticsLabel('Desk'), findsOneWidget);
      expect(find.bySemanticsLabel('Ceiling'), findsOneWidget);
    });

    testWidgets('Given the color wheel, when dragging the ceiling to the red at the top left, then only it turns red', (
      tester,
    ) async {
      // Given
      await load(tester);
      await tester.tap(find.text('Color'));
      await tester.pump();

      // When: the ceiling is off and waits in the middle; red sits at −110°.
      await tester.drag(find.bySemanticsLabel('Ceiling'), const Offset(-52, -146));
      await tester.pump(const Duration(milliseconds: 400));

      // Then
      final colors = lights.commands.where((command) => command.startsWith('color')).toList();
      expect(colors, everyElement(startsWith('color light.ceiling ')));
      final [red, green, _] = colors.last.split(' ').last.split(',').map(int.parse).toList();
      expect((red > 200, green < 130), (true, true), reason: 'ends on the red rim: ${colors.last}');
    });
  });
}
