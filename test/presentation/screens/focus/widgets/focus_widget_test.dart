import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/focus/focus.repository.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/focus/widgets/focus_widget.dart';

import '../../../../utils/widget.test_util.dart';

void main() {
  group('FocusWidget', () {
    final today = DateTime(2026, 10, 28, 10);
    late FocusRepository repository;
    late ProviderContainer container;

    FocusPoint buildPoint(String id, String title, {required DateTime dueDate, int position = 0, DateTime? createdAt}) {
      return FocusPoint(
        id: id,
        title: title,
        dueDate: dueDate,
        createdAt: createdAt ?? DateTime(2026, 10, 18),
        position: position,
      );
    }

    setUp(() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      repository = FocusRepository(database: database);
      container = createTestContainer(
        overrides: [
          focusRepositoryProvider.overrideWithValue(repository),
          currentDayProvider.overrideWith((ref) => Stream.value(DateTime(2026, 10, 28))),
        ],
      );
    });

    Future<void> pumpWidgetWith(
      WidgetTester tester,
      List<FocusPoint> points, {
      WidgetSize size = WidgetSize.large,
    }) async {
      for (final point in points) {
        await repository.save(point);
      }
      await withClock(
        Clock.fixed(today),
        () => loadWidgetTestApp(
          tester: tester,
          container: container,
          underTestWidget: FocusWidget(size: size),
        ),
      );
    }

    testWidgets('Given three focus points, '
        'when showing the large widget, '
        'then each one stands there with its countdown', (tester) async {
      // Given / When
      await pumpWidgetWith(tester, [
        buildPoint('f1', 'Hub on the wall', dueDate: DateTime(2026, 11, 6)),
        buildPoint('f2', 'Taxes', dueDate: DateTime(2026, 10, 30), position: 1),
        buildPoint('f3', 'Bike service', dueDate: DateTime(2026, 10, 28), position: 2),
      ]);

      // Then
      expect(find.text('Hub on the wall'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('Taxes'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('Given points due later and today, '
        'when showing them, '
        'then the one due first stands on top', (tester) async {
      // Given / When
      await pumpWidgetWith(tester, [
        buildPoint('f1', 'Hub on the wall', dueDate: DateTime(2026, 11, 6)),
        buildPoint('f2', 'Taxes', dueDate: DateTime(2026, 10, 29), position: 1),
      ], size: WidgetSize.small);

      // Then: the small widget shows only the one that is due first
      expect(find.text('Taxes'), findsOneWidget);
      expect(find.text('Hub on the wall'), findsNothing);
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('Given a point whose day has passed, '
        'when showing it, '
        'then it says how many days it is over', (tester) async {
      // Given / When
      await pumpWidgetWith(tester, [buildPoint('f1', 'Taxes', dueDate: DateTime(2026, 10, 25))]);

      // Then
      expect(find.text('3'), findsOneWidget);
      expect(find.text('days over'), findsOneWidget);
    });

    testWidgets('Given a focus point, '
        'when tapping it, '
        'then done, edit and drop lie over it', (tester) async {
      // Given
      await pumpWidgetWith(tester, [buildPoint('f1', 'Hub on the wall', dueDate: DateTime(2026, 11, 6))]);

      // When
      await tester.tap(find.text('Hub on the wall'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Drop'), findsOneWidget);
      expect(find.text('Hub on the wall'), findsNothing);
    });

    testWidgets('Given the options of a point, '
        'when tapping "Done", '
        'then it is marked as done and gone from the widget', (tester) async {
      // Given
      await pumpWidgetWith(tester, [buildPoint('f1', 'Hub on the wall', dueDate: DateTime(2026, 11, 6))]);
      await tester.tap(find.text('Hub on the wall'));
      await tester.pumpAndSettle();

      // When
      await withClock(Clock.fixed(today), () async {
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
      });

      // Then
      expect((await repository.all()).single.achievedAt, today);
      expect(find.text('Hub on the wall'), findsNothing);
      expect(find.text('What are you on?'), findsOneWidget);
    });

    testWidgets('Given the options of a point, '
        'when tapping "Drop", '
        'then it is gone for good', (tester) async {
      // Given
      await pumpWidgetWith(tester, [buildPoint('f1', 'Hub on the wall', dueDate: DateTime(2026, 11, 6))]);
      await tester.tap(find.text('Hub on the wall'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.text('Drop'));
      await tester.pumpAndSettle();

      // Then
      expect(await repository.all(), isEmpty);
    });

    testWidgets('Given the options of a point, '
        'when tapping it again, '
        'then they are put away', (tester) async {
      // Given
      await pumpWidgetWith(tester, [buildPoint('f1', 'Hub on the wall', dueDate: DateTime(2026, 11, 6))]);
      await tester.tap(find.text('Hub on the wall'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.text('Edit').hitTestable().first, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FocusWidget), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Then: the editor opened and nothing was lost
      expect(await repository.all(), hasLength(1));
    });

    testWidgets('Given no focus point yet, '
        'when showing the widget, '
        'then it asks what you are on', (tester) async {
      // Given / When
      await pumpWidgetWith(tester, []);

      // Then
      expect(find.text('What are you on?'), findsOneWidget);
      expect(find.text('A name and a day. Up to three.'), findsOneWidget);
    });

    testWidgets('Given three focus points, '
        'when showing every size, '
        'then each one lays out without overflowing', (tester) async {
      for (final size in WidgetSize.values) {
        // Given / When
        await pumpWidgetWith(tester, [
          buildPoint('f1', 'Hub on the wall', dueDate: DateTime(2026, 11, 6)),
          buildPoint('f2', 'Taxes', dueDate: DateTime(2026, 10, 28), position: 1),
          buildPoint('f3', 'Bike service for the long ride', dueDate: DateTime(2026, 10, 25), position: 2),
        ], size: size);

        // Then
        expect(tester.takeException(), isNull, reason: 'size ${size.name}');
        await repository.delete('f1');
        await repository.delete('f2');
        await repository.delete('f3');
      }
    });
  });
}
