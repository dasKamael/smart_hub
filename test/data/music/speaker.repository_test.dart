import 'package:flutter_test/flutter_test.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';

HaEntityState _player(String id, String state, Map<String, Object?> attributes) {
  final time = DateTime.utc(2026, 10, 26);
  return HaEntityState(entityId: id, state: state, attributes: attributes, lastChanged: time, lastUpdated: time);
}

void main() {
  group('SpeakerRepository mapping', () {
    test('Given a playing grouped speaker, '
        'when mapping, '
        'then playback, volume, group and track are read', () {
      // When
      final speaker = SpeakerRepository.toSpeaker(
        _player('media_player.office', 'playing', {
          'friendly_name': 'Office',
          'volume_level': 0.35,
          'group_members': ['media_player.office', 'media_player.kitchen'],
          'media_title': 'Morning Light',
          'media_artist': 'Lumen Quartet',
        }),
      );

      // Then
      expect(speaker.name, 'Office');
      expect(speaker.playback, Playback.playing);
      expect(speaker.volumePercent, 35);
      expect(speaker.isGrouped, isTrue);
      expect(speaker.title, 'Morning Light');
      expect(speaker.artist, 'Lumen Quartet');
    });

    final playbacks = {
      'playing': Playback.playing,
      'paused': Playback.paused,
      'idle': Playback.idle,
      'on': Playback.idle,
      'off': Playback.off,
      'unavailable': Playback.off,
    };
    for (final MapEntry(key: state, value: playback) in playbacks.entries) {
      test('Given state "$state", when mapping, then playback is ${playback.name}', () {
        expect(SpeakerRepository.toSpeaker(_player('media_player.x', state, {})).playback, playback);
      });
    }

    test('Given a media player without group_members, when filtering, then it is not a speaker', () {
      expect(SpeakerRepository.isSpeaker(_player('media_player.spotify', 'playing', {})), isFalse);
      expect(
        SpeakerRepository.isSpeaker(_player('media_player.office', 'idle', {'group_members': <String>[]})),
        isTrue,
      );
    });
  });

  group('SpeakerRepository commands', () {
    late FakeHomeAssistant server;
    late SpeakerRepository repository;

    setUp(() async {
      server = FakeHomeAssistant(
        states: [
          _player('media_player.office', 'playing', {
            'group_members': ['media_player.office'],
          }),
        ],
      );
      final session = HaSessionRepository(transportFor: (_) => server);
      addTearDown(session.dispose);
      final online = session.watchStatus().firstWhere((s) => s == ConnectionStatus.online);
      await session.connect(ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha:8123'), token: 'test-token'));
      await online;
      repository = SpeakerRepository(session: session);
    });

    test('Given a speaker, when sending commands, then the matching services are called', () async {
      // When
      await repository.playPause('media_player.office');
      await repository.setVolume('media_player.office', 35);
      await repository.join('media_player.office', 'media_player.sleep');
      await repository.leave('media_player.sleep');

      // Then
      expect(server.serviceCalls.map((c) => '${c.service} ${c.entityIds.join()} ${c.data}'), [
        'media_play_pause media_player.office {}',
        'volume_set media_player.office {volume_level: 0.35}',
        'join media_player.office {group_members: [media_player.sleep]}',
        'unjoin media_player.sleep {}',
      ]);
    });

    test('Given the session, when listing speakers, then they are mapped', () async {
      expect((await repository.watchSpeakers().first).single.id, 'media_player.office');
    });
  });
}
