import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_theme.dart';

import 'riverpod.test_util.dart';

export 'riverpod.test_util.dart' show createTestContainer;

/// Logical size of the target tablet in landscape (~11", 1920×1200 px at 1.5x).
const kTabletSize = Size(1280, 800);

/// Sets the test surface to the tablet size and resets it at the end of the test.
void useTabletSurface(WidgetTester tester, {Size size = kTabletSize}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps [underTestWidget] inside the hub theme and a provider scope on a tablet sized surface and returns
/// a [BuildContext] below the theme.
///
/// With [pumpAndSettle] `false` only a single frame is pumped, e.g. to inspect loading states.
Future<BuildContext> loadWidgetTestApp({
  required WidgetTester tester,
  required Widget underTestWidget,
  ProviderContainer? container,
  bool pumpAndSettle = true,
}) async {
  useTabletSurface(tester);
  late BuildContext context;
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container ?? createTestContainer(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: HubTheme.dark,
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return underTestWidget;
            },
          ),
        ),
      ),
    ),
  );
  if (pumpAndSettle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  return context;
}
