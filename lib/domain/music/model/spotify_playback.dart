import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_playback.freezed.dart';

/// What Spotify plays right now and where.
@freezed
abstract class SpotifyPlayback with _$SpotifyPlayback {
  const factory SpotifyPlayback({
    required String deviceId,
    required bool isPlaying,
    String? title,

    /// The playing track, e.g. `spotify:track:…`.
    String? trackUri,
    String? artist,
    String? artworkUrl,

    /// Album or playlist the track plays from, e.g. `spotify:playlist:…`.
    String? contextUri,
    int? durationSeconds,
    @Default(0) double positionSeconds,

    /// When [positionSeconds] was read; the position runs on from here while playing.
    required DateTime positionAt,
  }) = _SpotifyPlayback;
}
