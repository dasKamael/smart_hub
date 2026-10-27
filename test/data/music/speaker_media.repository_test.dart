import 'package:flutter_test/flutter_test.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';

HaEntityState _player(Map<String, Object?> attributes, {String state = 'playing'}) {
  final time = DateTime.utc(2026, 10, 26);
  return HaEntityState(
    entityId: 'media_player.kitchen',
    state: state,
    attributes: {
      'group_members': ['media_player.kitchen'],
      ...attributes,
    },
    lastChanged: time,
    lastUpdated: time,
  );
}

void main() {
  group('SpeakerRepository media', () {
    late FakeHomeAssistant server;
    late SpeakerRepository repository;

    Future<void> connect(List<HaEntityState> states) async {
      server = FakeHomeAssistant(states: states);
      final session = HaSessionRepository(transportFor: (_) => server);
      addTearDown(session.dispose);
      final online = session.watchStatus().firstWhere((s) => s == ConnectionStatus.online);
      await session.connect(
        ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha.local:8123'), token: 'test-token'),
      );
      await online;
      repository = SpeakerRepository(session: session);
    }

    test('Given a playing Sonos, '
        'when mapping, '
        'then track, position and the cover as absolute URL are read', () async {
      // Given
      await connect([
        _player({
          'media_title': 'Morning Light',
          'media_album_name': 'Daybreak',
          'media_duration': 214,
          'media_position': 74.5,
          'media_position_updated_at': '2026-10-26T09:00:00+00:00',
          'media_playlist': 'Morning Coffee',
          'entity_picture': '/api/media_player_proxy/media_player.kitchen?token=abc',
        }),
      ]);

      // When
      final speaker = (await repository.watchSpeakers().first).single;

      // Then
      expect(speaker.album, 'Daybreak');
      expect(speaker.playlist, 'Morning Coffee');
      expect(speaker.durationSeconds, 214);
      expect(speaker.positionSeconds, 74.5);
      expect(speaker.positionUpdatedAt, DateTime.utc(2026, 10, 26, 9));
      expect(speaker.artworkUrl, 'http://ha.local:8123/api/media_player_proxy/media_player.kitchen?token=abc');
    });

    test('Given a media browser with playable items on top, when loading favorites, then they are returned', () async {
      // Given
      await connect([_player({})]);
      server.commandHandlers['media_player/browse_media'] = (_) => {
        'children': [
          {'title': 'Jazz', 'media_content_id': 'fav:1', 'media_content_type': 'favorite_item_id', 'can_play': true},
          {'title': 'Folder', 'media_content_id': 'dir', 'media_content_type': 'dir', 'can_play': false},
        ],
      };

      // When
      final favorites = await repository.favorites('media_player.kitchen');

      // Then
      expect(favorites, [const MediaItem(title: 'Jazz', contentId: 'fav:1', contentType: 'favorite_item_id')]);
    });

    test('Given a Sonos browser with folders on top, '
        'when loading favorites, '
        'then the Favorites folder is opened', () async {
      // Given
      await connect([_player({})]);
      final requests = <Map<String, Object?>>[];
      server.commandHandlers['media_player/browse_media'] = (message) {
        requests.add(message);
        if (message['media_content_id'] == null) {
          return {
            'children': [
              {'title': 'Library', 'media_content_id': 'library', 'media_content_type': 'library', 'can_play': false},
              {'title': 'Favorites', 'media_content_id': '', 'media_content_type': 'favorites', 'can_play': false},
            ],
          };
        }
        return {
          'children': [
            {'title': 'Radio', 'media_content_id': 'fav:7', 'media_content_type': 'favorite_item_id', 'can_play': true},
          ],
        };
      };

      // When
      final favorites = await repository.favorites('media_player.kitchen');

      // Then
      expect(favorites.single.title, 'Radio');
      expect(requests.last['media_content_type'], 'favorites');
    });

    test('Given a Sonos, when loading the queue, then its tracks are read', () async {
      // Given
      await connect([_player({})]);
      server.onServiceCall = (call) => {
        'media_player.kitchen': [
          {'media_title': 'One', 'media_artist': 'A'},
          {'media_title': 'Two', 'media_artist': 'B'},
        ],
      };

      // When
      final queue = await repository.queue('media_player.kitchen');

      // Then
      expect(queue?.map((item) => '${item.title} – ${item.artist}'), ['One – A', 'Two – B']);
    });

    test('Given a player without queue support, when loading the queue, then there is none', () async {
      // Given
      await connect([_player({})]);
      server.onServiceCall = (call) => throw const FakeHomeAssistantError(code: 'service_not_found', message: 'no');

      // When / Then
      expect(await repository.queue('media_player.kitchen'), isNull);
    });

    test('Given a favorite, when playing it, then play_media gets its id and type', () async {
      // Given
      await connect([_player({})]);

      // When
      await repository.play(
        'media_player.kitchen',
        const MediaItem(title: 'Jazz', contentId: 'fav:1', contentType: 'x'),
      );
      await repository.next('media_player.kitchen');
      await repository.previous('media_player.kitchen');

      // Then
      expect(server.serviceCalls.map((c) => c.service), ['play_media', 'media_next_track', 'media_previous_track']);
      expect(server.serviceCalls.first.data, {'media_content_id': 'fav:1', 'media_content_type': 'x'});
    });
  });
}
