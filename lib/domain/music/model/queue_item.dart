import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_item.freezed.dart';

/// A track in the play queue of a speaker.
@freezed
abstract class QueueItem with _$QueueItem {
  const factory QueueItem({
    required String title,
    String? artist,

    /// Small cover for lists.
    String? artworkUrl,

    /// Full size cover, as "Now playing" shows it once the track plays; loaded ahead of time.
    String? coverUrl,
  }) = _QueueItem;
}
