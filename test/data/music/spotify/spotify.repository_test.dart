import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/music/spotify/spotify.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify_auth.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify_tokens.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';

class _MockAuth extends Mock implements SpotifyAuthRepository {}

void main() {
  setUpAll(() => registerFallbackValue(SpotifyTokens(accessToken: '', refreshToken: '', expiresAt: DateTime(2026))));

  group('SpotifyRepository', () {
    final now = DateTime(2026, 10, 26, 12);
    late _MockAuth auth;
    late List<http.Request> requests;

    SpotifyTokens tokens(String access, {Duration validFor = const Duration(hours: 1)}) {
      return SpotifyTokens(accessToken: access, refreshToken: 'refresh', expiresAt: now.add(validFor));
    }

    Map<String, Object?> album(String name) => {
      'name': name,
      'uri': 'spotify:album:${name.toLowerCase()}',
      'images': [
        {'url': 'https://i.scdn.co/$name.jpg'},
      ],
    };

    MockClient api({Set<String> rejected = const {}, int likedSongs = 3, bool canReadLibrary = true}) {
      return MockClient((request) async {
        requests.add(request);
        final token = request.headers['Authorization']?.replaceFirst('Bearer ', '');
        if (rejected.contains(token)) return http.Response('', 401);
        if (!canReadLibrary && request.url.path == '/v1/me/tracks') return http.Response('', 403);
        final body = switch (request.url.path) {
          '/v1/me' => {'display_name': 'Richard', 'id': 'rm'},
          '/v1/me/player/recently-played' => {
            'items': [
              {
                'track': {'album': album('Daybreak')},
              },
              {
                'track': {'album': album('Daybreak')},
              },
              {
                'track': {'album': album('Currents')},
              },
            ],
          },
          '/v1/me/player/devices' => {
            'devices': [
              {
                'id': 'd-phone',
                'name': 'Pixel 9',
                'type': 'Smartphone',
                'is_active': true,
                'volume_percent': 40,
                'supports_volume': true,
              },
              {'id': 'd-tv', 'name': 'Living room', 'type': 'CastVideo', 'is_restricted': true},
              {'id': null, 'name': 'Without id', 'type': 'Computer'},
            ],
          },
          '/v1/me/player' when request.method == 'GET' => {
            'device': {'id': 'd-phone'},
            'is_playing': true,
            'progress_ms': 61500,
            'item': {
              'name': 'Morning Light',
              'duration_ms': 215000,
              'artists': [
                {'name': 'Lumen'},
                {'name': 'Quartet'},
              ],
              'album': {
                'images': [
                  {'url': 'https://i.scdn.co/big.jpg'},
                ],
              },
            },
          },
          '/v1/me/player/queue' => {
            'currently_playing': {
              'name': 'Morning Light',
              'artists': <Object?>[],
              'album': {
                'images': [
                  {'url': 'https://i.scdn.co/640.jpg'},
                  {'url': 'https://i.scdn.co/64.jpg'},
                ],
              },
            },
            'queue': [
              for (var i = 0; i < 12; i++) {'name': 'Track $i', 'artists': <Object?>[]},
            ],
          },
          '/v1/me/playlists' when request.url.queryParameters['offset'] == '0' => {
            'items': [
              {'name': 'Morning Coffee', 'uri': 'spotify:playlist:mc', 'images': <Object?>[]},
            ],
            'next': 'https://api.spotify.com/v1/me/playlists?offset=50',
          },
          '/v1/me/playlists' => {
            'items': [
              {'name': 'Night Drive', 'uri': 'spotify:playlist:nd', 'images': <Object?>[]},
            ],
          },
          '/v1/me/tracks' => {'total': likedSongs},
          _ => <String, Object?>{},
        };
        return http.Response(jsonEncode(body), 200);
      });
    }

    setUp(() {
      auth = _MockAuth();
      requests = [];
      when(() => auth.refresh(any())).thenAnswer((_) async => tokens('fresh'));
    });

    test('Given a signed in user, '
        'when loading recently played, '
        'then the albums come newest first without duplicates', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final repository = SpotifyRepository(auth: auth, client: api());

      // When
      final recent = await withClock(Clock.fixed(now), repository.recent);

      // Then
      expect(recent.map((item) => '${item.contentType} ${item.title}'), ['album Daybreak', 'album Currents']);
      expect(recent.first.contentId, 'spotify:album:daybreak');
      expect(recent.first.artworkUrl, 'https://i.scdn.co/Daybreak.jpg');
    });

    test('Given liked songs and two pages of playlists, '
        'when loading the playlists, '
        'then liked songs come first, then every page', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final repository = SpotifyRepository(auth: auth, client: api());

      // When
      final playlists = await withClock(Clock.fixed(now), repository.playlists);

      // Then
      expect(playlists.map((item) => item.title), ['Liked Songs', 'Morning Coffee', 'Night Drive']);
      expect(playlists.first.contentId, 'spotify:user:rm:collection');
      expect(playlists.first.isLikedSongs, isTrue);
    });

    test('Given a sign-in from before liked songs were allowed, '
        'when loading the playlists, '
        'then they come without liked songs', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final repository = SpotifyRepository(auth: auth, client: api(canReadLibrary: false));

      // When
      final playlists = await withClock(Clock.fixed(now), repository.playlists);

      // Then
      expect(playlists.map((item) => item.title), ['Morning Coffee', 'Night Drive']);
    });

    test('Given an expired access token, when loading, then it is refreshed before the request', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('old', validFor: const Duration(seconds: 30)));
      final repository = SpotifyRepository(auth: auth, client: api());

      // When
      final name = await withClock(Clock.fixed(now), repository.displayName);

      // Then
      expect(name, 'Richard');
      expect(requests.single.headers['Authorization'], 'Bearer fresh');
    });

    test('Given a revoked access token, when loading, then it is refreshed once and the request repeated', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('revoked'));
      final repository = SpotifyRepository(
        auth: auth,
        client: api(rejected: {'revoked'}),
      );

      // When
      final name = await withClock(Clock.fixed(now), repository.displayName);

      // Then
      expect(name, 'Richard');
      expect(requests.map((r) => r.headers['Authorization']), ['Bearer revoked', 'Bearer fresh']);
    });

    test('Given access was withdrawn, when loading, then the user counts as signed out', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('revoked'));
      when(() => auth.refresh(any())).thenAnswer((_) async => tokens('also-revoked'));
      final repository = SpotifyRepository(
        auth: auth,
        client: api(rejected: {'revoked', 'also-revoked'}),
      );

      // When / Then
      await expectLater(withClock(Clock.fixed(now), repository.displayName), throwsA(isA<SpotifySignedOutException>()));
    });

    test('Given no stored tokens, when loading, then the user counts as signed out', () async {
      when(() => auth.loadTokens()).thenAnswer((_) async => null);

      await expectLater(
        SpotifyRepository(auth: auth, client: api()).recent(),
        throwsA(isA<SpotifySignedOutException>()),
      );
    });

    test('Given devices with Spotify open, when loading them, then type, volume and restrictions are mapped', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final repository = SpotifyRepository(auth: auth, client: api());

      // When
      final devices = await withClock(Clock.fixed(now), repository.devices);

      // Then
      expect(devices, const [
        ConnectDevice(
          id: 'd-phone',
          name: 'Pixel 9',
          type: ConnectDeviceType.smartphone,
          isActive: true,
          volumePercent: 40,
          supportsVolume: true,
        ),
        ConnectDevice(id: 'd-tv', name: 'Living room', type: ConnectDeviceType.tv, isRestricted: true),
      ]);
    });

    test('Given music on the phone, when loading the playback, then track, position and device come back', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final repository = SpotifyRepository(auth: auth, client: api());

      // When
      final playback = await withClock(Clock.fixed(now), repository.playback);

      // Then
      expect(
        playback,
        SpotifyPlayback(
          deviceId: 'd-phone',
          isPlaying: true,
          title: 'Morning Light',
          artist: 'Lumen, Quartet',
          artworkUrl: 'https://i.scdn.co/big.jpg',
          durationSeconds: 215,
          positionSeconds: 61.5,
          positionAt: now,
        ),
      );
    });

    test('Given nothing plays, when loading the playback, then there is none', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final client = MockClient((request) async => http.Response('', 204));

      // When
      final playback = await withClock(Clock.fixed(now), SpotifyRepository(auth: auth, client: client).playback);

      // Then
      expect(playback, isNull);
    });

    test('Given a long queue, when loading it, then the playing track and the next ten come back', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final repository = SpotifyRepository(auth: auth, client: api());

      // When
      final queue = await withClock(Clock.fixed(now), repository.queue);

      // Then
      expect(queue.map((item) => item.title), ['Morning Light', for (var i = 0; i < 10; i++) 'Track $i']);
      expect(queue.first.artworkUrl, 'https://i.scdn.co/64.jpg', reason: 'small for the list');
      expect(queue.first.coverUrl, 'https://i.scdn.co/640.jpg', reason: 'full size to load ahead');
    });

    test('Given a device, when sending commands, then each goes to the matching endpoint', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => tokens('valid'));
      final repository = SpotifyRepository(auth: auth, client: api());

      // When
      await withClock(Clock.fixed(now), () async {
        await repository.play(
          'd1',
          item: const MediaItem(title: 'D', contentId: 'spotify:album:d', contentType: 'album'),
        );
        await repository.play('d1');
        await repository.pause('d1');
        await repository.next('d1');
        await repository.previous('d1');
        await repository.setVolume('d1', 30);
        await repository.seek('d1', 75);
        await repository.transfer('d2');
      });

      // Then
      expect(requests.map((r) => '${r.method} ${r.url.path}?${r.url.query} ${r.body}'), [
        'PUT /v1/me/player/play?device_id=d1 {"context_uri":"spotify:album:d"}',
        'PUT /v1/me/player/play?device_id=d1 {}',
        'PUT /v1/me/player/pause?device_id=d1 ',
        'POST /v1/me/player/next?device_id=d1 ',
        'POST /v1/me/player/previous?device_id=d1 ',
        'PUT /v1/me/player/volume?device_id=d1&volume_percent=30 ',
        'PUT /v1/me/player/seek?device_id=d1&position_ms=75000 ',
        'PUT /v1/me/player? {"device_ids":["d2"],"play":true}',
      ]);
    });
  });
}
