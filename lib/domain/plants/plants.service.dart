import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/plants/plant.repository.dart';
import 'package:smart_hub/data/plants/plant_photo.repository.dart';
import 'package:smart_hub/data/plants/plant_profile.repository.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/watering_due.util.dart';

part 'plants.service.g.dart';

/// All plants, sorted by name, and watering.
@Riverpod(keepAlive: true)
class PlantsService extends _$PlantsService {
  @override
  Stream<List<Plant>> build() {
    return ref
        .watch(plantRepositoryProvider)
        .watchAll()
        .map((plants) => [...plants]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));
  }

  /// Adds a plant that was just watered. [photoSource] is copied into the app.
  Future<Plant> add({
    required String name,
    required int everyDays,
    int? fertilizeEveryWeeks,
    String? photoSource,
  }) async {
    final now = clock.now();
    final id = 'plant-${now.microsecondsSinceEpoch.toRadixString(36)}';
    final plant = Plant(
      id: id,
      name: name.trim(),
      everyDays: everyDays.clamp(1, 365),
      lastWatered: now,
      fertilizeEveryWeeks: fertilizeEveryWeeks,
      // Counts as fertilized at the start, so the first feeding is due after one interval.
      lastFertilized: fertilizeEveryWeeks == null ? null : now,
      photoPath: photoSource == null ? null : await ref.read(plantPhotoRepositoryProvider).store(id, photoSource),
    );
    await ref.read(plantRepositoryProvider).save(plant);
    return plant;
  }

  /// Saves name and interval; a new [photoSource] replaces the old photo.
  Future<void> edit(Plant plant, {String? photoSource}) async {
    var updated = plant.copyWith(
      name: plant.name.trim(),
      everyDays: plant.everyDays.clamp(1, 365),
      // Fertilizing switched on starts today, instead of being due at once.
      lastFertilized: plant.fertilizeEveryWeeks != null ? plant.lastFertilized ?? clock.now() : plant.lastFertilized,
    );
    if (photoSource != null) {
      final photos = ref.read(plantPhotoRepositoryProvider);
      updated = updated.copyWith(photoPath: await photos.store(plant.id, photoSource));
      if (plant.photoPath case final old?) await photos.delete(old);
    }
    await ref.read(plantRepositoryProvider).save(updated);
  }

  Future<void> delete(Plant plant) async {
    await ref.read(plantRepositoryProvider).delete(plant.id);
    await ref.read(plantProfileRepositoryProvider).delete(plant.id);
    if (plant.photoPath case final photo?) await ref.read(plantPhotoRepositoryProvider).delete(photo);
  }

  /// Waters [ids] now. Plants already watered today are left alone, so their undo stays possible.
  Future<void> water(List<String> ids) async {
    final now = clock.now();
    final watered = [
      for (final plant in await ref.read(plantRepositoryProvider).all())
        if (ids.contains(plant.id) && !WateringDueUtil.isWateredToday(plant, now))
          plant.copyWith(lastWatered: now, previousWatered: plant.lastWatered),
    ];
    await ref.read(plantRepositoryProvider).saveAll(watered);
  }

  /// Fertilizes [ids] now.
  Future<void> fertilize(List<String> ids) async {
    final now = clock.now();
    final fertilized = [
      for (final plant in await ref.read(plantRepositoryProvider).all())
        if (ids.contains(plant.id)) plant.copyWith(lastFertilized: now),
    ];
    await ref.read(plantRepositoryProvider).saveAll(fertilized);
  }

  /// Takes back today's watering of [id].
  Future<void> undoWatering(String id) async {
    final repository = ref.read(plantRepositoryProvider);
    final plant = (await repository.all()).where((plant) => plant.id == id).firstOrNull;
    final previous = plant?.previousWatered;
    if (plant == null || previous == null || !WateringDueUtil.isWateredToday(plant, clock.now())) return;
    await repository.save(plant.copyWith(lastWatered: previous, previousWatered: null));
  }

  /// Adds [plants] if there are none yet, e.g. the plants of the demo home.
  Future<void> addAllIfEmpty(List<Plant> plants) async {
    final repository = ref.read(plantRepositoryProvider);
    if ((await repository.all()).isEmpty) await repository.saveAll(plants);
  }
}
