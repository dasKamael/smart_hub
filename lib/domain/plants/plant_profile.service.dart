import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/config/perenual_config.dart';
import 'package:smart_hub/data/plants/perenual/perenual.repository.dart';
import 'package:smart_hub/data/plants/plant.repository.dart';
import 'package:smart_hub/data/plants/plant_profile.repository.dart';
import 'package:smart_hub/domain/plants/care_suggestion.util.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';
import 'package:smart_hub/domain/plants/plant_care_import.util.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';

part 'plant_profile.service.g.dart';

/// Whether plants can be linked with the plant database (needs an API key in the build).
@riverpod
bool plantDatabaseAvailable(Ref ref) => ref.watch(perenualConfigProvider).isConfigured;

/// The profile of [plantId]; `null` while the plant is not linked with a species.
@riverpod
Stream<PlantProfile?> plantProfile(Ref ref, String plantId) {
  return ref.watch(plantProfileRepositoryProvider).watch(plantId);
}

/// Species matching [query] in the plant database; empty for short queries or without the database.
@riverpod
Future<List<SpeciesMatch>> speciesSearch(Ref ref, String query) async {
  final text = query.trim();
  if (!ref.watch(plantDatabaseAvailableProvider) || text.length < 3) return const [];
  return ref.watch(perenualRepositoryProvider).search(text);
}

/// Links plants with species of the plant database. Profiles are stored with the plant, and a species another plant
/// already has is copied instead of loaded again.
@Riverpod(keepAlive: true)
class PlantProfileService extends _$PlantProfileService {
  /// Profiles loaded for a preview, so linking right after does not ask the database again.
  final _previews = <int, PlantProfile>{};

  @override
  void build() {}

  /// The profile of [speciesId] without linking it, e.g. to suggest a watering interval while adding a plant.
  Future<PlantProfile> preview(int speciesId) async {
    if (_previews[speciesId] case final profile?) return profile;
    final profile =
        await ref.read(plantProfileRepositoryProvider).ofSpecies(speciesId) ??
        await ref.read(perenualRepositoryProvider).profile(speciesId);
    return _previews[speciesId] = profile;
  }

  Future<PlantProfile> link(String plantId, int speciesId) async {
    final profile = await preview(speciesId);
    await ref.read(plantProfileRepositoryProvider).save(plantId, profile);
    return profile;
  }

  /// Loads the profile of [plantId] again from the plant database.
  Future<void> reload(String plantId) async {
    final profiles = ref.read(plantProfileRepositoryProvider);
    final speciesId = (await profiles.watch(plantId).first)?.speciesId;
    if (speciesId == null) return;
    await profiles.save(plantId, await ref.read(perenualRepositoryProvider).profile(speciesId));
  }

  Future<void> unlink(String plantId) => ref.read(plantProfileRepositoryProvider).delete(plantId);

  /// Keeps an imported [profile] with [plantId], e.g. pasted while editing the plant.
  Future<void> keep(String plantId, PlantProfile profile) =>
      ref.read(plantProfileRepositoryProvider).save(plantId, profile);

  /// Saves imported care data. Plants are matched by name (case does not matter); unknown names become new plants.
  /// Each plant takes over the suggested watering interval (for the current season) and feeding interval.
  Future<({int updated, int added})> importCare(List<PlantCareEntry> entries) async {
    final now = clock.now();
    final plants = ref.read(plantsServiceProvider.notifier);
    final existing = await ref.read(plantRepositoryProvider).all();
    var updated = 0;
    var added = 0;
    for (final (:name, :profile) in entries) {
      final everyDays = CareSuggestionUtil.everyDays(profile, now) ?? 7;
      final fertilizeEveryWeeks = CareSuggestionUtil.fertilizeEveryWeeks(profile);
      final match = existing.where((plant) => plant.name.trim().toLowerCase() == name.trim().toLowerCase());
      final String plantId;
      if (match.firstOrNull case final plant?) {
        await plants.edit(plant.copyWith(everyDays: everyDays, fertilizeEveryWeeks: fertilizeEveryWeeks));
        plantId = plant.id;
        updated++;
      } else {
        plantId = (await plants.add(name: name, everyDays: everyDays, fertilizeEveryWeeks: fertilizeEveryWeeks)).id;
        added++;
      }
      await ref.read(plantProfileRepositoryProvider).save(plantId, profile);
    }
    return (updated: updated, added: added);
  }
}
