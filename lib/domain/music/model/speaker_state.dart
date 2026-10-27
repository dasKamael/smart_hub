import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';

part 'speaker_state.freezed.dart';

@freezed
abstract class SpeakerState with _$SpeakerState {
  const factory SpeakerState({
    required String id,
    required String name,

    /// The name Home Assistant reports, set when the speaker was renamed in the hub.
    String? reportedName,
    required Playback playback,

    /// 0–100.
    @Default(0) int volumePercent,

    /// Ids of all speakers in the same group including this one; just this one when not grouped.
    @Default([]) List<String> groupMembers,
    String? title,
    String? artist,
    String? album,

    /// Playlist or source the track comes from, if the player reports it.
    String? playlist,

    /// Absolute URL of the cover.
    String? artworkUrl,

    /// Length of the track in seconds.
    int? durationSeconds,

    /// Position in seconds at [positionUpdatedAt]; it keeps running while playing.
    double? positionSeconds,
    DateTime? positionUpdatedAt,
  }) = _SpeakerState;

  const SpeakerState._();

  bool get isGrouped => groupMembers.length > 1;

  /// The group leader, or the speaker itself when it is not grouped.
  String get leaderId => groupMembers.isEmpty ? id : groupMembers.first;

  /// Seconds played at [now], extrapolated while playing and capped at the track length.
  double? positionAt(DateTime now) {
    final position = positionSeconds;
    if (position == null) return null;
    final updated = positionUpdatedAt;
    final elapsed = playback.isPlaying && updated != null ? now.difference(updated).inMilliseconds / 1000 : 0.0;
    final total = position + (elapsed < 0 ? 0 : elapsed);
    return switch (durationSeconds) {
      final duration? => total.clamp(0, duration.toDouble()),
      null => total,
    };
  }
}
