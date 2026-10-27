import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_account.freezed.dart';

@freezed
sealed class SpotifyAccount with _$SpotifyAccount {
  /// No client id in the build; Spotify is hidden.
  const factory SpotifyAccount.notConfigured() = SpotifyNotConfigured;

  const factory SpotifyAccount.signedOut() = SpotifySignedOut;

  const factory SpotifyAccount.signedIn({required String displayName}) = SpotifySignedIn;
}
