// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Editing the dashboard like the iPad home screen: long press to jiggle, drag to move (the others make room),
/// drag the corner to resize, remove and add.

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

/// Editing the dashboard like the iPad home screen: long press to jiggle, drag to move (the others make room),
/// drag the corner to resize, remove and add.
final class DashboardControllerProvider extends $NotifierProvider<DashboardController, DashboardPageState> {
  /// Editing the dashboard like the iPad home screen: long press to jiggle, drag to move (the others make room),
  /// drag the corner to resize, remove and add.
  DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardPageState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DashboardPageState>(value));
  }
}

String _$dashboardControllerHash() => r'50bfb4421a5270692dc0f248aa2b64fab25223f4';

/// Editing the dashboard like the iPad home screen: long press to jiggle, drag to move (the others make room),
/// drag the corner to resize, remove and add.

abstract class _$DashboardController extends $Notifier<DashboardPageState> {
  DashboardPageState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DashboardPageState, DashboardPageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DashboardPageState, DashboardPageState>,
              DashboardPageState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(dashboardLayout)
final dashboardLayoutProvider = DashboardLayoutProvider._();

final class DashboardLayoutProvider extends $FunctionalProvider<DashboardLayout, DashboardLayout, DashboardLayout>
    with $Provider<DashboardLayout> {
  DashboardLayoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardLayoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardLayoutHash();

  @$internal
  @override
  $ProviderElement<DashboardLayout> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DashboardLayout create(Ref ref) {
    return dashboardLayout(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardLayout value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DashboardLayout>(value));
  }
}

String _$dashboardLayoutHash() => r'07020a950408db92a3560508386d9a9d63abf740';
