import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';

import '../../../mocks/devices.mock.dart';
import '../../../utils/riverpod.test_util.dart';

void main() {
  group('currentTarget', () {
    const phone = ConnectDevice(id: 'd-phone', name: 'Pixel 9', type: ConnectDeviceType.smartphone);
    SpeakerState speaker(String id, String name, Playback playback) =>
        SpeakerState(id: id, name: name, playback: playback, groupMembers: [id]);

    Future<ProviderContainer> createContainer({
      required List<SpeakerState> speakers,
      bool phonePlays = false,
      Map<String, SpeakerSetting> settings = const {},
    }) async {
      final container = createTestContainer(
        overrides: [
          speakersServiceProvider.overrideWith(() => FakeSpeakersService(speakers)),
          speakerSettingsServiceProvider.overrideWith(() => FakeSpeakerSettingsService(settings)),
          spotifyConnectServiceProvider.overrideWith(
            () => FakeSpotifyConnectService((
              devices: const [phone],
              playback: SpotifyPlayback(deviceId: 'd-phone', isPlaying: phonePlays, positionAt: DateTime(2026)),
            )),
          ),
        ],
      );
      container.listen(currentTargetProvider(visible: true), (_, _) {});
      await container.read(speakersServiceProvider.future);
      await container.read(speakerSettingsServiceProvider.future);
      await container.read(spotifyConnectServiceProvider.future);
      return container;
    }

    String? shown(ProviderContainer container) => container.read(currentTargetProvider(visible: true))?.name;

    test('Given the office plays and the phone too, '
        'when the office is paused, '
        'then the phone is shown – music plays in one place only', () async {
      // Given
      final container = await createContainer(
        speakers: [speaker('media_player.office', 'Office', Playback.playing)],
        phonePlays: true,
      );
      expect(shown(container), 'Office');

      // When
      container.read(speakersServiceProvider.notifier).state = AsyncData([
        speaker('media_player.office', 'Office', Playback.paused),
      ]);

      // Then
      expect(shown(container), 'Pixel 9');
    });

    test('Given nothing plays, when the phone starts, then the phone is shown', () async {
      // Given
      final container = await createContainer(speakers: [speaker('media_player.office', 'Office', Playback.paused)]);
      expect(shown(container), 'Office');

      // When
      container.read(spotifyConnectServiceProvider.notifier).state = AsyncData((
        devices: const [phone],
        playback: SpotifyPlayback(deviceId: 'd-phone', isPlaying: true, positionAt: DateTime(2026)),
      ));

      // Then
      expect(shown(container), 'Pixel 9');
    });

    test('Given nothing plays and a default speaker, when reading, then the default speaker is shown', () async {
      // When
      final container = await createContainer(
        speakers: [
          speaker('media_player.office', 'Office', Playback.paused),
          speaker('media_player.sleep', 'Sleep', Playback.paused),
        ],
        settings: const {'media_player.sleep': SpeakerSetting(id: 'media_player.sleep', isDefault: true)},
      );

      // Then
      expect(shown(container), 'Sleep');
    });

    test('Given the phone was selected a while ago and the office plays, '
        'when the office plays on, then the office is shown – music plays in one place only', () async {
      // Given
      final start = DateTime(2026, 10, 27, 20);
      final container = await withClock(Clock.fixed(start), () async {
        final container = await createContainer(speakers: [speaker('media_player.office', 'Office', Playback.paused)]);
        container.read(musicControllerProvider.notifier).selectTarget('spotify-device:d-phone');
        shown(container);
        return container;
      });

      // When
      final later = withClock(Clock.fixed(start.add(const Duration(seconds: 10))), () {
        container.read(speakersServiceProvider.notifier).state = AsyncData([
          speaker('media_player.office', 'Office', Playback.playing),
        ]);
        return shown(container);
      });

      // Then
      expect(later, 'Office');
    });

    test('Given the phone was just selected, when the office still plays, then the phone stays shown', () async {
      // Given
      final container = await createContainer(speakers: [speaker('media_player.office', 'Office', Playback.paused)]);
      container.read(musicControllerProvider.notifier).selectTarget('spotify-device:d-phone');

      // When
      container.read(speakersServiceProvider.notifier).state = AsyncData([
        speaker('media_player.office', 'Office', Playback.playing),
      ]);

      // Then: music is on its way to the phone.
      expect(shown(container), 'Pixel 9');
    });

    test('Given a playing and a paused target, when playback changes, then the order stays', () async {
      // Given
      final container = await createContainer(
        speakers: [speaker('media_player.office', 'Office', Playback.paused)],
        phonePlays: true,
      );

      // When
      final order = [for (final target in container.read(playbackTargetsProvider(visible: true))) target.name];

      // Then
      expect(order, ['Office', 'Pixel 9']);
    });

    group('MusicController.tapTile', () {
      const office = SpeakerState(
        id: 'media_player.office',
        name: 'Office',
        playback: Playback.paused,
        groupMembers: ['media_player.office'],
      );
      const phone = ConnectDevice(id: 'd-phone', name: 'Pixel 9', type: ConnectDeviceType.smartphone);
      final phonePlays = SpotifyPlayback(
        deviceId: 'd-phone',
        isPlaying: true,
        title: 'Slow Rivers',
        contextUri: 'spotify:playlist:mc',
        positionAt: DateTime(2026),
      );
      late FakeSpeakersService speakers;
      late FakeSpotifyConnectService spotify;

      Future<ProviderContainer> createContainer({List<ConnectDevice> devices = const [phone]}) async {
        speakers = FakeSpeakersService(const [office]);
        spotify = FakeSpotifyConnectService((devices: devices, playback: phonePlays));
        final container = createTestContainer(
          overrides: [
            speakersServiceProvider.overrideWith(() => speakers),
            speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
            spotifyConnectServiceProvider.overrideWith(() => spotify),
          ],
        );
        container.listen(currentTargetProvider(visible: true), (_, _) {});
        await container.read(speakersServiceProvider.future);
        await container.read(speakerSettingsServiceProvider.future);
        await container.read(spotifyConnectServiceProvider.future);
        return container;
      }

      void tap(ProviderContainer container, String name) {
        final current = container.read(currentTargetProvider(visible: true));
        final target = container.read(playbackTargetsProvider(visible: true)).firstWhere((t) => t.name == name);
        container.read(musicControllerProvider.notifier).tapTile(target, current: current, tileId: target.id);
      }

      test('Given Spotify plays on the phone, '
          'when choosing a speaker without a Spotify device of its own, '
          'then the playlist starts on the speaker and the phone pauses', () async {
        // Given
        final container = await createContainer();
        expect(container.read(currentTargetProvider(visible: true))?.name, 'Pixel 9');

        // When
        tap(container, 'Office');
        await Future<void>.delayed(Duration.zero);

        // Then
        expect(speakers.commands, ['play Slow Rivers on media_player.office']);
        expect(spotify.commands, ['pause d-phone']);
        expect(container.read(currentTargetProvider(visible: true))?.name, 'Office');
      });

      test('Given Spotify plays on the phone and the speaker is a Spotify device too, '
          'when choosing the speaker, '
          'then Spotify moves the music there', () async {
        // Given
        final container = await createContainer(
          devices: const [
            phone,
            ConnectDevice(id: 'd-office', name: 'Office', type: ConnectDeviceType.speaker),
          ],
        );

        // When
        tap(container, 'Office');
        await Future<void>.delayed(Duration.zero);

        // Then
        expect(spotify.commands, ['transfer d-office']);
        expect(speakers.commands, isEmpty);
      });

      test('Given the active one, when tapping it, then its options show and nothing moves', () async {
        // Given
        final container = await createContainer();

        // When
        tap(container, 'Pixel 9');

        // Then
        expect(container.read(musicControllerProvider).openTileId, 'spotify-device:d-phone');
        expect(spotify.commands, isEmpty);
      });
    });
  });

  group('upNext', () {
    test('Given a queue, when the second track plays, then the third one is next', () async {
      // Given
      final container = createTestContainer(
        overrides: [
          speakersServiceProvider.overrideWith(
            () => FakeSpeakersService(const [
              SpeakerState(
                id: 'media_player.office',
                name: 'Office',
                playback: Playback.playing,
                groupMembers: ['media_player.office'],
                title: 'Slow Rivers',
              ),
            ]),
          ),
          speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
          spotifyConnectServiceProvider.overrideWith(FakeSpotifyConnectService.new),
          playQueueProvider.overrideWith(
            (ref, id) async => const [
              QueueItem(title: 'Morning Light'),
              QueueItem(title: 'Slow Rivers'),
              QueueItem(title: 'Copper Sky', coverUrl: 'https://covers/copper.jpg'),
            ],
          ),
        ],
      );
      container.listen(upNextProvider(visible: true), (_, _) {});
      await container.read(speakersServiceProvider.future);
      await container.read(speakerSettingsServiceProvider.future);
      await container.read(playQueueProvider('media_player.office').future);

      // When
      final next = container.read(upNextProvider(visible: true));

      // Then
      expect(next?.coverUrl, 'https://covers/copper.jpg');
    });
  });
}
