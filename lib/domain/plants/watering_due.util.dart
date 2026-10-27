import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';

/// Watering schedule (`README` → "Plants"): `due in = every − days since watered`, `< 0` overdue, `0` today.
///
/// Days are calendar days in local time, so watering late in the evening does not shift the schedule.
abstract final class WateringDueUtil {
  /// Calendar days from [from] to [to], ignoring the time of day.
  static int daysBetween(DateTime from, DateTime to) {
    final start = DateTime.utc(from.year, from.month, from.day);
    final end = DateTime.utc(to.year, to.month, to.day);
    return end.difference(start).inDays;
  }

  /// Days until the next watering; negative when overdue.
  static int dueInDays(Plant plant, DateTime now) => plant.everyDays - daysBetween(plant.lastWatered.toLocal(), now);

  static bool isWateredToday(Plant plant, DateTime now) => daysBetween(plant.lastWatered.toLocal(), now) == 0;

  static WateringState stateOf(Plant plant, DateTime now) {
    if (isWateredToday(plant, now)) return WateringState.wateredToday;
    final dueIn = dueInDays(plant, now);
    if (dueIn < 0) return WateringState.overdue;
    if (dueIn == 0) return WateringState.dueToday;
    return WateringState.upcoming;
  }

  /// Plants per day for the next 7 days, starting today.
  ///
  /// Today shows what is due, overdue or already watered today; later days show the plants that are due then,
  /// assuming they are watered on time.
  static List<List<Plant>> week(List<Plant> plants, DateTime now) {
    return [
      for (var day = 0; day < 7; day++)
        [
          for (final plant in plants)
            if (_isOnDay(plant, day, now)) plant,
        ]..sort((a, b) => _todayOrder(a, now).compareTo(_todayOrder(b, now))),
    ];
  }

  static bool _isOnDay(Plant plant, int day, DateTime now) {
    final dueIn = dueInDays(plant, now);
    if (day == 0) return dueIn <= 0 || isWateredToday(plant, now);
    final first = dueIn < 0 ? 0 : dueIn;
    return day >= first && (day - first) % plant.everyDays == 0;
  }

  /// Most overdue first, watered plants last.
  static int _todayOrder(Plant plant, DateTime now) {
    return isWateredToday(plant, now) ? 1 << 20 : dueInDays(plant, now);
  }
}
