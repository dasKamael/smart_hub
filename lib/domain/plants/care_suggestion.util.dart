import 'package:smart_hub/domain/plants/fertilizing.util.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/plant_profile_source.enum.dart';

/// What a plant profile suggests for the plant's own plan.
abstract final class CareSuggestionUtil {
  /// The watering range for [now]: the winter range from October to February when the profile has one ([winter]
  /// says which one it is).
  static ({int min, int max, bool winter})? wateringRange(PlantProfile profile, DateTime now) {
    final winterNow = !FertilizingUtil.inSeason(now);
    if (winterNow) {
      if ((profile.wateringWinterMinDays, profile.wateringWinterMaxDays) case (final min?, final max?)) {
        return (min: min, max: max, winter: true);
      }
    }
    return switch ((profile.wateringMinDays, profile.wateringMaxDays)) {
      (final min?, final max?) => (min: min, max: max, winter: false),
      (final days?, null) || (null, final days?) => (min: days, max: days, winter: false),
      _ => null,
    };
  }

  /// The middle of [wateringRange], as the plant's interval.
  static int? everyDays(PlantProfile profile, DateTime now) {
    final range = wateringRange(profile, now);
    return range == null ? null : ((range.min + range.max) / 2).round();
  }

  /// Weeks between feeding: as imported (`null` = needs none), otherwise from the care level.
  static int? fertilizeEveryWeeks(PlantProfile profile) {
    return switch (profile.source) {
      PlantProfileSource.imported => profile.fertilizeEveryWeeks,
      PlantProfileSource.perenual => FertilizingUtil.defaultEveryWeeks(profile.careLevel),
    };
  }
}
