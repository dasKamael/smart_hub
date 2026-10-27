import 'package:ha_client/src/ha_entity_state.dart';

/// A change of one entity. [newState] is `null` when the entity was removed, [oldState] when it is new.
final class HaStateChange {
  const HaStateChange({required this.entityId, this.oldState, this.newState});

  final String entityId;
  final HaEntityState? oldState;
  final HaEntityState? newState;

  @override
  String toString() => 'HaStateChange($entityId: ${oldState?.state} → ${newState?.state})';
}
