// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(spotifyRepository)
final spotifyRepositoryProvider = SpotifyRepositoryProvider._();

/// Providers

final class SpotifyRepositoryProvider
    extends
        $FunctionalProvider<
          SpotifyRepository,
          SpotifyRepository,
          SpotifyRepository
        >
    with $Provider<SpotifyRepository> {
  /// Providers
  SpotifyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpotifyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpotifyRepository create(Ref ref) {
    return spotifyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotifyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotifyRepository>(value),
    );
  }
}

String _$spotifyRepositoryHash() => r'6ba65c96d4cf8ceb783b46d61ec1b2309eea361d';
