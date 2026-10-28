import 'package:ha_client/ha_client.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';

/// Speakers are `media_player.*` entities that can be grouped (`group_members`).
class HaSpeakerRepository implements SpeakerRepository {
  HaSpeakerRepository({required this.session});

  final HaSessionRepository session;

  @override
  Stream<List<SpeakerState>> watchSpeakers() {
    return session.watchDomain('media_player').map((states) => states.where(isSpeaker).map(map).toList());
  }

  @override
  Stream<bool> watchOnline() => session.watchStatus().map((status) => status.isOnline);

  @override
  Future<void> playPause(String id) => session.callService('media_player', 'media_play_pause', entityIds: [id]);

  @override
  Future<void> next(String id) => session.callService('media_player', 'media_next_track', entityIds: [id]);

  @override
  Future<void> previous(String id) => session.callService('media_player', 'media_previous_track', entityIds: [id]);

  @override
  Future<void> seek(String id, int seconds) {
    return session.callService('media_player', 'media_seek', entityIds: [id], data: {'seek_position': seconds});
  }

  @override
  Future<void> play(String id, MediaItem item) {
    return session.callService(
      'media_player',
      'play_media',
      entityIds: [id],
      data: {'media_content_id': item.contentId, 'media_content_type': item.contentType},
    );
  }

  /// Playable favorites of [id]: the top level of HA's media browser, or its favorites / playlists folder when the
  /// top level only holds folders (as for Sonos).
  @override
  Future<List<MediaItem>> favorites(String id) async {
    final root = await _browse(id);
    var playable = _playableChildren(root);
    if (playable.isEmpty) {
      final folder = _children(root).where((child) => _favoritesFolder.hasMatch('${child['title']}')).firstOrNull;
      if (folder != null) {
        playable = _playableChildren(
          await _browse(
            id,
            contentId: folder['media_content_id'] as String?,
            contentType: folder['media_content_type'] as String?,
          ),
        );
      }
    }
    return playable.take(maxFavorites).toList();
  }

  /// Plays the track at [position] of the queue of [id] (`sonos.play_queue`).
  @override
  Future<void> playFromQueue(String id, int position) {
    return session.callService('sonos', 'play_queue', entityIds: [id], data: {'queue_position': position});
  }

  /// The play queue of [id] via `sonos.get_queue`; `null` when the player has no queue HA can read.
  @override
  Future<List<QueueItem>?> queue(String id) async {
    final Object? response;
    try {
      response = await session.callService('sonos', 'get_queue', entityIds: [id], returnResponse: true);
    } on HaCommandException {
      return null;
    }
    final items = response is Map<String, Object?> ? response[id] : null;
    if (items is! List<Object?>) return null;
    return [
      for (final (position, item) in items.whereType<Map<String, Object?>>().indexed)
        QueueItem(
          position: position,
          title: (item['media_title'] as String?) ?? 'Unknown',
          artist: item['media_artist'] as String?,
          artworkUrl: session.resolveUrl(item['media_image'] as String?)?.toString(),
          coverUrl: session.resolveUrl(item['media_image'] as String?)?.toString(),
        ),
    ];
  }

  static const maxFavorites = 12;
  static final _favoritesFolder = RegExp('favorit|playlist', caseSensitive: false);

  Future<Map<String, Object?>> _browse(String id, {String? contentId, String? contentType}) async {
    final result = await session.sendCommand('media_player/browse_media', {
      'entity_id': id,
      'media_content_id': ?contentId,
      'media_content_type': ?contentType,
    });
    return result is Map<String, Object?> ? result : const {};
  }

  static List<Map<String, Object?>> _children(Map<String, Object?> node) {
    return (node['children'] as List<Object?>? ?? const []).whereType<Map<String, Object?>>().toList();
  }

  List<MediaItem> _playableChildren(Map<String, Object?> node) {
    return [
      for (final child in _children(node))
        if (child['can_play'] == true)
          MediaItem(
            title: (child['title'] as String?) ?? 'Untitled',
            contentId: (child['media_content_id'] as String?) ?? '',
            contentType: (child['media_content_type'] as String?) ?? 'music',
            artworkUrl: session.resolveUrl(child['thumbnail'] as String?)?.toString(),
          ),
    ];
  }

  @override
  Future<void> setVolume(String id, int percent) {
    return session.callService('media_player', 'volume_set', entityIds: [id], data: {'volume_level': percent / 100});
  }

  /// Adds [memberId] to the group of [leaderId].
  @override
  Future<void> join(String leaderId, String memberId) {
    return session.callService(
      'media_player',
      'join',
      entityIds: [leaderId],
      data: {
        'group_members': [memberId],
      },
    );
  }

  @override
  Future<void> leave(String id) => session.callService('media_player', 'unjoin', entityIds: [id]);

  /// Media players without `group_members` (e.g. a streaming account) are content sources, not speakers.
  static bool isSpeaker(HaEntityState state) => state.attributes.containsKey('group_members');

  SpeakerState map(HaEntityState state) {
    return toSpeaker(state)
        .copyWith(artworkUrl: session.resolveUrl(state.attributes['entity_picture'] as String?)?.toString());
  }

  static SpeakerState toSpeaker(HaEntityState state) {
    final attributes = state.attributes;
    return SpeakerState(
      id: state.entityId,
      name: (attributes['friendly_name'] as String?) ?? state.entityId,
      playback: switch (state.state) {
        'playing' => Playback.playing,
        'paused' => Playback.paused,
        'idle' || 'on' || 'standby' || 'buffering' => Playback.idle,
        _ => Playback.off,
      },
      volumePercent: (((attributes['volume_level'] as num?) ?? 0) * 100).round().clamp(0, 100),
      groupMembers: (attributes['group_members'] as List<Object?>? ?? [state.entityId]).whereType<String>().toList(),
      title: attributes['media_title'] as String?,
      artist: attributes['media_artist'] as String?,
      album: attributes['media_album_name'] as String?,
      playlist: (attributes['media_playlist'] ?? attributes['media_channel']) as String?,
      durationSeconds: (attributes['media_duration'] as num?)?.round(),
      positionSeconds: (attributes['media_position'] as num?)?.toDouble(),
      positionUpdatedAt: DateTime.tryParse('${attributes['media_position_updated_at']}'),
    );
  }
}
