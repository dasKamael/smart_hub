// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perenual.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(perenualRepository)
final perenualRepositoryProvider = PerenualRepositoryProvider._();

/// Providers

final class PerenualRepositoryProvider
    extends
        $FunctionalProvider<
          PerenualRepository,
          PerenualRepository,
          PerenualRepository
        >
    with $Provider<PerenualRepository> {
  /// Providers
  PerenualRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'perenualRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$perenualRepositoryHash();

  @$internal
  @override
  $ProviderElement<PerenualRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PerenualRepository create(Ref ref) {
    return perenualRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PerenualRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PerenualRepository>(value),
    );
  }
}

String _$perenualRepositoryHash() =>
    r'828cff25477ee1e71440b4fa680bc6de28161360';
