// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_layout.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The widgets on the dashboard in their order. Changes are only made when everything still fits on the page.
///
/// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
/// other instead of on what the database reports back later.

@ProviderFor(DashboardLayoutService)
final dashboardLayoutServiceProvider = DashboardLayoutServiceProvider._();

/// The widgets on the dashboard in their order. Changes are only made when everything still fits on the page.
///
/// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
/// other instead of on what the database reports back later.
final class DashboardLayoutServiceProvider
    extends $AsyncNotifierProvider<DashboardLayoutService, List<DashboardWidget>> {
  /// The widgets on the dashboard in their order. Changes are only made when everything still fits on the page.
  ///
  /// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
  /// other instead of on what the database reports back later.
  DashboardLayoutServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardLayoutServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardLayoutServiceHash();

  @$internal
  @override
  DashboardLayoutService create() => DashboardLayoutService();
}

String _$dashboardLayoutServiceHash() => r'b0a8896a7f5b796bb905f84f7f7b67b704a8e241';

/// The widgets on the dashboard in their order. Changes are only made when everything still fits on the page.
///
/// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
/// other instead of on what the database reports back later.

abstract class _$DashboardLayoutService extends $AsyncNotifier<List<DashboardWidget>> {
  FutureOr<List<DashboardWidget>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<DashboardWidget>>, List<DashboardWidget>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DashboardWidget>>, List<DashboardWidget>>,
              AsyncValue<List<DashboardWidget>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
