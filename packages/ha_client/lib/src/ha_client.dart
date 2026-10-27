import 'dart:async';
import 'dart:collection';

import 'package:ha_client/src/ha_backoff.dart';
import 'package:ha_client/src/ha_connection_status.dart';
import 'package:ha_client/src/ha_entity_state.dart';
import 'package:ha_client/src/ha_exception.dart';
import 'package:ha_client/src/ha_session.dart';
import 'package:ha_client/src/ha_state_change.dart';
import 'package:ha_client/src/ha_transport.dart';
import 'package:logging/logging.dart';

/// Long-lived HA client: keeps a session alive, mirrors all entity states and reconnects with backoff.
///
/// On every (re)connect it subscribes to `state_changed` first and then loads `get_states`, so no change
/// between the two is lost. Differences to the previously known states are emitted on [stateChanges].
final class HaClient {
  HaClient({
    required this.uri,
    required this._accessToken,
    this._transport = const WebSocketHaTransport(),
    HaBackoff? backoff,
    this.pingInterval = const Duration(seconds: 30),
    this.commandTimeout = const Duration(seconds: 10),
  }) : _backoff = backoff ?? HaBackoff();

  static final _log = Logger('HaClient');

  final Uri uri;
  final Duration pingInterval;
  final Duration commandTimeout;
  final String _accessToken;
  final HaTransport _transport;
  final HaBackoff _backoff;

  final _statusController = StreamController<HaConnectionStatus>.broadcast(sync: true);
  final _changesController = StreamController<HaStateChange>.broadcast(sync: true);
  final _states = <String, HaEntityState>{};

  var _status = HaConnectionStatus.disconnected;
  var _running = false;
  HaSession? _session;
  Future<void>? _loop;
  Completer<void>? _wake;

  HaConnectionStatus get status => _status;

  Stream<HaConnectionStatus> get statusChanges => _statusController.stream;

  /// Last known state of every entity. Kept while disconnected.
  Map<String, HaEntityState> get states => UnmodifiableMapView(_states);

  Stream<HaStateChange> get stateChanges => _changesController.stream;

  String? get haVersion => _session?.haVersion;

  /// Starts connecting. Does nothing if already running.
  void start() {
    if (_running) return;
    _running = true;
    _loop = _run();
  }

  /// Closes the connection and stops reconnecting. Known states are kept.
  Future<void> stop() async {
    _running = false;
    final wake = _wake;
    if (wake != null && !wake.isCompleted) wake.complete();
    await _session?.close();
    await _loop;
    _loop = null;
  }

  Future<void> dispose() async {
    await stop();
    await _statusController.close();
    await _changesController.close();
  }

  /// Calls `<domain>.<service>` for [entityIds] with [data] as service data.
  ///
  /// With [returnResponse] the service's response is returned (e.g. `sonos.get_queue`), otherwise `null`.
  /// Throws [HaNotConnectedException] while disconnected and [HaCommandException] when HA rejects the call.
  Future<Object?> callService(
    String domain,
    String service, {
    List<String> entityIds = const [],
    Map<String, Object?> data = const {},
    bool returnResponse = false,
  }) async {
    final result = await sendCommand('call_service', {
      'domain': domain,
      'service': service,
      if (data.isNotEmpty) 'service_data': data,
      if (entityIds.isNotEmpty) 'target': {'entity_id': entityIds},
      if (returnResponse) 'return_response': true,
    });
    return returnResponse && result is Map<String, Object?> ? result['response'] : null;
  }

  /// Sends any WebSocket command, e.g. `media_player/browse_media`, and returns its result.
  ///
  /// Throws [HaNotConnectedException] while disconnected and [HaCommandException] when HA rejects it.
  Future<Object?> sendCommand(String type, [Map<String, Object?> payload = const {}]) {
    final session = _session;
    if (session == null || _status != HaConnectionStatus.connected) throw const HaNotConnectedException();
    return session.sendCommand(type, payload);
  }

  Future<void> _run() async {
    while (_running) {
      _setStatus(HaConnectionStatus.connecting);
      try {
        await _connectOnce();
      } on HaAuthException catch (e) {
        _log.severe('Authentication failed: ${e.message}');
        _running = false;
        _setStatus(HaConnectionStatus.authFailed);
        return;
      } on Object catch (e) {
        _log.warning('Connection failed: $e');
      }
      if (!_running) break;
      _setStatus(HaConnectionStatus.disconnected);
      await _sleep(_backoff.next());
    }
    _setStatus(HaConnectionStatus.disconnected);
  }

  Future<void> _connectOnce() async {
    final channel = await _transport.connect(uri);
    final session = await HaSession.connect(channel, accessToken: _accessToken, commandTimeout: commandTimeout);
    if (!_running) {
      await session.close();
      return;
    }
    _session = session;
    StreamSubscription<Map<String, Object?>>? events;
    Timer? pingTimer;
    try {
      events = (await session.subscribeEvents('state_changed')).listen(_onStateChangedEvent);
      _resync(await session.sendCommand('get_states'));
      _backoff.reset();
      _setStatus(HaConnectionStatus.connected);
      _log.info('Connected to Home Assistant ${session.haVersion ?? ''}');
      pingTimer = Timer.periodic(pingInterval, (_) => _ping(session));
      await session.done;
      _log.warning('Connection to Home Assistant lost');
    } finally {
      pingTimer?.cancel();
      // The session closes its event streams itself; waiting for the cancel is not needed.
      unawaited(events?.cancel());
      _session = null;
      await session.close();
    }
  }

  Future<void> _ping(HaSession session) async {
    try {
      await session.ping();
    } on Object catch (e) {
      _log.warning('Ping failed, reconnecting: $e');
      await session.close();
    }
  }

  void _onStateChangedEvent(Map<String, Object?> event) {
    final data = event['data'] as Map<String, Object?>?;
    final entityId = data?['entity_id'] as String?;
    if (data == null || entityId == null) return;
    final newJson = data['new_state'] as Map<String, Object?>?;
    final newState = newJson == null ? null : HaEntityState.fromJson(newJson);
    final oldState = newState == null ? _states.remove(entityId) : _states[entityId];
    if (newState != null) _states[entityId] = newState;
    _changesController.add(HaStateChange(entityId: entityId, oldState: oldState, newState: newState));
  }

  void _resync(Object? result) {
    final fresh = {
      for (final json in (result as List<Object?>? ?? const []).whereType<Map<String, Object?>>())
        json['entity_id'] as String: HaEntityState.fromJson(json),
    };
    final previous = Map.of(_states);
    _states
      ..clear()
      ..addAll(fresh);
    for (final MapEntry(key: id, value: old) in previous.entries) {
      if (!fresh.containsKey(id)) _changesController.add(HaStateChange(entityId: id, oldState: old));
    }
    for (final MapEntry(key: id, value: state) in fresh.entries) {
      final old = previous[id];
      if (old == null || old.lastUpdated != state.lastUpdated) {
        _changesController.add(HaStateChange(entityId: id, oldState: old, newState: state));
      }
    }
  }

  Future<void> _sleep(Duration duration) async {
    final wake = _wake = Completer<void>();
    final timer = Timer(duration, () {
      if (!wake.isCompleted) wake.complete();
    });
    await wake.future;
    timer.cancel();
    _wake = null;
  }

  void _setStatus(HaConnectionStatus status) {
    if (_status == status) return;
    _status = status;
    _statusController.add(status);
  }
}
