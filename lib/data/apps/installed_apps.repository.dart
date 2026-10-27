import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/apps/model/installed_app.dart';

part 'installed_apps.repository.g.dart';

/// The apps on the tablet, read from Android (`MainActivity.kt`, channel `smart_hub/apps`).
class InstalledAppsRepository {
  InstalledAppsRepository({MethodChannel? channel}) : _channel = channel ?? const MethodChannel(channelName);

  static const channelName = 'smart_hub/apps';

  /// Streaming apps that do not declare themselves as video apps to Android.
  static const _videoPackages = {
    'com.netflix.mediaclient',
    'com.amazon.avod.thirdpartyclient',
    'com.disney.disneyplus',
    'com.google.android.youtube',
    'com.google.android.videos',
    'com.apple.atve.androidtv.appletv',
    'com.wbd.stream',
    'de.swr.avp.ard',
    'com.zdf.android.mediathek',
    'de.rtl.tvnow',
    'de.prosiebensat1digital.seventv',
    'com.dazn',
    'de.sky.online',
    'com.plexapp.android',
    'org.jellyfin.mobile',
    'com.crunchyroll.crunchyroid',
    'tv.twitch.android.app',
  };

  final MethodChannel _channel;

  /// Every app with a launcher entry, by name.
  Future<List<InstalledApp>> load() async {
    final raw = await _channel.invokeListMethod<Map<Object?, Object?>>('installedApps') ?? const [];
    return [
      for (final app in raw)
        if ((app['package'], app['label'], app['icon']) case (
          final String package,
          final String label,
          final Uint8List icon,
        ))
          InstalledApp(
            packageName: package,
            label: label,
            isVideo: app['isVideo'] == true || _videoPackages.contains(package),
            icon: icon,
          ),
    ]..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
  }

  /// Opens [packageName]; `false` when it cannot be opened (e.g. uninstalled meanwhile).
  Future<bool> launch(String packageName) async {
    return await _channel.invokeMethod<bool>('launch', {'package': packageName}) ?? false;
  }
}

/// Providers
@riverpod
InstalledAppsRepository installedAppsRepository(Ref ref) => InstalledAppsRepository();
