import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/fertilizing.util.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';

void main() {
  group('FertilizingUtil', () {
    Plant plant({int? everyWeeks = 4, DateTime? lastFertilized}) => Plant(
      id: 'p',
      name: 'Monstera',
      everyDays: 7,
      lastWatered: DateTime(2026),
      fertilizeEveryWeeks: everyWeeks,
      lastFertilized: lastFertilized,
    );

    test('Given a plant that is not fertilized, when asking, then nothing is due', () {
      expect(FertilizingUtil.dueInDays(plant(everyWeeks: null), DateTime(2026, 5, 1)), isNull);
      expect(FertilizingUtil.isDue(plant(everyWeeks: null), DateTime(2026, 5, 1)), isFalse);
    });

    test('Given fertilized 4 weeks ago in May, when asking today, then it is due today', () {
      // Given
      final fed = plant(lastFertilized: DateTime(2026, 5, 1, 20));

      // When / Then
      expect(FertilizingUtil.dueInDays(fed, DateTime(2026, 5, 29, 7)), 0);
      expect(FertilizingUtil.isDue(fed, DateTime(2026, 5, 29)), isTrue);
    });

    test('Given fertilized 5 weeks ago in summer, when asking, then it is a week overdue', () {
      expect(FertilizingUtil.dueInDays(plant(lastFertilized: DateTime(2026, 7, 1)), DateTime(2026, 8, 5)), -7);
    });

    test('Given the next feeding would fall into October, when asking in September, then it waits for March', () {
      // When
      final due = FertilizingUtil.nextDue(plant(lastFertilized: DateTime(2026, 9, 20)), DateTime(2026, 9, 25));

      // Then
      expect(due, DateTime(2027, 3));
    });

    test('Given winter, when asking about a plant fed in autumn, then it is not due before March', () {
      // Given
      final fed = plant(lastFertilized: DateTime(2026, 9, 20));

      // When / Then
      expect(FertilizingUtil.isDue(fed, DateTime(2027, 1, 15)), isFalse);
      expect(FertilizingUtil.isDue(fed, DateTime(2027, 3, 1)), isTrue);
    });

    test('Given a plant never fertilized, when asking in season, then it is due today; in winter on 1 March', () {
      expect(FertilizingUtil.dueInDays(plant(), DateTime(2026, 6, 10)), 0);
      expect(FertilizingUtil.nextDue(plant(), DateTime(2026, 11, 10)), DateTime(2027, 3));
      expect(FertilizingUtil.nextDue(plant(), DateTime(2027, 2, 10)), DateTime(2027, 3));
    });

    test('Given the season limits, when checking, then March and September are inside, February and October not', () {
      expect(FertilizingUtil.inSeason(DateTime(2026, 3)), isTrue);
      expect(FertilizingUtil.inSeason(DateTime(2026, 9, 30)), isTrue);
      expect(FertilizingUtil.inSeason(DateTime(2026, 2, 28)), isFalse);
      expect(FertilizingUtil.inSeason(DateTime(2026, 10)), isFalse);
    });

    test('Given care levels, when picking a default interval, then demanding plants are fed more often', () {
      expect(FertilizingUtil.defaultEveryWeeks('High'), 2);
      expect(FertilizingUtil.defaultEveryWeeks('Medium'), 4);
      expect(FertilizingUtil.defaultEveryWeeks('low'), 6);
      expect(FertilizingUtil.defaultEveryWeeks(null), 4);
    });

    test('Given a feeding missed in September, when asking in October, then it rests until March', () {
      // Given
      final missed = plant(everyWeeks: 2, lastFertilized: DateTime(2026, 9));

      // When / Then
      expect(FertilizingUtil.isDue(missed, DateTime(2026, 10, 26)), isFalse);
      expect(FertilizingUtil.nextDue(missed, DateTime(2026, 10, 26)), DateTime(2027, 3));
    });
  });
}
