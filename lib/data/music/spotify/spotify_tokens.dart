/// Spotify OAuth tokens; [expiresAt] is when the access token runs out.
final class SpotifyTokens {
  const SpotifyTokens({required this.accessToken, required this.refreshToken, required this.expiresAt});

  factory SpotifyTokens.fromJson(Map<String, Object?> json) {
    return SpotifyTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  /// Refresh a minute early, so a request never starts with a token that expires on the way.
  bool isExpiredAt(DateTime now) => !now.isBefore(expiresAt.subtract(const Duration(minutes: 1)));

  Map<String, Object?> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expires_at': expiresAt.toIso8601String(),
  };
}
