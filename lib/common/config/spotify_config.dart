import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spotify_config.g.dart';

/// Spotify app registration (developer.spotify.com), passed in with `--dart-define-from-file=env/dev.json`.
class SpotifyConfig {
  const SpotifyConfig({required this.clientId, required this.redirectUri});

  static const fromEnvironment = SpotifyConfig(
    clientId: String.fromEnvironment('SPOTIFY_CLIENT_ID'),
    redirectUri: String.fromEnvironment('SPOTIFY_REDIRECT_URI', defaultValue: 'http://127.0.0.1:43821/callback'),
  );

  final String clientId;

  /// Exactly as registered. A loopback address; the app listens there during sign-in.
  final String redirectUri;

  bool get isConfigured => clientId.isNotEmpty;
}

@Riverpod(keepAlive: true)
SpotifyConfig spotifyConfig(Ref ref) => SpotifyConfig.fromEnvironment;
