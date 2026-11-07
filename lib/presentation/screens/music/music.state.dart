import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/presentation/screens/music/library_view.enum.dart';

part 'music.state.freezed.dart';

@freezed
abstract class MusicPageState with _$MusicPageState {
  const factory MusicPageState({
    /// Target shown in "Now playing" (`PlaybackTarget.id`); `null` picks what plays.
    String? targetId,

    @Default(LibraryView.recent) LibraryView libraryView,

    /// The playlist or album looked into, shown instead of "Up next" until something plays.
    MediaItem? opened,
  }) = _MusicPageState;
}
