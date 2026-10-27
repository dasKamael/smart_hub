import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';
import 'package:smart_hub/presentation/design_system/atoms/vertical_slider.dart';
import 'package:smart_hub/presentation/screens/music/music.screen.dart';

import '../../../mocks/devices.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('MusicScreen', () {
    const members = ['media_player.office', 'media_player.kitchen'];
    const office = SpeakerState(
      id: 'media_player.office',
      name: 'Office',
      playback: Playback.playing,
      volumePercent: 35,
      groupMembers: members,
      title: 'Morning Light',
      artist: 'Lumen Quartet',
      playlist: 'Morning Coffee',
    );
    const kitchen = SpeakerState(
      id: 'media_player.kitchen',
      name: 'Kitchen',
      playback: Playback.playing,
      volumePercent: 30,
      groupMembers: members,
      title: 'Morning Light',
    );
    const sleep = SpeakerState(
      id: 'media_player.sleep',
      name: 'Sleep',
      playback: Playback.paused,
      volumePercent: 20,
      groupMembers: ['media_player.sleep'],
      title: 'Late Tram',
      artist: 'Kessler',
    );

    late FakeSpeakersService speakers;
    late FakeSpotifyConnectService spotify;

    Future<void> pumpScreen(
      WidgetTester tester, {
      ConnectionStatus status = ConnectionStatus.online,
      List<QueueItem>? queue = const [QueueItem(title: 'Morning Light'), QueueItem(title: 'Slow Rivers')],
      List<ConnectDevice> devices = const [],
      Map<String, SpeakerSetting> settings = const {},
      SpotifyPlayback? playback,
      bool spotifySignedIn = false,
    }) async {
      speakers = FakeSpeakersService(const [kitchen, office, sleep]);
      spotify = FakeSpotifyConnectService((devices: devices, playback: playback));
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            speakersServiceProvider.overrideWith(() => speakers),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(status)),
            mediaFavoritesProvider.overrideWith(
              (ref, speakerId) async => const [
                MediaItem(title: 'Focus Flow', contentId: 'demo:playlist:1', contentType: 'playlist'),
                MediaItem(title: 'Nightline', contentId: 'demo:playlist:5', contentType: 'playlist'),
              ],
            ),
            playQueueProvider.overrideWith((ref, speakerId) async => queue),
            speakerSettingsServiceProvider.overrideWith(() => FakeSpeakerSettingsService(settings)),
            spotifyConnectServiceProvider.overrideWith(() => spotify),
            if (spotifySignedIn) ...[
              spotifyAccountServiceProvider.overrideWith(_SignedIn.new),
              spotifyRecentProvider.overrideWith(
                (ref) async => const [MediaItem(title: 'Daybreak', contentId: 'spotify:album:d', contentType: 'album')],
              ),
              spotifyPlaylistsProvider.overrideWith(
                (ref) async => [
                  const MediaItem(
                    title: 'Liked Songs',
                    contentId: 'spotify:user:rm:collection',
                    contentType: 'playlist',
                  ),
                  for (var i = 1; i <= 8; i++)
                    MediaItem(title: 'List $i', contentId: 'spotify:playlist:$i', contentType: 'playlist'),
                ],
              ),
            ],
          ],
        ),
        underTestWidget: const Padding(padding: EdgeInsets.all(24), child: MusicScreen()),
      );
    }

    /// Opens the places above the place button.
    Future<void> openPlaces(WidgetTester tester) async {
      await tester.tap(find.bySemanticsLabel(RegExp('^Playing on')));
      await tester.pumpAndSettle();
    }

    Finder place(String name) => find.bySemanticsLabel(name);

    testWidgets('Given a playing group and a paused speaker, '
        'when rendering, '
        'then the playing group is shown with its track, favorites and queue', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(find.bySemanticsLabel('Playing on Kitchen + Office'), findsOneWidget);
      expect(find.text('Morning Light'), findsNWidgets(2), reason: 'now playing and queue');
      expect(find.text('Lumen Quartet · Morning Coffee'), findsOneWidget);
      expect(find.bySemanticsLabel('Pause'), findsOneWidget);
      expect(find.text('Focus Flow'), findsOneWidget);
      expect(find.text('Slow Rivers'), findsOneWidget);
    });

    testWidgets('Given the office group plays, '
        'when choosing Sleep as the place, '
        'then Sleep becomes the active one and the music moves there', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await openPlaces(tester);
      await tester.tap(place('Sleep'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Late Tram'), findsOneWidget);
      expect(find.bySemanticsLabel('Playing on Sleep'), findsOneWidget);
      expect(speakers.commands, ['move media_player.office to media_player.sleep']);
      // Lets the selection hold of the shown target run out.
      await tester.pump(CurrentTarget.selectionHold);
    });

    testWidgets('Given the office group, when opening the places, then both of its speakers are marked as one', (
      tester,
    ) async {
      // When
      await pumpScreen(tester);
      await openPlaces(tester);

      // Then
      expect(find.bySemanticsLabel('Playing on Kitchen + Office'), findsOneWidget);
      expect(tester.getSemantics(place('Office')), isSemantics(isSelected: true));
      expect(tester.getSemantics(place('Kitchen')), isSemantics(isSelected: true));
      expect(tester.getSemantics(place('Sleep')), isSemantics(isSelected: false));
    });

    testWidgets('Given the transport, when using it and starting a playlist, then the group leader gets the commands', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.bySemanticsLabel('Previous'));
      await tester.tap(find.bySemanticsLabel('Pause'));
      await tester.tap(find.bySemanticsLabel('Next'));
      await tester.tap(find.bySemanticsLabel('Play Nightline'));
      await tester.pump();

      // Then
      expect(speakers.commands, [
        'previous media_player.office',
        'playPause media_player.office',
        'next media_player.office to Slow Rivers',
        'play Nightline on media_player.office',
      ]);
    });

    testWidgets('Given the office group, when taking the kitchen out and adding Sleep, then the groups change', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);
      await openPlaces(tester);

      // When
      await tester.tap(find.bySemanticsLabel('Remove Kitchen from the group'));
      await tester.tap(find.bySemanticsLabel('Add Sleep to the group'));
      await tester.pump();

      // Then
      expect(speakers.commands, ['leave media_player.kitchen', 'join media_player.sleep to media_player.office']);
    });

    testWidgets('Given the office group plays at 35 and 30, when moving the volume up, then both speakers follow', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);
      final slider = find.byType(VerticalSlider);

      // When
      await tester.tapAt(tester.getTopLeft(slider) + Offset(20, tester.getSize(slider).height * 0.5));
      await tester.pump(const Duration(milliseconds: 300));

      // Then
      expect(speakers.commands, containsAll(['volume media_player.office 50', 'volume media_player.kitchen 50']));
    });

    testWidgets('Given the hub is offline, when tapping the transport, then nothing is sent', (tester) async {
      // Given
      await pumpScreen(tester, status: ConnectionStatus.offline);

      // When
      await tester.tap(find.bySemanticsLabel('Pause'));
      await tester.tap(find.bySemanticsLabel('Play Nightline'));
      await tester.pump();

      // Then
      expect(speakers.commands, isEmpty);
    });

    testWidgets('Given a player without queue, when rendering, then Up next says so', (tester) async {
      await pumpScreen(tester, queue: null);

      expect(find.bySemanticsLabel('Nothing queued here'), findsOneWidget);
    });

    group('with Spotify devices', () {
      const phone = ConnectDevice(id: 'd-phone', name: 'Pixel 9', type: ConnectDeviceType.smartphone);
      const devices = [
        phone,
        ConnectDevice(id: 'd-office', name: 'office', type: ConnectDeviceType.speaker),
        ConnectDevice(id: 'd-tv', name: 'Living room TV', type: ConnectDeviceType.tv),
        ConnectDevice(id: 'd-laptop', name: 'MacBook', type: ConnectDeviceType.computer),
      ];
      const settings = {
        'spotify:Living room TV': SpeakerSetting(id: 'spotify:Living room TV', hidden: true),
        'spotify:MacBook': SpeakerSetting(id: 'spotify:MacBook', displayName: 'Laptop'),
      };

      testWidgets('Given devices with Spotify open, '
          'when rendering, '
          'then they are listed without the speakers, without hidden ones and with their hub names', (tester) async {
        // When
        await pumpScreen(tester, devices: devices, settings: settings);
        await openPlaces(tester);

        // Then
        expect(place('Pixel 9'), findsOneWidget);
        expect(place('Laptop'), findsOneWidget);
        expect(find.bySemanticsLabel('office'), findsNothing, reason: 'already a speaker');
        expect(place('Living room TV'), findsNothing, reason: 'hidden');
      });

      testWidgets('Given Spotify plays on the laptop, '
          'when switching from the laptop to the phone, '
          'then the music moves to the phone', (tester) async {
        // Given
        await pumpScreen(
          tester,
          devices: devices,
          settings: settings,
          playback: SpotifyPlayback(
            deviceId: 'd-laptop',
            isPlaying: true,
            title: 'Slow Rivers',
            positionAt: DateTime(2026),
          ),
        );
        await openPlaces(tester);
        await tester.tap(place('Laptop'));
        await tester.pumpAndSettle();

        // When
        await openPlaces(tester);
        await tester.tap(place('Pixel 9'));
        await tester.pumpAndSettle();

        // Then
        expect(spotify.commands, ['transfer d-phone']);
        expect(find.bySemanticsLabel('Playing on Pixel 9'), findsOneWidget);
        // Lets the selection hold of the shown target run out.
        await tester.pump(CurrentTarget.selectionHold);
      });
    });

    testWidgets('Given Spotify is connected, '
        'when switching to playlists, '
        'then liked songs and own playlists are listed instead of recent albums', (tester) async {
      // Given
      await pumpScreen(tester, spotifySignedIn: true);
      expect(find.text('Daybreak'), findsOneWidget);

      // When
      await tester.tap(find.bySemanticsLabel('Playlists'));
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(find.text('List 8'), find.text('List 1'), const Offset(0, -100));

      // Then
      expect(find.text('Daybreak'), findsNothing);
      expect(find.text('List 8'), findsOneWidget);
    });

    testWidgets('Given no speakers and Spotify not connected, '
        'when rendering, '
        'then it asks to connect Spotify', (tester) async {
      // When
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            speakersServiceProvider.overrideWith(FakeSpeakersService.new),
            speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
            spotifyConnectServiceProvider.overrideWith(FakeSpotifyConnectService.new),
            spotifyAccountServiceProvider.overrideWith(_SignedOut.new),
          ],
        ),
        underTestWidget: const MusicScreen(),
      );

      // Then
      expect(find.text('Connect Spotify'), findsOneWidget);
      expect(find.text('Open settings'), findsOneWidget);
    });

    testWidgets('Given a queue, when tapping the next track under Up next, then the group plays it', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Slow Rivers'));
      await tester.pump();

      // Then
      expect(speakers.commands, ['queue Slow Rivers on media_player.office']);
    });
  });
}

class _SignedIn extends SpotifyAccountService {
  @override
  Future<SpotifyAccount> build() async => const SpotifyAccount.signedIn(displayName: 'Richard');
}

class _SignedOut extends SpotifyAccountService {
  @override
  Future<SpotifyAccount> build() async => const SpotifyAccount.signedOut();
}
