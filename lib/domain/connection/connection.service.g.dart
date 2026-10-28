// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The saved connection. `null` means the hub is not set up yet.

@ProviderFor(ConnectionConfigService)
final connectionConfigServiceProvider = ConnectionConfigServiceProvider._();

/// The saved connection. `null` means the hub is not set up yet.
final class ConnectionConfigServiceProvider
    extends $AsyncNotifierProvider<ConnectionConfigService, ConnectionConfig?> {
  /// The saved connection. `null` means the hub is not set up yet.
  ConnectionConfigServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionConfigServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionConfigServiceHash();

  @$internal
  @override
  ConnectionConfigService create() => ConnectionConfigService();
}

String _$connectionConfigServiceHash() =>
    r'ecd7daf6768c20bf832aaffa770f20f7a153c48f';

/// The saved connection. `null` means the hub is not set up yet.

abstract class _$ConnectionConfigService
    extends $AsyncNotifier<ConnectionConfig?> {
  FutureOr<ConnectionConfig?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ConnectionConfig?>, ConnectionConfig?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ConnectionConfig?>, ConnectionConfig?>,
              AsyncValue<ConnectionConfig?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether Home Assistant (or the demo home) provides lights and speakers. Without it, their parts are hidden or
/// explain how to connect.

@ProviderFor(hasHomeAssistant)
final hasHomeAssistantProvider = HasHomeAssistantProvider._();

/// Whether Home Assistant (or the demo home) provides lights and speakers. Without it, their parts are hidden or
/// explain how to connect.

final class HasHomeAssistantProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether Home Assistant (or the demo home) provides lights and speakers. Without it, their parts are hidden or
  /// explain how to connect.
  HasHomeAssistantProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasHomeAssistantProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasHomeAssistantHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasHomeAssistant(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasHomeAssistantHash() => r'929a250e0af4cad6414509375ce3fff0d940c027';

@ProviderFor(connectionStatusService)
final connectionStatusServiceProvider = ConnectionStatusServiceProvider._();

final class ConnectionStatusServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectionStatus>,
          ConnectionStatus,
          Stream<ConnectionStatus>
        >
    with $FutureModifier<ConnectionStatus>, $StreamProvider<ConnectionStatus> {
  ConnectionStatusServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionStatusServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionStatusServiceHash();

  @$internal
  @override
  $StreamProviderElement<ConnectionStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ConnectionStatus> create(Ref ref) {
    return connectionStatusService(ref);
  }
}

String _$connectionStatusServiceHash() =>
    r'5db15bce065c949cd2fc528c1af310b2789ba37e';

/// All known entities, sorted by kind and name.

@ProviderFor(hubEntitiesService)
final hubEntitiesServiceProvider = HubEntitiesServiceProvider._();

/// All known entities, sorted by kind and name.

final class HubEntitiesServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HubEntity>>,
          List<HubEntity>,
          Stream<List<HubEntity>>
        >
    with $FutureModifier<List<HubEntity>>, $StreamProvider<List<HubEntity>> {
  /// All known entities, sorted by kind and name.
  HubEntitiesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hubEntitiesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hubEntitiesServiceHash();

  @$internal
  @override
  $StreamProviderElement<List<HubEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HubEntity>> create(Ref ref) {
    return hubEntitiesService(ref);
  }
}

String _$hubEntitiesServiceHash() =>
    r'9714f110e3ed372043738f29626fd85c0547991d';
