import 'package:flutter_test/flutter_test.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';
import 'package:smart_hub/data/connection/demo/demo_home_assistant.dart';

void main() {
  group('Demo home', () {
    late FakeHomeAssistant home;
    late HaClient client;

    setUp(() async {
      home = createDemoHomeAssistant();
      client = HaClient(uri: Uri.parse('ws://demo/api/websocket'), accessToken: demoAccessToken, transport: home);
      addTearDown(client.dispose);
      final connected = client.statusChanges.firstWhere((s) => s == HaConnectionStatus.connected);
      client.start();
      await connected;
    });

    Map<String, Object?> attributes(String id) => home.states[id]!.attributes;

    test('Given a light that is off, '
        'when turning it on with brightness and color, '
        'then it is on with these values', () async {
      // When
      await client.callService(
        'light',
        'turn_on',
        entityIds: ['light.kitchen_pendant'],
        data: {
          'brightness_pct': 50,
          'rgb_color': [255, 0, 0],
        },
      );

      // Then
      expect(home.states['light.kitchen_pendant']?.state, 'on');
      expect(attributes('light.kitchen_pendant')['brightness'], 128);
      expect(attributes('light.kitchen_pendant')['rgb_color'], [255, 0, 0]);
    });

    test('Given an on/off-only light, '
        'when turning it on with a brightness, '
        'then it is on without brightness', () async {
      // When
      await client.callService('light', 'turn_on', entityIds: ['light.wc'], data: {'brightness_pct': 50});

      // Then
      expect(home.states['light.wc']?.state, 'on');
      expect(attributes('light.wc')['brightness'], isNull);
    });

    test('Given a light that is on, '
        'when toggling it, '
        'then it is off', () async {
      // When
      await client.callService('light', 'toggle', entityIds: ['light.office_desk']);

      // Then
      expect(home.states['light.office_desk']?.state, 'off');
    });

    test('Given two grouped speakers that play, '
        'when pausing the leader, '
        'then the whole group pauses', () async {
      // When
      await client.callService('media_player', 'media_play_pause', entityIds: ['media_player.office']);

      // Then
      expect(home.states['media_player.office']?.state, 'paused');
      expect(home.states['media_player.kitchen']?.state, 'paused');
    });

    test('Given a single speaker, '
        'when it joins a group, '
        'then all members share group and track', () async {
      // When
      await client.callService(
        'media_player',
        'join',
        entityIds: ['media_player.office'],
        data: {
          'group_members': ['media_player.sleep'],
        },
      );

      // Then
      final group = ['media_player.office', 'media_player.kitchen', 'media_player.sleep'];
      for (final id in group) {
        expect(attributes(id)['group_members'], unorderedEquals(group));
      }
      expect(attributes('media_player.sleep')['media_title'], attributes('media_player.office')['media_title']);
    });

    test('Given a grouped speaker, '
        'when it leaves the group, '
        'then it is alone and the rest stays grouped', () async {
      // When
      await client.callService('media_player', 'unjoin', entityIds: ['media_player.kitchen']);

      // Then
      expect(attributes('media_player.kitchen')['group_members'], ['media_player.kitchen']);
      expect(attributes('media_player.office')['group_members'], ['media_player.office']);
    });

    test('Given a speaker, '
        'when setting the volume, '
        'then the volume level changes', () async {
      // When
      await client.callService(
        'media_player',
        'volume_set',
        entityIds: ['media_player.sleep'],
        data: {'volume_level': 0.6},
      );

      // Then
      expect(attributes('media_player.sleep')['volume_level'], 0.6);
    });

    test('Given the demo favorites, when browsing, then six playable playlists come back', () async {
      // When
      final root = await client.sendCommand('media_player/browse_media', {'entity_id': 'media_player.office'});

      // Then
      final children = ((root! as Map<String, Object?>)['children']! as List<Object?>).cast<Map<String, Object?>>();
      expect(children, hasLength(6));
      expect(children.every((child) => child['can_play'] == true), isTrue);
    });

    test('Given a playlist, '
        'when playing it on a grouped speaker, '
        'then the whole group plays its first track from the start', () async {
      // When
      await client.callService(
        'media_player',
        'play_media',
        entityIds: ['media_player.office'],
        data: {'media_content_id': 'demo:playlist:1', 'media_content_type': 'playlist'},
      );

      // Then
      for (final id in ['media_player.office', 'media_player.kitchen']) {
        expect(attributes(id)['media_title'], 'Slow Rivers');
        expect(attributes(id)['media_playlist'], 'Focus Flow');
        expect(attributes(id)['media_position'], 0);
        expect(home.states[id]?.state, 'playing');
      }
    });

    test('Given a speaker, when skipping, then the next track starts from the beginning', () async {
      // When
      await client.callService('media_player', 'media_next_track', entityIds: ['media_player.sleep']);

      // Then
      expect(attributes('media_player.sleep')['media_title'], 'Morning Light', reason: 'wraps after the last track');
      expect(attributes('media_player.sleep')['media_position'], 0);
    });

    test('Given a speaker, when asking for its queue, then the current and following tracks come back', () async {
      // When
      final response = await client.callService(
        'sonos',
        'get_queue',
        entityIds: ['media_player.sleep'],
        returnResponse: true,
      );

      // Then
      final queue = ((response! as Map<String, Object?>)['media_player.sleep']! as List<Object?>)
          .cast<Map<String, Object?>>();
      expect(queue.first['media_title'], 'Late Tram');
      expect(queue, hasLength(6));
    });
  });
}
