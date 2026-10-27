// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All speakers, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the speaker does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").

@ProviderFor(SpeakersService)
final speakersServiceProvider = SpeakersServiceProvider._();

/// All speakers, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the speaker does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").
final class SpeakersServiceProvider extends $AsyncNotifierProvider<SpeakersService, List<SpeakerState>> {
  /// All speakers, sorted by name, and the commands to control them.
  ///
  /// Commands show at once (optimistic) and roll back when the speaker does not report the change within 3 s or the
  /// command fails (`README` → "Optimistic UI").
  SpeakersServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakersServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakersServiceHash();

  @$internal
  @override
  SpeakersService create() => SpeakersService();
}

String _$speakersServiceHash() => r'f72dba056930ee3e88759e71b205b043cf42cd79';

/// All speakers, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the speaker does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").

abstract class _$SpeakersService extends $AsyncNotifier<List<SpeakerState>> {
  FutureOr<List<SpeakerState>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<SpeakerState>>, List<SpeakerState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SpeakerState>>, List<SpeakerState>>,
              AsyncValue<List<SpeakerState>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Favorites and playlists [speakerId] can play.

@ProviderFor(mediaFavorites)
final mediaFavoritesProvider = MediaFavoritesFamily._();

/// Favorites and playlists [speakerId] can play.

final class MediaFavoritesProvider
    extends $FunctionalProvider<AsyncValue<List<MediaItem>>, List<MediaItem>, FutureOr<List<MediaItem>>>
    with $FutureModifier<List<MediaItem>>, $FutureProvider<List<MediaItem>> {
  /// Favorites and playlists [speakerId] can play.
  MediaFavoritesProvider._({required MediaFavoritesFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'mediaFavoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaFavoritesHash();

  @override
  String toString() {
    return r'mediaFavoritesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MediaItem>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MediaItem>> create(Ref ref) {
    final argument = this.argument as String;
    return mediaFavorites(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaFavoritesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaFavoritesHash() => r'5cfc1ec394d1eadfb7126784ad41fcae746e2c0d';

/// Favorites and playlists [speakerId] can play.

final class MediaFavoritesFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<MediaItem>>, String> {
  MediaFavoritesFamily._()
    : super(
        retry: null,
        name: r'mediaFavoritesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Favorites and playlists [speakerId] can play.

  MediaFavoritesProvider call(String speakerId) => MediaFavoritesProvider._(argument: speakerId, from: this);

  @override
  String toString() => r'mediaFavoritesProvider';
}

/// The play queue of [speakerId]; `null` when the player has none HA can read. Reloads when the track changes.

@ProviderFor(playQueue)
final playQueueProvider = PlayQueueFamily._();

/// The play queue of [speakerId]; `null` when the player has none HA can read. Reloads when the track changes.

final class PlayQueueProvider
    extends $FunctionalProvider<AsyncValue<List<QueueItem>?>, List<QueueItem>?, FutureOr<List<QueueItem>?>>
    with $FutureModifier<List<QueueItem>?>, $FutureProvider<List<QueueItem>?> {
  /// The play queue of [speakerId]; `null` when the player has none HA can read. Reloads when the track changes.
  PlayQueueProvider._({required PlayQueueFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'playQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playQueueHash();

  @override
  String toString() {
    return r'playQueueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<QueueItem>?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QueueItem>?> create(Ref ref) {
    final argument = this.argument as String;
    return playQueue(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playQueueHash() => r'71e6094fff24a708910c74cee926c00cd7ed8853';

/// The play queue of [speakerId]; `null` when the player has none HA can read. Reloads when the track changes.

final class PlayQueueFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<QueueItem>?>, String> {
  PlayQueueFamily._()
    : super(
        retry: null,
        name: r'playQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The play queue of [speakerId]; `null` when the player has none HA can read. Reloads when the track changes.

  PlayQueueProvider call(String speakerId) => PlayQueueProvider._(argument: speakerId, from: this);

  @override
  String toString() => r'playQueueProvider';
}
