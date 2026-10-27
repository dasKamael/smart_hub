/// Raw state of one HA entity as delivered by `get_states` and `state_changed`.
final class HaEntityState {
  const HaEntityState({
    required this.entityId,
    required this.state,
    this.attributes = const {},
    required this.lastChanged,
    required this.lastUpdated,
  });

  factory HaEntityState.fromJson(Map<String, Object?> json) {
    return HaEntityState(
      entityId: json['entity_id'] as String,
      state: json['state'] as String,
      attributes: (json['attributes'] as Map<String, Object?>?) ?? const {},
      lastChanged: DateTime.parse(json['last_changed'] as String),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  final String entityId;
  final String state;
  final Map<String, Object?> attributes;

  /// Last change of [state].
  final DateTime lastChanged;

  /// Last change of [state] or [attributes].
  final DateTime lastUpdated;

  /// Entity domain, e.g. `light` for `light.desk`.
  String get domain => entityId.substring(0, entityId.indexOf('.'));

  Map<String, Object?> toJson() => {
    'entity_id': entityId,
    'state': state,
    'attributes': attributes,
    'last_changed': lastChanged.toIso8601String(),
    'last_updated': lastUpdated.toIso8601String(),
  };

  @override
  String toString() => 'HaEntityState($entityId: $state)';
}
