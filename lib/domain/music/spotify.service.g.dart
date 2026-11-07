// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Spotify account used as content source (playlists, recently played).

@ProviderFor(SpotifyAccountService)
final spotifyAccountServiceProvider = SpotifyAccountServiceProvider._();

/// The Spotify account used as content source (playlists, recently played).
final class SpotifyAccountServiceProvider
    extends $AsyncNotifierProvider<SpotifyAccountService, SpotifyAccount> {
  /// The Spotify account used as content source (playlists, recently played).
  SpotifyAccountServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyAccountServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyAccountServiceHash();

  @$internal
  @override
  SpotifyAccountService create() => SpotifyAccountService();
}

String _$spotifyAccountServiceHash() =>
    r'625654a0eda3739a27359a2056c0b972aa4fa0be';

/// The Spotify account used as content source (playlists, recently played).

abstract class _$SpotifyAccountService extends $AsyncNotifier<SpotifyAccount> {
  FutureOr<SpotifyAccount> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SpotifyAccount>, SpotifyAccount>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotifyAccount>, SpotifyAccount>,
              AsyncValue<SpotifyAccount>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Recently played albums; empty while signed out.

@ProviderFor(spotifyRecent)
final spotifyRecentProvider = SpotifyRecentProvider._();

/// Recently played albums; empty while signed out.

final class SpotifyRecentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaItem>>,
          List<MediaItem>,
          FutureOr<List<MediaItem>>
        >
    with $FutureModifier<List<MediaItem>>, $FutureProvider<List<MediaItem>> {
  /// Recently played albums; empty while signed out.
  SpotifyRecentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyRecentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyRecentHash();

  @$internal
  @override
  $FutureProviderElement<List<MediaItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MediaItem>> create(Ref ref) {
    return spotifyRecent(ref);
  }
}

String _$spotifyRecentHash() => r'234d3f2d781b73ee124c36c756083e838eea74e8';

/// Own playlists, "Liked Songs" first; empty while signed out.

@ProviderFor(spotifyPlaylists)
final spotifyPlaylistsProvider = SpotifyPlaylistsProvider._();

/// Own playlists, "Liked Songs" first; empty while signed out.

final class SpotifyPlaylistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaItem>>,
          List<MediaItem>,
          FutureOr<List<MediaItem>>
        >
    with $FutureModifier<List<MediaItem>>, $FutureProvider<List<MediaItem>> {
  /// Own playlists, "Liked Songs" first; empty while signed out.
  SpotifyPlaylistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyPlaylistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyPlaylistsHash();

  @$internal
  @override
  $FutureProviderElement<List<MediaItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MediaItem>> create(Ref ref) {
    return spotifyPlaylists(ref);
  }
}

String _$spotifyPlaylistsHash() => r'3bd870fa738e5fd5981fcdb6de0d0affdd12ddd1';

/// The tracks of a playlist, album or the liked songs, to look into it before playing.

@ProviderFor(spotifyTracks)
final spotifyTracksProvider = SpotifyTracksFamily._();

/// The tracks of a playlist, album or the liked songs, to look into it before playing.

final class SpotifyTracksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QueueItem>>,
          List<QueueItem>,
          FutureOr<List<QueueItem>>
        >
    with $FutureModifier<List<QueueItem>>, $FutureProvider<List<QueueItem>> {
  /// The tracks of a playlist, album or the liked songs, to look into it before playing.
  SpotifyTracksProvider._({
    required SpotifyTracksFamily super.from,
    required MediaItem super.argument,
  }) : super(
         retry: null,
         name: r'spotifyTracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spotifyTracksHash();

  @override
  String toString() {
    return r'spotifyTracksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<QueueItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QueueItem>> create(Ref ref) {
    final argument = this.argument as MediaItem;
    return spotifyTracks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpotifyTracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spotifyTracksHash() => r'1aaca1393f482ee9b9a89372a9f56cdff71b2947';

/// The tracks of a playlist, album or the liked songs, to look into it before playing.

final class SpotifyTracksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<QueueItem>>, MediaItem> {
  SpotifyTracksFamily._()
    : super(
        retry: null,
        name: r'spotifyTracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The tracks of a playlist, album or the liked songs, to look into it before playing.

  SpotifyTracksProvider call(MediaItem item) =>
      SpotifyTracksProvider._(argument: item, from: this);

  @override
  String toString() => r'spotifyTracksProvider';
}
