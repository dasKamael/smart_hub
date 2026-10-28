import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/data/music/ha_speaker.repository.dart';
import 'package:smart_hub/data/music/sonos/sonos_config.repository.dart';
import 'package:smart_hub/data/music/sonos/sonos_speaker.repository.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';

part 'speaker.repository.g.dart';

/// Where the speakers come from: Home Assistant, or the speakers in the home network directly.
abstract interface class SpeakerRepository {
  Stream<List<SpeakerState>> watchSpeakers();

  /// Whether the speakers can be controlled right now.
  Stream<bool> watchOnline();

  Future<void> playPause(String id);

  Future<void> next(String id);

  Future<void> previous(String id);

  /// Jumps to [seconds] into the playing track of [id].
  Future<void> seek(String id, int seconds);

  Future<void> play(String id, MediaItem item);

  Future<List<MediaItem>> favorites(String id);

  /// Plays the track at [position] of the queue of [id].
  Future<void> playFromQueue(String id, int position);

  /// The play queue of [id]; `null` when the player has none that can be read.
  Future<List<QueueItem>?> queue(String id);

  Future<void> setVolume(String id, int percent);

  /// Adds [memberId] to the group of [leaderId].
  Future<void> join(String leaderId, String memberId);

  Future<void> leave(String id);
}

/// Providers
/// Speakers added from the home network provide the speakers; otherwise Home Assistant does.
@Riverpod(keepAlive: true)
SpeakerRepository speakerRepository(Ref ref) {
  final hosts = ref.watch(sonosHostsProvider).value ?? const <String>[];
  if (hosts.isEmpty) return HaSpeakerRepository(session: ref.watch(haSessionRepositoryProvider));
  final repository = SonosSpeakerRepository(hosts: hosts, client: ref.watch(sonosHttpClientProvider));
  ref.onDispose(repository.dispose);
  return repository;
}
