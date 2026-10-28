// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The focus points and what you can do with them: take one on, say it is done, change it, drop it. At most
/// [maxActive] are active at a time – a fourth one only goes in once another is done or dropped.

@ProviderFor(FocusService)
final focusServiceProvider = FocusServiceProvider._();

/// The focus points and what you can do with them: take one on, say it is done, change it, drop it. At most
/// [maxActive] are active at a time – a fourth one only goes in once another is done or dropped.
final class FocusServiceProvider
    extends $StreamNotifierProvider<FocusService, List<FocusPoint>> {
  /// The focus points and what you can do with them: take one on, say it is done, change it, drop it. At most
  /// [maxActive] are active at a time – a fourth one only goes in once another is done or dropped.
  FocusServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusServiceHash();

  @$internal
  @override
  FocusService create() => FocusService();
}

String _$focusServiceHash() => r'e2392dfbf43ffdd41e8e7baa40ffcf60e6f1d23f';

/// The focus points and what you can do with them: take one on, say it is done, change it, drop it. At most
/// [maxActive] are active at a time – a fourth one only goes in once another is done or dropped.

abstract class _$FocusService extends $StreamNotifier<List<FocusPoint>> {
  Stream<List<FocusPoint>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FocusPoint>>, List<FocusPoint>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FocusPoint>>, List<FocusPoint>>,
              AsyncValue<List<FocusPoint>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The focus points still to do, in their order, at most [FocusService.maxActive].

@ProviderFor(activeFocusPoints)
final activeFocusPointsProvider = ActiveFocusPointsProvider._();

/// The focus points still to do, in their order, at most [FocusService.maxActive].

final class ActiveFocusPointsProvider
    extends
        $FunctionalProvider<
          List<FocusPoint>,
          List<FocusPoint>,
          List<FocusPoint>
        >
    with $Provider<List<FocusPoint>> {
  /// The focus points still to do, in their order, at most [FocusService.maxActive].
  ActiveFocusPointsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeFocusPointsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeFocusPointsHash();

  @$internal
  @override
  $ProviderElement<List<FocusPoint>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<FocusPoint> create(Ref ref) {
    return activeFocusPoints(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FocusPoint> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FocusPoint>>(value),
    );
  }
}

String _$activeFocusPointsHash() => r'4a284fdec9c3626d7bf2017ca70366a704aaeeb6';

/// What is done, newest first.

@ProviderFor(achievedFocusPoints)
final achievedFocusPointsProvider = AchievedFocusPointsProvider._();

/// What is done, newest first.

final class AchievedFocusPointsProvider
    extends
        $FunctionalProvider<
          List<FocusPoint>,
          List<FocusPoint>,
          List<FocusPoint>
        >
    with $Provider<List<FocusPoint>> {
  /// What is done, newest first.
  AchievedFocusPointsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievedFocusPointsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievedFocusPointsHash();

  @$internal
  @override
  $ProviderElement<List<FocusPoint>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<FocusPoint> create(Ref ref) {
    return achievedFocusPoints(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FocusPoint> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FocusPoint>>(value),
    );
  }
}

String _$achievedFocusPointsHash() =>
    r'dbd01d414bd829a3b5fa87d7c6cad0d4582afdc1';
