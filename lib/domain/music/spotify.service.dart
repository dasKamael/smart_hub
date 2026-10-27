import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/config/spotify_config.dart';
import 'package:smart_hub/data/music/spotify/spotify.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify_auth.repository.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';

part 'spotify.service.g.dart';

/// The Spotify account used as content source (playlists, recently played).
@Riverpod(keepAlive: true)
class SpotifyAccountService extends _$SpotifyAccountService {
  static final _log = Logger('SpotifyAccountService');

  @override
  Future<SpotifyAccount> build() async {
    if (!ref.watch(spotifyConfigProvider).isConfigured) return const SpotifyAccount.notConfigured();
    if (await ref.watch(spotifyAuthRepositoryProvider).loadTokens() == null) return const SpotifyAccount.signedOut();
    try {
      return SpotifyAccount.signedIn(displayName: await ref.watch(spotifyRepositoryProvider).displayName());
    } on SpotifySignedOutException {
      return const SpotifyAccount.signedOut();
    } on Object catch (e) {
      // Offline: keep the account, the name comes back with the connection.
      _log.warning('Could not load the Spotify profile: $e');
      return const SpotifyAccount.signedIn(displayName: 'Spotify');
    }
  }

  /// Opens the Spotify login. Throws [SpotifyAuthException] when it fails.
  Future<void> signIn() async {
    await ref.read(spotifyAuthRepositoryProvider).signIn();
    ref.read(spotifyRepositoryProvider).reset();
    ref.invalidateSelf();
    await future;
  }

  Future<void> signOut() async {
    await ref.read(spotifyAuthRepositoryProvider).signOut();
    ref.read(spotifyRepositoryProvider).reset();
    state = const AsyncData(SpotifyAccount.signedOut());
  }
}

/// Recently played albums; empty while signed out.
@riverpod
Future<List<MediaItem>> spotifyRecent(Ref ref) async {
  final account = await ref.watch(spotifyAccountServiceProvider.future);
  if (account is! SpotifySignedIn) return const [];
  return ref.watch(spotifyRepositoryProvider).recent();
}

/// Own playlists, "Liked Songs" first; empty while signed out.
@riverpod
Future<List<MediaItem>> spotifyPlaylists(Ref ref) async {
  final account = await ref.watch(spotifyAccountServiceProvider.future);
  if (account is! SpotifySignedIn) return const [];
  return ref.watch(spotifyRepositoryProvider).playlists();
}
