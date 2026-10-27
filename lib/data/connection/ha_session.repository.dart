import 'dart:async';

import 'package:ha_client/ha_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/connection/demo/demo_home_assistant.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/connection/model/hub_entity.dart';

part 'ha_session.repository.g.dart';

/// Owns the single Home Assistant client of the app. Every device repository talks to HA through this.
class HaSessionRepository {
  HaSessionRepository({this._transportFor});

  static final demoUri = Uri.parse('ws://demo.local/api/websocket');

  final HaTransport Function(ConnectionConfig config)? _transportFor;

  /// One demo home per app run, so demo changes survive reconnects.
  late final _demoHome = createDemoHomeAssistant();

  final _statusController = StreamController<ConnectionStatus>.broadcast();
  final _stateChangesController = StreamController<HaStateChange>.broadcast();
  final _entitiesChangedController = StreamController<void>.broadcast();

  /// Domain of each changed entity; `null` when all entities changed (disconnect).
  final _domainChangesController = StreamController<String?>.broadcast();

  HaClient? _client;
  ConnectionConfig? _config;
  StreamSubscription<HaConnectionStatus>? _statusSubscription;
  StreamSubscription<HaStateChange>? _changesSubscription;
  var _status = ConnectionStatus.notConfigured;
  var _wasOnline = false;

  ConnectionStatus get status => _status;

  /// Current status first, then every change.
  Stream<ConnectionStatus> watchStatus() => _currentThen(() => _status, _statusController.stream);

  /// Last known state of every entity; kept while offline.
  Map<String, HaEntityState> get states => _client?.states ?? const {};

  Stream<HaStateChange> get stateChanges => _stateChangesController.stream;

  List<HubEntity> entities() {
    return [
      for (final state in states.values)
        HubEntity(
          id: state.entityId,
          domain: state.domain,
          name: (state.attributes['friendly_name'] as String?) ?? state.entityId,
          state: state.state,
        ),
    ];
  }

  /// Current entities first, then a new list after every change.
  Stream<List<HubEntity>> watchEntities() {
    return _currentThen(entities, _entitiesChangedController.stream.map((_) => entities()));
  }

  /// Current states of all entities of [domain] (e.g. `light`), re-emitted when one of them changes.
  Stream<List<HaEntityState>> watchDomain(String domain) {
    List<HaEntityState> current() => [
      for (final state in states.values)
        if (state.domain == domain) state,
    ];
    return _currentThen(
      current,
      _domainChangesController.stream.where((changed) => changed == null || changed == domain).map((_) => current()),
    );
  }

  /// Calls a HA service; with [returnResponse] its response is returned. Throws [HaNotConnectedException] while
  /// offline.
  Future<Object?> callService(
    String domain,
    String service, {
    List<String> entityIds = const [],
    Map<String, Object?> data = const {},
    bool returnResponse = false,
  }) async {
    final client = _client;
    if (client == null) throw const HaNotConnectedException();
    return client.callService(domain, service, entityIds: entityIds, data: data, returnResponse: returnResponse);
  }

  /// Sends a WebSocket command, e.g. `media_player/browse_media`. Throws [HaNotConnectedException] while offline.
  Future<Object?> sendCommand(String type, [Map<String, Object?> payload = const {}]) async {
    final client = _client;
    if (client == null) throw const HaNotConnectedException();
    return client.sendCommand(type, payload);
  }

  /// Absolute URL for a path HA reports, e.g. an `entity_picture`. Already absolute URLs are kept; without a real
  /// HA (demo) relative paths cannot be loaded and give `null`.
  Uri? resolveUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    final uri = Uri.tryParse(path);
    if (uri == null) return null;
    if (uri.hasScheme) return uri;
    return switch (_config) {
      HomeAssistantConnectionConfig(:final baseUrl) => baseUrl.resolveUri(uri),
      _ => null,
    };
  }

  /// Replaces the current connection with one for [config] and starts connecting. Without Home Assistant
  /// ([StandaloneConnectionConfig]) there is nothing to connect to.
  Future<void> connect(ConnectionConfig config) async {
    await disconnect();
    final (uri, token) = switch (config) {
      HomeAssistantConnectionConfig(:final baseUrl, :final token) => (websocketUri(baseUrl), token),
      DemoConnectionConfig() => (demoUri, demoAccessToken),
      StandaloneConnectionConfig() => (null, null),
    };
    if (uri == null || token == null) return;
    final client = HaClient(uri: uri, accessToken: token, transport: (_transportFor ?? _defaultTransport)(config));
    _client = client;
    _config = config;
    _wasOnline = false;
    _statusSubscription = client.statusChanges.listen(_onClientStatus);
    _changesSubscription = client.stateChanges.listen((change) {
      _stateChangesController.add(change);
      _entitiesChangedController.add(null);
      _domainChangesController.add(change.entityId.split('.').first);
    });
    _setStatus(ConnectionStatus.connecting);
    client.start();
  }

  /// Closes the connection and forgets all states.
  Future<void> disconnect() async {
    final client = _client;
    if (client == null) return;
    _client = null;
    _config = null;
    // Cancelling completes immediately; awaiting it would only add a root zone microtask.
    unawaited(_statusSubscription?.cancel());
    unawaited(_changesSubscription?.cancel());
    await client.dispose();
    _setStatus(ConnectionStatus.notConfigured);
    _entitiesChangedController.add(null);
    _domainChangesController.add(null);
  }

  Future<void> dispose() async {
    await disconnect();
    await _statusController.close();
    await _stateChangesController.close();
    await _entitiesChangedController.close();
    await _domainChangesController.close();
  }

  /// `http://host:8123` → `ws://host:8123/api/websocket`, `https` → `wss`.
  static Uri websocketUri(Uri baseUrl) {
    return baseUrl.replace(scheme: baseUrl.scheme == 'https' ? 'wss' : 'ws', path: '/api/websocket');
  }

  /// Emits [current] on listen and then [changes], subscribing in the same step so nothing is missed.
  Stream<T> _currentThen<T>(T Function() current, Stream<T> changes) {
    StreamSubscription<T>? subscription;
    late final StreamController<T> controller;
    controller = StreamController<T>(
      onListen: () {
        controller.add(current());
        subscription = changes.listen(controller.add);
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  HaTransport _defaultTransport(ConnectionConfig config) {
    return switch (config) {
      HomeAssistantConnectionConfig() || StandaloneConnectionConfig() => const WebSocketHaTransport(),
      DemoConnectionConfig() => _demoHome,
    };
  }

  void _onClientStatus(HaConnectionStatus status) {
    if (status == HaConnectionStatus.connected) _wasOnline = true;
    _setStatus(switch (status) {
      HaConnectionStatus.connected => ConnectionStatus.online,
      HaConnectionStatus.connecting => _wasOnline ? ConnectionStatus.offline : ConnectionStatus.connecting,
      HaConnectionStatus.disconnected => ConnectionStatus.offline,
      HaConnectionStatus.authFailed => ConnectionStatus.authFailed,
    });
  }

  void _setStatus(ConnectionStatus status) {
    if (_status == status) return;
    _status = status;
    _statusController.add(status);
  }
}

/// Providers
@Riverpod(keepAlive: true)
HaSessionRepository haSessionRepository(Ref ref) {
  final repository = HaSessionRepository();
  ref.onDispose(repository.dispose);
  return repository;
}
