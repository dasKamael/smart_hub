import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/database/secure_storage.provider.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';

part 'connection_settings.repository.g.dart';

/// Persists the connection config (including the access token) in the platform's secure storage.
class ConnectionSettingsRepository {
  ConnectionSettingsRepository({required this.storage});

  static const storageKey = 'connection_config';
  static final _log = Logger('ConnectionSettingsRepository');

  final FlutterSecureStorage storage;

  Future<ConnectionConfig?> load() async {
    final raw = await storage.read(key: storageKey);
    if (raw == null) return null;
    try {
      return _fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object catch (e) {
      _log.warning('Ignoring unreadable connection config: $e');
      return null;
    }
  }

  Future<void> save(ConnectionConfig config) => storage.write(key: storageKey, value: jsonEncode(_toJson(config)));

  Future<void> clear() => storage.delete(key: storageKey);

  Map<String, Object?> _toJson(ConnectionConfig config) {
    return switch (config) {
      HomeAssistantConnectionConfig(:final baseUrl, :final token) => {
        'type': 'home_assistant',
        'base_url': baseUrl.toString(),
        'token': token,
      },
      DemoConnectionConfig() => {'type': 'demo'},
      StandaloneConnectionConfig() => {'type': 'standalone'},
    };
  }

  ConnectionConfig? _fromJson(Map<String, Object?> json) {
    return switch (json['type']) {
      'home_assistant' => ConnectionConfig.homeAssistant(
        baseUrl: Uri.parse(json['base_url'] as String),
        token: json['token'] as String,
      ),
      'demo' => const ConnectionConfig.demo(),
      'standalone' => const ConnectionConfig.standalone(),
      _ => null,
    };
  }
}

/// Providers
@Riverpod(keepAlive: true)
ConnectionSettingsRepository connectionSettingsRepository(Ref ref) {
  return ConnectionSettingsRepository(storage: ref.watch(secureStorageProvider));
}
