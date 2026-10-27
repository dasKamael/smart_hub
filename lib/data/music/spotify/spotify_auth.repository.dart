import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/config/spotify_config.dart';
import 'package:smart_hub/common/database/secure_storage.provider.dart';
import 'package:smart_hub/common/http/http_client.provider.dart';
import 'package:smart_hub/data/music/spotify/spotify_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

part 'spotify_auth.repository.g.dart';

/// Sign-in failed or was cancelled.
final class SpotifyAuthException implements Exception {
  const SpotifyAuthException(this.message);

  final String message;

  @override
  String toString() => 'SpotifyAuthException: $message';
}

/// Spotify sign-in with PKCE (no client secret on the device) and a loopback redirect (RFC 8252): during sign-in
/// the app listens on the registered `http://127.0.0.1:<port>/callback` and takes the code from there.
class SpotifyAuthRepository {
  SpotifyAuthRepository({
    required this.config,
    required this.storage,
    required this.client,
    required this.openBrowser,
    Random? random,
  }) : _random = random ?? Random.secure();

  static const storageKey = 'spotify_tokens';
  static const signInTimeout = Duration(minutes: 5);
  static final authorizeUrl = Uri.parse('https://accounts.spotify.com/authorize');
  static final tokenUrl = Uri.parse('https://accounts.spotify.com/api/token');

  /// Own playlists, liked songs and recently played as content, plus reading and steering playback on Spotify Connect devices
  /// (e.g. the Spotify app on the tablet) – nothing else.
  static const scopes = [
    'playlist-read-private',
    'playlist-read-collaborative',
    'user-read-recently-played',
    'user-library-read',
    'user-read-playback-state',
    'user-modify-playback-state',
  ];

  final SpotifyConfig config;
  final FlutterSecureStorage storage;
  final http.Client client;
  final Future<bool> Function(Uri url) openBrowser;
  final Random _random;

  Future<SpotifyTokens?> loadTokens() async {
    final raw = await storage.read(key: storageKey);
    if (raw == null) return null;
    try {
      return SpotifyTokens.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      return null;
    }
  }

  /// Opens the Spotify login and waits for the redirect. Throws [SpotifyAuthException] on denial, mismatch or
  /// timeout.
  Future<SpotifyTokens> signIn() async {
    final registered = Uri.parse(config.redirectUri);
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, registered.port);
    try {
      // Port 0 in the configuration means "any free port" (allowed by Spotify for loopback literals).
      final redirect = registered.replace(port: server.port);
      final verifier = _randomString(64);
      final state = _randomString(16);
      final opened = await openBrowser(
        authorizeUrl.replace(
          queryParameters: {
            'client_id': config.clientId,
            'response_type': 'code',
            'redirect_uri': redirect.toString(),
            'code_challenge_method': 'S256',
            'code_challenge': codeChallengeOf(verifier),
            'scope': scopes.join(' '),
            'state': state,
          },
        ),
      );
      if (!opened) throw const SpotifyAuthException('Could not open the browser');

      final code = await _awaitCode(
        server,
        path: registered.path,
        state: state,
      ).timeout(signInTimeout, onTimeout: () => throw const SpotifyAuthException('Sign-in timed out'));
      final tokens = await _requestTokens({
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirect.toString(),
        'client_id': config.clientId,
        'code_verifier': verifier,
      });
      await _save(tokens);
      return tokens;
    } finally {
      await server.close(force: true);
    }
  }

  /// A fresh access token. Spotify may hand out a new refresh token, otherwise the old one stays valid.
  Future<SpotifyTokens> refresh(SpotifyTokens tokens) async {
    final refreshed = await _requestTokens({
      'grant_type': 'refresh_token',
      'refresh_token': tokens.refreshToken,
      'client_id': config.clientId,
    }, previousRefreshToken: tokens.refreshToken);
    await _save(refreshed);
    return refreshed;
  }

  Future<void> signOut() => storage.delete(key: storageKey);

  /// `BASE64URL(SHA256(verifier))` without padding (RFC 7636).
  static String codeChallengeOf(String verifier) {
    return base64UrlEncode(sha256.convert(ascii.encode(verifier)).bytes).replaceAll('=', '');
  }

  Future<String> _awaitCode(HttpServer server, {required String path, required String state}) async {
    await for (final request in server) {
      if (request.uri.path != path) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      final params = request.uri.queryParameters;
      final error = params['error'];
      final ok = error == null && params['state'] == state && params['code'] != null;
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.html
        ..write(_page(ok ? 'Spotify is connected. You can close this tab.' : 'Spotify sign-in did not work.'));
      await request.response.close();
      if (error != null) throw SpotifyAuthException('Spotify answered: $error');
      if (params['state'] != state) throw const SpotifyAuthException('State mismatch');
      final code = params['code'];
      if (code == null) throw const SpotifyAuthException('No code');
      return code;
    }
    throw const SpotifyAuthException('Sign-in was cancelled');
  }

  Future<SpotifyTokens> _requestTokens(Map<String, String> body, {String? previousRefreshToken}) async {
    final response = await client.post(tokenUrl, body: body);
    if (response.statusCode != 200) {
      throw SpotifyAuthException('Token request failed (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, Object?>;
    final refreshToken = (json['refresh_token'] as String?) ?? previousRefreshToken;
    if (refreshToken == null) throw const SpotifyAuthException('No refresh token');
    return SpotifyTokens(
      accessToken: json['access_token'] as String,
      refreshToken: refreshToken,
      expiresAt: clock.now().add(Duration(seconds: (json['expires_in'] as num?)?.toInt() ?? 3600)),
    );
  }

  Future<void> _save(SpotifyTokens tokens) => storage.write(key: storageKey, value: jsonEncode(tokens.toJson()));

  String _randomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    return String.fromCharCodes([for (var i = 0; i < length; i++) chars.codeUnitAt(_random.nextInt(chars.length))]);
  }

  static String _page(String message) {
    return '<!doctype html><meta name="viewport" content="width=device-width">'
        '<body style="background:#000;color:#fff;font:600 20px sans-serif;display:grid;place-items:center;'
        'height:90vh">$message</body>';
  }
}

/// Providers
@Riverpod(keepAlive: true)
SpotifyAuthRepository spotifyAuthRepository(Ref ref) {
  return SpotifyAuthRepository(
    config: ref.watch(spotifyConfigProvider),
    storage: ref.watch(secureStorageProvider),
    client: ref.watch(httpClientProvider),
    openBrowser: (url) => launchUrl(url, mode: LaunchMode.inAppBrowserView),
  );
}
