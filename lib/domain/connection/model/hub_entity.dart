import 'package:freezed_annotation/freezed_annotation.dart';

part 'hub_entity.freezed.dart';

/// Any entity the hub knows, independent of its kind (light, speaker, sensor, ...).
@freezed
abstract class HubEntity with _$HubEntity {
  const factory HubEntity({
    /// Stable id, e.g. `light.desk_lamp`.
    required String id,

    /// Kind of entity, e.g. `light` or `media_player`.
    required String domain,

    /// Human readable name; falls back to [id].
    required String name,

    /// Raw state, e.g. `on`, `off`, `playing`, `unavailable`.
    required String state,
  }) = _HubEntity;
}
