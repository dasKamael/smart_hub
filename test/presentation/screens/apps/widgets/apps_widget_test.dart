import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/apps/installed_apps.service.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/apps/widgets/apps_widget.dart';

import '../../../../mocks/apps.mock.dart';
import '../../../../utils/widget.test_util.dart';

void main() {
  group('AppsWidget', () {
    late FakeInstalledAppsService apps;

    Future<void> load(WidgetTester tester, WidgetSize size, {List<String> packageNames = const []}) async {
      apps = FakeInstalledAppsService([
        testApp('app.films', 'Films', isVideo: true),
        testApp('app.mail', 'Mail'),
        testApp('app.series', 'Series', isVideo: true),
      ]);
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(overrides: [installedAppsServiceProvider.overrideWith(() => apps)]),
        underTestWidget: Center(
          child: AppsWidget(size: size, packageNames: packageNames),
        ),
      );
    }

    testWidgets('Given nothing chosen, when tapping an app, then the video apps show and it opens', (tester) async {
      // Given
      await load(tester, WidgetSize.medium);
      final shown = (find.text('Films').evaluate().length, find.text('Mail').evaluate().length);

      // When
      await tester.tap(find.text('Series'));
      await tester.pump();

      // Then
      expect(shown, (1, 0));
      expect(apps.launched, ['app.series']);
    });

    testWidgets('Given mail chosen, when shown small, then only its icon shows', (tester) async {
      // Given / When
      await load(tester, WidgetSize.small, packageNames: const ['app.mail']);

      // Then
      expect(find.bySemanticsLabel('Mail'), findsOneWidget);
      expect(find.bySemanticsLabel('Films'), findsNothing);
      expect(find.text('Mail'), findsNothing);
    });

    testWidgets('Given only removed apps chosen, when shown, then it explains how to pick apps', (tester) async {
      // Given / When
      await load(tester, WidgetSize.large, packageNames: const ['app.gone']);

      // Then
      expect(find.text('Hold, then tap here to pick apps'), findsOneWidget);
    });
  });
}
