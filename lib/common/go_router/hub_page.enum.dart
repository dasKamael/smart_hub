/// Full screen pages outside of the tab shell.
enum HubPage {
  setup(path: '/setup'),
  settings(path: '/settings'),
  speakers(path: '/settings/speakers'),

  /// Profile of one plant: `/plants/<id>`.
  plantProfile(path: '/plants/:id'),
  weather(path: '/weather');

  const HubPage({required this.path});

  final String path;
}
