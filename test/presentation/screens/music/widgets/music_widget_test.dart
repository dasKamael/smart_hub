import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/music/widgets/music_widget.dart';

import '../../../../mocks/devices.mock.dart';
import '../../../../utils/widget.test_util.dart';

void main() {
  group('MusicWidget', () {
    const office = SpeakerState(
      id: 'media_player.office',
      name: 'Office',
      playback: Playback.playing,
      groupMembers: ['media_player.office'],
      title: 'Morning Light',
      artist: 'Lumen Quartet',
    );

    late FakeSpeakersService speakers;

    Future<void> load(
      WidgetTester tester,
      WidgetSize size, {
      List<SpeakerState> withSpeakers = const [office],
      ConnectionStatus status = ConnectionStatus.online,
    }) async {
      speakers = FakeSpeakersService(withSpeakers);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            speakersServiceProvider.overrideWith(() => speakers),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(status)),
            speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
            spotifyConnectServiceProvider.overrideWith(FakeSpotifyConnectService.new),
            mediaFavoritesProvider.overrideWith(
              (ref, speakerId) async => const [
                MediaItem(title: 'Focus Flow', contentId: 'demo:playlist:1', contentType: 'playlist'),
              ],
            ),
            playQueueProvider.overrideWith(
              (ref, speakerId) async => const [
                QueueItem(title: 'Morning Light'),
                QueueItem(title: 'Slow Rivers', artist: 'Nadia Hale'),
              ],
            ),
          ],
        ),
        underTestWidget: Center(child: MusicWidget(size: size)),
      );
    }

    testWidgets('Given the office plays, when shown small, then the track shows on its cover', (tester) async {
      // Given / When
      await load(tester, WidgetSize.small);

      // Then
      expect(find.text('Morning Light'), findsOneWidget);
      expect(find.bySemanticsLabel('Pause'), findsOneWidget);
    });

    testWidgets('Given the office plays, when tapping pause in the medium widget, then the office pauses', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.medium);

      // When
      await tester.tap(find.bySemanticsLabel('Pause'));
      await tester.pump();

      // Then
      expect(speakers.commands, ['playPause media_player.office']);
    });

    testWidgets('Given a queue, when shown large and skipping, then it shows the next track and skips', (tester) async {
      // Given
      await load(tester, WidgetSize.large);
      final upNext = find.text('Slow Rivers · Nadia Hale', findRichText: true).evaluate().length;

      // When
      await tester.tap(find.bySemanticsLabel('Next'));
      await tester.pump();

      // Then
      expect(upNext, 1);
      expect(speakers.commands, ['next media_player.office to Slow Rivers']);
    });

    testWidgets('Given a queue, when tapping the next track in the extra large widget, then the office plays it', (
      tester,
    ) async {
      // Given
      await load(tester, WidgetSize.extraLarge);

      // When
      await tester.tap(find.text('Slow Rivers'));
      await tester.pump();

      // Then
      expect(find.text('Up next'), findsOneWidget);
      expect(speakers.commands, ['queue Slow Rivers on media_player.office']);
    });

    testWidgets('Given the hub is offline, when tapping pause, then nothing is sent', (tester) async {
      // Given
      await load(tester, WidgetSize.medium, status: ConnectionStatus.offline);

      // When
      await tester.tap(find.bySemanticsLabel('Pause'));
      await tester.pump();

      // Then
      expect(speakers.commands, isEmpty);
    });

    testWidgets('Given no speakers and no Spotify devices, when shown, then it says there is nothing to play on', (
      tester,
    ) async {
      // Given / When
      await load(tester, WidgetSize.medium, withSpeakers: const []);

      // Then
      expect(find.text('Nothing to play on'), findsOneWidget);
    });

    testWidgets('Given a queue, when tapping a track under Up next, then it plays', (tester) async {
      // Given
      await load(tester, WidgetSize.large);

      // When
      await tester.tap(find.text('Slow Rivers · Nadia Hale', findRichText: true));
      await tester.pump();

      // Then
      expect(speakers.commands, ['queue Slow Rivers on media_player.office']);
    });
  });
}
