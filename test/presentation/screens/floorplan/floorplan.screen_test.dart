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
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/color_swatch_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/design_system/atoms/slider_bar.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.screen.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('FloorplanScreen', () {
    const desk = LightState(
      id: 'light.desk',
      name: 'Desk lamp',
      isOn: true,
      brightnessPercent: 80,
      color: RgbColor(255, 179, 64),
      capabilities: {LightCapability.brightness, LightCapability.color},
    );
    const wc = LightState(id: 'light.wc', name: 'WC light', isOn: false);
    const hall = LightState(id: 'light.hall', name: 'Hall light', isOn: false);
    const office = SpeakerState(
      id: 'media_player.office',
      name: 'Office speaker',
      playback: Playback.playing,
      volumePercent: 35,
      groupMembers: ['media_player.office', 'media_player.kitchen'],
      title: 'Morning Light',
      artist: 'Lumen Quartet',
    );

    late FakeLightsService lights;
    late FakeSpeakersService speakers;
    late FakePlacementService placements;

    Future<void> pumpScreen(WidgetTester tester, {ConnectionStatus status = ConnectionStatus.online}) async {
      lights = FakeLightsService(const [desk, wc, hall]);
      speakers = FakeSpeakersService(const [office]);
      placements = FakePlacementService(const [
        Placement(deviceId: 'light.desk', kind: DeviceKind.light, position: PlanPoint(390, 70)),
        Placement(deviceId: 'light.wc', kind: DeviceKind.light, position: PlanPoint(770, 180)),
        Placement(deviceId: 'media_player.office', kind: DeviceKind.speaker, position: PlanPoint(60, 110)),
      ]);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            lightsServiceProvider.overrideWith(() => lights),
            speakersServiceProvider.overrideWith(() => speakers),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(status)),
            ...floorplanWidgetTestOverrides(placements),
          ],
        ),
        underTestWidget: const Padding(padding: EdgeInsets.all(24), child: FloorplanScreen()),
      );
    }

    Finder marker(String name) => find.byWidgetPredicate((w) => w is DeviceMarker && w.label == name);

    testWidgets('Given placed and unplaced devices, '
        'when rendering, '
        'then rooms are labeled, placed devices are markers and the rest is in the tray', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      for (final room in ['Office', 'Kitchen', 'Hall', 'Sleep', 'WC', 'Storage', 'Storage 2']) {
        expect(find.text(room), findsOneWidget, reason: room);
      }
      expect(find.text('9.0 m²'), findsOneWidget);
      expect(marker('Desk lamp'), findsOneWidget);
      expect(marker('Office speaker'), findsOneWidget);
      expect(find.text('Hall light'), findsOneWidget, reason: 'tray item name');
      expect(find.text('Tap a room or device'), findsOneWidget);
    });

    testWidgets('Given the plan, '
        'when tapping inside the kitchen, '
        'then the room inspector shows the kitchen', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Kitchen'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Kitchen'), findsNWidgets(2));
      expect(find.text('12.9 m²'), findsNWidgets(2));
      expect(find.text('None'), findsNWidgets(3));
    });

    testWidgets('Given the plan, '
        'when tapping the office, '
        'then lights and the playing speaker are summarized and lights can be switched off', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Office'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lights off'));

      // Then
      expect(find.text('1 of 1 on'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);
      expect(lights.commands, ['off light.desk']);
    });

    testWidgets('Given a light marker, '
        'when tapping it, '
        'then the light inspector shows name, room, brightness and color swatches', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(marker('Desk lamp'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Desk lamp'), findsNWidgets(2), reason: 'name pill and inspector title');
      expect(find.text('Office · 80%'), findsOneWidget);
      expect(find.byType(SliderBar), findsOneWidget);
      expect(find.byType(ColorSwatchButton), findsNWidgets(5));
    });

    testWidgets('Given an on/off-only light, '
        'when selecting it, '
        'then neither slider nor swatches are shown', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(marker('WC light'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('WC · Off'), findsOneWidget);
      expect(find.byType(SliderBar), findsNothing);
      expect(find.byType(ColorSwatchButton), findsNothing);
    });

    testWidgets('Given a selected light, '
        'when tapping the power button, a swatch and Remove, '
        'then the commands are sent and the light goes back to the tray', (tester) async {
      // Given
      await pumpScreen(tester);
      await tester.tap(marker('Desk lamp'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.bySemanticsLabel('Turn off'));
      await tester.tap(find.byType(ColorSwatchButton).last);
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      // Then
      expect(lights.commands, ['off light.desk', 'color light.desk 191,90,242']);
      expect(placements.removed, ['light.desk']);
      expect(find.text('Desk lamp'), findsOneWidget, reason: 'only the tray item name is left');
      expect(find.text('Tap a room or device'), findsOneWidget);
    });

    testWidgets('Given the hub is offline, '
        'when tapping the power button of a light, '
        'then nothing is sent', (tester) async {
      // Given
      await pumpScreen(tester, status: ConnectionStatus.offline);
      await tester.tap(marker('Desk lamp'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.bySemanticsLabel('Turn off'));
      await tester.pumpAndSettle();

      // Then
      expect(lights.commands, isEmpty);
      expect(tester.widget<SliderBar>(find.byType(SliderBar)).onChanged, isNull);
    });

    testWidgets('Given a speaker marker, '
        'when tapping it and then play/pause and Leave group, '
        'then the speaker inspector sends the commands', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(marker('Office speaker'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Pause'));
      await tester.tap(find.text('Leave group'));

      // Then
      expect(find.text('Morning Light'), findsOneWidget);
      expect(find.text('Volume 35%'), findsOneWidget);
      expect(speakers.commands, ['playPause media_player.office', 'leave media_player.office']);
    });

    testWidgets('Given visible lights, '
        'when switching the Lights layer off, '
        'then light markers ignore taps', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Lights'));
      await tester.pumpAndSettle();
      await tester.tap(marker('Desk lamp'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Office · 80%'), findsNothing);
    });
  });
}
