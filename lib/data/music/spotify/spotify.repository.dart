import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/http/http_client.provider.dart';
import 'package:smart_hub/data/music/spotify/spotify_auth.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify_tokens.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';

part 'spotify.repository.g.dart';

/// The Spotify account is signed out or its tokens were revoked.
final class SpotifySignedOutException implements Exception {
  const SpotifySignedOutException();
}

/// Reads the signed-in user's library from the Spotify Web API. Playback goes through Home Assistant, which plays
/// Spotify URIs on the speakers.
class SpotifyRepository {
  SpotifyRepository({required this.auth, required this.client});

  static final apiBase = Uri.parse('https://api.spotify.com/v1/');
  static const maxRecent = 12;
  static const maxPlaylists = 200;

  final SpotifyAuthRepository auth;
  final http.Client client;

  SpotifyTokens? _tokens;

  /// Display name of the signed-in user.
  Future<String> displayName() async {
    final me = await _get('me');
    return (me['display_name'] as String?) ?? (me['id'] as String?) ?? 'Spotify';
  }

  /// Albums of recently played tracks, newest first, without duplicates.
  Future<List<MediaItem>> recent() async {
    final json = await _get('me/player/recently-played', {'limit': '50'});
    final items = <String, MediaItem>{};
    for (final played in _list(json['items'])) {
      final album = (played['track'] as Map<String, Object?>?)?['album'] as Map<String, Object?>?;
      if (album == null || items.length >= maxRecent) continue;
      _add(items, album, contentType: 'album');
    }
    return items.values.toList();
  }

  /// The user's playlists, "Liked Songs" first. Liked songs need the `user-library-read` scope; sign-ins from before
  /// it was added just do not show them.
  Future<List<MediaItem>> playlists() async {
    final items = <String, MediaItem>{};
    for (var offset = 0; offset < maxPlaylists; offset += 50) {
      final page = await _get('me/playlists', {'limit': '50', 'offset': '$offset'});
      for (final playlist in _list(page['items'])) {
        _add(items, playlist, contentType: 'playlist');
      }
      if (page['next'] == null) break;
    }
    return [?await _likedSongs(), ...items.values];
  }

  Future<MediaItem?> _likedSongs() async {
    try {
      final (tracks, me) = await (_get('me/tracks', {'limit': '1'}), _get('me')).wait;
      final id = me['id'] as String?;
      if (id == null || ((tracks['total'] as num?) ?? 0) == 0) return null;
      return MediaItem(title: 'Liked Songs', contentId: 'spotify:user:$id:collection', contentType: 'playlist');
    } on ParallelWaitError<Object?, Object?> {
      return null;
    }
  }

  /// Devices with Spotify open.
  Future<List<ConnectDevice>> devices() async {
    final json = await _get('me/player/devices');
    return [
      for (final device in _list(json['devices']))
        if (device['id'] case final String id)
          ConnectDevice(
            id: id,
            name: (device['name'] as String?) ?? 'Spotify device',
            type: _deviceType(device['type'] as String?),
            isActive: device['is_active'] == true,
            isRestricted: device['is_restricted'] == true,
            volumePercent: (device['volume_percent'] as num?)?.round(),
            supportsVolume: device['supports_volume'] == true,
          ),
    ];
  }

  /// Current playback; `null` when Spotify plays nowhere.
  Future<SpotifyPlayback?> playback() async {
    final json = await _get('me/player');
    final device = json['device'] as Map<String, Object?>?;
    final deviceId = device?['id'] as String?;
    if (deviceId == null) return null;
    final item = json['item'] as Map<String, Object?>?;
    final images = _list((item?['album'] as Map<String, Object?>?)?['images']);
    return SpotifyPlayback(
      deviceId: deviceId,
      isPlaying: json['is_playing'] == true,
      title: item?['name'] as String?,
      trackUri: item?['uri'] as String?,
      artist: _list(item?['artists']).map((artist) => artist['name']).whereType<String>().join(', '),
      artworkUrl: images.isEmpty ? null : images.first['url'] as String?,
      contextUri: (json['context'] as Map<String, Object?>?)?['uri'] as String?,
      durationSeconds: ((item?['duration_ms'] as num?)?.toDouble() ?? 0) ~/ 1000,
      positionSeconds: ((json['progress_ms'] as num?)?.toDouble() ?? 0) / 1000,
      positionAt: clock.now(),
    );
  }

  /// Up next on Spotify, the playing track first.
  Future<List<QueueItem>> queue() async {
    final json = await _get('me/player/queue');
    QueueItem toItem(Map<String, Object?> track) {
      final images = _list((track['album'] as Map<String, Object?>?)?['images']);
      return QueueItem(
        title: (track['name'] as String?) ?? 'Unknown',
        artist: _list(track['artists']).map((artist) => artist['name']).whereType<String>().join(', '),
        artworkUrl: images.isEmpty ? null : images.last['url'] as String?,
        coverUrl: images.isEmpty ? null : images.first['url'] as String?,
      );
    }

    return [
      if (json['currently_playing'] case final Map<String, Object?> current) toItem(current),
      for (final track in _list(json['queue']).take(10)) toItem(track),
    ];
  }

  /// Starts [item] (an album or playlist URI) on [deviceId]; without [item] it resumes there.
  Future<void> play(String deviceId, {MediaItem? item}) {
    return _send('PUT', 'me/player/play', query: {'device_id': deviceId}, body: {'context_uri': ?item?.contentId});
  }

  Future<void> pause(String deviceId) => _send('PUT', 'me/player/pause', query: {'device_id': deviceId});

  Future<void> next(String deviceId) => _send('POST', 'me/player/next', query: {'device_id': deviceId});

  Future<void> previous(String deviceId) => _send('POST', 'me/player/previous', query: {'device_id': deviceId});

  Future<void> setVolume(String deviceId, int percent) {
    return _send('PUT', 'me/player/volume', query: {'device_id': deviceId, 'volume_percent': '$percent'});
  }

  /// Moves the playback to [deviceId] and keeps playing there.
  Future<void> transfer(String deviceId) {
    return _send(
      'PUT',
      'me/player',
      body: {
        'device_ids': [deviceId],
        'play': true,
      },
    );
  }

  static ConnectDeviceType _deviceType(String? type) {
    return switch (type?.toLowerCase()) {
      'computer' => ConnectDeviceType.computer,
      'smartphone' => ConnectDeviceType.smartphone,
      'tablet' => ConnectDeviceType.tablet,
      'speaker' || 'avr' || 'stb' || 'audiodongle' || 'castaudio' => ConnectDeviceType.speaker,
      'tv' || 'castvideo' || 'gameconsole' => ConnectDeviceType.tv,
      _ => ConnectDeviceType.other,
    };
  }

  void _add(Map<String, MediaItem> items, Map<String, Object?> json, {required String contentType}) {
    final uri = json['uri'] as String?;
    if (uri == null || items.containsKey(uri)) return;
    final images = _list(json['images']);
    items[uri] = MediaItem(
      title: (json['name'] as String?) ?? 'Untitled',
      contentId: uri,
      contentType: contentType,
      artworkUrl: images.isEmpty ? null : images.first['url'] as String?,
    );
  }

  static List<Map<String, Object?>> _list(Object? json) {
    return (json as List<Object?>? ?? const []).whereType<Map<String, Object?>>().toList();
  }

  /// GET with a valid access token. "No content" (e.g. nothing playing) gives an empty map.
  Future<Map<String, Object?>> _get(String path, [Map<String, String>? query]) async {
    final response = await _request('GET', path, query: query);
    if (response.statusCode == 204 || response.body.isEmpty) return const {};
    return jsonDecode(response.body) as Map<String, Object?>;
  }

  Future<void> _send(String method, String path, {Map<String, String>? query, Map<String, Object?>? body}) async {
    await _request(method, path, query: query, body: body);
  }

  /// A request with a valid access token: refreshed ahead of expiry and once more after a 401.
  Future<http.Response> _request(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, Object?>? body,
  }) async {
    final url = apiBase.resolve(path).replace(queryParameters: query);
    Future<http.Response> send(SpotifyTokens tokens) async {
      final request = http.Request(method, url)..headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      if (body != null) {
        request
          ..headers['Content-Type'] = 'application/json'
          ..body = jsonEncode(body);
      }
      return http.Response.fromStream(await client.send(request));
    }

    var tokens = await _validTokens();
    var response = await send(tokens);
    if (response.statusCode == 401) {
      tokens = _tokens = await auth.refresh(tokens);
      response = await send(tokens);
    }
    if (response.statusCode == 401) throw const SpotifySignedOutException();
    if (response.statusCode >= 300) throw http.ClientException('Spotify answered ${response.statusCode}', url);
    return response;
  }

  Future<SpotifyTokens> _validTokens() async {
    final tokens = _tokens ?? await auth.loadTokens();
    if (tokens == null) throw const SpotifySignedOutException();
    if (!tokens.isExpiredAt(clock.now())) return _tokens = tokens;
    return _tokens = await auth.refresh(tokens);
  }

  /// Forgets cached tokens, e.g. after signing out.
  void reset() => _tokens = null;
}

/// Providers
@Riverpod(keepAlive: true)
SpotifyRepository spotifyRepository(Ref ref) {
  return SpotifyRepository(auth: ref.watch(spotifyAuthRepositoryProvider), client: ref.watch(httpClientProvider));
}
