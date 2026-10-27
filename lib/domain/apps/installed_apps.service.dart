import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/apps/installed_apps.repository.dart';
import 'package:smart_hub/domain/apps/model/installed_app.dart';

part 'installed_apps.service.g.dart';

/// The apps on the tablet, loaded while something shows them, and opening one.
@riverpod
class InstalledAppsService extends _$InstalledAppsService {
  @override
  Future<List<InstalledApp>> build() => ref.watch(installedAppsRepositoryProvider).load();

  /// Opens [packageName]; when that fails the app is gone, so the list is read again.
  Future<void> launch(String packageName) async {
    if (!await ref.read(installedAppsRepositoryProvider).launch(packageName)) {
      ref.invalidateSelf();
    }
  }
}
