import 'package:ha_client/ha_client.dart';

final testUri = Uri.parse('ws://ha.test/api/websocket');

HaEntityState entity(String entityId, String state, {Map<String, Object?> attributes = const {}, DateTime? updated}) {
  final time = updated ?? DateTime.utc(2026, 10, 26, 8);
  return HaEntityState(entityId: entityId, state: state, attributes: attributes, lastChanged: time, lastUpdated: time);
}
