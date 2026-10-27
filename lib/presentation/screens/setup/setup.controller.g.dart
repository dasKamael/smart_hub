// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetupController)
final setupControllerProvider = SetupControllerProvider._();

final class SetupControllerProvider extends $NotifierProvider<SetupController, SetupState> {
  SetupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupControllerHash();

  @$internal
  @override
  SetupController create() => SetupController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetupState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SetupState>(value));
  }
}

String _$setupControllerHash() => r'd11e81b39ba4b9569a6adc0959a273cb0e977a4c';

abstract class _$SetupController extends $Notifier<SetupState> {
  SetupState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SetupState, SetupState>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<SetupState, SetupState>, SetupState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
