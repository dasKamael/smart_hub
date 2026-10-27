import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/floorplan/floorplan.repository.dart';
import 'package:smart_hub/data/floorplan/placement.repository.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

part 'floorplan.service.g.dart';

@Riverpod(keepAlive: true)
Future<FloorPlan> floorPlanService(Ref ref) => ref.watch(floorplanRepositoryProvider).load();

/// Placed devices, live from the database.
@Riverpod(keepAlive: true)
class PlacementService extends _$PlacementService {
  @override
  Stream<List<Placement>> build() => ref.watch(placementRepositoryProvider).watchAll();

  /// Places or moves a device. The position is kept inside the plan bounds.
  Future<void> place(String deviceId, DeviceKind kind, PlanPoint position) async {
    final plan = await ref.read(floorPlanServiceProvider.future);
    final clamped = PlanGeometryUtil.clampInside(position, PlanGeometryUtil.bounds(plan));
    await ref.read(placementRepositoryProvider).save(Placement(deviceId: deviceId, kind: kind, position: clamped));
  }

  /// Places [placements] if nothing is placed yet, e.g. the layout of the demo home.
  Future<void> placeAllIfEmpty(List<Placement> placements) async {
    final repository = ref.read(placementRepositoryProvider);
    if ((await repository.all()).isEmpty) await repository.saveAll(placements);
  }

  /// Puts a device back into the "not placed" tray.
  Future<void> remove(String deviceId) => ref.read(placementRepositoryProvider).remove(deviceId);
}
