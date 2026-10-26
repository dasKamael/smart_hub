import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/hub_app.dart';
import 'package:smart_hub/presentation/hub_router.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.screen.dart';
import 'package:smart_hub/presentation/screens/music/music.screen.dart';

import '../utils/widget.test_util.dart';

void main() {
  group('Hub router', () {
    Future<void> pumpApp(WidgetTester tester) async {
      useTabletSurface(tester);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: createTestContainer(),
          child: HubApp(router: createHubRouter()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Given the app starts, '
        'when no location is given, '
        'then the floor plan is shown with its page title', (tester) async {
      // When
      await pumpApp(tester);

      // Then
      expect(find.byType(FloorplanScreen), findsOneWidget);
      expect(find.text('Floor plan'), findsWidgets);
    });

    testWidgets('Given the floor plan is shown, '
        'when tapping the Music tab, '
        'then the music page and title are shown', (tester) async {
      // Given
      await pumpApp(tester);

      // When
      await tester.tap(find.text('Music').first);
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(MusicScreen), findsOneWidget);
      expect(find.widgetWithText(Row, 'Music'), findsWidgets);
    });
  });
}
