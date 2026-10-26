/// Top level sections of the hub, one tab each.
enum HubRoute {
  plan(path: '/plan', title: 'Floor plan', tabLabel: 'Plan'),
  lights(path: '/lights', title: 'Lights', tabLabel: 'Lights'),
  plants(path: '/plants', title: 'Plants', tabLabel: 'Plants'),
  music(path: '/music', title: 'Music', tabLabel: 'Music');

  const HubRoute({required this.path, required this.title, required this.tabLabel});

  final String path;
  final String title;
  final String tabLabel;
}
