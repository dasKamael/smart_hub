// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the hub is the home screen of the tablet (kiosk).

@ProviderFor(HomeAppController)
final homeAppControllerProvider = HomeAppControllerProvider._();

/// Whether the hub is the home screen of the tablet (kiosk).
final class HomeAppControllerProvider
    extends $AsyncNotifierProvider<HomeAppController, bool> {
  /// Whether the hub is the home screen of the tablet (kiosk).
  HomeAppControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeAppControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeAppControllerHash();

  @$internal
  @override
  HomeAppController create() => HomeAppController();
}

String _$homeAppControllerHash() => r'd2d9dfc830dcb390ab70852d692f7ebc4e8a5747';

/// Whether the hub is the home screen of the tablet (kiosk).

abstract class _$HomeAppController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Connecting and disconnecting Spotify; [build] holds the last sign-in error.

@ProviderFor(SpotifyConnectController)
final spotifyConnectControllerProvider = SpotifyConnectControllerProvider._();

/// Connecting and disconnecting Spotify; [build] holds the last sign-in error.
final class SpotifyConnectControllerProvider
    extends
        $NotifierProvider<
          SpotifyConnectController,
          ({bool busy, String? error})
        > {
  /// Connecting and disconnecting Spotify; [build] holds the last sign-in error.
  SpotifyConnectControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyConnectControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyConnectControllerHash();

  @$internal
  @override
  SpotifyConnectController create() => SpotifyConnectController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({bool busy, String? error}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({bool busy, String? error})>(value),
    );
  }
}

String _$spotifyConnectControllerHash() =>
    r'a527f655649800189da04dd4a29fd70f02c87ddc';

/// Connecting and disconnecting Spotify; [build] holds the last sign-in error.

abstract class _$SpotifyConnectController
    extends $Notifier<({bool busy, String? error})> {
  ({bool busy, String? error}) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<({bool busy, String? error}), ({bool busy, String? error})>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({bool busy, String? error}),
                ({bool busy, String? error})
              >,
              ({bool busy, String? error}),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
