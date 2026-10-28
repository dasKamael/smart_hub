// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zen.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Minutes without a touch until the zen mode starts; 0 = only by hand.

@ProviderFor(ZenIdleService)
final zenIdleServiceProvider = ZenIdleServiceProvider._();

/// Minutes without a touch until the zen mode starts; 0 = only by hand.
final class ZenIdleServiceProvider
    extends $StreamNotifierProvider<ZenIdleService, int> {
  /// Minutes without a touch until the zen mode starts; 0 = only by hand.
  ZenIdleServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zenIdleServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zenIdleServiceHash();

  @$internal
  @override
  ZenIdleService create() => ZenIdleService();
}

String _$zenIdleServiceHash() => r'6327fa9c559efa7e098364026150439ad5572eeb';

/// Minutes without a touch until the zen mode starts; 0 = only by hand.

abstract class _$ZenIdleService extends $StreamNotifier<int> {
  Stream<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
