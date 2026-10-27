import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

part 'floorplan.state.freezed.dart';

enum PlanLayer { plants, lights, speakers, glow }

@freezed
sealed class PlanSelection with _$PlanSelection {
  const factory PlanSelection.none() = NoSelection;

  const factory PlanSelection.room(String roomId) = RoomSelection;

  const factory PlanSelection.device(String deviceId) = DeviceSelection;
}

/// A device that is being dragged.
@freezed
abstract class PlanDrag with _$PlanDrag {
  const factory PlanDrag({
    required String deviceId,
    required DeviceKind kind,

    /// Position under the finger in cm; `null` while a device from the tray is not over the plan yet.
    PlanPoint? position,

    /// Device the dragged one would be grouped with when dropped now.
    String? targetId,
  }) = _PlanDrag;
}

@freezed
abstract class FloorplanState with _$FloorplanState {
  const factory FloorplanState({
    @Default(PlanSelection.none()) PlanSelection selection,
    @Default({PlanLayer.plants, PlanLayer.lights, PlanLayer.speakers, PlanLayer.glow}) Set<PlanLayer> layers,
    PlanDrag? drag,

    /// Key of the group that is fanned out (`GroupingUtil.groupKey`).
    String? openGroupKey,

    /// Positions of dropped devices until the stored placement arrives, so markers do not jump back.
    @Default({}) Map<String, PlanPoint> pendingPositions,
  }) = _FloorplanState;
}
