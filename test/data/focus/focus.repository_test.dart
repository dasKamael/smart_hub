import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/focus/focus.repository.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';

void main() {
  group('FocusRepository', () {
    late FocusRepository repository;

    FocusPoint buildPoint({String id = 'focus-1', int position = 0, DateTime? dueDate, DateTime? achievedAt}) {
      return FocusPoint(
        id: id,
        title: 'Hub on the wall',
        dueDate: dueDate ?? DateTime(2026, 11, 6),
        createdAt: DateTime(2026, 10, 18),
        position: position,
        achievedAt: achievedAt,
      );
    }

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = FocusRepository(database: database);
    });

    test('Given a focus point, '
        'when saving and reading it, '
        'then everything comes back', () async {
      // Given
      final point = buildPoint();

      // When
      await repository.save(point);

      // Then
      expect(await repository.all(), [point]);
    });

    test('Given a point marked done, '
        'when saving it as open again, '
        'then the done day is cleared', () async {
      // Given
      await repository.save(buildPoint(achievedAt: DateTime(2026, 10, 28)));

      // When
      await repository.save(buildPoint());

      // Then
      expect((await repository.all()).single.achievedAt, isNull);
    });

    test('Given points saved out of order, '
        'when reading them, '
        'then they come in their position order', () async {
      // Given
      await repository.save(buildPoint(id: 'focus-2', position: 1));
      await repository.save(buildPoint(id: 'focus-1', position: 0));

      // When
      final points = await repository.all();

      // Then
      expect([for (final point in points) point.id], ['focus-1', 'focus-2']);
    });

    test('Given a saved point, '
        'when deleting it, '
        'then nothing is left', () async {
      // Given
      await repository.save(buildPoint());

      // When
      await repository.delete('focus-1');

      // Then
      expect(await repository.all(), isEmpty);
    });

    test('Given a point being watched, '
        'when its day changes, '
        'then the watcher sees the new one', () async {
      // Given
      await repository.save(buildPoint());
      final days = repository.watchAll().map((points) => points.single.dueDate);

      // When
      final seen = days.take(2).toList();
      await repository.save(buildPoint(dueDate: DateTime(2026, 11, 20)));

      // Then
      expect(await seen, [DateTime(2026, 11, 6), DateTime(2026, 11, 20)]);
    });
  });
}
