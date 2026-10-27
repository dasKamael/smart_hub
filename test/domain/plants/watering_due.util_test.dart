import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/domain/plants/watering_due.util.dart';

void main() {
  final now = DateTime(2026, 10, 26, 9);

  Plant plant(String id, {required int every, required DateTime watered}) {
    return Plant(id: id, name: id, everyDays: every, lastWatered: watered);
  }

  group('WateringDueUtil', () {
    test('Given a plant watered 8 days ago with interval 7, when calculating, then it is 1 day overdue', () {
      final fern = plant('fern', every: 7, watered: DateTime(2026, 10, 18, 20));

      expect(WateringDueUtil.dueInDays(fern, now), -1);
      expect(WateringDueUtil.stateOf(fern, now), WateringState.overdue);
    });

    test('Given a plant watered exactly one interval ago, when calculating, then it is due today', () {
      final basil = plant('basil', every: 3, watered: DateTime(2026, 10, 23, 23, 59));

      expect(WateringDueUtil.dueInDays(basil, now), 0);
      expect(WateringDueUtil.stateOf(basil, now), WateringState.dueToday);
    });

    test('Given a plant watered late yesterday evening, '
        'when it is early morning, '
        'then calendar days count, not hours', () {
      final cactus = plant('cactus', every: 1, watered: DateTime(2026, 10, 25, 23, 50));

      expect(WateringDueUtil.dueInDays(cactus, DateTime(2026, 10, 26, 0, 10)), 0);
    });

    test('Given a plant watered today, when calculating, then it is watered today, not due', () {
      final mint = plant('mint', every: 1, watered: DateTime(2026, 10, 26, 7));

      expect(WateringDueUtil.stateOf(mint, now), WateringState.wateredToday);
      expect(WateringDueUtil.stateOf(mint, now).isDue, isFalse);
    });

    test('Given a plant with time left, when calculating, then it is upcoming', () {
      final palm = plant('palm', every: 10, watered: DateTime(2026, 10, 20));

      expect(WateringDueUtil.dueInDays(palm, now), 4);
      expect(WateringDueUtil.stateOf(palm, now), WateringState.upcoming);
    });

    test('Given a change to daylight saving time, when counting days, then a day is still a day', () {
      expect(WateringDueUtil.daysBetween(DateTime(2026, 10, 24, 12), DateTime(2026, 10, 26, 12)), 2);
      expect(WateringDueUtil.daysBetween(DateTime(2026, 3, 28, 12), DateTime(2026, 3, 30, 12)), 2);
    });
  });

  group('WateringDueUtil.week', () {
    test('Given overdue, due, watered and upcoming plants, '
        'when building the week, '
        'then today holds due and watered plants and later days their next waterings', () {
      // Given
      final overdue = plant('overdue', every: 7, watered: DateTime(2026, 10, 17));
      final due = plant('due', every: 3, watered: DateTime(2026, 10, 23));
      final watered = plant('watered', every: 2, watered: DateTime(2026, 10, 26, 8));
      final later = plant('later', every: 10, watered: DateTime(2026, 10, 21));

      // When
      final week = WateringDueUtil.week([later, watered, due, overdue], now);

      // Then
      expect(week, hasLength(7));
      expect(week[0].map((p) => p.id), ['overdue', 'due', 'watered']);
      expect(week[1].map((p) => p.id), isEmpty);
      expect(week[2].map((p) => p.id), ['watered']);
      expect(week[3].map((p) => p.id), ['due']);
      expect(week[4].map((p) => p.id), ['watered']);
      expect(week[5].map((p) => p.id), ['later']);
      expect(week[6].map((p) => p.id), ['due', 'watered']);
    });

    test('Given an overdue plant with a short interval, when building the week, then it repeats from today', () {
      final thirsty = plant('thirsty', every: 2, watered: DateTime(2026, 10, 20));

      final week = WateringDueUtil.week([thirsty], now);

      expect([for (final day in week) day.isNotEmpty], [true, false, true, false, true, false, true]);
    });
  });
}
