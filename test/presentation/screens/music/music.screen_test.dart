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
import 'package:smart_hub/presentation/screens/music/widgets/connect_device_tile.dart';
import 'package:smart_hub/presentation/screens/music/music.screen.dart';
import 'package:smart_hub/presentation/screens/music/widgets/speaker_tile.dart';

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

    Finder tile(String name) => find.byWidgetPredicate((w) => w is SpeakerTile && w.speaker.name == name);

    bool optionsShown(WidgetTester tester, String name) {
      return tester
          .widget<SpeakerTile>(find.byWidgetPredicate((w) => w is SpeakerTile && w.speaker.name == name))
          .optionsShown;
    }

    testWidgets('Given a playing group and a paused speaker, '
        'when rendering, '
        'then the playing group is shown with its track, favorites and queue', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(find.text('Kitchen + Office'), findsOneWidget);
      expect(find.text('Morning Light'), findsNWidgets(2), reason: 'now playing and queue');
      expect(find.text('Lumen Quartet · Morning Coffee'), findsOneWidget);
      expect(find.bySemanticsLabel('Pause'), findsOneWidget);
      expect(find.text('Focus Flow'), findsOneWidget);
      expect(find.text('Slow Rivers'), findsOneWidget);
    });

    testWidgets('Given the office group plays, '
        'when tapping the Sleep tile, '
        'then Sleep becomes the active one and the music moves there', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(tile('Sleep'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Late Tram'), findsOneWidget);
      expect(tester.widget<SpeakerTile>(tile('Sleep')).active, isTrue);
      expect(tester.widget<SpeakerTile>(tile('Office')).active, isFalse);
      expect(speakers.commands, ['move media_player.office to media_player.sleep']);
    });

    testWidgets('Given the office group, when rendering, then both of its tiles are active as one', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(tester.widget<SpeakerTile>(tile('Office')).active, isTrue);
      expect(tester.widget<SpeakerTile>(tile('Kitchen')).active, isTrue);
      expect(tester.widget<SpeakerTile>(tile('Sleep')).active, isFalse);
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

    testWidgets('Given a speaker tile, '
        'when tapping it and then Leave, '
        'then options appear and the speaker leaves its group', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(tile('Kitchen'));
      await tester.pumpAndSettle();
      final shown = optionsShown(tester, 'Kitchen');
      await tester.tap(find.bySemanticsLabel('Leave group'));
      await tester.pumpAndSettle();

      // Then
      expect(shown, isTrue);
      expect(optionsShown(tester, 'Kitchen'), isFalse);
      expect(speakers.commands, ['leave media_player.kitchen']);
    });

    testWidgets('Given a single speaker, when long pressing it and choosing Join, then it joins the active group', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.longPress(tile('Sleep'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Join group'));
      await tester.pump();

      // Then
      expect(speakers.commands, ['join media_player.sleep to media_player.office']);
    });

    testWidgets('Given open speaker options, when starting a playlist, then the options close', (tester) async {
      // Given
      await pumpScreen(tester);
      await tester.tap(tile('Kitchen'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.bySemanticsLabel('Play Focus Flow'));
      await tester.pumpAndSettle();

      // Then
      expect(optionsShown(tester, 'Kitchen'), isFalse);
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

      expect(find.text('Nothing queued here'), findsOneWidget);
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

      Finder deviceTile(String name) => find.byWidgetPredicate((w) => w is ConnectDeviceTile && w.device.name == name);

      testWidgets('Given devices with Spotify open, '
          'when rendering, '
          'then they are listed without the speakers, without hidden ones and with their hub names', (tester) async {
        // When
        await pumpScreen(tester, devices: devices, settings: settings);

        // Then
        expect(deviceTile('Pixel 9'), findsOneWidget);
        expect(deviceTile('Laptop'), findsOneWidget);
        expect(deviceTile('office'), findsNothing, reason: 'already a speaker');
        expect(deviceTile('Living room TV'), findsNothing, reason: 'hidden');
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
        await tester.ensureVisible(deviceTile('Laptop'));
        await tester.tap(deviceTile('Laptop'));
        await tester.pumpAndSettle();

        // When
        await tester.ensureVisible(deviceTile('Pixel 9'));
        await tester.tap(deviceTile('Pixel 9'));
        await tester.pumpAndSettle();

        // Then
        expect(spotify.commands, ['transfer d-phone']);
        expect(tester.widget<ConnectDeviceTile>(deviceTile('Pixel 9')).active, isTrue);
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
