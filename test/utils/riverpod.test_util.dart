import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show $ProviderOverride;
import 'package:smart_hub/common/config/perenual_config.dart';
import 'package:smart_hub/common/config/spotify_config.dart';

Duration? _noRetry(int retryCount, Object error) => null;

/// `ProviderContainer` for tests: no retry, disposed at the end of the test.
///
/// Riverpod 3 retries failing providers with backoff – expected errors would never arrive and timers
/// would still be pending when the test ends. Pass [retry] explicitly to test retry behaviour.
///
/// The app keys from `.env` are left out (Spotify and the plant database unconfigured), so no test depends on them;
/// a test that needs them overrides the config in [overrides].
ProviderContainer createTestContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
  Duration? Function(int retryCount, Object error)? retry = _noRetry,
}) {
  final keys = [
    spotifyConfigProvider.overrideWithValue(const SpotifyConfig(clientId: '', redirectUri: '')),
    perenualConfigProvider.overrideWithValue(const PerenualConfig(apiKey: '')),
  ];
  final overridden = {for (final override in overrides) _originOf(override)};
  final container = ProviderContainer(
    parent: parent,
    overrides: [
      ...overrides,
      if (parent == null)
        for (final key in keys)
          if (!overridden.contains(_originOf(key))) key,
    ],
    observers: observers,
    retry: retry,
  );
  addTearDown(container.dispose);
  return container;
}

Object? _originOf(Override override) => override is $ProviderOverride ? override.origin : null;
