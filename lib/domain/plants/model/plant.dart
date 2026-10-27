import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';

/// A plant of the household. Plants live only in the app, not in Home Assistant.
@freezed
abstract class Plant with _$Plant {
  const factory Plant({
    required String id,
    required String name,

    /// Watering interval in days, at least 1.
    required int everyDays,
    required DateTime lastWatered,

    /// The watering before [lastWatered], kept to undo a watering on the same day.
    DateTime? previousWatered,

    /// Photo in the app's documents directory.
    String? photoPath,

    /// Weeks between fertilizing in the growing season; `null` = not fertilized.
    int? fertilizeEveryWeeks,
    DateTime? lastFertilized,
  }) = _Plant;
}
