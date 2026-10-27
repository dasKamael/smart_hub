// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonos_config.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(sonosHttpClient)
final sonosHttpClientProvider = SonosHttpClientProvider._();

/// Providers

final class SonosHttpClientProvider extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  /// Providers
  SonosHttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sonosHttpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sonosHttpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return sonosHttpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<http.Client>(value));
  }
}

String _$sonosHttpClientHash() => r'2cad7dd447d5f8f0a8ad0a13f9062b04687c3fbc';

@ProviderFor(sonosConfigRepository)
final sonosConfigRepositoryProvider = SonosConfigRepositoryProvider._();

final class SonosConfigRepositoryProvider
    extends $FunctionalProvider<SonosConfigRepository, SonosConfigRepository, SonosConfigRepository>
    with $Provider<SonosConfigRepository> {
  SonosConfigRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sonosConfigRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sonosConfigRepositoryHash();

  @$internal
  @override
  $ProviderElement<SonosConfigRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SonosConfigRepository create(Ref ref) {
    return sonosConfigRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SonosConfigRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SonosConfigRepository>(value));
  }
}

String _$sonosConfigRepositoryHash() => r'd7bfa1fa763e6dab36452266bbac711512155c92';

/// The addresses of the speakers the hub talks to directly; empty when the speakers come from Home Assistant.

@ProviderFor(SonosHosts)
final sonosHostsProvider = SonosHostsProvider._();

/// The addresses of the speakers the hub talks to directly; empty when the speakers come from Home Assistant.
final class SonosHostsProvider extends $AsyncNotifierProvider<SonosHosts, List<String>> {
  /// The addresses of the speakers the hub talks to directly; empty when the speakers come from Home Assistant.
  SonosHostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sonosHostsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sonosHostsHash();

  @$internal
  @override
  SonosHosts create() => SonosHosts();
}

String _$sonosHostsHash() => r'dc4b4eb4845b098768ff4dfdd419a168417b027f';

/// The addresses of the speakers the hub talks to directly; empty when the speakers come from Home Assistant.

abstract class _$SonosHosts extends $AsyncNotifier<List<String>> {
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
