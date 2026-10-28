// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perenual_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(perenualConfig)
final perenualConfigProvider = PerenualConfigProvider._();

final class PerenualConfigProvider
    extends $FunctionalProvider<PerenualConfig, PerenualConfig, PerenualConfig>
    with $Provider<PerenualConfig> {
  PerenualConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'perenualConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$perenualConfigHash();

  @$internal
  @override
  $ProviderElement<PerenualConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PerenualConfig create(Ref ref) {
    return perenualConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PerenualConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PerenualConfig>(value),
    );
  }
}

String _$perenualConfigHash() => r'94485c2af5234b3491ba1668b8dfeb8c82e23417';
