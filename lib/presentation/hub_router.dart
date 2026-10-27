import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/go_router/hub_page.enum.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/layouts/hub_shell.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.screen.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.screen.dart';
import 'package:smart_hub/presentation/screens/lights/lights.controller.dart';
import 'package:smart_hub/presentation/screens/lights/lights.screen.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';
import 'package:smart_hub/presentation/screens/music/music.screen.dart';
import 'package:smart_hub/presentation/screens/plants/plant_profile.screen.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';
import 'package:smart_hub/presentation/screens/plants/plants.screen.dart';
import 'package:smart_hub/presentation/screens/settings/settings.screen.dart';
import 'package:smart_hub/presentation/screens/settings/speakers.screen.dart';
import 'package:smart_hub/presentation/screens/setup/setup.screen.dart';
import 'package:smart_hub/presentation/screens/weather/weather.screen.dart';
import 'package:smart_hub/presentation/screens/zen/widgets/zen_button.dart';
import 'package:smart_hub/presentation/shared_widgets/connection_indicator.dart';

part 'hub_router.g.dart';

/// App router. Shows the setup screen until a connection is configured.
@Riverpod(keepAlive: true)
GoRouter hubRouter(Ref ref) {
  final configChanged = ValueNotifier(0);
  ref.listen(connectionConfigServiceProvider, (_, _) => configChanged.value++);
  final router = createHubRouter(
    refreshListenable: configChanged,
    isConfigured: () => ref.read(connectionConfigServiceProvider).value != null,
    isStandalone: () => ref.read(connectionConfigServiceProvider).value is StandaloneConnectionConfig,
  );
  ref.onDispose(() {
    router.dispose();
    configChanged.dispose();
  });
  return router;
}

GoRouter createHubRouter({
  required bool Function() isConfigured,
  bool Function()? isStandalone,
  Listenable? refreshListenable,
}) {
  return GoRouter(
    initialLocation: HubRoute.home.path,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final atSetup = state.matchedLocation == HubPage.setup.path;
      if (!isConfigured()) return atSetup ? null : HubPage.setup.path;
      // Without Home Assistant the setup stays reachable, to connect one later.
      return atSetup && !(isStandalone?.call() ?? false) ? HubRoute.home.path : null;
    },
    routes: [
      GoRoute(path: HubPage.setup.path, builder: (context, state) => const SetupScreen()),
      GoRoute(path: HubPage.settings.path, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: HubPage.speakers.path, builder: (context, state) => const SpeakersScreen()),
      GoRoute(path: HubPage.weather.path, builder: (context, state) => const WeatherScreen()),
      GoRoute(
        path: HubPage.plantProfile.path,
        builder: (context, state) => PlantProfileScreen(plantId: state.pathParameters['id'] ?? ''),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          final route = HubRoute.values[shell.currentIndex];
          return Consumer(
            builder: (context, ref, _) => HubShell(
              // Only the shown page's color is watched, so e.g. Spotify is not polled for it elsewhere.
              tint: switch (route) {
                HubRoute.plants => ref.watch(plantsTintProvider),
                HubRoute.lights => ref.watch(lightsTintProvider),
                HubRoute.music => ref.watch(musicTintProvider(visible: true)),
                HubRoute.home || HubRoute.plan => null,
              },
              // The music page is all in the cover's color.
              tintsSky: route == HubRoute.music,
              tabLabels: [for (final r in HubRoute.values) r.tabLabel],
              selectedTab: shell.currentIndex,
              onTabSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: HubSpacing.s12,
                children: [
                  const ConnectionIndicator(),
                  const ZenButton(),
                  HubIconButton(
                    glyph: HubGlyph.gear,
                    semanticLabel: 'Settings',
                    onPressed: () => context.push(HubPage.settings.path),
                  ),
                ],
              ),
              child: shell,
            ),
          );
        },
        branches: [
          for (final route in HubRoute.values)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: route.path,
                  pageBuilder: (context, state) => NoTransitionPage(child: _screenFor(route)),
                ),
              ],
            ),
        ],
      ),
    ],
  );
}

Widget _screenFor(HubRoute route) {
  return switch (route) {
    HubRoute.home => const DashboardScreen(),
    HubRoute.plan => const FloorplanScreen(),
    HubRoute.lights => const LightsScreen(),
    HubRoute.plants => const PlantsScreen(),
    HubRoute.music => const MusicScreen(),
  };
}
