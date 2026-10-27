import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/utils/optimistic_overlay.dart';
import 'package:smart_hub/data/music/spotify/spotify.repository.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';

part 'spotify_connect.service.g.dart';

/// Devices with Spotify open and what plays where.
typedef SpotifyConnectState = ({List<ConnectDevice> devices, SpotifyPlayback? playback});

const spotifyConnectInterval = Duration(seconds: 5);

/// Spotify needs a moment until a command shows in its state; it is read again after these delays.
const spotifyCommandRefreshes = [Duration(seconds: 1), Duration(seconds: 3)];

/// Spotify Connect, polled every [spotifyConnectInterval] while someone listens (Spotify has no push for this),
/// and the playback commands. Empty while signed out.
///
/// Commands show at once (optimistic) and roll back when Spotify does not report the change in time or the command
/// fails (`README` → "Optimistic UI").
@riverpod
class SpotifyConnectService extends _$SpotifyConnectService {
  static final _log = Logger('SpotifyConnectService');
  static const _empty = (devices: <ConnectDevice>[], playback: null);
  static const _playbackId = 'playback';

  late OptimisticOverlay<ConnectDevice> _devices;
  late OptimisticOverlay<SpotifyPlayback> _playback;
  SpotifyConnectState _reported = _empty;
  final _refreshes = <Timer>[];

  @override
  Future<SpotifyConnectState> build() async {
    const timeout = Duration(seconds: 4);
    _devices = OptimisticOverlay(idOf: (device) => device.id, onChanged: _publish, timeout: timeout);
    _playback = OptimisticOverlay(idOf: (_) => _playbackId, onChanged: _publish, timeout: timeout);
    ref.onDispose(() {
      for (final timer in _refreshes) {
        timer.cancel();
      }
      _devices.dispose();
      _playback.dispose();
    });
    final repository = ref.watch(spotifyRepositoryProvider);
    final account = await ref.watch(spotifyAccountServiceProvider.future);
    if (account is! SpotifySignedIn || !ref.mounted) return _empty;

    final timer = Timer.periodic(spotifyConnectInterval, (_) => unawaited(_load(repository)));
    ref.onDispose(timer.cancel);
    await _load(repository);
    return _applied();
  }

  /// Plays [item] on [deviceId]; its name and cover show at once until Spotify reports the first track.
  Future<void> play(String deviceId, MediaItem item) {
    final now = clock.now();
    final title = _reported.playback?.title;
    _playback.add(
      _playbackId,
      apply: (playback) => playback.copyWith(
        deviceId: deviceId,
        isPlaying: true,
        title: item.title,
        artist: null,
        artworkUrl: item.artworkUrl,
        positionSeconds: 0,
        positionAt: now,
      ),
      isConfirmed: (playback) => playback.deviceId == deviceId && playback.isPlaying && playback.title != title,
    );
    return _run(_repository.play(deviceId, item: item));
  }

  Future<void> resume(String deviceId) => _setPlaying(_repository.play(deviceId), playing: true);

  Future<void> pause(String deviceId) => _setPlaying(_repository.pause(deviceId), playing: false);

  /// Skips; [upcoming] (the next track of the queue, when known) shows at once.
  Future<void> next(String deviceId, {QueueItem? upcoming}) => _skip(_repository.next(deviceId), upcoming: upcoming);

  Future<void> previous(String deviceId) => _skip(_repository.previous(deviceId));

  /// Jumps [steps] tracks ahead to [item]; it shows at once and stays until Spotify plays it. Spotify cannot jump
  /// into its queue, so it skips.
  Future<void> skipTo(String deviceId, QueueItem item, {required int steps}) {
    if (steps <= 0) return Future.value();
    final now = clock.now();
    _playback.add(
      _playbackId,
      apply: (playback) => playback.copyWith(
        isPlaying: true,
        title: item.title,
        artist: item.artist,
        artworkUrl: item.coverUrl ?? item.artworkUrl,
        positionSeconds: 0,
        positionAt: now,
      ),
      isConfirmed: (playback) => playback.title == item.title,
      // Every skip is a request of its own; the track only shows up in Spotify's state after the last one.
      timeout: Duration(seconds: 4 + steps),
    );
    return _run(() async {
      for (var step = 0; step < steps; step++) {
        await _repository.next(deviceId);
      }
    }());
  }

  Future<void> setVolume(String deviceId, int percent) {
    final value = percent.clamp(0, 100);
    _devices.add(
      deviceId,
      apply: (device) => device.copyWith(volumePercent: value),
      isConfirmed: (device) => ((device.volumePercent ?? -10) - value).abs() <= 1,
    );
    return _run(_repository.setVolume(deviceId, value), devices: [deviceId]);
  }

  /// Moves what is playing to [deviceId].
  Future<void> transfer(String deviceId) {
    _playback.add(
      _playbackId,
      apply: (playback) => playback.copyWith(deviceId: deviceId, isPlaying: true),
      isConfirmed: (playback) => playback.deviceId == deviceId,
    );
    return _run(_repository.transfer(deviceId));
  }

  SpotifyRepository get _repository => ref.read(spotifyRepositoryProvider);

  Future<void> _setPlaying(Future<void> command, {required bool playing}) {
    final now = clock.now();
    _playback.add(
      _playbackId,
      apply: (playback) =>
          playback.copyWith(isPlaying: playing, positionSeconds: _positionOf(playback, now), positionAt: now),
      isConfirmed: (playback) => playback.isPlaying == playing,
    );
    return _run(command);
  }

  /// The track starts over at once, as [upcoming] when that is known; Spotify confirms the new title.
  Future<void> _skip(Future<void> command, {QueueItem? upcoming}) {
    final title = _reported.playback?.title;
    final now = clock.now();
    _playback.add(
      _playbackId,
      apply: (playback) => switch (upcoming) {
        null => playback.copyWith(positionSeconds: 0, positionAt: now),
        final upcoming => playback.copyWith(
          title: upcoming.title,
          artist: upcoming.artist,
          artworkUrl: upcoming.coverUrl ?? upcoming.artworkUrl,
          positionSeconds: 0,
          positionAt: now,
        ),
      },
      isConfirmed: (playback) => playback.title != title,
    );
    return _run(command);
  }

  Future<void> _run(Future<void> command, {List<String> devices = const []}) async {
    try {
      await command;
    } on Object {
      _playback.remove(const [_playbackId]);
      _devices.remove(devices);
      rethrow;
    }
    if (!ref.mounted) return;
    final repository = _repository;
    for (final delay in spotifyCommandRefreshes) {
      _refreshes.add(Timer(delay, () => unawaited(_load(repository))));
    }
  }

  Future<void> _load(SpotifyRepository repository) async {
    try {
      final (devices, playback) = await (repository.devices(), repository.playback()).wait;
      if (!ref.mounted) return;
      _reported = (devices: devices, playback: playback);
      _publish();
    } on Object catch (e) {
      // Keep the last state; the next poll tries again.
      _log.warning('Could not read Spotify Connect: $e');
    }
  }

  SpotifyConnectState _applied() {
    final playback = _reported.playback;
    return (
      devices: _devices.applyTo(_reported.devices),
      playback: playback == null ? null : _playback.applyTo([playback]).single,
    );
  }

  void _publish() {
    if (ref.mounted && state.hasValue) state = AsyncData(_applied());
  }

  static double _positionOf(SpotifyPlayback playback, DateTime now) {
    final elapsed = playback.isPlaying ? now.difference(playback.positionAt).inMilliseconds / 1000 : 0.0;
    final position = playback.positionSeconds + (elapsed < 0 ? 0 : elapsed);
    return switch (playback.durationSeconds) {
      final duration? => position.clamp(0, duration.toDouble()),
      null => position,
    };
  }
}

/// Spotify's play queue; reloaded when the track changes.
@riverpod
Future<List<QueueItem>> spotifyQueue(Ref ref) async {
  ref.watch(spotifyConnectServiceProvider.select((state) => state.value?.playback?.title));
  return ref.watch(spotifyRepositoryProvider).queue();
}
