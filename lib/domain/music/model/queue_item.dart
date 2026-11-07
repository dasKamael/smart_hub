import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_item.freezed.dart';

/// A track in the play queue of a speaker, or of a playlist or album.
@freezed
abstract class QueueItem with _$QueueItem {
  const factory QueueItem({
    required String title,
    String? artist,

    /// Small cover for lists.
    String? artworkUrl,

    /// Full size cover, as "Now playing" shows it once the track plays; loaded ahead of time.
    String? coverUrl,

    /// Place in the speaker's queue, to jump there; `null` where that is not possible (Spotify).
    int? position,

    /// The track on Spotify (`spotify:track:…`), to start a playlist or album from it.
    String? uri,
  }) = _QueueItem;
}
