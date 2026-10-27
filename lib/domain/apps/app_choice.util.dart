import 'package:smart_hub/domain/apps/model/installed_app.dart';

abstract final class AppChoiceUtil {
  /// The apps [chosen] by package name, in that order and skipping removed ones; without a choice the video apps.
  static List<InstalledApp> shown(List<InstalledApp> apps, List<String> chosen) {
    if (chosen.isEmpty) {
      return [
        for (final app in apps)
          if (app.isVideo) app,
      ];
    }
    final byPackage = {for (final app in apps) app.packageName: app};
    return [for (final packageName in chosen) ?byPackage[packageName]];
  }
}
