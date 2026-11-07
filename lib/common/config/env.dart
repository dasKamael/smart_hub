import 'package:envied/envied.dart';

part 'env.g.dart';

/// Keys from `.env` (gitignored, see `.env.example`), baked in by `build_runner`: a build without them fails instead
/// of starting without Spotify or the plant database.
@Envied(path: '.env', requireEnvFile: true, obfuscate: true)
abstract final class Env {
  @EnviedField(varName: 'SPOTIFY_CLIENT_ID')
  static final String spotifyClientId = _Env.spotifyClientId;

  @EnviedField(varName: 'SPOTIFY_REDIRECT_URI', defaultValue: 'http://127.0.0.1:43821/callback')
  static final String spotifyRedirectUri = _Env.spotifyRedirectUri;

  @EnviedField(varName: 'PERENUAL_API_KEY')
  static final String perenualApiKey = _Env.perenualApiKey;
}
