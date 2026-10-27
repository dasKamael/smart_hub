import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';

/// Something a speaker can play, e.g. a favorite or a playlist.
@freezed
abstract class MediaItem with _$MediaItem {
  const factory MediaItem({
    required String title,
    required String contentId,
    required String contentType,
    String? artworkUrl,
  }) = _MediaItem;

  const MediaItem._();

  /// Spotify's "Liked Songs" of the user.
  bool get isLikedSongs => contentId.endsWith(':collection');
}
