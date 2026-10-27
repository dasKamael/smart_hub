import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/database/secure_storage.provider.dart';
import 'package:smart_hub/common/http/http_client.provider.dart';
import 'package:smart_hub/domain/lights/model/light_bridge.dart';

part 'hue_bridge.repository.g.dart';

/// Finds a Philips Hue Bridge in the home network, pairs with it (press its button) and keeps its key in secure
/// storage.
class HueBridgeRepository {
  HueBridgeRepository({required this.storage, required this.client, this.bridgeClientFor = hueClientFor});

  static const _storageKey = 'hue_bridge';

  /// Signify's discovery service: the bridges that reported in from this network.
  static final _discovery = Uri.parse('https://discovery.meethue.com/');

  final FlutterSecureStorage storage;
  final http.Client client;
  final http.Client Function(String host) bridgeClientFor;

  Future<LightBridge?> load() async {
    final json = await storage.read(key: _storageKey);
    if (json == null) return null;
    return switch (jsonDecode(json)) {
      {'host': final String host, 'appKey': final String appKey, 'name': final String? name} => LightBridge(
        host: host,
        appKey: appKey,
        name: name,
      ),
      _ => null,
    };
  }

  Future<void> save(LightBridge bridge) {
    return storage.write(
      key: _storageKey,
      value: jsonEncode({'host': bridge.host, 'appKey': bridge.appKey, 'name': bridge.name}),
    );
  }

  Future<void> clear() => storage.delete(key: _storageKey);

  /// IP addresses of the bridges in this network; empty when none is found or the service cannot be reached.
  Future<List<String>> discover() async {
    try {
      final response = await client.get(_discovery).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return const [];
      return [
        for (final bridge in (jsonDecode(response.body) as List<Object?>).whereType<Map<String, Object?>>())
          if (bridge['internalipaddress'] case final String host) host,
      ];
    } on Object {
      return const [];
    }
  }

  /// Asks the bridge at [host] for a key; works within 30 s after its button was pressed.
  ///
  /// Throws [BridgeButtonNotPressedException] while the button was not pressed.
  Future<LightBridge> pair(String host) async {
    final bridge = bridgeClientFor(host);
    try {
      final response = await bridge
          .post(Uri.https(host, '/api'), body: jsonEncode({'devicetype': 'smart_hub#wall tablet'}))
          .timeout(const Duration(seconds: 6));
      final result = (jsonDecode(response.body) as List<Object?>).firstOrNull;
      return switch (result) {
        {'success': {'username': final String appKey}} => LightBridge(
          host: host,
          appKey: appKey,
          name: await _nameOf(bridge, host),
        ),
        {'error': {'type': 101}} => throw const BridgeButtonNotPressedException(),
        _ => throw StateError('Unexpected answer from the bridge: ${response.body}'),
      };
    } finally {
      bridge.close();
    }
  }

  static Future<String?> _nameOf(http.Client bridge, String host) async {
    try {
      final response = await bridge.get(Uri.https(host, '/api/0/config'));
      return (jsonDecode(response.body) as Map<String, Object?>)['name'] as String?;
    } on Object {
      return null;
    }
  }
}

/// HTTP for the bridge at [host]. The bridge has a certificate of its own that no public authority signed; it is
/// only accepted for that one address in the home network.
http.Client hueClientFor(String host) {
  final client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 5)
    ..badCertificateCallback = (certificate, certificateHost, port) => certificateHost == host;
  return IOClient(client);
}

/// Providers
@Riverpod(keepAlive: true)
HueBridgeRepository hueBridgeRepository(Ref ref) {
  return HueBridgeRepository(storage: ref.watch(secureStorageProvider), client: ref.watch(httpClientProvider));
}

/// The paired bridge; `null` when there is none.
@Riverpod(keepAlive: true)
class HueBridgeConfig extends _$HueBridgeConfig {
  @override
  Future<LightBridge?> build() => ref.watch(hueBridgeRepositoryProvider).load();

  Future<void> set(LightBridge? bridge) async {
    final repository = ref.read(hueBridgeRepositoryProvider);
    bridge == null ? await repository.clear() : await repository.save(bridge);
    state = AsyncData(bridge);
  }
}
