// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installed_apps.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(installedAppsRepository)
final installedAppsRepositoryProvider = InstalledAppsRepositoryProvider._();

/// Providers

final class InstalledAppsRepositoryProvider
    extends
        $FunctionalProvider<
          InstalledAppsRepository,
          InstalledAppsRepository,
          InstalledAppsRepository
        >
    with $Provider<InstalledAppsRepository> {
  /// Providers
  InstalledAppsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedAppsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedAppsRepositoryHash();

  @$internal
  @override
  $ProviderElement<InstalledAppsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InstalledAppsRepository create(Ref ref) {
    return installedAppsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstalledAppsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstalledAppsRepository>(value),
    );
  }
}

String _$installedAppsRepositoryHash() =>
    r'b455307ade8cad6d6de9f06f2b6caad62c963b16';
