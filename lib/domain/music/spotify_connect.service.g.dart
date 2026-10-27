// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_connect.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spotify Connect, polled every [spotifyConnectInterval] while someone listens (Spotify has no push for this),
/// and the playback commands. Empty while signed out.
///
/// Commands show at once (optimistic) and roll back when Spotify does not report the change in time or the command
/// fails (`README` → "Optimistic UI").

@ProviderFor(SpotifyConnectService)
final spotifyConnectServiceProvider = SpotifyConnectServiceProvider._();

/// Spotify Connect, polled every [spotifyConnectInterval] while someone listens (Spotify has no push for this),
/// and the playback commands. Empty while signed out.
///
/// Commands show at once (optimistic) and roll back when Spotify does not report the change in time or the command
/// fails (`README` → "Optimistic UI").
final class SpotifyConnectServiceProvider extends $AsyncNotifierProvider<SpotifyConnectService, SpotifyConnectState> {
  /// Spotify Connect, polled every [spotifyConnectInterval] while someone listens (Spotify has no push for this),
  /// and the playback commands. Empty while signed out.
  ///
  /// Commands show at once (optimistic) and roll back when Spotify does not report the change in time or the command
  /// fails (`README` → "Optimistic UI").
  SpotifyConnectServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyConnectServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyConnectServiceHash();

  @$internal
  @override
  SpotifyConnectService create() => SpotifyConnectService();
}

String _$spotifyConnectServiceHash() => r'052275257bce698afbb807346a8e92a88dda79e3';

/// Spotify Connect, polled every [spotifyConnectInterval] while someone listens (Spotify has no push for this),
/// and the playback commands. Empty while signed out.
///
/// Commands show at once (optimistic) and roll back when Spotify does not report the change in time or the command
/// fails (`README` → "Optimistic UI").

abstract class _$SpotifyConnectService extends $AsyncNotifier<SpotifyConnectState> {
  FutureOr<SpotifyConnectState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SpotifyConnectState>, SpotifyConnectState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotifyConnectState>, SpotifyConnectState>,
              AsyncValue<SpotifyConnectState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Spotify's play queue; reloaded when the track changes.

@ProviderFor(spotifyQueue)
final spotifyQueueProvider = SpotifyQueueProvider._();

/// Spotify's play queue; reloaded when the track changes.

final class SpotifyQueueProvider
    extends $FunctionalProvider<AsyncValue<List<QueueItem>>, List<QueueItem>, FutureOr<List<QueueItem>>>
    with $FutureModifier<List<QueueItem>>, $FutureProvider<List<QueueItem>> {
  /// Spotify's play queue; reloaded when the track changes.
  SpotifyQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyQueueHash();

  @$internal
  @override
  $FutureProviderElement<List<QueueItem>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QueueItem>> create(Ref ref) {
    return spotifyQueue(ref);
  }
}

String _$spotifyQueueHash() => r'083be06913ab09fbc8e7b4b97a0b0e5236ceaa2a';
