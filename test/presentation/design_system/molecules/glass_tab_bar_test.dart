import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/design_system/molecules/glass_tab_bar.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

import '../../../utils/widget.test_util.dart';

void main() {
  group('GlassTabBar', () {
    const labels = ['Plan', 'Lights', 'Plants'];

    Color labelColor(WidgetTester tester, String label) {
      final text = tester.widget<DefaultTextStyle>(
        find.ancestor(of: find.text(label), matching: find.byType(DefaultTextStyle)).first,
      );
      return text.style.color!;
    }

    testWidgets('Given the second tab is selected, '
        'when rendering, '
        'then its label is primary text and the others are secondary', (tester) async {
      // When
      await loadWidgetTestApp(
        tester: tester,
        underTestWidget: Center(
          child: GlassTabBar(labels: labels, selectedIndex: 1, onSelected: (_) {}),
        ),
      );

      // Then
      expect(labelColor(tester, 'Lights'), HubColorPalette.text);
      expect(labelColor(tester, 'Plan'), HubColorPalette.text2);
      expect(labelColor(tester, 'Plants'), HubColorPalette.text2);
    });

    testWidgets('Given a tab bar, '
        'when tapping a tab, '
        'then onSelected reports its index', (tester) async {
      // Given
      int? selected;
      await loadWidgetTestApp(
        tester: tester,
        underTestWidget: Center(
          child: GlassTabBar(labels: labels, selectedIndex: 0, onSelected: (index) => selected = index),
        ),
      );

      // When
      await tester.tap(find.text('Plants'));

      // Then
      expect(selected, 2);
    });

    testWidgets('Given a tab bar, '
        'when rendering, '
        'then every tab has at least the minimum touch target size', (tester) async {
      // When
      await loadWidgetTestApp(
        tester: tester,
        underTestWidget: Center(
          child: GlassTabBar(labels: labels, selectedIndex: 0, onSelected: (_) {}),
        ),
      );

      // Then
      for (final label in labels) {
        final size = tester.getSize(find.ancestor(of: find.text(label), matching: find.byType(SizedBox)).first);
        expect(size.height, greaterThanOrEqualTo(44));
        expect(size.width, greaterThanOrEqualTo(44));
      }
    });
  });
}
