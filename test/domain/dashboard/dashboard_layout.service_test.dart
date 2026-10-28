import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/dashboard/dashboard_layout.repository.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.service.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

import '../../utils/riverpod.test_util.dart';

void main() {
  group('DashboardLayoutService', () {
    late AppDatabase database;
    late ProviderContainer container;

    ProviderContainer createContainer() {
      final container = createTestContainer(
        overrides: [dashboardLayoutRepositoryProvider.overrideWithValue(DashboardLayoutRepository(database: database))],
      );
      container.listen(dashboardLayoutServiceProvider, (_, _) {});
      return container;
    }

    DashboardLayoutService service() => container.read(dashboardLayoutServiceProvider.notifier);

    List<String> layoutOf(ProviderContainer container) => [
      for (final widget in container.read(dashboardLayoutServiceProvider).value ?? const <DashboardWidget>[])
        '${widget.id} ${widget.size.name}',
    ];

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      container = createContainer();
      await container.read(dashboardLayoutServiceProvider.future);
    });

    test('Given a new hub, when reading the dashboard, then it has the default widgets', () {
      expect(layoutOf(container), ['weather-1 extraLarge', 'home-1 medium', 'weather-2 medium']);
    });

    test(
      'Given the default widgets, when removing all quickly, then the dashboard stays empty after a restart',
      () async {
        // When
        await Future.wait([service().remove('weather-1'), service().remove('home-1'), service().remove('weather-2')]);
        final restarted = createContainer();
        await restarted.read(dashboardLayoutServiceProvider.future);

        // Then
        expect(layoutOf(container), isEmpty);
        expect(layoutOf(restarted), isEmpty);
      },
    );

    test('Given two cells left in the last row, when asking what fits, then small and medium are offered', () async {
      // Given: the default fills rows 1–2; two medium widgets take 4 of the 6 cells of row 3.
      await service().add(DashboardWidgetKind.weather, DashboardWidgetSize.medium);
      await service().add(DashboardWidgetKind.weather, DashboardWidgetSize.medium);

      // When
      final sizes = service().sizesThatFit(DashboardWidgetKind.weather);

      // Then
      expect(sizes, [DashboardWidgetSize.small, DashboardWidgetSize.medium]);
    });

    test('Given no room for it, when making a widget extra large, then nothing changes', () async {
      // When
      final resized = await service().resize('home-1', DashboardWidgetSize.extraLarge);

      // Then
      expect(resized, isFalse);
      expect(layoutOf(container)[1], 'home-1 medium');
    });

    test(
      'Given the default widgets, when moving one into the empty bottom right, then it stays there after a restart',
      () async {
        // When
        final moved = await service().move('weather-2', (column: 4, row: 2));
        final restarted = createContainer();
        final widgets = await restarted.read(dashboardLayoutServiceProvider.future);

        // Then
        expect(moved, isTrue);
        expect(
          {for (final widget in widgets) widget.id: widget.cell},
          {'weather-1': (column: 0, row: 0), 'home-1': (column: 4, row: 0), 'weather-2': (column: 4, row: 2)},
        );
      },
    );

    test('Given a gap left by a removed widget, when adding nothing, then the others stay where they are', () async {
      // When
      await service().remove('home-1');

      // Then
      expect(
        {for (final widget in container.read(dashboardLayoutServiceProvider).value!) widget.id: widget.cell},
        {'weather-1': (column: 0, row: 0), 'weather-2': (column: 4, row: 1)},
      );
    });

    test('Given a lights widget, when choosing two rooms without a card, then that is kept after a restart', () async {
      // Given
      await service().remove('weather-2');
      await service().add(DashboardWidgetKind.lights, DashboardWidgetSize.medium);
      final id = container.read(dashboardLayoutServiceProvider).value!.last.id;

      // When
      await service().edit(id, selection: ['kitchen', 'office'], card: false);
      final restarted = createContainer();
      final widgets = await restarted.read(dashboardLayoutServiceProvider.future);

      // Then
      expect(widgets.last.selection, ['kitchen', 'office']);
      expect((widgets.last.showsCard, widgets.first.selection.isEmpty, widgets.first.showsCard), (false, true, true));
    });
  });
}
