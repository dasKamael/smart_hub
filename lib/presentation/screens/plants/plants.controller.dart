import 'dart:async';

import 'package:clock/clock.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/domain/plants/fertilizing.util.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/domain/plants/plant_care_import.util.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';
import 'package:smart_hub/domain/plants/watering_due.util.dart';
import 'package:smart_hub/presentation/screens/plants/plants.state.dart';

part 'plants.controller.g.dart';

/// What the plant editor returns.
sealed class PlantEdit {
  const PlantEdit();
}

final class SavePlant extends PlantEdit {
  const SavePlant({
    required this.name,
    required this.everyDays,
    this.fertilizeEveryWeeks,
    this.speciesId,
    this.importedProfile,
    this.photoSource,
  });

  final String name;
  final int everyDays;
  final int? fertilizeEveryWeeks;

  /// Species picked in the plant database; `null` keeps the current link.
  final int? speciesId;

  /// Care data pasted in the editor; replaces the current profile.
  final PlantProfile? importedProfile;

  /// A newly taken or picked photo; `null` keeps the current one.
  final String? photoSource;
}

final class DeletePlant extends PlantEdit {
  const DeletePlant();
}

/// A plant with its state today, the room it stands in (`null` while not placed) and the days until it is fertilized
/// (`null` when it is not fertilized).
typedef ScheduledPlant = ({Plant plant, WateringState state, int dueInDays, String? room, int? feedInDays});

/// Day shown on the page: 0 is today, 1–6 the following days.
const allPlantsDay = -1;

/// Watering plan page: watering, undo and editing plants.
@riverpod
class PlantsController extends _$PlantsController {
  static final _log = Logger('PlantsController');

  @override
  PlantsPageState build() => const PlantsPageState();

  /// Shows the plants of [day] of the week strip; [allPlantsDay] shows every plant.
  void selectDay(int day) => state = state.copyWith(selectedDay: day, openPlantId: null);

  /// Shows the options of a card, or hides them when they are already shown.
  void toggleOptions(String plantId) {
    state = state.copyWith(openPlantId: state.openPlantId == plantId ? null : plantId);
  }

  void closeOptions() => state = state.copyWith(openPlantId: null);

  /// Waters a due plant, or undoes today's watering of a watered one.
  void toggleWatered(ScheduledPlant entry) {
    closeOptions();
    final service = ref.read(plantsServiceProvider.notifier);
    _run(
      'toggle watering',
      entry.state == WateringState.wateredToday
          ? service.undoWatering(entry.plant.id)
          : service.water([entry.plant.id]),
    );
  }

  void fertilize(ScheduledPlant entry) {
    closeOptions();
    _run('fertilize', ref.read(plantsServiceProvider.notifier).fertilize([entry.plant.id]));
  }

  void waterAll(List<ScheduledPlant> due) {
    _run('water all', ref.read(plantsServiceProvider.notifier).water([for (final entry in due) entry.plant.id]));
  }

  /// Applies [edit] to [plant], or adds a new plant when [plant] is `null`. New plants start in the "not placed"
  /// tray of the floor plan.
  Future<void> applyEdit(Plant? plant, PlantEdit edit) async {
    final service = ref.read(plantsServiceProvider.notifier);
    try {
      switch ((plant, edit)) {
        case (null, final SavePlant save):
          final added = await service.add(
            name: save.name,
            everyDays: save.everyDays,
            fertilizeEveryWeeks: save.fertilizeEveryWeeks,
            photoSource: save.photoSource,
          );
          await _link(added.id, save.speciesId, save.importedProfile);
        case (final Plant existing, final SavePlant save):
          await service.edit(
            existing.copyWith(
              name: save.name,
              everyDays: save.everyDays,
              fertilizeEveryWeeks: save.fertilizeEveryWeeks,
            ),
            photoSource: save.photoSource,
          );
          await _link(existing.id, save.speciesId, save.importedProfile);
        case (final Plant existing, DeletePlant()):
          await ref.read(placementServiceProvider.notifier).remove(existing.id);
          await service.delete(existing);
        case (null, DeletePlant()):
          break;
      }
    } on Object catch (e) {
      _log.warning('Could not save plant: $e');
    }
  }

  /// Saves imported care data and takes over its intervals; `null` when the import failed.
  Future<({int updated, int added})?> importCare(List<PlantCareEntry> entries) async {
    try {
      return await ref.read(plantProfileServiceProvider.notifier).importCare(entries);
    } on Object catch (e) {
      _log.warning('Could not import care data: $e');
      return null;
    }
  }

  Future<void> _link(String plantId, int? speciesId, PlantProfile? imported) async {
    final profiles = ref.read(plantProfileServiceProvider.notifier);
    if (imported != null) {
      await profiles.keep(plantId, imported);
    } else if (speciesId != null) {
      await profiles.link(plantId, speciesId);
    }
  }

  void _run(String action, Future<void> command) {
    unawaited(command.catchError((Object e) => _log.warning('Could not $action: $e')));
  }
}

/// All plants with their state today, plus the plants per day of the coming week (today first).
@riverpod
({List<ScheduledPlant> all, List<List<ScheduledPlant>> week}) wateringPlan(Ref ref) {
  final today = ref.watch(currentDayProvider).value ?? clock.now();
  final plants = ref.watch(plantsServiceProvider).value ?? const <Plant>[];
  final floorPlan = ref.watch(floorPlanServiceProvider).value;
  final positions = {
    for (final placement in ref.watch(placementServiceProvider).value ?? const <Placement>[])
      placement.deviceId: placement.position,
  };
  ScheduledPlant scheduled(Plant plant) {
    final position = positions[plant.id];
    return (
      plant: plant,
      state: WateringDueUtil.stateOf(plant, today),
      dueInDays: WateringDueUtil.dueInDays(plant, today),
      room: position == null || floorPlan == null ? null : RoomLookupUtil.roomAt(floorPlan, position)?.name,
      feedInDays: FertilizingUtil.dueInDays(plant, today),
    );
  }

  return (
    all: [for (final plant in plants) scheduled(plant)],
    week: [
      for (final day in WateringDueUtil.week(plants, today)) [for (final plant in day) scheduled(plant)],
    ],
  );
}
