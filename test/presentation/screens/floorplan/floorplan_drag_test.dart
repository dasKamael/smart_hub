import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.screen.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('FloorplanScreen dragging', () {
    late FakePlacementService placements;

    Future<void> pumpScreen(WidgetTester tester, {List<Placement>? placed}) async {
      placements = FakePlacementService(
        placed ??
            const [
              Placement(deviceId: 'light.a', kind: DeviceKind.light, position: PlanPoint(100, 60)),
              Placement(deviceId: 'light.b', kind: DeviceKind.light, position: PlanPoint(300, 60)),
            ],
      );
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            lightsServiceProvider.overrideWith(
              () => FakeLightsService(const [
                LightState(id: 'light.a', name: 'Lamp A', isOn: false),
                LightState(id: 'light.b', name: 'Lamp B', isOn: false),
                LightState(id: 'light.c', name: 'Lamp C', isOn: false),
              ]),
            ),
            speakersServiceProvider.overrideWith(FakeSpeakersService.new),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.online)),
            ...floorplanWidgetTestOverrides(placements),
          ],
        ),
        underTestWidget: const Padding(padding: EdgeInsets.all(24), child: FloorplanScreen()),
      );
    }

    Finder marker(String name) => find.byWidgetPredicate((w) => w is DeviceMarker && w.label == name);

    PlanPoint placedAt(String id) => placements.state.requireValue.firstWhere((p) => p.deviceId == id).position;

    testWidgets('Given a placed light, '
        'when dragging it 150 px to the right, '
        'then it is stored further right', (tester) async {
      // Given
      await pumpScreen(tester);
      final before = placedAt('light.a');

      // When
      await tester.drag(marker('Lamp A'), const Offset(150, 0));
      await tester.pumpAndSettle();

      // Then
      expect(placedAt('light.a').x, greaterThan(before.x + 50));
      expect(placedAt('light.a').y, closeTo(before.y, 1));
    });

    testWidgets('Given a placed light, '
        'when moving it less than 5 px, '
        'then it is a tap and selects the light', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(marker('Lamp A'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Office · Off'), findsOneWidget);
      expect(placedAt('light.a'), const PlanPoint(100, 60));
    });

    testWidgets('Given two lights, '
        'when dropping one onto the other, '
        'then it lands next to the target and both form a group', (tester) async {
      // Given
      await pumpScreen(tester);
      final from = tester.getCenter(marker('Lamp A'));
      final to = tester.getCenter(marker('Lamp B'));

      // When
      final gesture = await tester.startGesture(from);
      await gesture.moveBy(const Offset(10, 0));
      await gesture.moveTo(to + const Offset(3, 3));
      await tester.pump();
      final targetPill = find.text('Group');
      final showsTargetPill = targetPill.evaluate().isNotEmpty;
      await gesture.up();
      await tester.pumpAndSettle();

      // Then
      expect(showsTargetPill, isTrue);
      expect(placedAt('light.a'), const PlanPoint(307, 65));
      expect(find.bySemanticsLabel('Group of 2'), findsOneWidget);
    });

    testWidgets('Given a group, '
        'when tapping it and then the close button, '
        'then it fans out and collapses again', (tester) async {
      // Given
      await pumpScreen(
        tester,
        placed: const [
          Placement(deviceId: 'light.a', kind: DeviceKind.light, position: PlanPoint(300, 60)),
          Placement(deviceId: 'light.b', kind: DeviceKind.light, position: PlanPoint(307, 65)),
        ],
      );
      final stacked = tester.getCenter(marker('Lamp B'));

      // When
      await tester.tap(find.bySemanticsLabel('Group of 2'));
      await tester.pumpAndSettle();
      final fanned = tester.getCenter(marker('Lamp B'));
      await tester.tap(find.bySemanticsLabel('Close group'));
      await tester.pumpAndSettle();

      // Then
      expect((fanned - stacked).distance, greaterThan(30));
      expect(find.bySemanticsLabel('Group of 2'), findsOneWidget);
    });

    testWidgets('Given a device in the tray, '
        'when dragging it up onto the plan, '
        'then it is placed there', (tester) async {
      // Given
      await pumpScreen(tester);
      final trayItem = tester.getCenter(marker('Lamp C'));
      final roomCenter = tester.getCenter(find.text('Kitchen')) + const Offset(40, 80);

      // When
      final gesture = await tester.startGesture(trayItem);
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump();
      await gesture.moveTo(roomCenter);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Then
      final placed = placements.state.requireValue.where((p) => p.deviceId == 'light.c');
      expect(placed, hasLength(1));
      expect(placed.single.position.x, inInclusiveRange(450, 715));
    });

    testWidgets('Given a device in the tray, '
        'when dragging it up but releasing outside of the plan, '
        'then it stays in the tray', (tester) async {
      // Given
      await pumpScreen(tester);
      final trayItem = tester.getCenter(marker('Lamp C'));

      // When
      final gesture = await tester.startGesture(trayItem);
      await gesture.moveBy(const Offset(0, -40));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Then
      expect(placements.state.requireValue.where((p) => p.deviceId == 'light.c'), isEmpty);
    });
  });
}
