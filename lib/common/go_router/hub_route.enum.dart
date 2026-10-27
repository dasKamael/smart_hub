/// Top level sections of the hub, one tab each.
enum HubRoute {
  home(path: '/home', tabLabel: 'Home'),
  plan(path: '/plan', tabLabel: 'Plan'),
  lights(path: '/lights', tabLabel: 'Lights'),
  plants(path: '/plants', tabLabel: 'Plants'),
  music(path: '/music', tabLabel: 'Music');

  const HubRoute({required this.path, required this.tabLabel});

  final String path;
  final String tabLabel;
}
