// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_location.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(deviceLocationRepository)
final deviceLocationRepositoryProvider = DeviceLocationRepositoryProvider._();

/// Providers

final class DeviceLocationRepositoryProvider
    extends
        $FunctionalProvider<
          DeviceLocationRepository,
          DeviceLocationRepository,
          DeviceLocationRepository
        >
    with $Provider<DeviceLocationRepository> {
  /// Providers
  DeviceLocationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceLocationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceLocationRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeviceLocationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceLocationRepository create(Ref ref) {
    return deviceLocationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceLocationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceLocationRepository>(value),
    );
  }
}

String _$deviceLocationRepositoryHash() =>
    r'4100c39d9679c0d56502d7b937cc40c0e02a8e44';
