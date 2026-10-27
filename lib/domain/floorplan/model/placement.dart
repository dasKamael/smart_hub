import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

part 'placement.freezed.dart';

/// A device placed on the plan. Devices without a placement are "not placed" (tray).
///
/// The room is never stored – it is derived from [position].
@freezed
abstract class Placement with _$Placement {
  const factory Placement({
    /// Entity id for lights and speakers, local id for plants.
    required String deviceId,
    required DeviceKind kind,
    required PlanPoint position,
  }) = _Placement;
}
