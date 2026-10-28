import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.util.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

void main() {
  group('DashboardLayoutUtil', () {
    DashboardWidget widget(String id, DashboardWidgetSize size, {GridCell? at}) =>
        DashboardWidget(id: id, kind: DashboardWidgetKind.weather, size: size, cell: at);

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

    test('Given a widget put in the bottom right, when placing, then it stays there and leaves the gap before it', () {
      // When
      final cells = DashboardLayoutUtil.place([
        widget('m', DashboardWidgetSize.medium, at: (column: 4, row: 2)),
        widget('s', DashboardWidgetSize.small),
      ]);

      // Then
      expect(cells, {'m': (column: 4, row: 2), 's': (column: 0, row: 0)});
    });

    test('Given two widgets put on the same cell, when placing, then the first keeps it and the second moves on', () {
      // When
      final cells = DashboardLayoutUtil.place([
        widget('a', DashboardWidgetSize.small, at: (column: 0, row: 0)),
        widget('b', DashboardWidgetSize.small, at: (column: 0, row: 0)),
      ]);

      // Then
      expect(cells, {'a': (column: 0, row: 0), 'b': (column: 1, row: 0)});
    });

    test('Given widgets without a place, when pinning them, then each keeps the cell it is shown in', () {
      // When
      final pinned = DashboardLayoutUtil.pinned([
        widget('xl', DashboardWidgetSize.extraLarge),
        widget('m', DashboardWidgetSize.medium),
      ]);

      // Then
      expect([for (final widget in pinned) widget.cell], [(column: 0, row: 0), (column: 4, row: 0)]);
    });

    test('Given a small widget, when moving it into an empty corner, then only it moves', () {
      // Given
      final widgets = [
        widget('m', DashboardWidgetSize.medium, at: (column: 0, row: 0)),
        widget('s', DashboardWidgetSize.small, at: (column: 2, row: 0)),
      ];

      // When
      final moved = DashboardLayoutUtil.move(widgets, 's', (column: 5, row: 2));

      // Then
      expect(DashboardLayoutUtil.place(moved!), {'m': (column: 0, row: 0), 's': (column: 5, row: 2)});
    });

    test('Given two medium widgets, when moving one onto the other, then they swap places', () {
      // Given
      final widgets = [
        widget('a', DashboardWidgetSize.medium, at: (column: 0, row: 0)),
        widget('b', DashboardWidgetSize.medium, at: (column: 4, row: 2)),
      ];

      // When
      final moved = DashboardLayoutUtil.move(widgets, 'a', (column: 4, row: 2));

      // Then
      expect(DashboardLayoutUtil.place(moved!), {'a': (column: 4, row: 2), 'b': (column: 0, row: 0)});
    });

    test(
      'Given a large widget moved over two small ones, when they cannot swap, then they take the nearest free spots',
      () {
        // Given
        final widgets = [
          widget('l', DashboardWidgetSize.large, at: (column: 0, row: 0)),
          widget('s1', DashboardWidgetSize.small, at: (column: 4, row: 0)),
          widget('s2', DashboardWidgetSize.small, at: (column: 5, row: 0)),
        ];

        // When
        final moved = DashboardLayoutUtil.move(widgets, 'l', (column: 4, row: 0));

        // Then
        expect(DashboardLayoutUtil.place(moved!), {
          'l': (column: 4, row: 0),
          's1': (column: 3, row: 0),
          's2': (column: 5, row: 2),
        });
      },
    );

    test('Given a full page, when moving a widget where the others have no room, then the move is refused', () {
      // Given
      final widgets = [
        widget('xl', DashboardWidgetSize.extraLarge, at: (column: 0, row: 0)),
        widget('l', DashboardWidgetSize.large, at: (column: 4, row: 0)),
        widget('m', DashboardWidgetSize.medium, at: (column: 0, row: 2)),
        widget('m2', DashboardWidgetSize.medium, at: (column: 2, row: 2)),
        widget('m3', DashboardWidgetSize.medium, at: (column: 4, row: 2)),
      ];

      // When / Then
      expect(DashboardLayoutUtil.move(widgets, 'l', (column: 2, row: 0)), isNull);
      expect(DashboardLayoutUtil.move(widgets, 'm', (column: 5, row: 2)), isNull, reason: 'off the page');
    });

    test('Given a widget next to another, when it grows into it, then it no longer fits in place', () {
      // Given
      final widgets = [
        widget('a', DashboardWidgetSize.medium, at: (column: 0, row: 0)),
        widget('b', DashboardWidgetSize.medium, at: (column: 2, row: 0)),
      ];

      // When
      final grown = [widgets.first.copyWith(size: DashboardWidgetSize.extraLarge), widgets.last];

      // Then
      expect(DashboardLayoutUtil.fitsInPlace(widgets), isTrue);
      expect(DashboardLayoutUtil.fitsInPlace(grown), isFalse);
    });
  });
}
