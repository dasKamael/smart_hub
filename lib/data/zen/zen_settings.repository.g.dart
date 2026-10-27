// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zen_settings.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(zenSettingsRepository)
final zenSettingsRepositoryProvider = ZenSettingsRepositoryProvider._();

/// Providers

final class ZenSettingsRepositoryProvider
    extends $FunctionalProvider<ZenSettingsRepository, ZenSettingsRepository, ZenSettingsRepository>
    with $Provider<ZenSettingsRepository> {
  /// Providers
  ZenSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zenSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zenSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ZenSettingsRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ZenSettingsRepository create(Ref ref) {
    return zenSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZenSettingsRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ZenSettingsRepository>(value));
  }
}

String _$zenSettingsRepositoryHash() => r'b678f57704ca01020582482c8e45d598a04f8792';
