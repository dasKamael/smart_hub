// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floorplan.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(floorplanRepository)
final floorplanRepositoryProvider = FloorplanRepositoryProvider._();

/// Providers

final class FloorplanRepositoryProvider
    extends
        $FunctionalProvider<
          FloorplanRepository,
          FloorplanRepository,
          FloorplanRepository
        >
    with $Provider<FloorplanRepository> {
  /// Providers
  FloorplanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'floorplanRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$floorplanRepositoryHash();

  @$internal
  @override
  $ProviderElement<FloorplanRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FloorplanRepository create(Ref ref) {
    return floorplanRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FloorplanRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FloorplanRepository>(value),
    );
  }
}

String _$floorplanRepositoryHash() =>
    r'3cb1fda506c8089ff569c0e8249911a2fae0f142';
