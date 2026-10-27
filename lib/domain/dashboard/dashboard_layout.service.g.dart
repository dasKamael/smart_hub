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

String _$dashboardLayoutServiceHash() => r'bb8d330ef05a8ceb1ab8df810ade43b5ab5ef831';

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
