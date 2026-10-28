import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/focus/focus.repository.dart';
import 'package:smart_hub/domain/focus/focus.service.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';

import '../../utils/riverpod.test_util.dart';

void main() {
  group('FocusService', () {
    final now = DateTime(2026, 10, 28, 9, 30);
    final nextWeek = DateTime(2026, 11, 4);
    late FocusRepository repository;
    late ProviderContainer container;

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = FocusRepository(database: database);
      container = createTestContainer(overrides: [focusRepositoryProvider.overrideWithValue(repository)]);
      // Keeps the service's stream subscribed, so its state is there to read.
      container.listen(focusServiceProvider, (_, _) {});
    });

    FocusService service() => container.read(focusServiceProvider.notifier);

    Future<T> at<T>(Future<T> Function() body) => withClock(Clock.fixed(now), body);

    test('Given two focus points, '
        'when taking on a third, '
        'then it goes in at the end', () async {
      // Given
      await at(() => service().add(title: 'Hub on the wall', dueDate: nextWeek));
      await at(() => service().add(title: 'Taxes', dueDate: nextWeek));

      // When
      final added = await at(() => service().add(title: 'Bike service', dueDate: nextWeek));

      // Then
      expect(added, isNotNull);
      expect([for (final point in await repository.all()) point.title], ['Hub on the wall', 'Taxes', 'Bike service']);
    });

    test('Given three focus points, '
        'when taking on a fourth, '
        'then it is turned down – three is the limit', () async {
      // Given
      for (final title in ['One', 'Two', 'Three']) {
        await at(() => service().add(title: title, dueDate: nextWeek));
      }

      // When
      final added = await at(() => service().add(title: 'Four', dueDate: nextWeek));

      // Then
      expect(added, isNull);
      expect(await repository.all(), hasLength(3));
    });

    test('Given three focus points of which one is done, '
        'when taking on another, '
        'then the freed place is taken', () async {
      // Given
      for (final title in ['One', 'Two', 'Three']) {
        await at(() => service().add(title: title, dueDate: nextWeek));
      }
      final done = (await repository.all()).first;

      // When
      await at(() => service().achieve(done.id));
      final added = await at(() => service().add(title: 'Four', dueDate: nextWeek));

      // Then
      expect(added, isNotNull);
      expect((await repository.all()).where((point) => point.isActive), hasLength(3));
    });

    test('Given a day with a time on it, '
        'when taking on a point for it, '
        'then the day is kept without the time', () async {
      // Given
      final dueDate = DateTime(2026, 11, 30, 17, 45);

      // When
      await at(() => service().add(title: 'Taxes', dueDate: dueDate));

      // Then
      expect((await repository.all()).single.dueDate, DateTime(2026, 11, 30));
    });

    test('Given a focus point, '
        'when changing its name and its day, '
        'then both are saved', () async {
      // Given
      final point = await at(() => service().add(title: 'Taxes', dueDate: nextWeek));

      // When
      await at(() => service().edit(point!.id, title: '  Tax return  ', dueDate: DateTime(2026, 11, 30, 8)));

      // Then
      final edited = (await repository.all()).single;
      expect(edited.title, 'Tax return');
      expect(edited.dueDate, DateTime(2026, 11, 30));
    });

    test('Given a point that is done, '
        'when taking it back up, '
        'then it is to do again', () async {
      // Given
      final point = await at(() => service().add(title: 'Taxes', dueDate: nextWeek));
      await at(() => service().achieve(point!.id));

      // When
      await at(() => service().undoAchieve(point!.id));

      // Then
      expect((await repository.all()).single.isActive, isTrue);
    });

    test('Given a focus point, '
        'when dropping it, '
        'then it is gone for good', () async {
      // Given
      final point = await at(() => service().add(title: 'Taxes', dueDate: nextWeek));

      // When
      await at(() => service().remove(point!.id));

      // Then
      expect(await repository.all(), isEmpty);
    });

    test('Given three points in their order, '
        'when reordering them, '
        'then they come back in the new order', () async {
      // Given
      for (final title in ['One', 'Two', 'Three']) {
        await at(() => service().add(title: title, dueDate: nextWeek));
      }
      final ids = [for (final point in await repository.all()) point.id];

      // When
      await at(() => service().reorder([ids[2], ids[0], ids[1]]));

      // Then
      expect([for (final point in await repository.all()) point.title], ['Three', 'One', 'Two']);
    });
  });

  group('Active and achieved focus points', () {
    FocusPoint buildPoint(String id, {DateTime? achievedAt}) {
      return FocusPoint(
        id: id,
        title: id,
        dueDate: DateTime(2026, 11, 4),
        createdAt: DateTime(2026, 10, 1),
        achievedAt: achievedAt,
      );
    }

    test('Given one point to do and two that are done, '
        'when reading them, '
        'then only the open one is active and the others are in the archive, the newest first', () async {
      // Given
      final points = [
        buildPoint('Open'),
        buildPoint('Early', achievedAt: DateTime(2026, 10, 20)),
        buildPoint('Late', achievedAt: DateTime(2026, 10, 25)),
      ];
      final container = createTestContainer(
        overrides: [focusServiceProvider.overrideWith(() => _FixedFocusService(points))],
      );
      container.listen(focusServiceProvider, (_, _) {});
      await container.read(focusServiceProvider.future);

      // When
      final active = container.read(activeFocusPointsProvider);
      final achieved = container.read(achievedFocusPointsProvider);

      // Then
      expect([for (final point in active) point.title], ['Open']);
      expect([for (final point in achieved) point.title], ['Late', 'Early']);
    });
  });
}

/// A service with a fixed set of points, for the providers derived from it.
class _FixedFocusService extends FocusService {
  _FixedFocusService(this.points);

  final List<FocusPoint> points;

  @override
  Stream<List<FocusPoint>> build() => Stream.value(points);
}
