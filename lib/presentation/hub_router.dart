import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/presentation/design_system/layouts/hub_shell.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.screen.dart';
import 'package:smart_hub/presentation/screens/lights/lights.screen.dart';
import 'package:smart_hub/presentation/screens/music/music.screen.dart';
import 'package:smart_hub/presentation/screens/plants/plants.screen.dart';

GoRouter createHubRouter({String? initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation ?? HubRoute.plan.path,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          final route = HubRoute.values[shell.currentIndex];
          return HubShell(
            title: route.title,
            tabLabels: [for (final r in HubRoute.values) r.tabLabel],
            selectedTab: shell.currentIndex,
            onTabSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
            child: shell,
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
    HubRoute.plan => const FloorplanScreen(),
    HubRoute.lights => const LightsScreen(),
    HubRoute.plants => const PlantsScreen(),
    HubRoute.music => const MusicScreen(),
  };
}
