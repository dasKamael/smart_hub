import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/spotify_playback.dart';
import 'package:smart_hub/presentation/screens/music/speaker_group.dart';

/// What "Now playing" shows, independent of where it plays.
final class NowPlaying {
  const NowPlaying({
    required this.isPlaying,
    this.title,
    this.artist,
    this.source,
    this.artworkUrl,
    this.durationSeconds,
    this.positionSeconds,
    this.positionAt,
  });

  final bool isPlaying;
  final String? title;
  final String? artist;

  /// Playlist or service, e.g. "Morning Coffee".
  final String? source;
  final String? artworkUrl;
  final int? durationSeconds;
  final double? positionSeconds;
  final DateTime? positionAt;

  /// Seconds played at [now], running on while playing and capped at the track length.
  double? positionAtTime(DateTime now) {
    final position = positionSeconds;
    if (position == null) return null;
    final at = positionAt;
    final elapsed = isPlaying && at != null ? now.difference(at).inMilliseconds / 1000 : 0.0;
    final total = position + (elapsed < 0 ? 0 : elapsed);
    return switch (durationSeconds) {
      final duration? => total.clamp(0, duration.toDouble()),
      null => total,
    };
  }
}

/// Where music plays: a speaker group from Home Assistant or a device with Spotify open.
sealed class PlaybackTarget {
  const PlaybackTarget();

  String get id;

  String get name;

  NowPlaying get nowPlaying;
}

final class SpeakerGroupTarget extends PlaybackTarget {
  const SpeakerGroupTarget(this.group);

  final SpeakerGroup group;

  @override
  String get id => group.leaderId;

  @override
  String get name => group.name;

  @override
  NowPlaying get nowPlaying {
    final leader = group.leader;
    return NowPlaying(
      isPlaying: leader.playback.isPlaying,
      title: leader.title,
      artist: leader.artist,
      source: leader.playlist,
      artworkUrl: leader.artworkUrl,
      durationSeconds: leader.durationSeconds,
      positionSeconds: leader.positionSeconds,
      positionAt: leader.positionUpdatedAt,
    );
  }
}

final class ConnectTarget extends PlaybackTarget {
  const ConnectTarget(this.device, {this.playback});

  static const idPrefix = 'spotify-device:';

  final ConnectDevice device;

  /// Spotify's playback, when it plays on [device].
  final SpotifyPlayback? playback;

  @override
  String get id => '$idPrefix${device.id}';

  @override
  String get name => device.name;

  @override
  NowPlaying get nowPlaying {
    final playback = this.playback;
    if (playback == null) return const NowPlaying(isPlaying: false, source: 'Spotify');
    return NowPlaying(
      isPlaying: playback.isPlaying,
      title: playback.title,
      artist: playback.artist,
      source: 'Spotify',
      artworkUrl: playback.artworkUrl,
      durationSeconds: playback.durationSeconds,
      positionSeconds: playback.positionSeconds,
      positionAt: playback.positionAt,
    );
  }
}
