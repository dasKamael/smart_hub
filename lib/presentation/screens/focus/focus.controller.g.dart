// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The focus widget: saying a point is done, dropping it and saving the editor.

@ProviderFor(FocusController)
final focusControllerProvider = FocusControllerProvider._();

/// The focus widget: saying a point is done, dropping it and saving the editor.
final class FocusControllerProvider
    extends $NotifierProvider<FocusController, String?> {
  /// The focus widget: saying a point is done, dropping it and saving the editor.
  FocusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusControllerHash();

  @$internal
  @override
  FocusController create() => FocusController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$focusControllerHash() => r'7512079e08737697d395cf7cd18d12be70d33bfa';

/// The focus widget: saying a point is done, dropping it and saving the editor.

abstract class _$FocusController extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The focus points still to do with their countdown, the most pressing one first.

@ProviderFor(focusPlan)
final focusPlanProvider = FocusPlanProvider._();

/// The focus points still to do with their countdown, the most pressing one first.

final class FocusPlanProvider
    extends
        $FunctionalProvider<
          List<FocusEntry>,
          List<FocusEntry>,
          List<FocusEntry>
        >
    with $Provider<List<FocusEntry>> {
  /// The focus points still to do with their countdown, the most pressing one first.
  FocusPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusPlanHash();

  @$internal
  @override
  $ProviderElement<List<FocusEntry>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<FocusEntry> create(Ref ref) {
    return focusPlan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FocusEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FocusEntry>>(value),
    );
  }
}

String _$focusPlanHash() => r'05a71dccd9946154f7e822ba17928ee62bc34e90';

/// The color of the focus area: it warms as the days run out.

@ProviderFor(focusTint)
final focusTintProvider = FocusTintProvider._();

/// The color of the focus area: it warms as the days run out.

final class FocusTintProvider extends $FunctionalProvider<Color, Color, Color>
    with $Provider<Color> {
  /// The color of the focus area: it warms as the days run out.
  FocusTintProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'focusTintProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$focusTintHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return focusTint(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$focusTintHash() => r'bcaa45d22f05b8cf35298e3df2c0594318df4ec1';
