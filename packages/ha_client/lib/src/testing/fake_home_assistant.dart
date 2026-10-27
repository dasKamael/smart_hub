import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:ha_client/src/ha_entity_state.dart';
import 'package:ha_client/src/ha_transport.dart';
import 'package:stream_channel/stream_channel.dart';

/// Reacts to a service call, e.g. by updating states with [FakeHomeAssistant.setState]. The returned value is the
/// service response for calls with `return_response`. Throw [FakeHomeAssistantError] to answer with an error result.
typedef FakeServiceCallHandler = FutureOr<Object?> Function(FakeServiceCall call);

/// Answers a WebSocket command the fake does not know by itself, e.g. `media_player/browse_media`.
typedef FakeCommandHandler = FutureOr<Object?> Function(Map<String, Object?> message);

final class FakeServiceCall {
  const FakeServiceCall({required this.domain, required this.service, this.entityIds = const [], this.data = const {}});

  final String domain;
  final String service;
  final List<String> entityIds;
  final Map<String, Object?> data;

  @override
  String toString() => 'FakeServiceCall($domain.$service $entityIds $data)';
}

/// Answer a command with `success: false`.
final class FakeHomeAssistantError implements Exception {
  const FakeHomeAssistantError({required this.code, required this.message});

  final String code;
  final String message;
}

/// Thrown by [FakeHomeAssistant.connect] while [FakeHomeAssistant.reachable] is `false`.
final class FakeHomeAssistantUnreachable implements Exception {
  const FakeHomeAssistantUnreachable();

  @override
  String toString() => 'FakeHomeAssistantUnreachable';
}

/// In-process Home Assistant speaking the real WebSocket protocol.
///
/// Use it as [HaTransport] for `HaClient`. Supports `auth`, `get_states`, `subscribe_events` /
/// `unsubscribe_events` (`state_changed`), `call_service` and `ping`.
final class FakeHomeAssistant implements HaTransport {
  FakeHomeAssistant({
    this.accessToken = 'test-token',
    this.haVersion = '2026.10.0',
    Iterable<HaEntityState> states = const [],
  }) {
    for (final state in states) {
      _states[state.entityId] = state;
    }
  }

  final String accessToken;
  final String haVersion;

  /// `false` makes [connect] fail, like an unreachable host.
  bool reachable = true;

  /// `false` swallows pings, like a half-open connection.
  bool respondToPings = true;

  /// `false` swallows every command after authentication, to provoke timeouts.
  bool respondToCommands = true;

  /// Called for every `call_service` after it was recorded in [serviceCalls].
  FakeServiceCallHandler? onServiceCall;

  /// Extra commands by type. Unknown commands are answered with `unknown_command`.
  final commandHandlers = <String, FakeCommandHandler>{};

  final serviceCalls = <FakeServiceCall>[];
  var connectAttempts = 0;

  final _states = <String, HaEntityState>{};
  final _connections = <_FakeConnection>[];

  Map<String, HaEntityState> get states => UnmodifiableMapView(_states);

  int get openConnections => _connections.length;

  @override
  Future<StreamChannel<String>> connect(Uri uri) async {
    connectAttempts++;
    if (!reachable) throw const FakeHomeAssistantUnreachable();
    final controller = StreamChannelController<String>();
    _connections.add(_FakeConnection(this, controller.foreign));
    return controller.local;
  }

  /// Sets an entity state and notifies subscribed clients. Keeps existing attributes unless [attributes] is given.
  void setState(String entityId, String state, {Map<String, Object?>? attributes}) {
    final now = clock.now().toUtc();
    final old = _states[entityId];
    final next = HaEntityState(
      entityId: entityId,
      state: state,
      attributes: attributes ?? old?.attributes ?? const {},
      lastChanged: old != null && old.state == state ? old.lastChanged : now,
      lastUpdated: now,
    );
    _states[entityId] = next;
    _broadcast(entityId, old, next);
  }

  /// Removes an entity and notifies subscribed clients.
  void removeState(String entityId) {
    final old = _states.remove(entityId);
    if (old != null) _broadcast(entityId, old, null);
  }

  /// Closes all connections from the server side.
  Future<void> dropConnections() async {
    for (final connection in [..._connections]) {
      await connection.close();
    }
  }

  void _broadcast(String entityId, HaEntityState? old, HaEntityState? next) {
    for (final connection in _connections) {
      connection.sendStateChanged(entityId, old, next);
    }
  }
}

final class _FakeConnection {
  _FakeConnection(this._server, this._channel) {
    _subscription = _channel.stream.listen(_onRaw, onDone: _onClosed);
    _send({'type': 'auth_required', 'ha_version': _server.haVersion});
  }

  final FakeHomeAssistant _server;
  final StreamChannel<String> _channel;
  late final StreamSubscription<String> _subscription;
  final _stateChangedSubscriptions = <int>{};
  var _authenticated = false;
  var _closed = false;

  void sendStateChanged(String entityId, HaEntityState? old, HaEntityState? next) {
    for (final id in _stateChangedSubscriptions) {
      _send({
        'id': id,
        'type': 'event',
        'event': {
          'event_type': 'state_changed',
          'data': {'entity_id': entityId, 'old_state': old?.toJson(), 'new_state': next?.toJson()},
          'origin': 'LOCAL',
          'time_fired': clock.now().toUtc().toIso8601String(),
        },
      });
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _onClosed();
    await _channel.sink.close();
  }

  void _onRaw(String raw) {
    final message = jsonDecode(raw) as Map<String, Object?>;
    final type = message['type'];

    if (!_authenticated) {
      if (type == 'auth' && message['access_token'] == _server.accessToken) {
        _authenticated = true;
        _send({'type': 'auth_ok', 'ha_version': _server.haVersion});
      } else {
        _send({'type': 'auth_invalid', 'message': 'Invalid access token or password'});
        unawaited(close());
      }
      return;
    }

    final id = message['id'] as int;
    if (type == 'ping') {
      if (_server.respondToPings) _send({'id': id, 'type': 'pong'});
      return;
    }
    if (!_server.respondToCommands) return;

    switch (type) {
      case 'get_states':
        _result(id, [for (final state in _server._states.values) state.toJson()]);
      case 'subscribe_events':
        if (message['event_type'] == 'state_changed') _stateChangedSubscriptions.add(id);
        _result(id, null);
      case 'unsubscribe_events':
        _stateChangedSubscriptions.remove(message['subscription'] as int?);
        _result(id, null);
      case 'call_service':
        unawaited(_callService(id, message));
      default:
        unawaited(_handleCommand(id, type as String?, message));
    }
  }

  Future<void> _handleCommand(int id, String? type, Map<String, Object?> message) async {
    final handler = _server.commandHandlers[type];
    if (handler == null) return _error(id, 'unknown_command', 'Unknown command.');
    try {
      _result(id, await handler(message));
    } on FakeHomeAssistantError catch (e) {
      _error(id, e.code, e.message);
    }
  }

  Future<void> _callService(int id, Map<String, Object?> message) async {
    final target = message['target'] as Map<String, Object?>?;
    final call = FakeServiceCall(
      domain: message['domain'] as String,
      service: message['service'] as String,
      entityIds: switch (target?['entity_id']) {
        final String single => [single],
        final List<Object?> many => many.cast<String>(),
        _ => const [],
      },
      data: (message['service_data'] as Map<String, Object?>?) ?? const {},
    );
    _server.serviceCalls.add(call);
    try {
      final response = await _server.onServiceCall?.call(call);
      _result(id, {
        'context': {'id': 'fake-$id'},
        if (message['return_response'] == true) 'response': response,
      });
    } on FakeHomeAssistantError catch (e) {
      _error(id, e.code, e.message);
    }
  }

  void _result(int id, Object? result) => _send({'id': id, 'type': 'result', 'success': true, 'result': result});

  void _error(int id, String code, String message) {
    _send({
      'id': id,
      'type': 'result',
      'success': false,
      'error': {'code': code, 'message': message},
    });
  }

  void _send(Map<String, Object?> message) {
    if (!_closed) _channel.sink.add(jsonEncode(message));
  }

  void _onClosed() {
    if (_closed) return;
    _closed = true;
    _server._connections.remove(this);
    unawaited(_subscription.cancel());
  }
}
