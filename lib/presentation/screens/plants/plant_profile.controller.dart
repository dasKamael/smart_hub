import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';

part 'plant_profile.controller.g.dart';

/// Profile page of one plant: linking with the plant database and taking over its suggestions. The state says
/// whether the plant database is being asked.
@riverpod
class PlantProfileController extends _$PlantProfileController {
  static final _log = Logger('PlantProfileController');

  @override
  bool build(String plantId) => false;

  Future<void> link(int speciesId) => _busy('link', () => _profiles.link(plantId, speciesId));

  Future<void> reload() => _busy('reload', () => _profiles.reload(plantId));

  /// Takes over the suggested watering interval.
  Future<void> waterEvery(Plant plant, int days) => _plants.edit(plant.copyWith(everyDays: days));

  /// Fertilizing every [weeks] weeks; `null` switches it off.
  Future<void> fertilizeEvery(Plant plant, int? weeks) => _plants.edit(plant.copyWith(fertilizeEveryWeeks: weeks));

  PlantProfileService get _profiles => ref.read(plantProfileServiceProvider.notifier);

  PlantsService get _plants => ref.read(plantsServiceProvider.notifier);

  Future<void> _busy(String action, Future<void> Function() command) async {
    state = true;
    try {
      await command();
    } on Object catch (e) {
      _log.warning('Could not $action the plant profile: $e');
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
