// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installed_apps.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The apps on the tablet, loaded while something shows them, and opening one.

@ProviderFor(InstalledAppsService)
final installedAppsServiceProvider = InstalledAppsServiceProvider._();

/// The apps on the tablet, loaded while something shows them, and opening one.
final class InstalledAppsServiceProvider extends $AsyncNotifierProvider<InstalledAppsService, List<InstalledApp>> {
  /// The apps on the tablet, loaded while something shows them, and opening one.
  InstalledAppsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedAppsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedAppsServiceHash();

  @$internal
  @override
  InstalledAppsService create() => InstalledAppsService();
}

String _$installedAppsServiceHash() => r'd2d50544453625494f77c223540f777de2115201';

/// The apps on the tablet, loaded while something shows them, and opening one.

abstract class _$InstalledAppsService extends $AsyncNotifier<List<InstalledApp>> {
  FutureOr<List<InstalledApp>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<InstalledApp>>, List<InstalledApp>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<InstalledApp>>, List<InstalledApp>>,
              AsyncValue<List<InstalledApp>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
