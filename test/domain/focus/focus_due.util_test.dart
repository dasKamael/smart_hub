import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/focus/focus_due.util.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';
import 'package:smart_hub/domain/focus/model/focus_urgency.enum.dart';

void main() {
  final today = DateTime(2026, 10, 28, 21, 40);

  FocusPoint buildPoint({DateTime? dueDate, DateTime? createdAt, DateTime? achievedAt}) {
    return FocusPoint(
      id: 'focus-1',
      title: 'Hub on the wall',
      dueDate: dueDate ?? DateTime(2026, 11, 6),
      createdAt: createdAt ?? DateTime(2026, 10, 18),
      achievedAt: achievedAt,
    );
  }

  group('FocusDueUtil.daysLeft', () {
    test('Given a point due in nine days, '
        'when counting the days left, '
        'then nine are left whatever the time of day is', () {
      // Given
      final point = buildPoint();

      // When
      final left = FocusDueUtil.daysLeft(point, today);

      // Then
      expect(left, 9);
    });

    test('Given a point due today, '
        'when counting the days left, '
        'then none are left and it is not over yet', () {
      // Given
      final point = buildPoint(dueDate: DateTime(2026, 10, 28));

      // When
      final left = FocusDueUtil.daysLeft(point, today);

      // Then
      expect(left, 0);
      expect(FocusDueUtil.urgencyOf(point, today), FocusUrgency.today);
    });

    test('Given a point whose day was the day before yesterday, '
        'when counting the days left, '
        'then it is two days over', () {
      // Given
      final point = buildPoint(dueDate: DateTime(2026, 10, 26));

      // When
      final left = FocusDueUtil.daysLeft(point, today);

      // Then
      expect(left, -2);
      expect(FocusDueUtil.countdown(point, today), '2 days over');
    });
  });

  group('FocusDueUtil.urgencyOf', () {
    test('Given a point due in four days, '
        'when asking how pressing it is, '
        'then it is still calm; one day earlier it presses', () {
      // Given
      final calm = buildPoint(dueDate: DateTime(2026, 11, 1));
      final soon = buildPoint(dueDate: DateTime(2026, 10, 31));

      // When / Then
      expect(FocusDueUtil.urgencyOf(calm, today), FocusUrgency.calm);
      expect(FocusDueUtil.urgencyOf(soon, today), FocusUrgency.soon);
    });

    test('Given a point that is done, '
        'when asking how pressing it is, '
        'then it is done however long its day has passed', () {
      // Given
      final point = buildPoint(dueDate: DateTime(2026, 10, 1), achievedAt: DateTime(2026, 10, 2));

      // When
      final urgency = FocusDueUtil.urgencyOf(point, today);

      // Then
      expect(urgency, FocusUrgency.done);
    });
  });

  group('FocusDueUtil.progress', () {
    test('Given ten days taken on of which five have passed, '
        'when asking how far it has run, '
        'then it is half', () {
      // Given
      final point = buildPoint(createdAt: DateTime(2026, 10, 23, 18), dueDate: DateTime(2026, 11, 2));

      // When
      final progress = FocusDueUtil.progress(point, today);

      // Then
      expect(progress, 0.5);
    });

    test('Given a point whose day has passed, '
        'when asking how far it has run, '
        'then it stays full instead of running over', () {
      // Given
      final point = buildPoint(createdAt: DateTime(2026, 10, 18), dueDate: DateTime(2026, 10, 20));

      // When
      final progress = FocusDueUtil.progress(point, today);

      // Then
      expect(progress, 1);
    });

    test('Given a point taken on for today, '
        'when asking how far it has run, '
        'then it is full – there is no time left to show', () {
      // Given
      final point = buildPoint(createdAt: today, dueDate: DateTime(2026, 10, 28));

      // When
      final progress = FocusDueUtil.progress(point, today);

      // Then
      expect(progress, 1);
    });
  });

  group('FocusDueUtil.countdown', () {
    test('Given points due today, tomorrow and in nine days, '
        'when writing their countdown, '
        'then each one reads as it would be said', () {
      // Given / When / Then
      expect(FocusDueUtil.countdown(buildPoint(dueDate: DateTime(2026, 10, 28)), today), 'Today');
      expect(FocusDueUtil.countdown(buildPoint(dueDate: DateTime(2026, 10, 29)), today), 'Tomorrow');
      expect(FocusDueUtil.countdown(buildPoint(), today), 'in 9 days');
      expect(FocusDueUtil.countdown(buildPoint(dueDate: DateTime(2026, 10, 27)), today), '1 day over');
    });
  });
}
