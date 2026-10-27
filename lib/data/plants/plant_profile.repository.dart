import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/plant_profile_source.enum.dart';

part 'plant_profile.repository.g.dart';

/// Plant profiles, kept locally so the plant database is asked only once per species.
class PlantProfileRepository {
  PlantProfileRepository({required this.database});

  final AppDatabase database;

  $PlantProfilesTableTable get _table => database.plantProfilesTable;

  Stream<PlantProfile?> watch(String plantId) {
    return (database.select(
      _table,
    )..where((t) => t.plantId.equals(plantId))).watchSingleOrNull().map((row) => row == null ? null : _toProfile(row));
  }

  Stream<Map<String, PlantProfile>> watchAll() {
    return database.select(_table).watch().map((rows) => {for (final row in rows) row.plantId: _toProfile(row)});
  }

  /// A profile of [speciesId] that another plant already has.
  Future<PlantProfile?> ofSpecies(int speciesId) async {
    final query = database.select(_table)
      ..where((t) => t.speciesId.equals(speciesId))
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : _toProfile(row);
  }

  Future<void> save(String plantId, PlantProfile profile) {
    return database.into(_table).insertOnConflictUpdate(_toRow(plantId, profile).toCompanion(false));
  }

  Future<void> delete(String plantId) => (database.delete(_table)..where((t) => t.plantId.equals(plantId))).go();

  static List<String> _lines(String text) => [
    for (final line in text.split('\n'))
      if (line.isNotEmpty) line,
  ];

  static PlantProfile _toProfile(PlantProfileRow row) {
    return PlantProfile(
      speciesId: row.speciesId,
      source:
          PlantProfileSource.values.where((source) => source.name == row.source).firstOrNull ??
          PlantProfileSource.perenual,
      commonName: row.commonName,
      scientificName: row.scientificName,
      imageUrl: row.imageUrl,
      watering: row.watering,
      wateringMinDays: row.wateringMinDays,
      wateringMaxDays: row.wateringMaxDays,
      wateringWinterMinDays: row.wateringWinterMinDays,
      wateringWinterMaxDays: row.wateringWinterMaxDays,
      fertilizeEveryWeeks: row.fertilizeEveryWeeks,
      sunlight: _lines(row.sunlight),
      careLevel: row.careLevel,
      indoor: row.indoor,
      poisonousToPets: row.poisonousToPets,
      pruningMonths: _lines(row.pruningMonths),
      wateringGuide: row.wateringGuide,
      sunlightGuide: row.sunlightGuide,
      pruningGuide: row.pruningGuide,
      fetchedAt: row.fetchedAt,
    );
  }

  static PlantProfileRow _toRow(String plantId, PlantProfile profile) {
    return PlantProfileRow(
      plantId: plantId,
      speciesId: profile.speciesId,
      source: profile.source.name,
      commonName: profile.commonName,
      scientificName: profile.scientificName,
      imageUrl: profile.imageUrl,
      watering: profile.watering,
      wateringMinDays: profile.wateringMinDays,
      wateringMaxDays: profile.wateringMaxDays,
      wateringWinterMinDays: profile.wateringWinterMinDays,
      wateringWinterMaxDays: profile.wateringWinterMaxDays,
      fertilizeEveryWeeks: profile.fertilizeEveryWeeks,
      sunlight: profile.sunlight.join('\n'),
      careLevel: profile.careLevel,
      indoor: profile.indoor,
      poisonousToPets: profile.poisonousToPets,
      pruningMonths: profile.pruningMonths.join('\n'),
      wateringGuide: profile.wateringGuide,
      sunlightGuide: profile.sunlightGuide,
      pruningGuide: profile.pruningGuide,
      fetchedAt: profile.fetchedAt,
    );
  }
}

/// Providers
@Riverpod(keepAlive: true)
PlantProfileRepository plantProfileRepository(Ref ref) {
  return PlantProfileRepository(database: ref.watch(appDatabaseProvider));
}
