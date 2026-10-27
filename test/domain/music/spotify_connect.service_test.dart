import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/music/spotify/spotify.repository.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';

import '../../utils/riverpod.test_util.dart';

class _MockSpotify extends Mock implements SpotifyRepository {}

class _FakeAccount extends SpotifyAccountService {
  _FakeAccount(this.account);

  final SpotifyAccount account;

  @override
  Future<SpotifyAccount> build() async => account;
}

void main() {
  group('SpotifyConnectService', () {
    const phone = ConnectDevice(id: 'd-phone', name: 'Pixel 9', type: ConnectDeviceType.smartphone, volumePercent: 40);
    const laptop = ConnectDevice(id: 'd-laptop', name: 'MacBook', type: ConnectDeviceType.computer);
    late _MockSpotify spotify;
    late SpotifyPlayback? playback;

    setUp(() {
      spotify = _MockSpotify();
      playback = SpotifyPlayback(
        deviceId: 'd-phone',
        isPlaying: true,
        title: 'Morning Light',
        positionAt: DateTime(2026),
      );
      when(() => spotify.devices()).thenAnswer((_) async => [laptop, phone]);
      when(() => spotify.playback()).thenAnswer((_) async => playback);
      when(() => spotify.pause(any())).thenAnswer((_) async {});
      when(() => spotify.next(any())).thenAnswer((_) async {});
      when(() => spotify.setVolume(any(), any())).thenAnswer((_) async {});
      when(() => spotify.transfer(any())).thenAnswer((_) async {});
    });

    ProviderContainer createContainer({SpotifyAccount account = const SpotifySignedIn(displayName: 'Richard')}) {
      final container = createTestContainer(
        overrides: [
          spotifyAccountServiceProvider.overrideWith(() => _FakeAccount(account)),
          spotifyRepositoryProvider.overrideWithValue(spotify),
        ],
      );
      container.listen(spotifyConnectServiceProvider, (_, _) {});
      return container;
    }

    SpotifyConnectState? stateOf(ProviderContainer container) => container.read(spotifyConnectServiceProvider).value;

    SpotifyConnectService serviceOf(ProviderContainer container) =>
        container.read(spotifyConnectServiceProvider.notifier);

    test('Given a signed out user, when reading Spotify Connect, then there are no devices', () async {
      // Given
      final container = createContainer(account: const SpotifySignedOut());

      // When
      final state = await container.read(spotifyConnectServiceProvider.future);

      // Then
      expect(state.devices, isEmpty);
      verifyNever(() => spotify.devices());
    });

    test('Given a phone opens Spotify, when the next poll runs, then it shows up', () {
      fakeAsync((async) {
        // Given
        when(() => spotify.devices()).thenAnswer((_) async => [laptop]);
        final container = createContainer();
        async.flushMicrotasks();
        expect(stateOf(container)?.devices, [laptop]);

        // When
        when(() => spotify.devices()).thenAnswer((_) async => [laptop, phone]);
        async.elapse(spotifyConnectInterval);

        // Then
        expect(stateOf(container)?.devices, [laptop, phone]);
      });
    });

    test('Given a failing poll, when polling, then the last devices stay', () {
      fakeAsync((async) {
        // Given
        final container = createContainer();
        async.flushMicrotasks();

        // When
        when(() => spotify.devices()).thenThrow(Exception('offline'));
        async.elapse(spotifyConnectInterval);

        // Then
        expect(stateOf(container)?.devices, [laptop, phone]);
      });
    });

    test('Given music on the phone, '
        'when pausing and Spotify still reports playing a second later, '
        'then it shows paused at once and stays paused until Spotify confirms', () {
      fakeAsync((async) {
        // Given
        final container = createContainer();
        async.flushMicrotasks();

        // When
        serviceOf(container).pause('d-phone');
        async.flushMicrotasks();
        final shownAtOnce = stateOf(container)?.playback?.isPlaying;
        async.elapse(spotifyCommandRefreshes.first);
        final shownWhileLagging = stateOf(container)?.playback?.isPlaying;
        playback = playback?.copyWith(isPlaying: false);
        async.elapse(spotifyCommandRefreshes.last - spotifyCommandRefreshes.first);

        // Then
        expect(shownAtOnce, isFalse);
        expect(shownWhileLagging, isFalse);
        expect(stateOf(container)?.playback?.isPlaying, isFalse);
        verify(() => spotify.pause('d-phone')).called(1);
        verify(() => spotify.playback()).called(3);
      });
    });

    test('Given Spotify never takes the pause, when waiting, then playing shows again', () {
      fakeAsync((async) {
        // Given
        final container = createContainer();
        async.flushMicrotasks();

        // When
        serviceOf(container).pause('d-phone');
        async.elapse(const Duration(seconds: 4));

        // Then
        expect(stateOf(container)?.playback?.isPlaying, isTrue);
      });
    });

    test('Given a failing command, when changing the volume, then the old volume shows again', () {
      fakeAsync((async) {
        // Given
        when(() => spotify.setVolume(any(), any())).thenAnswer((_) async => throw Exception('restricted'));
        final container = createContainer();
        async.flushMicrotasks();

        // When
        serviceOf(container).setVolume('d-phone', 70).ignore();
        final shownAtOnce = stateOf(container)?.devices.last.volumePercent;
        async.flushMicrotasks();

        // Then
        expect(shownAtOnce, 70);
        expect(stateOf(container)?.devices.last.volumePercent, 40);
      });
    });

    test('Given music on the phone, when moving it to the laptop, then it shows there at once', () {
      fakeAsync((async) {
        // Given
        final container = createContainer();
        async.flushMicrotasks();

        // When
        serviceOf(container).transfer('d-laptop');
        async.flushMicrotasks();

        // Then
        expect(stateOf(container)?.playback?.deviceId, 'd-laptop');
        verify(() => spotify.transfer('d-laptop')).called(1);
      });
    });

    test('Given a track at 1:40, when skipping, then it starts over at once', () {
      fakeAsync((async) {
        // Given
        playback = playback?.copyWith(positionSeconds: 100);
        final container = createContainer();
        async.flushMicrotasks();

        // When
        serviceOf(container).next('d-phone');
        async.flushMicrotasks();

        // Then
        expect(stateOf(container)?.playback?.positionSeconds, 0);
      });
    });

    test('Given the next track of the queue, when skipping, then the next track shows at once', () {
      fakeAsync((async) {
        // Given
        final container = createContainer();
        async.flushMicrotasks();

        // When
        serviceOf(container).next(
          'd-phone',
          upcoming: const QueueItem(title: 'Slow Rivers', artist: 'Nadia Hale'),
        );
        async.flushMicrotasks();

        // Then
        expect(stateOf(container)?.playback?.title, 'Slow Rivers');
        expect(stateOf(container)?.playback?.artist, 'Nadia Hale');
      });
    });

    test('Given music on the phone, when playing an album, then its name shows at once', () {
      fakeAsync((async) {
        // Given
        when(() => spotify.play(any(), item: any(named: 'item'))).thenAnswer((_) async {});
        final container = createContainer();
        async.flushMicrotasks();

        // When
        serviceOf(container)
            .play('d-phone', const MediaItem(title: 'Daybreak', contentId: 'spotify:album:d', contentType: 'album'));
        async.flushMicrotasks();

        // Then
        expect(stateOf(container)?.playback?.title, 'Daybreak');
      });
    });
  });
}
