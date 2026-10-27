import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/connection/connection_settings.repository.dart';
import 'package:smart_hub/data/connection/ha_session.repository.dart';
import 'package:smart_hub/domain/connection/model/connect_result.enum.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/connection/model/hub_entity.dart';

part 'connection.service.g.dart';

/// The saved connection. `null` means the hub is not set up yet.
@Riverpod(keepAlive: true)
class ConnectionConfigService extends _$ConnectionConfigService {
  static const connectTimeout = Duration(seconds: 10);

  @override
  Future<ConnectionConfig?> build() async {
    final config = await ref.watch(connectionSettingsRepositoryProvider).load();
    if (config != null) await ref.read(haSessionRepositoryProvider).connect(config);
    return config;
  }

  /// Connects with [config] and saves it only when the connection works. Running without Home Assistant always
  /// works.
  Future<ConnectResult> connect(ConnectionConfig config) async {
    final session = ref.read(haSessionRepositoryProvider);
    await session.connect(config);
    if (config is StandaloneConnectionConfig) {
      await ref.read(connectionSettingsRepositoryProvider).save(config);
      state = AsyncData(config);
      return ConnectResult.connected;
    }
    final status = await session
        .watchStatus()
        .firstWhere((s) => s == ConnectionStatus.online || s == ConnectionStatus.authFailed)
        .timeout(connectTimeout, onTimeout: () => ConnectionStatus.offline);

    if (status != ConnectionStatus.online) {
      await session.disconnect();
      return status == ConnectionStatus.authFailed ? ConnectResult.authFailed : ConnectResult.unreachable;
    }
    await ref.read(connectionSettingsRepositoryProvider).save(config);
    state = AsyncData(config);
    return ConnectResult.connected;
  }

  /// Disconnects and forgets the saved connection.
  Future<void> clear() async {
    await ref.read(haSessionRepositoryProvider).disconnect();
    await ref.read(connectionSettingsRepositoryProvider).clear();
    state = const AsyncData(null);
  }
}

/// Whether Home Assistant (or the demo home) provides lights and speakers. Without it, their parts are hidden or
/// explain how to connect.
@riverpod
bool hasHomeAssistant(Ref ref) {
  return switch (ref.watch(connectionConfigServiceProvider).value) {
    HomeAssistantConnectionConfig() || DemoConnectionConfig() => true,
    StandaloneConnectionConfig() || null => false,
  };
}

@riverpod
Stream<ConnectionStatus> connectionStatusService(Ref ref) {
  return ref.watch(haSessionRepositoryProvider).watchStatus();
}

/// All known entities, sorted by kind and name.
@riverpod
Stream<List<HubEntity>> hubEntitiesService(Ref ref) {
  return ref
      .watch(haSessionRepositoryProvider)
      .watchEntities()
      .map(
        (entities) => [...entities]
          ..sort((a, b) {
            final byDomain = a.domain.compareTo(b.domain);
            return byDomain != 0 ? byDomain : a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }),
      );
}
