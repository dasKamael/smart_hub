import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/device/kiosk.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';

part 'settings.controller.g.dart';

/// Whether the hub is the home screen of the tablet (kiosk).
@riverpod
class HomeAppController extends _$HomeAppController {
  static final _log = Logger('HomeAppController');

  @override
  Future<bool> build() async {
    try {
      return await ref.watch(kioskProvider).isHomeApp();
    } on Object catch (e) {
      _log.warning('Home app state not available: $e');
      return false;
    }
  }

  Future<void> setHomeApp({required bool enabled}) async {
    state = AsyncData(enabled);
    try {
      await ref.read(kioskProvider).setHomeApp(enabled: enabled);
    } on Object catch (e) {
      _log.warning('Could not change the home app: $e');
      if (ref.mounted) state = AsyncData(!enabled);
    }
  }
}

/// Connecting and disconnecting Spotify; [build] holds the last sign-in error.
@riverpod
class SpotifyConnectController extends _$SpotifyConnectController {
  static final _log = Logger('SpotifyConnectController');

  @override
  ({bool busy, String? error}) build() => (busy: false, error: null);

  Future<void> connect() async {
    if (state.busy) return;
    state = (busy: true, error: null);
    try {
      await ref.read(spotifyAccountServiceProvider.notifier).signIn();
      if (ref.mounted) state = (busy: false, error: null);
    } on Object catch (e) {
      _log.warning('Spotify sign-in failed: $e');
      if (ref.mounted) state = (busy: false, error: 'Spotify sign-in did not work. Please try again.');
    }
  }

  Future<void> disconnect() => ref.read(spotifyAccountServiceProvider.notifier).signOut();
}
