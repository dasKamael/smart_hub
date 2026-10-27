import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/presentation/screens/music/library_view.enum.dart';

part 'music.state.freezed.dart';

@freezed
abstract class MusicPageState with _$MusicPageState {
  const factory MusicPageState({
    /// Target shown in "Now playing" (`PlaybackTarget.id`); `null` picks what plays.
    String? targetId,

    @Default(LibraryView.recent) LibraryView libraryView,
  }) = _MusicPageState;
}
