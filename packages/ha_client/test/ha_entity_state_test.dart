import 'package:ha_client/ha_client.dart';
import 'package:test/test.dart';

void main() {
  group('HaEntityState', () {
    test('Given a get_states entry from HA, '
        'when parsing it, '
        'then id, state, attributes, timestamps and domain are read', () {
      // Given
      final json = <String, Object?>{
        'entity_id': 'light.desk_lamp',
        'state': 'on',
        'attributes': {
          'brightness': 204,
          'supported_color_modes': ['color_temp', 'xy'],
        },
        'last_changed': '2026-10-26T07:58:12.000+00:00',
        'last_updated': '2026-10-26T08:01:44.512+00:00',
        'context': {'id': 'abc'},
      };

      // When
      final state = HaEntityState.fromJson(json);

      // Then
      expect(state.entityId, 'light.desk_lamp');
      expect(state.domain, 'light');
      expect(state.state, 'on');
      expect(state.attributes['brightness'], 204);
      expect(state.lastChanged, DateTime.utc(2026, 10, 26, 7, 58, 12));
      expect(state.lastUpdated, DateTime.utc(2026, 10, 26, 8, 1, 44, 512));
    });

    test('Given an entity state, '
        'when converting it to JSON and back, '
        'then all fields survive', () {
      // Given
      final original = HaEntityState(
        entityId: 'media_player.kitchen',
        state: 'playing',
        attributes: const {'volume_level': 0.35},
        lastChanged: DateTime.utc(2026, 10, 26, 9),
        lastUpdated: DateTime.utc(2026, 10, 26, 9, 5),
      );

      // When
      final copy = HaEntityState.fromJson(original.toJson());

      // Then
      expect(copy.entityId, original.entityId);
      expect(copy.state, original.state);
      expect(copy.attributes, original.attributes);
      expect(copy.lastChanged, original.lastChanged);
      expect(copy.lastUpdated, original.lastUpdated);
    });
  });
}
