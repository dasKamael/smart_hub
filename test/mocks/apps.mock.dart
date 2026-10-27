import 'dart:convert';

import 'package:smart_hub/domain/apps/installed_apps.service.dart';
import 'package:smart_hub/domain/apps/model/installed_app.dart';

/// A 1 × 1 px PNG as app icon.
final testIcon = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

InstalledApp testApp(String packageName, String label, {bool isVideo = false}) =>
    InstalledApp(packageName: packageName, label: label, isVideo: isVideo, icon: testIcon);

/// [InstalledAppsService] with fixed [apps] that records which app was opened.
class FakeInstalledAppsService extends InstalledAppsService {
  FakeInstalledAppsService(this.apps);

  final List<InstalledApp> apps;
  final launched = <String>[];

  @override
  Future<List<InstalledApp>> build() async => apps;

  @override
  Future<void> launch(String packageName) async => launched.add(packageName);
}
