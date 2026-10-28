// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(kiosk)
final kioskProvider = KioskProvider._();

final class KioskProvider extends $FunctionalProvider<Kiosk, Kiosk, Kiosk>
    with $Provider<Kiosk> {
  KioskProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kioskProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kioskHash();

  @$internal
  @override
  $ProviderElement<Kiosk> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Kiosk create(Ref ref) {
    return kiosk(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Kiosk value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Kiosk>(value),
    );
  }
}

String _$kioskHash() => r'b79e7aa4cec26b077454f8c02046e10275e1c287';
