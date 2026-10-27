import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/plants/model/plant_profile_source.enum.dart';

part 'plant_profile.freezed.dart';

/// Care data of a plant's species, loaded once from the plant database (or imported) and kept locally.
@freezed
abstract class PlantProfile with _$PlantProfile {
  const factory PlantProfile({
    /// Species in the plant database; `null` for imported profiles.
    int? speciesId,
    @Default(PlantProfileSource.perenual) PlantProfileSource source,
    required String commonName,
    String? scientificName,
    String? imageUrl,

    /// E.g. "Average".
    String? watering,

    /// Typical days between waterings in the growing season, e.g. 7–10.
    int? wateringMinDays,
    int? wateringMaxDays,

    /// Days between waterings from October to February; `null` when unknown.
    int? wateringWinterMinDays,
    int? wateringWinterMaxDays,

    /// Weeks between feeding in the growing season, as the source suggests; only imported profiles know it.
    int? fertilizeEveryWeeks,

    /// E.g. ["part shade", "full sun"].
    @Default([]) List<String> sunlight,

    /// "Low", "Medium" or "High".
    String? careLevel,
    bool? indoor,
    bool? poisonousToPets,

    /// Months in which to prune, e.g. ["March", "April"].
    @Default([]) List<String> pruningMonths,
    String? wateringGuide,
    String? sunlightGuide,
    String? pruningGuide,
    required DateTime fetchedAt,
  }) = _PlantProfile;
}
