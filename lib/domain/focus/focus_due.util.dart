import 'package:smart_hub/domain/focus/model/focus_point.dart';
import 'package:smart_hub/domain/focus/model/focus_urgency.enum.dart';

/// The countdown of a focus point: how many days are left, how much of its time has passed and how pressing it is.
///
/// Days are calendar days in local time, so a point set late in the evening still has all of its last day.
abstract final class FocusDueUtil {
  /// Days left at which a point starts to press.
  static const soonDays = 3;

  /// [time] without its time of day.
  static DateTime dayOf(DateTime time) => DateTime(time.year, time.month, time.day);

  /// Calendar days from [from] to [to], ignoring the time of day.
  static int daysBetween(DateTime from, DateTime to) {
    return DateTime.utc(to.year, to.month, to.day).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
  }

  /// Days until it has to be done; 0 on the day itself, negative once it has passed.
  static int daysLeft(FocusPoint point, DateTime now) => daysBetween(now, point.dueDate);

  /// How much of the time from the day it was taken on to its day has passed, 0 to 1. A point due the day it was
  /// taken on starts at 0 and is full once the day is over.
  static double progress(FocusPoint point, DateTime now) {
    final total = daysBetween(point.createdAt, point.dueDate);
    if (total <= 0) return daysLeft(point, now) <= 0 ? 1 : 0;
    final gone = daysBetween(point.createdAt, now);
    return (gone / total).clamp(0, 1).toDouble();
  }

  static FocusUrgency urgencyOf(FocusPoint point, DateTime now) {
    if (point.achievedAt != null) return FocusUrgency.done;
    final left = daysLeft(point, now);
    if (left < 0) return FocusUrgency.overdue;
    if (left == 0) return FocusUrgency.today;
    return left <= soonDays ? FocusUrgency.soon : FocusUrgency.calm;
  }

  /// "Today", "Tomorrow", "in 9 days", "2 days over" – the countdown in words.
  static String countdown(FocusPoint point, DateTime now) {
    final left = daysLeft(point, now);
    return switch (left) {
      0 => 'Today',
      1 => 'Tomorrow',
      final left when left > 1 => 'in $left days',
      -1 => '1 day over',
      final over => '${-over} days over',
    };
  }
}
