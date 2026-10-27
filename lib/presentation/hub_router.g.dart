// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App router. Shows the setup screen until a connection is configured.

@ProviderFor(hubRouter)
final hubRouterProvider = HubRouterProvider._();

/// App router. Shows the setup screen until a connection is configured.

final class HubRouterProvider extends $FunctionalProvider<GoRouter, GoRouter, GoRouter> with $Provider<GoRouter> {
  /// App router. Shows the setup screen until a connection is configured.
  HubRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hubRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hubRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return hubRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GoRouter>(value));
  }
}

String _$hubRouterHash() => r'a4325084790cdaea4f172be75a86c334ef616bec';
