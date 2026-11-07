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
final class SpotifyConnectServiceProvider
    extends $AsyncNotifierProvider<SpotifyConnectService, SpotifyConnectState> {
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

String _$spotifyConnectServiceHash() =>
    r'24af01aabbffec058f11854810c1412587e8a17e';

/// Spotify Connect, polled every [spotifyConnectInterval] while someone listens (Spotify has no push for this),
/// and the playback commands. Empty while signed out.
///
/// Commands show at once (optimistic) and roll back when Spotify does not report the change in time or the command
/// fails (`README` → "Optimistic UI").

abstract class _$SpotifyConnectService
    extends $AsyncNotifier<SpotifyConnectState> {
  FutureOr<SpotifyConnectState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SpotifyConnectState>, SpotifyConnectState>;
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
    extends
        $FunctionalProvider<
          AsyncValue<List<QueueItem>>,
          List<QueueItem>,
          FutureOr<List<QueueItem>>
        >
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
  $FutureProviderElement<List<QueueItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QueueItem>> create(Ref ref) {
    return spotifyQueue(ref);
  }
}

String _$spotifyQueueHash() => r'083be06913ab09fbc8e7b4b97a0b0e5236ceaa2a';

/// The play queue of [speakerId]: its own, or Spotify's while it plays music sent to it with Spotify (it has none of
/// its own then) and Spotify plays the same track. Reloads when the track changes.

@ProviderFor(speakerQueue)
final speakerQueueProvider = SpeakerQueueFamily._();

/// The play queue of [speakerId]: its own, or Spotify's while it plays music sent to it with Spotify (it has none of
/// its own then) and Spotify plays the same track. Reloads when the track changes.

final class SpeakerQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QueueItem>?>,
          List<QueueItem>?,
          FutureOr<List<QueueItem>?>
        >
    with $FutureModifier<List<QueueItem>?>, $FutureProvider<List<QueueItem>?> {
  /// The play queue of [speakerId]: its own, or Spotify's while it plays music sent to it with Spotify (it has none of
  /// its own then) and Spotify plays the same track. Reloads when the track changes.
  SpeakerQueueProvider._({
    required SpeakerQueueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'speakerQueueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$speakerQueueHash();

  @override
  String toString() {
    return r'speakerQueueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<QueueItem>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QueueItem>?> create(Ref ref) {
    final argument = this.argument as String;
    return speakerQueue(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpeakerQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speakerQueueHash() => r'7446430b0e9aa425fc9bf86d5c92bb113b5d184b';

/// The play queue of [speakerId]: its own, or Spotify's while it plays music sent to it with Spotify (it has none of
/// its own then) and Spotify plays the same track. Reloads when the track changes.

final class SpeakerQueueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<QueueItem>?>, String> {
  SpeakerQueueFamily._()
    : super(
        retry: null,
        name: r'speakerQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The play queue of [speakerId]: its own, or Spotify's while it plays music sent to it with Spotify (it has none of
  /// its own then) and Spotify plays the same track. Reloads when the track changes.

  SpeakerQueueProvider call(String speakerId) =>
      SpeakerQueueProvider._(argument: speakerId, from: this);

  @override
  String toString() => r'speakerQueueProvider';
}
