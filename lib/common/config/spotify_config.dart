import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/config/env.dart';

part 'spotify_config.g.dart';

/// Spotify app registration (developer.spotify.com), from `.env` ([Env]).
class SpotifyConfig {
  const SpotifyConfig({required this.clientId, required this.redirectUri});

  static final fromEnvironment = SpotifyConfig(clientId: Env.spotifyClientId, redirectUri: Env.spotifyRedirectUri);

  final String clientId;

  /// Exactly as registered. A loopback address; the app listens there during sign-in.
  final String redirectUri;

  bool get isConfigured => clientId.isNotEmpty;
}

@Riverpod(keepAlive: true)
SpotifyConfig spotifyConfig(Ref ref) => SpotifyConfig.fromEnvironment;
