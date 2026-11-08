import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/floorplan/floorplan.repository.dart';
import 'package:smart_hub/data/floorplan/placement.repository.dart';
import 'package:smart_hub/domain/floorplan/furnishing.util.dart';
import 'package:smart_hub/domain/floorplan/layout_conversion.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

part 'floorplan.service.g.dart';

/// The apartment as drawn: walls, openings, rooms and furniture. A plan still in the first format (room outlines) is
/// turned into walls once and stored that way.
@Riverpod(keepAlive: true)
class HomeLayoutService extends _$HomeLayoutService {
  @override
  Future<HomeLayout> build() async {
    final repository = ref.watch(floorplanRepositoryProvider);
    switch (await repository.load()) {
      case StoredLayout(:final layout):
        return layout;
      case StoredOutlines(:final plan):
        // Furnished once, so the apartment looks lived in from the start.
        final layout = FurnishingUtil.furnishAll(LayoutConversionUtil.fromFloorPlan(plan));
        await repository.save(layout);
        return layout;
    }
  }

  /// Stores an edited layout; everything showing the apartment follows at once.
  Future<void> save(HomeLayout layout) async {
    state = AsyncData(layout);
    await ref.read(floorplanRepositoryProvider).save(layout);
  }

  /// [layout] as JSON, e.g. for a backup.
  String encode(HomeLayout layout) => FloorplanRepository.encode(layout);
}

/// The floor plan the app shows: room outlines and door segments, derived from the drawn layout.
@Riverpod(keepAlive: true)
Future<FloorPlan> floorPlanService(Ref ref) async =>
    LayoutRoomsUtil.toFloorPlan(await ref.watch(homeLayoutServiceProvider.future));

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
