import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/design_system/atoms/scene_marker.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/home_scene.color_palette.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.screen.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('FloorplanScreen with plants', () {
    late FakePlantsService plants;

    // testToday is 2026-10-26.
    final monstera = Plant(id: 'p.monstera', name: 'Monstera', everyDays: 7, lastWatered: DateTime(2026, 10, 17));
    final basil = Plant(id: 'p.basil', name: 'Basil', everyDays: 2, lastWatered: DateTime(2026, 10, 24));
    final fern = Plant(
      id: 'p.fern',
      name: 'Fern',
      everyDays: 3,
      lastWatered: DateTime(2026, 10, 26, 8),
      previousWatered: DateTime(2026, 10, 23),
    );
    final fig = Plant(id: 'p.fig', name: 'Fig', everyDays: 7, lastWatered: DateTime(2026, 10, 23));

    Future<void> pumpScreen(WidgetTester tester) async {
      plants = FakePlantsService([monstera, basil, fern, fig]);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            lightsServiceProvider.overrideWith(FakeLightsService.new),
            speakersServiceProvider.overrideWith(FakeSpeakersService.new),
            // Plants are local: watering works offline.
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.offline)),
            ...floorplanWidgetTestOverrides(
              FakePlacementService(const [
                Placement(deviceId: 'p.monstera', kind: DeviceKind.plant, position: PlanPoint(290, 120)),
                Placement(deviceId: 'p.basil', kind: DeviceKind.plant, position: PlanPoint(380, 60)),
                Placement(deviceId: 'p.fern', kind: DeviceKind.plant, position: PlanPoint(960, 330)),
              ]),
              plants: plants,
            ),
          ],
        ),
        underTestWidget: const Padding(padding: EdgeInsets.all(24), child: FloorplanScreen()),
      );
    }

    Finder marker(String name) => find.byWidgetPredicate((w) => w is DeviceMarker && w.label == name);

    DeviceMarker markerOf(WidgetTester tester, String name) => tester.widget<DeviceMarker>(marker(name).first);

    testWidgets('Given plants in every state, '
        'when rendering, '
        'then overdue has a red ring and badge, due today a blue ring and the others a subtle ring', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(markerOf(tester, 'Monstera').badge, MarkerBadge.alert);
      expect(markerOf(tester, 'Monstera').ringColor, HubColorPalette.danger);
      expect(markerOf(tester, 'Basil').ringColor, HubColorPalette.accent);
      expect(markerOf(tester, 'Basil').badge, MarkerBadge.none);
      expect(markerOf(tester, 'Fern').ringColor, HomeSceneColorPalette.markerOffBorder);
      expect(markerOf(tester, 'Fern').ringWidth, lessThan(markerOf(tester, 'Basil').ringWidth));
      expect(find.text('Fig'), findsOneWidget, reason: 'unplaced plant in the tray');
    });

    testWidgets('Given plants in every state, when tilting the plan into 3D, then overdue has a red ring and dot and due '
        'today a blue ring', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.bySemanticsLabel('3D view'));
      await tester.pumpAndSettle();

      // Then
      SceneMarker sceneMarkerOf(String name) =>
          tester.widget<SceneMarker>(find.byWidgetPredicate((w) => w is SceneMarker && w.semanticLabel == name));
      expect(sceneMarkerOf('Monstera').ringColor, HubColorPalette.danger);
      expect(sceneMarkerOf('Monstera').alert, isTrue);
      expect(sceneMarkerOf('Basil').ringColor, HubColorPalette.accent);
      expect(sceneMarkerOf('Basil').alert, isFalse);
      expect(sceneMarkerOf('Fern').ringColor, isNull);
    });

    testWidgets('Given an overdue plant, '
        'when selecting it and tapping Water now, '
        'then the inspector shows the status and the plant is watered', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(marker('Monstera'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Water now'));

      // Then
      expect(find.text('Office · Every 7 days'), findsOneWidget);
      expect(find.text('2 days overdue'), findsOneWidget);
      expect(plants.commands, ['water p.monstera']);
    });

    testWidgets('Given a plant watered today, '
        'when selecting it, '
        'then it offers Undo', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(marker('Fern'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Undo'));

      // Then
      expect(find.text('Watered today · next in 3 days'), findsOneWidget);
      expect(plants.commands, ['undo p.fern']);
    });

    testWidgets('Given two plants in the office of which both are due, '
        'when selecting the room, '
        'then Water 2 waters both', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Office'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Water 2'));

      // Then
      expect(find.text('2 · 2 to water'), findsOneWidget);
      expect(plants.commands.single, anyOf('water p.monstera,p.basil', 'water p.basil,p.monstera'));
    });
  });
}
