// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_speakers.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Speakers the hub talks to directly in the home network instead of through Home Assistant, by address. Empty
/// when the speakers come from Home Assistant.

@ProviderFor(NetworkSpeakersService)
final networkSpeakersServiceProvider = NetworkSpeakersServiceProvider._();

/// Speakers the hub talks to directly in the home network instead of through Home Assistant, by address. Empty
/// when the speakers come from Home Assistant.
final class NetworkSpeakersServiceProvider
    extends $AsyncNotifierProvider<NetworkSpeakersService, List<String>> {
  /// Speakers the hub talks to directly in the home network instead of through Home Assistant, by address. Empty
  /// when the speakers come from Home Assistant.
  NetworkSpeakersServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkSpeakersServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkSpeakersServiceHash();

  @$internal
  @override
  NetworkSpeakersService create() => NetworkSpeakersService();
}

String _$networkSpeakersServiceHash() =>
    r'0f72364c5461b597c51a76d345c801a3fbdc54a0';

/// Speakers the hub talks to directly in the home network instead of through Home Assistant, by address. Empty
/// when the speakers come from Home Assistant.

abstract class _$NetworkSpeakersService extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the speakers can be controlled right now: the network speakers answer, or Home Assistant is online.

@ProviderFor(speakersOnline)
final speakersOnlineProvider = SpeakersOnlineProvider._();

/// Whether the speakers can be controlled right now: the network speakers answer, or Home Assistant is online.

final class SpeakersOnlineProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the speakers can be controlled right now: the network speakers answer, or Home Assistant is online.
  SpeakersOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakersOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakersOnlineHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return speakersOnline(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$speakersOnlineHash() => r'07bfc2cf7592cd5cbd238ec2a783238dd45dbb8f';

@ProviderFor(_networkSpeakersOnline)
final _networkSpeakersOnlineProvider = _NetworkSpeakersOnlineProvider._();

final class _NetworkSpeakersOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  _NetworkSpeakersOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_networkSpeakersOnlineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_networkSpeakersOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return _networkSpeakersOnline(ref);
  }
}

String _$_networkSpeakersOnlineHash() =>
    r'281ca11126559502a6115ce220ebd0d65fff9bc9';
