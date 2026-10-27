// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hue_bridge.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(hueBridgeRepository)
final hueBridgeRepositoryProvider = HueBridgeRepositoryProvider._();

/// Providers

final class HueBridgeRepositoryProvider
    extends $FunctionalProvider<HueBridgeRepository, HueBridgeRepository, HueBridgeRepository>
    with $Provider<HueBridgeRepository> {
  /// Providers
  HueBridgeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hueBridgeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hueBridgeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HueBridgeRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  HueBridgeRepository create(Ref ref) {
    return hueBridgeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HueBridgeRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<HueBridgeRepository>(value));
  }
}

String _$hueBridgeRepositoryHash() => r'edd35601daf968ef3488f7a19b3fb20c121d7ba5';

/// The paired bridge; `null` when there is none.

@ProviderFor(HueBridgeConfig)
final hueBridgeConfigProvider = HueBridgeConfigProvider._();

/// The paired bridge; `null` when there is none.
final class HueBridgeConfigProvider extends $AsyncNotifierProvider<HueBridgeConfig, LightBridge?> {
  /// The paired bridge; `null` when there is none.
  HueBridgeConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hueBridgeConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hueBridgeConfigHash();

  @$internal
  @override
  HueBridgeConfig create() => HueBridgeConfig();
}

String _$hueBridgeConfigHash() => r'6ddd327bc57b8ecf08181ddb7f27c40d64152f09';

/// The paired bridge; `null` when there is none.

abstract class _$HueBridgeConfig extends $AsyncNotifier<LightBridge?> {
  FutureOr<LightBridge?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LightBridge?>, LightBridge?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LightBridge?>, LightBridge?>,
              AsyncValue<LightBridge?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
