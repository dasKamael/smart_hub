import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/watering_due.util.dart';

/// Fertilizing schedule: every few weeks in the growing season (March to September), paused in winter. Plant
/// databases do not say how often to fertilize, so the interval comes from the care level and can be changed.
abstract final class FertilizingUtil {
  static const seasonFirstMonth = DateTime.march;
  static const seasonLastMonth = DateTime.september;

  static bool inSeason(DateTime day) => day.month >= seasonFirstMonth && day.month <= seasonLastMonth;

  /// Demanding plants are fed more often than easy ones.
  static int defaultEveryWeeks(String? careLevel) {
    return switch (careLevel?.toLowerCase()) {
      'high' => 2,
      'low' => 6,
      _ => 4,
    };
  }

  /// The day fertilizing is next due; `null` when the plant is not fertilized. A due day in winter – or a feeding
  /// still open when the season ended – moves to the start of the next season.
  static DateTime? nextDue(Plant plant, DateTime now) {
    final weeks = plant.fertilizeEveryWeeks;
    if (weeks == null) return null;
    final last = plant.lastFertilized?.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final due = last == null ? today : DateTime(last.year, last.month, last.day + weeks * 7);
    // An overdue feeding counts as due today.
    final pending = due.isBefore(today) ? today : due;
    if (inSeason(pending)) return due;
    return DateTime(pending.month > seasonLastMonth ? pending.year + 1 : pending.year, seasonFirstMonth);
  }

  /// Days until fertilizing is due; negative when overdue, `null` when the plant is not fertilized.
  static int? dueInDays(Plant plant, DateTime now) {
    final due = nextDue(plant, now);
    return due == null ? null : WateringDueUtil.daysBetween(now, due);
  }

  static bool isDue(Plant plant, DateTime now) => (dueInDays(plant, now) ?? 1) <= 0;

  static bool isFertilizedToday(Plant plant, DateTime now) {
    final last = plant.lastFertilized;
    return last != null && WateringDueUtil.daysBetween(last.toLocal(), now) == 0;
  }
}
