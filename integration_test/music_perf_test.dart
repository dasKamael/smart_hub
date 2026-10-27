import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_theme.dart';
import 'package:smart_hub/presentation/screens/music/music.screen.dart';
import 'package:smart_hub/presentation/screens/music/widgets/speaker_tile.dart';

/// Frame timings of the music page while Spotify is polled and while using it.
///
/// Run in profile mode: `flutter drive --profile --no-dds --driver=test_driver/perf_driver.dart
/// --target=integration_test/music_perf_test.dart`. Summaries: `build/music_idle|music_use.timeline_summary.json`.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('music page with speakers and Spotify devices', (tester) async {
    final speakers = _Speakers();
    final spotify = _Spotify();
    addTearDown(speakers.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          speakerRepositoryProvider.overrideWithValue(speakers),
          spotifyRepositoryProvider.overrideWithValue(spotify),
          spotifyAccountServiceProvider.overrideWith(_SignedIn.new),
          speakerSettingsServiceProvider.overrideWith(_NoSettings.new),
          connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.online)),
        ],
        child: MaterialApp(
          theme: HubTheme.dark,
          home: const Scaffold(
            body: Padding(padding: EdgeInsets.all(24), child: MusicScreen()),
          ),
        ),
      ),
    );
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    Future<void> frames(int count) async {
      for (var i = 0; i < count; i++) {
        binding.scheduleForcedFrame();
        await tester.pump(const Duration(milliseconds: 16));
      }
    }

    // Playing, Spotify polled in the background.
    await binding.traceAction(() => frames(420), reportKey: 'music_idle');

    await binding.traceAction(() async {
      final playPause = find.bySemanticsLabel(RegExp(r'^(Play|Pause)$'));
      await tester.tap(playPause);
      await frames(60);
      await tester.tap(playPause);
      await frames(60);
      final kitchen = find.byWidgetPredicate((w) => w is SpeakerTile && w.speaker.name == 'Kitchen');
      await tester.tap(kitchen);
      await frames(30);
      final gesture = await tester.startGesture(tester.getCenter(kitchen) - const Offset(80, 0));
      for (var step = 0; step < 90; step++) {
        await gesture.moveBy(Offset(step < 45 ? 3 : -3, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await frames(60);
      await tester.tap(find.text('Pixel 9').first);
      await frames(60);
      await tester.tap(kitchen);
      await frames(60);
    }, reportKey: 'music_use');
  });
}

/// Home Assistant speakers that react like real ones: a command shows up a little later.
class _Speakers extends Fake implements SpeakerRepository {
  static const _latency = Duration(milliseconds: 300);

  final _controller = StreamController<List<SpeakerState>>.broadcast();
  final _timers = <Timer>[];
  late var _speakers = [
    _speaker('media_player.kitchen', 'Kitchen', 30),
    _speaker('media_player.office', 'Office', 35),
    _speaker('media_player.sleep', 'Sleep', 20, groupMembers: const ['media_player.sleep'], playback: Playback.paused),
  ];

  static SpeakerState _speaker(
    String id,
    String name,
    int volume, {
    List<String> groupMembers = const ['media_player.office', 'media_player.kitchen'],
    Playback playback = Playback.playing,
  }) {
    return SpeakerState(
      id: id,
      name: name,
      playback: playback,
      volumePercent: volume,
      groupMembers: groupMembers,
      title: 'Morning Light',
      artist: 'Lumen Quartet',
      playlist: 'Morning Coffee',
      durationSeconds: 214,
      positionSeconds: 60,
      positionUpdatedAt: clock.now(),
    );
  }

  void _later(SpeakerState Function(SpeakerState speaker) change, bool Function(SpeakerState speaker) where) {
    _timers.add(
      Timer(_latency, () {
        _speakers = [for (final speaker in _speakers) where(speaker) ? change(speaker) : speaker];
        _controller.add(_speakers);
      }),
    );
  }

  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    unawaited(_controller.close());
  }

  @override
  Stream<List<SpeakerState>> watchSpeakers() async* {
    yield _speakers;
    yield* _controller.stream;
  }

  @override
  Future<void> playPause(String id) async {
    final leader = _speakers.firstWhere((speaker) => speaker.id == id);
    final playing = leader.playback.isPlaying;
    _later(
      (speaker) => speaker.copyWith(
        playback: playing ? Playback.paused : Playback.playing,
        positionSeconds: speaker.positionAt(clock.now()),
        positionUpdatedAt: clock.now(),
      ),
      (speaker) => leader.groupMembers.contains(speaker.id),
    );
  }

  @override
  Future<void> setVolume(String id, int percent) async {
    _later((speaker) => speaker.copyWith(volumePercent: percent), (speaker) => speaker.id == id);
  }

  @override
  Future<List<MediaItem>> favorites(String id) async => const [];

  @override
  Future<List<QueueItem>?> queue(String id) async => [for (var i = 0; i < 10; i++) QueueItem(title: 'Track $i')];
}

/// Spotify with a phone and a laptop; the phone plays. Commands show up about a second later, as with the real API.
class _Spotify extends Fake implements SpotifyRepository {
  static const _latency = Duration(seconds: 1);

  var _deviceId = 'd-phone';
  var _playing = true;
  var _position = 60.0;
  var _positionAt = clock.now();
  final _volumes = {'d-phone': 40, 'd-laptop': 80};

  void _later(void Function() change) => Timer(_latency, change);

  double get _now => _position + (_playing ? clock.now().difference(_positionAt).inMilliseconds / 1000 : 0);

  void _setPlaying(bool playing) {
    _position = _now;
    _positionAt = clock.now();
    _playing = playing;
  }

  @override
  Future<List<ConnectDevice>> devices() async => [
    ConnectDevice(
      id: 'd-phone',
      name: 'Pixel 9',
      type: ConnectDeviceType.smartphone,
      volumePercent: _volumes['d-phone'],
      supportsVolume: true,
      isActive: _deviceId == 'd-phone',
    ),
    ConnectDevice(
      id: 'd-laptop',
      name: 'MacBook',
      type: ConnectDeviceType.computer,
      volumePercent: _volumes['d-laptop'],
      supportsVolume: true,
      isActive: _deviceId == 'd-laptop',
    ),
  ];

  @override
  Future<SpotifyPlayback?> playback() async {
    return SpotifyPlayback(
      deviceId: _deviceId,
      isPlaying: _playing,
      title: 'Slow Rivers',
      artist: 'Nadia Hale',
      durationSeconds: 300,
      // Spotify's position drifts a little against the local clock.
      positionSeconds: _now + 0.4,
      positionAt: clock.now(),
    );
  }

  @override
  Future<void> pause(String deviceId) async => _later(() => _setPlaying(false));

  @override
  Future<void> play(String deviceId, {MediaItem? item}) async => _later(() => _setPlaying(true));

  @override
  Future<void> setVolume(String deviceId, int percent) async => _later(() => _volumes[deviceId] = percent);

  @override
  Future<void> transfer(String deviceId) async => _later(() => _deviceId = deviceId);

  @override
  Future<List<QueueItem>> queue() async => [for (var i = 0; i < 10; i++) QueueItem(title: 'Spotify $i')];

  @override
  Future<List<MediaItem>> playlists() async => const [];

  @override
  Future<List<MediaItem>> recent() async => [
    for (var i = 0; i < 6; i++) MediaItem(title: 'Album $i', contentId: 'spotify:album:$i', contentType: 'album'),
  ];
}

class _SignedIn extends SpotifyAccountService {
  @override
  Future<SpotifyAccount> build() async => const SpotifyAccount.signedIn(displayName: 'Richard');
}

class _NoSettings extends SpeakerSettingsService {
  @override
  Stream<Map<String, SpeakerSetting>> build() => Stream.value(const {});
}
