import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/screens/settings/speakers.screen.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('SpeakersScreen', () {
    late FakeSpeakerSettingsService settings;

    Future<void> pumpScreen(WidgetTester tester) async {
      settings = FakeSpeakerSettingsService(const {
        'media_player.sleep': SpeakerSetting(id: 'media_player.sleep', hidden: true),
      });
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            speakerSettingsServiceProvider.overrideWith(() => settings),
            placementServiceProvider.overrideWith(FakePlacementService.new),
            speakersServiceProvider.overrideWith(
              () => FakeSpeakersService(const [
                SpeakerState(id: 'media_player.sleep', name: 'Sleep', playback: Playback.idle),
              ]),
            ),
            spotifyConnectServiceProvider.overrideWith(
              () => FakeSpotifyConnectService((
                devices: const [ConnectDevice(id: 'd-phone', name: 'Pixel 9', type: ConnectDeviceType.smartphone)],
                playback: null,
              )),
            ),
          ],
        ),
        underTestWidget: const SpeakersScreen(),
      );
    }

    testWidgets('Given a hidden speaker that is not placed and a phone, '
        'when rendering, '
        'then both rows show their source and state', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(find.text('Home Assistant · Hidden · Not on the plan'), findsOneWidget);
      expect(find.text('Spotify'), findsOneWidget);
    });

    testWidgets('Given the hidden speaker, when tapping it, then Show and Place are offered', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Sleep'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Show').hitTestable(), findsOneWidget);
      expect(find.text('Place').hitTestable(), findsOneWidget);
      expect(find.text('Hide').hitTestable(), findsNothing);
    });

    testWidgets('Given the phone, when hiding it and making it the default, then both are saved', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Pixel 9'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hide').hitTestable());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pixel 9'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Default').hitTestable());
      await tester.pumpAndSettle();

      // Then
      expect(settings.commands, ['hide spotify:Pixel 9', 'default spotify:Pixel 9']);
    });

    testWidgets('Given the phone, when renaming it, then the new name is saved', (tester) async {
      // Given
      await pumpScreen(tester);
      await tester.tap(find.text('Pixel 9'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.text('Rename').hitTestable());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Phone');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Then
      expect(settings.commands, ['rename spotify:Pixel 9 Phone']);
    });
  });
}
