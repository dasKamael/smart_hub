import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/common/config/spotify_config.dart';
import 'package:smart_hub/data/music/spotify/spotify.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify_auth.repository.dart';
import 'package:smart_hub/data/music/spotify/spotify_tokens.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';

import '../../utils/riverpod.test_util.dart';

class _MockAuth extends Mock implements SpotifyAuthRepository {}

class _MockSpotify extends Mock implements SpotifyRepository {}

void main() {
  group('SpotifyAccountService', () {
    const configured = SpotifyConfig(clientId: 'client-1', redirectUri: 'http://127.0.0.1:43821/callback');
    final someTokens = SpotifyTokens(accessToken: 'a', refreshToken: 'r', expiresAt: DateTime(2027));
    late _MockAuth auth;
    late _MockSpotify spotify;

    setUp(() {
      auth = _MockAuth();
      spotify = _MockSpotify();
      when(() => spotify.displayName()).thenAnswer((_) async => 'Richard');
      when(() => spotify.recent()).thenAnswer(
        (_) async => const [MediaItem(title: 'Daybreak', contentId: 'spotify:album:d', contentType: 'album')],
      );
      when(() => spotify.playlists()).thenAnswer(
        (_) async => const [
          MediaItem(title: 'Morning Coffee', contentId: 'spotify:playlist:mc', contentType: 'playlist'),
        ],
      );
      when(() => auth.signOut()).thenAnswer((_) async {});
    });

    ProviderContainer createContainer({SpotifyConfig config = configured}) {
      final container = createTestContainer(
        overrides: [
          spotifyConfigProvider.overrideWithValue(config),
          spotifyAuthRepositoryProvider.overrideWithValue(auth),
          spotifyRepositoryProvider.overrideWithValue(spotify),
        ],
      );
      container.listen(spotifyAccountServiceProvider, (_, _) {});
      return container;
    }

    test('Given no client id in the build, when reading the account, then Spotify is not configured', () async {
      final container = createContainer(
        config: const SpotifyConfig(clientId: '', redirectUri: ''),
      );

      expect(await container.read(spotifyAccountServiceProvider.future), const SpotifyAccount.notConfigured());
    });

    test('Given no stored tokens, when reading the account, then the user is signed out', () async {
      when(() => auth.loadTokens()).thenAnswer((_) async => null);

      expect(await createContainer().read(spotifyAccountServiceProvider.future), const SpotifyAccount.signedOut());
    });

    test('Given stored tokens, when reading the account and library, then all come from Spotify', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => someTokens);
      final container = createContainer();
      container
        ..listen(spotifyRecentProvider, (_, _) {})
        ..listen(spotifyPlaylistsProvider, (_, _) {});

      // When
      final account = await container.read(spotifyAccountServiceProvider.future);
      final recent = await container.read(spotifyRecentProvider.future);
      final playlists = await container.read(spotifyPlaylistsProvider.future);

      // Then
      expect(account, const SpotifyAccount.signedIn(displayName: 'Richard'));
      expect(recent.single.title, 'Daybreak');
      expect(playlists.single.title, 'Morning Coffee');
    });

    test('Given a revoked authorization, when reading the account, then the user is signed out', () async {
      when(() => auth.loadTokens()).thenAnswer((_) async => someTokens);
      when(() => spotify.displayName()).thenThrow(const SpotifySignedOutException());

      expect(await createContainer().read(spotifyAccountServiceProvider.future), const SpotifyAccount.signedOut());
    });

    test('Given a signed out user, when signing in, then the account is reloaded as signed in', () async {
      // Given
      var signedIn = false;
      when(() => auth.loadTokens()).thenAnswer((_) async => signedIn ? someTokens : null);
      when(() => auth.signIn()).thenAnswer((_) async {
        signedIn = true;
        return someTokens;
      });
      when(() => spotify.reset()).thenReturn(null);
      final container = createContainer();
      await container.read(spotifyAccountServiceProvider.future);

      // When
      await container.read(spotifyAccountServiceProvider.notifier).signIn();

      // Then
      expect(
        container.read(spotifyAccountServiceProvider).value,
        const SpotifyAccount.signedIn(displayName: 'Richard'),
      );
    });

    test('Given a signed in user, when signing out, then the tokens are dropped', () async {
      // Given
      when(() => auth.loadTokens()).thenAnswer((_) async => someTokens);
      when(() => spotify.reset()).thenReturn(null);
      final container = createContainer();
      await container.read(spotifyAccountServiceProvider.future);

      // When
      await container.read(spotifyAccountServiceProvider.notifier).signOut();

      // Then
      verify(() => auth.signOut()).called(1);
      expect(container.read(spotifyAccountServiceProvider).value, const SpotifyAccount.signedOut());
    });
  });
}
