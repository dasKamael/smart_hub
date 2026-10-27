import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/utils/optimistic_overlay.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';

part 'speaker.service.g.dart';

/// All speakers, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the speaker does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").
@Riverpod(keepAlive: true)
class SpeakersService extends _$SpeakersService {
  late OptimisticOverlay<SpeakerState> _overlay;
  var _reported = const <SpeakerState>[];

  /// Speakers with the names set in the hub's speaker settings.
  @override
  Future<List<SpeakerState>> build() {
    _overlay = OptimisticOverlay(idOf: (speaker) => speaker.id, onChanged: _publish);
    final names = {
      for (final setting in (ref.watch(speakerSettingsServiceProvider).value ?? const {}).values)
        setting.id: ?setting.displayName,
    };
    final first = Completer<List<SpeakerState>>();
    final subscription = ref
        .watch(speakerRepositoryProvider)
        .watchSpeakers()
        .listen(
          (speakers) {
            _reported = [
              for (final speaker in speakers)
                speaker.copyWith(
                  name: names[speaker.id] ?? speaker.name,
                  reportedName: names.containsKey(speaker.id) ? speaker.name : null,
                ),
            ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
            if (first.isCompleted) {
              _publish();
            } else {
              first.complete(_overlay.applyTo(_reported));
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!first.isCompleted) first.completeError(error, stackTrace);
          },
        );
    ref.onDispose(() {
      unawaited(subscription.cancel());
      _overlay.dispose();
    });
    return first.future;
  }

  /// Plays or pauses [id] and its group.
  Future<void> playPause(String id) {
    final group = _groupOf(id);
    final playing = !(group.firstOrNull?.playback.isPlaying ?? false);
    final now = clock.now();
    for (final speaker in group) {
      _overlay.add(
        speaker.id,
        apply: (speaker) => speaker.copyWith(
          playback: playing ? Playback.playing : Playback.paused,
          positionSeconds: speaker.positionAt(now),
          positionUpdatedAt: now,
        ),
        isConfirmed: (speaker) => speaker.playback.isPlaying == playing,
      );
    }
    return _run(group, _repository.playPause(id));
  }

  Future<void> next(String id) => _skip(id, _repository.next(id));

  Future<void> previous(String id) => _skip(id, _repository.previous(id));

  /// Plays [item] on [id] and its group.
  Future<void> play(String id, MediaItem item) {
    final group = _groupOf(id);
    final now = clock.now();
    for (final speaker in group) {
      _overlay.add(
        speaker.id,
        apply: (speaker) => speaker.copyWith(playback: Playback.playing, positionSeconds: 0, positionUpdatedAt: now),
        isConfirmed: (speaker) => speaker.playback.isPlaying,
      );
    }
    return _run(group, _repository.play(id, item));
  }

  Future<void> setVolume(String id, int percent) {
    final value = percent.clamp(0, 100);
    _overlay.add(
      id,
      apply: (speaker) => speaker.copyWith(volumePercent: value),
      isConfirmed: (speaker) => (speaker.volumePercent - value).abs() <= 1,
    );
    return _run([?_reported.where((speaker) => speaker.id == id).firstOrNull], _repository.setVolume(id, value));
  }

  /// Moves what the group of [fromId] plays to [toIds]: they join that group, then its old speakers leave it.
  Future<void> move(String fromId, List<String> toIds) {
    final from = _groupOf(fromId);
    final leader = from.where((speaker) => speaker.id == speaker.leaderId).firstOrNull ?? from.firstOrNull;
    final to = [
      for (final speaker in _reported)
        if (toIds.contains(speaker.id)) speaker,
    ];
    if (leader == null || to.isEmpty) return Future.value();
    final left = [
      for (final speaker in from)
        if (!toIds.contains(speaker.id)) speaker,
    ];
    final now = clock.now();
    final position = leader.positionAt(now);
    for (final speaker in to) {
      _overlay.add(
        speaker.id,
        apply: (speaker) => speaker.copyWith(
          playback: leader.playback,
          title: leader.title,
          artist: leader.artist,
          album: leader.album,
          playlist: leader.playlist,
          artworkUrl: leader.artworkUrl,
          durationSeconds: leader.durationSeconds,
          positionSeconds: position,
          positionUpdatedAt: now,
          groupMembers: toIds,
        ),
        isConfirmed: (speaker) =>
            speaker.playback.isPlaying &&
            speaker.groupMembers.toSet().containsAll(toIds) &&
            speaker.groupMembers.length == toIds.length,
      );
    }
    for (final speaker in left) {
      _overlay.add(
        speaker.id,
        apply: (speaker) => speaker.copyWith(playback: Playback.paused, groupMembers: [speaker.id]),
        isConfirmed: (speaker) => speaker.groupMembers.length <= 1,
      );
    }
    return _run([...to, ...left], () async {
      for (final speaker in to) {
        if (!leader.groupMembers.contains(speaker.id)) await _repository.join(leader.id, speaker.id);
      }
      for (final speaker in left) {
        await _repository.leave(speaker.id);
      }
    }());
  }

  /// Joins the group that is currently playing. Does nothing when no other speaker plays.
  Future<void> joinPlayingGroup(String id) async {
    final speakers = state.value ?? const <SpeakerState>[];
    final leader = speakers.where((s) => s.id != id && s.playback.isPlaying).firstOrNull;
    if (leader == null) return;
    await _repository.join(leader.groupMembers.first, id);
  }

  Future<void> leaveGroup(String id) => _repository.leave(id);

  /// Adds [id] to the group led by [leaderId].
  Future<void> joinGroup(String id, String leaderId) => _repository.join(leaderId, id);

  SpeakerRepository get _repository => ref.read(speakerRepositoryProvider);

  /// The track starts over at once; the new title follows from the speaker.
  Future<void> _skip(String id, Future<void> command) {
    final group = _groupOf(id);
    final now = clock.now();
    for (final speaker in group) {
      final title = speaker.title;
      _overlay.add(
        speaker.id,
        apply: (speaker) => speaker.copyWith(positionSeconds: 0, positionUpdatedAt: now),
        isConfirmed: (speaker) => speaker.title != title,
      );
    }
    return _run(group, command);
  }

  /// [id] and the speakers grouped with it, as reported.
  List<SpeakerState> _groupOf(String id) {
    final speaker = _reported.where((speaker) => speaker.id == id).firstOrNull;
    if (speaker == null) return const [];
    final members = speaker.groupMembers.isEmpty ? [id] : speaker.groupMembers;
    return [
      for (final member in _reported)
        if (members.contains(member.id)) member,
    ];
  }

  Future<void> _run(List<SpeakerState> speakers, Future<void> command) async {
    try {
      await command;
    } on Object {
      _overlay.remove([for (final speaker in speakers) speaker.id]);
      rethrow;
    }
  }

  void _publish() {
    if (state.hasValue || _reported.isNotEmpty) state = AsyncData(_overlay.applyTo(_reported));
  }
}

/// Favorites and playlists [speakerId] can play.
@riverpod
Future<List<MediaItem>> mediaFavorites(Ref ref, String speakerId) {
  return ref.watch(speakerRepositoryProvider).favorites(speakerId);
}

/// The play queue of [speakerId]; `null` when the player has none HA can read. Reloads when the track changes.
@riverpod
Future<List<QueueItem>?> playQueue(Ref ref, String speakerId) {
  ref.watch(
    speakersServiceProvider.select(
      (speakers) => speakers.value?.where((speaker) => speaker.id == speakerId).firstOrNull?.title,
    ),
  );
  return ref.watch(speakerRepositoryProvider).queue(speakerId);
}
