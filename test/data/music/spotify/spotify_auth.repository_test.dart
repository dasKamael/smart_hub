import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_hub/common/config/spotify_config.dart';
import 'package:smart_hub/data/music/spotify/spotify_auth.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify_tokens.dart';

import '../../../mocks/secure_storage.mock.dart';

void main() {
  group('SpotifyAuthRepository', () {
    // Port 0: any free port, so tests do not collide.
    const config = SpotifyConfig(clientId: 'client-1', redirectUri: 'http://127.0.0.1:0/callback');

    late Map<String, String> stored;
    late List<http.Request> tokenRequests;

    MockClient tokenEndpoint({String? refreshToken = 'refresh-1'}) {
      return MockClient((request) async {
        tokenRequests.add(request);
        return http.Response(
          jsonEncode({'access_token': 'access-1', 'expires_in': 3600, 'refresh_token': ?refreshToken}),
          200,
        );
      });
    }

    /// A browser that follows the authorize URL by calling the redirect with [params] (state is copied unless set).
    Future<bool> Function(Uri) browser(Map<String, String> params, {List<Uri>? opened}) {
      return (url) async {
        opened?.add(url);
        final redirect = Uri.parse(url.queryParameters['redirect_uri']!);
        final query = {'state': url.queryParameters['state']!, ...params};
        // Answer after the repository started listening for the callback.
        Future<void>.delayed(const Duration(milliseconds: 20), () async {
          final client = HttpClient();
          final request = await client.getUrl(redirect.replace(queryParameters: query));
          await (await request.close()).drain<void>();
          client.close();
        });
        return true;
      };
    }

    SpotifyAuthRepository repository({required http.Client client, required Future<bool> Function(Uri) openBrowser}) {
      return SpotifyAuthRepository(
        config: config,
        storage: inMemorySecureStorage(stored),
        client: client,
        openBrowser: openBrowser,
      );
    }

    setUp(() {
      stored = {};
      tokenRequests = [];
    });

    test('Given the RFC 7636 example verifier, when deriving the challenge, then it matches the RFC', () {
      expect(
        SpotifyAuthRepository.codeChallengeOf('dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk'),
        'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM',
      );
    });

    test('Given the user approves, '
        'when signing in, '
        'then the code is exchanged with the PKCE verifier and the tokens are stored', () async {
      // Given
      final opened = <Uri>[];
      final auth = repository(
        client: tokenEndpoint(),
        openBrowser: browser({'code': 'code-1'}, opened: opened),
      );

      // When
      final tokens = await auth.signIn();

      // Then
      final authorize = opened.single;
      expect(authorize.host, 'accounts.spotify.com');
      expect(authorize.queryParameters['client_id'], 'client-1');
      expect(authorize.queryParameters['code_challenge_method'], 'S256');
      expect(authorize.queryParameters['scope'], contains('user-read-recently-played'));
      final exchange = tokenRequests.single.bodyFields;
      expect(exchange['grant_type'], 'authorization_code');
      expect(exchange['code'], 'code-1');
      expect(exchange['redirect_uri'], authorize.queryParameters['redirect_uri']);
      expect(
        SpotifyAuthRepository.codeChallengeOf(exchange['code_verifier']!),
        authorize.queryParameters['code_challenge'],
      );
      expect(exchange.containsKey('client_secret'), isFalse);
      expect(tokens.accessToken, 'access-1');
      expect((await auth.loadTokens())?.refreshToken, 'refresh-1');
    });

    test('Given the user denies access, when signing in, then it fails and nothing is stored', () async {
      final auth = repository(client: tokenEndpoint(), openBrowser: browser({'error': 'access_denied'}));

      await expectLater(auth.signIn(), throwsA(isA<SpotifyAuthException>()));
      expect(stored, isEmpty);
      expect(tokenRequests, isEmpty);
    });

    test('Given a callback with a foreign state, when signing in, then it is rejected', () async {
      final auth = repository(client: tokenEndpoint(), openBrowser: browser({'code': 'c', 'state': 'forged'}));

      await expectLater(auth.signIn(), throwsA(isA<SpotifyAuthException>()));
      expect(tokenRequests, isEmpty);
    });

    test('Given no browser, when signing in, then it fails', () async {
      final auth = repository(client: tokenEndpoint(), openBrowser: (_) async => false);

      await expectLater(auth.signIn(), throwsA(isA<SpotifyAuthException>()));
    });

    test('Given Spotify returns no new refresh token, when refreshing, then the old one is kept', () async {
      // Given
      final auth = repository(client: tokenEndpoint(refreshToken: null), openBrowser: (_) async => true);
      final old = SpotifyTokens(accessToken: 'old', refreshToken: 'refresh-0', expiresAt: DateTime(2026));

      // When
      final refreshed = await auth.refresh(old);

      // Then
      expect(tokenRequests.single.bodyFields, {
        'grant_type': 'refresh_token',
        'refresh_token': 'refresh-0',
        'client_id': 'client-1',
      });
      expect(refreshed.accessToken, 'access-1');
      expect(refreshed.refreshToken, 'refresh-0');
    });

    test('Given stored tokens, when signing out, then they are gone', () async {
      // Given
      final auth = repository(client: tokenEndpoint(), openBrowser: (_) async => true);
      await auth.refresh(SpotifyTokens(accessToken: 'a', refreshToken: 'r', expiresAt: DateTime(2026)));

      // When
      await auth.signOut();

      // Then
      expect(await auth.loadTokens(), isNull);
    });
  });
}
