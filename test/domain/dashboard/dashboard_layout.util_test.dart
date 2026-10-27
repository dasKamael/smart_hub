import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.util.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

void main() {
  group('DashboardLayoutUtil', () {
    DashboardWidget widget(String id, DashboardWidgetSize size) =>
        DashboardWidget(id: id, kind: DashboardWidgetKind.weather, size: size);

    test('Given an extra large and two medium widgets, when placing them, then the medium ones stack beside it', () {
      // When
      final cells = DashboardLayoutUtil.place([
        widget('xl', DashboardWidgetSize.extraLarge),
        widget('m1', DashboardWidgetSize.medium),
        widget('m2', DashboardWidgetSize.medium),
      ]);

      // Then
      expect(cells, {'xl': (column: 0, row: 0), 'm1': (column: 4, row: 0), 'm2': (column: 4, row: 1)});
    });

    test(
      'Given a small widget after a large one, when placing them, then it fills the first gap from the top left',
      () {
        // When
        final cells = DashboardLayoutUtil.place([
          widget('m', DashboardWidgetSize.medium),
          widget('l', DashboardWidgetSize.large),
          widget('m2', DashboardWidgetSize.medium),
          widget('s', DashboardWidgetSize.small),
        ]);

        // Then
        expect(cells, {
          'm': (column: 0, row: 0),
          'l': (column: 2, row: 0),
          'm2': (column: 4, row: 0),
          's': (column: 0, row: 1),
        });
      },
    );

    test('Given a full page, when adding one more, then it does not fit and is left out', () {
      // Given
      final full = [
        widget('a', DashboardWidgetSize.extraLarge),
        widget('b', DashboardWidgetSize.large),
        widget('c', DashboardWidgetSize.medium),
        widget('d', DashboardWidgetSize.medium),
        widget('e', DashboardWidgetSize.medium),
      ];

      // When
      final withOneMore = [...full, widget('f', DashboardWidgetSize.small)];

      // Then
      expect(DashboardLayoutUtil.fits(full), isTrue);
      expect(DashboardLayoutUtil.fits(withOneMore), isFalse);
      expect(DashboardLayoutUtil.place(withOneMore).keys, ['a', 'b', 'c', 'd', 'e']);
    });

    test('Given two extra large widgets, when placing them, then the second does not fit below the first', () {
      expect(
        DashboardLayoutUtil.fits([
          widget('a', DashboardWidgetSize.extraLarge),
          widget('b', DashboardWidgetSize.extraLarge),
        ]),
        isFalse,
        reason: '3 rows only',
      );
    });
  });
}
