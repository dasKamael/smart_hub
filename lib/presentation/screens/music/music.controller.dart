import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';
import 'package:smart_hub/presentation/shared_widgets/cover_colors.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/common/utils/throttler.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/play_queue.util.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/screens/music/library_view.enum.dart';
import 'package:smart_hub/presentation/screens/music/music.state.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/presentation/screens/music/speaker_group.dart';

part 'music.controller.g.dart';

/// Music page: which target is shown, which tile shows its options, and the playback commands.
@riverpod
class MusicController extends _$MusicController {
  static final _log = Logger('MusicController');
  static const sliderInterval = Duration(milliseconds: 200);

  final _throttlers = <String, Throttler>{};

  @override
  MusicPageState build() {
    ref.onDispose(() {
      for (final throttler in _throttlers.values) {
        throttler.dispose();
      }
    });
    return const MusicPageState();
  }

  void selectTarget(String targetId) => state = state.copyWith(targetId: targetId);

  /// Plays on [target] from now on; when music plays on [current] it moves along – music plays in one place only.
  void moveTo(PlaybackTarget target, {required PlaybackTarget? current}) {
    if (current?.id == target.id) return;
    final playing = current != null && current.nowPlaying.isPlaying && !target.nowPlaying.isPlaying;
    selectTarget(target.id);
    if (playing) _run('move playback', _move(current, target));
  }

  void showLibrary(LibraryView view) => state = state.copyWith(libraryView: view);

  void playPause(PlaybackTarget target) {
    switch (target) {
      case SpeakerGroupTarget(:final group):
        _transport('play/pause', _speakers.playPause(group.leaderId));
      case ConnectTarget(:final device, :final nowPlaying):
        _transport('play/pause', nowPlaying.isPlaying ? _spotify.pause(device.id) : _spotify.resume(device.id));
    }
  }

  /// Skips; the next track of the queue shows at once when the queue is loaded. The queue is read here, not in the
  /// services: it watches them.
  void next(PlaybackTarget target) {
    final title = target.nowPlaying.title;
    switch (target) {
      case SpeakerGroupTarget(:final group):
        final upcoming = PlayQueueUtil.nextAfter(ref.read(playQueueProvider(group.leaderId)).value, title);
        _transport('skip', _speakers.next(group.leaderId, upcoming: upcoming));
      case ConnectTarget(:final device):
        final upcoming = PlayQueueUtil.nextAfter(ref.read(spotifyQueueProvider).value, title);
        _transport('skip', _spotify.next(device.id, upcoming: upcoming));
    }
  }

  /// Jumps to [item] of the target's "Up next".
  void playFromQueue(PlaybackTarget target, QueueItem item) {
    switch (target) {
      case SpeakerGroupTarget(:final group):
        _transport('play ${item.title}', _speakers.playFromQueue(group.leaderId, item));
      case ConnectTarget(:final device):
        // Spotify's queue starts with the playing track: the place of the item is the number of skips.
        final queue = ref.read(spotifyQueueProvider).value ?? const <QueueItem>[];
        final current = queue.indexWhere((queued) => queued.title == target.nowPlaying.title);
        final steps = queue.indexOf(item) - (current < 0 ? -1 : current);
        _transport('play ${item.title}', _spotify.skipTo(device.id, item, steps: steps));
    }
  }

  void previous(PlaybackTarget target) {
    switch (target) {
      case SpeakerGroupTarget(:final group):
        _transport('go back', _speakers.previous(group.leaderId));
      case ConnectTarget(:final device):
        _transport('go back', _spotify.previous(device.id));
    }
  }

  void seek(PlaybackTarget target, int seconds) {
    switch (target) {
      case SpeakerGroupTarget(:final group):
        _transport('seek', _speakers.seek(group.leaderId, seconds));
      case ConnectTarget(:final device):
        _transport('seek', _spotify.seek(device.id, seconds));
    }
  }

  void play(PlaybackTarget target, MediaItem item) {
    switch (target) {
      case SpeakerGroupTarget(:final group):
        _transport('play ${item.title}', _speakers.play(group.leaderId, item));
      case ConnectTarget(:final device):
        _transport('play ${item.title}', _spotify.play(device.id, item));
    }
  }

  void changeVolume(String speakerId, int percent) {
    _throttler(speakerId)(() => _run('set volume', _speakers.setVolume(speakerId, percent)));
  }

  void endVolume(String speakerId, int percent) {
    _throttler(speakerId).flush(() => _run('set volume', _speakers.setVolume(speakerId, percent)));
  }

  void changeDeviceVolume(ConnectDevice device, int percent) {
    _throttler(device.id)(() => _run('set volume', _spotify.setVolume(device.id, percent)));
  }

  void endDeviceVolume(ConnectDevice device, int percent) {
    _throttler(device.id).flush(() => _run('set volume', _spotify.setVolume(device.id, percent)));
  }

  /// Takes [speaker] out of the [current] group, or adds it – also when it plays in another group.
  void toggleMembership(SpeakerState speaker, SpeakerGroup current) {
    _run(
      'change group',
      current.contains(speaker.id)
          ? _speakers.leaveGroup(speaker.id)
          : _speakers.joinGroup(speaker.id, current.leaderId),
    );
  }

  Future<void> _move(PlaybackTarget from, PlaybackTarget to) async {
    final spotify = ref.read(spotifyConnectServiceProvider).value;
    final playback = spotify?.playback;
    final devices = spotify?.devices ?? const <ConnectDevice>[];
    String? deviceOf(PlaybackTarget target) => switch (target) {
      ConnectTarget(:final device) => device.id,
      SpeakerGroupTarget(:final group) => _connectDeviceOf(group, devices)?.id,
    };

    final fromDevice = deviceOf(from);
    if (playback != null && playback.isPlaying && fromDevice == playback.deviceId) {
      final toDevice = deviceOf(to);
      if (toDevice != null) return _spotify.transfer(toDevice, from: _playbackOf(from));
      // Albums and playlists go on at the same track; anything else (e.g. liked songs) as the track alone.
      final context = playback.contextUri;
      final uri = context != null && (context.contains(':playlist:') || context.contains(':album:'))
          ? context
          : playback.trackUri;
      if ((to, uri) case (SpeakerGroupTarget(:final group), final uri?)) {
        // The speaker has no Spotify device of its own: start the same music there.
        final now = clock.now();
        final item = MediaItem(
          title: playback.title ?? 'Spotify',
          contentId: uri,
          contentType: uri.split(':')[1],
          artworkUrl: playback.artworkUrl,
          startTrack: uri == playback.trackUri ? null : playback.trackUri,
          startSeconds: playback.positionSeconds + now.difference(playback.positionAt).inMilliseconds / 1000,
        );
        // Paused first, so only one place plays while the speaker starts; it plays on when the speaker cannot.
        await _spotify.pause(playback.deviceId);
        try {
          return await _speakers.play(group.leaderId, item);
        } on Object {
          await _spotify.resume(playback.deviceId);
          rethrow;
        }
      }
      return;
    }
    if ((from, to) case (SpeakerGroupTarget(:final group), ConnectTarget(:final device))) {
      // Music sent to the speaker over Spotify is not reported by Spotify: pause it there, then resume it on the device.
      await _speakers.playPause(group.leaderId);
      return _spotify.transfer(device.id, from: _playbackOf(from));
    }
    if ((from, to) case (SpeakerGroupTarget(group: final source), SpeakerGroupTarget(group: final target))) {
      return _speakers.move(source.leaderId, [for (final speaker in target.members) speaker.id]);
    }
  }

  /// What [target] plays, to show it at once where it moves to.
  static SpotifyPlayback _playbackOf(PlaybackTarget target) {
    final track = target.nowPlaying;
    final now = clock.now();
    return SpotifyPlayback(
      deviceId: target.id,
      isPlaying: true,
      title: track.title,
      artist: track.artist,
      artworkUrl: track.artworkUrl,
      durationSeconds: track.durationSeconds,
      positionSeconds: track.positionAtTime(now) ?? 0,
      positionAt: now,
    );
  }

  /// The Spotify device of a speaker group: speakers with Spotify built in show up there under their own name.
  static ConnectDevice? _connectDeviceOf(SpeakerGroup group, List<ConnectDevice> devices) {
    final names = {
      for (final speaker in group.members) ...[speaker.name.toLowerCase(), ?speaker.reportedName?.toLowerCase()],
    };
    return devices.where((device) => names.contains(device.name.toLowerCase())).firstOrNull;
  }

  SpeakersService get _speakers => ref.read(speakersServiceProvider.notifier);

  SpotifyConnectService get _spotify => ref.read(spotifyConnectServiceProvider.notifier);

  Throttler _throttler(String key) => _throttlers.putIfAbsent(key, () => Throttler(sliderInterval));

  void _transport(String action, Future<void> command) => _run(action, command);

  void _run(String action, Future<void> command) {
    unawaited(command.catchError((Object e) => _log.warning('Could not $action: $e')));
  }
}

/// Speakers grouped by their leader, members by name, groups by their first member – so tiles keep their order when
/// groups change. Hidden speakers are left out.
@riverpod
List<SpeakerGroup> speakerGroups(Ref ref) {
  final settings = ref.watch(speakerSettingsServiceProvider).value ?? const <String, SpeakerSetting>{};
  final speakers = [
    for (final speaker in ref.watch(speakersServiceProvider).value ?? const <SpeakerState>[])
      if (settings[speaker.id]?.hidden != true) speaker,
  ];
  final byId = {for (final speaker in speakers) speaker.id: speaker};
  final groups = <String, SpeakerGroup>{};
  for (final speaker in speakers) {
    final leader = byId[speaker.leaderId] ?? speaker;
    groups.putIfAbsent(
      leader.id,
      () => SpeakerGroup(
        leader: leader,
        members: [
          for (final id in leader.groupMembers.isEmpty ? [leader.id] : leader.groupMembers) ?byId[id],
        ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
      ),
    );
  }
  return groups.values.toList()
    ..sort((a, b) => a.members.first.name.toLowerCase().compareTo(b.members.first.name.toLowerCase()));
}

/// Devices with Spotify open that are not hidden and not already a speaker from Home Assistant (speakers show up in
/// both). Only polled while [visible], i.e. while the music page is on screen.
@riverpod
List<ConnectTarget> connectTargets(Ref ref, {required bool visible}) {
  if (!visible) return const [];
  final connect = ref.watch(spotifyConnectServiceProvider).value;
  if (connect == null) return const [];
  final settings = ref.watch(speakerSettingsServiceProvider).value ?? const <String, SpeakerSetting>{};
  final speakerNames = {
    for (final speaker in ref.watch(speakersServiceProvider).value ?? const <SpeakerState>[]) ...[
      speaker.name.toLowerCase(),
      ?speaker.reportedName?.toLowerCase(),
    ],
  };
  return [
    for (final device in connect.devices)
      if (!speakerNames.contains(device.name.toLowerCase()) &&
          settings[SpeakerSettingsService.spotifyId(device.name)]?.hidden != true)
        ConnectTarget(
          device.copyWith(name: settings[SpeakerSettingsService.spotifyId(device.name)]?.displayName ?? device.name),
          playback: connect.playback?.deviceId == device.id ? connect.playback : null,
        ),
  ];
}

/// Every place music can play: speakers first, then Spotify devices. The order stays put while playback changes, so
/// nothing moves under the finger.
@riverpod
List<PlaybackTarget> playbackTargets(Ref ref, {required bool visible}) {
  return [
    for (final group in ref.watch(speakerGroupsProvider)) SpeakerGroupTarget(group),
    ...ref.watch(connectTargetsProvider(visible: visible)),
  ];
}

/// The target shown in "Now playing". Music plays in one place only, so a target that plays wins: when music
/// starts somewhere else (e.g. from the laptop), the card follows it. Without anything playing it is the selected
/// one, otherwise the one shown before, otherwise the default speaker.
///
/// Right after a target is selected it stays for [selectionHold], while music moves there and the old place still
/// reports playing. Pausing never swaps the card.
@riverpod
class CurrentTarget extends _$CurrentTarget {
  static const selectionHold = Duration(seconds: 6);

  String? _keptId;
  String? _lastSelected;
  var _selectedAt = DateTime(0);

  @override
  PlaybackTarget? build({required bool visible}) {
    final targets = ref.watch(playbackTargetsProvider(visible: visible));
    final selected = ref.watch(musicControllerProvider.select((state) => state.targetId));
    final settings = ref.watch(speakerSettingsServiceProvider).value ?? const <String, SpeakerSetting>{};
    final defaultId = settings.values.where((setting) => setting.isDefault).firstOrNull?.id;
    bool isDefault(PlaybackTarget target) => switch (target) {
      SpeakerGroupTarget(:final group) => group.contains(defaultId ?? ''),
      ConnectTarget(:final device) => SpeakerSettingsService.spotifyId(device.name) == defaultId,
    };
    // A speaker id also finds the group the speaker is in now, e.g. right after music moved there.
    PlaybackTarget? byId(String? id) =>
        targets.where((target) => target.id == id).firstOrNull ??
        targets.where((target) => target is SpeakerGroupTarget && target.group.contains(id ?? '')).firstOrNull;

    final now = clock.now();
    if (selected != _lastSelected) {
      _lastSelected = selected;
      _selectedAt = now;
    }
    final chosen = byId(_keptId) ?? byId(selected);
    final justSelected = selected != null && now.difference(_selectedAt) < selectionHold;
    final playing = targets.where((target) => target.nowPlaying.isPlaying).firstOrNull;

    final target = switch ((justSelected, chosen, playing)) {
      (true, _, _) => byId(selected) ?? chosen ?? playing,
      // Music plays elsewhere: follow it.
      (false, final chosen?, final playing?) when !chosen.nowPlaying.isPlaying => playing,
      (false, final chosen?, _) => chosen,
      _ => playing ?? targets.where(isDefault).firstOrNull ?? targets.firstOrNull,
    };
    if (target != null && (target.id == selected || target.nowPlaying.isPlaying)) _keptId = target.id;
    // The hold lasts even when the target already shows as playing: that may only be the optimistic state while the
    // music starts there. Asked again when it ends, so a target that plays meanwhile takes over.
    if (justSelected) {
      final timer = Timer(selectionHold - now.difference(_selectedAt), ref.invalidateSelf);
      ref.onDispose(timer.cancel);
    }
    return target;
  }
}

/// The track after the current one in the active target's queue, e.g. to load its cover ahead of time.
@riverpod
QueueItem? upNext(Ref ref, {required bool visible}) {
  final shown = ref.watch(
    currentTargetProvider(visible: visible).select(
      (target) => (
        leaderId: target is SpeakerGroupTarget ? target.group.leaderId : null,
        spotifyPlays: target is ConnectTarget && target.playback != null,
        title: target?.nowPlaying.title,
      ),
    ),
  );
  final queue = switch (shown) {
    (leaderId: final leaderId?, spotifyPlays: _, title: _) => ref.watch(playQueueProvider(leaderId)).value,
    (leaderId: null, spotifyPlays: true, title: _) => ref.watch(spotifyQueueProvider).value,
    _ => null,
  };
  if (queue == null || queue.isEmpty) return null;
  final current = queue.indexWhere((item) => item.title == shown.title);
  return current >= 0 && current + 1 < queue.length ? queue[current + 1] : null;
}

/// The color of the playing track's cover, read from the image. While a new cover is still being read the previous
/// color stays, so the page blends once instead of twice.
@riverpod
class CoverTint extends _$CoverTint {
  @override
  Color build({required bool visible}) {
    final cover = ref.watch(
      currentTargetProvider(
        visible: visible,
      ).select((target) => (url: target?.nowPlaying.artworkUrl, seed: target?.nowPlaying.title ?? target?.name ?? '')),
    );
    if (cover.url == null) return Artwork.colorOf(cover.seed);
    if (CoverColors.knownTintOf(cover.url) case final known?) return known;
    var current = true;
    ref.onDispose(() => current = false);
    unawaited(
      CoverColors.tintOf(cover.url, seed: cover.seed).then((tint) {
        if (current) state = tint;
      }),
    );
    return stateOrNull ?? Artwork.colorOf(cover.seed);
  }
}

/// The color of the music area: the cover's, paler while nothing plays.
@riverpod
Color musicTint(Ref ref, {required bool visible}) {
  final playing = ref.watch(
    currentTargetProvider(visible: visible).select((target) => target?.nowPlaying.isPlaying ?? false),
  );
  return HubAreaColors.musicFor(ref.watch(coverTintProvider(visible: visible)), playing: playing);
}
