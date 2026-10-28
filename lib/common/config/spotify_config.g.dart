// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(spotifyConfig)
final spotifyConfigProvider = SpotifyConfigProvider._();

final class SpotifyConfigProvider
    extends $FunctionalProvider<SpotifyConfig, SpotifyConfig, SpotifyConfig>
    with $Provider<SpotifyConfig> {
  SpotifyConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyConfigHash();

  @$internal
  @override
  $ProviderElement<SpotifyConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SpotifyConfig create(Ref ref) {
    return spotifyConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotifyConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotifyConfig>(value),
    );
  }
}

String _$spotifyConfigHash() => r'ff0338895f4b17dc7ab71b4b4e0d9e092a7ef649';
