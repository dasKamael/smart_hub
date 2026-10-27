// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zen.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the zen mode is shown. It starts after the set minutes without a touch, or by hand.

@ProviderFor(ZenController)
final zenControllerProvider = ZenControllerProvider._();

/// Whether the zen mode is shown. It starts after the set minutes without a touch, or by hand.
final class ZenControllerProvider extends $NotifierProvider<ZenController, bool> {
  /// Whether the zen mode is shown. It starts after the set minutes without a touch, or by hand.
  ZenControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zenControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zenControllerHash();

  @$internal
  @override
  ZenController create() => ZenController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$zenControllerHash() => r'197c3b246edeaf99f66d025532a3ef0d532bdcd4';

/// Whether the zen mode is shown. It starts after the set minutes without a touch, or by hand.

abstract class _$ZenController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
