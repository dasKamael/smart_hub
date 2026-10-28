// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_auth.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(spotifyAuthRepository)
final spotifyAuthRepositoryProvider = SpotifyAuthRepositoryProvider._();

/// Providers

final class SpotifyAuthRepositoryProvider
    extends
        $FunctionalProvider<
          SpotifyAuthRepository,
          SpotifyAuthRepository,
          SpotifyAuthRepository
        >
    with $Provider<SpotifyAuthRepository> {
  /// Providers
  SpotifyAuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyAuthRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyAuthRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpotifyAuthRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpotifyAuthRepository create(Ref ref) {
    return spotifyAuthRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotifyAuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotifyAuthRepository>(value),
    );
  }
}

String _$spotifyAuthRepositoryHash() =>
    r'29996d9160749e88c4c8ea492a2afb76bc44a4b0';
