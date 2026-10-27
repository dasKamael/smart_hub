/// Home Assistant WebSocket client.
///
/// Speaks the HA WebSocket protocol only – it knows entities, not lights, plants or rooms.
library;

export 'src/ha_backoff.dart';
export 'src/ha_client.dart';
export 'src/ha_connection_status.dart';
export 'src/ha_entity_state.dart';
export 'src/ha_exception.dart';
export 'src/ha_session.dart';
export 'src/ha_state_change.dart';
export 'src/ha_transport.dart';
