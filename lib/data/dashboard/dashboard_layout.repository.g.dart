// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_layout.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(dashboardLayoutRepository)
final dashboardLayoutRepositoryProvider = DashboardLayoutRepositoryProvider._();

/// Providers

final class DashboardLayoutRepositoryProvider
    extends $FunctionalProvider<DashboardLayoutRepository, DashboardLayoutRepository, DashboardLayoutRepository>
    with $Provider<DashboardLayoutRepository> {
  /// Providers
  DashboardLayoutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardLayoutRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardLayoutRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardLayoutRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DashboardLayoutRepository create(Ref ref) {
    return dashboardLayoutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardLayoutRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DashboardLayoutRepository>(value));
  }
}

String _$dashboardLayoutRepositoryHash() => r'dcd67c8c8ce83f56924faabf8b3d1ea3d003aa3f';
