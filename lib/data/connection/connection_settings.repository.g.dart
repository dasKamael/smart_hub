// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_settings.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(connectionSettingsRepository)
final connectionSettingsRepositoryProvider = ConnectionSettingsRepositoryProvider._();

/// Providers

final class ConnectionSettingsRepositoryProvider
    extends
        $FunctionalProvider<ConnectionSettingsRepository, ConnectionSettingsRepository, ConnectionSettingsRepository>
    with $Provider<ConnectionSettingsRepository> {
  /// Providers
  ConnectionSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConnectionSettingsRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ConnectionSettingsRepository create(Ref ref) {
    return connectionSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectionSettingsRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ConnectionSettingsRepository>(value));
  }
}

String _$connectionSettingsRepositoryHash() => r'292ac849d905d08b81f1a9f984b54a4d6dc97ccd';
