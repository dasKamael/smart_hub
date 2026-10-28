// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_layout.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The widgets on the dashboard and where they were put. Changes are only made when everything still fits on the
/// page; once changed, every widget keeps its cell.
///
/// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
/// other instead of on what the database reports back later.

@ProviderFor(DashboardLayoutService)
final dashboardLayoutServiceProvider = DashboardLayoutServiceProvider._();

/// The widgets on the dashboard and where they were put. Changes are only made when everything still fits on the
/// page; once changed, every widget keeps its cell.
///
/// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
/// other instead of on what the database reports back later.
final class DashboardLayoutServiceProvider
    extends
        $AsyncNotifierProvider<DashboardLayoutService, List<DashboardWidget>> {
  /// The widgets on the dashboard and where they were put. Changes are only made when everything still fits on the
  /// page; once changed, every widget keeps its cell.
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

String _$dashboardLayoutServiceHash() =>
    r'dc8dece64a7b4b92f456ca8132f37bb1fdc86eb3';

/// The widgets on the dashboard and where they were put. Changes are only made when everything still fits on the
/// page; once changed, every widget keeps its cell.
///
/// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
/// other instead of on what the database reports back later.

abstract class _$DashboardLayoutService
    extends $AsyncNotifier<List<DashboardWidget>> {
  FutureOr<List<DashboardWidget>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<DashboardWidget>>, List<DashboardWidget>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<DashboardWidget>>,
                List<DashboardWidget>
              >,
              AsyncValue<List<DashboardWidget>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
