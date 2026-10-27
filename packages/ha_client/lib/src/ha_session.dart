import 'dart:async';
import 'dart:convert';

import 'package:ha_client/src/ha_exception.dart';
import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';

/// One authenticated connection to HA: correlates command ids with results and routes subscribed events.
///
/// A session never reconnects – once [done] completes it is dead. Reconnecting is the job of `HaClient`.
final class HaSession {
  HaSession._(this._channel, this._accessToken, this._commandTimeout) {
    _subscription = _channel.stream.listen(_onRaw, onDone: _onDone, onError: (Object _) => _onDone());
  }

  /// Authenticates on [channel] and returns the ready session.
  ///
  /// Throws [HaAuthException] for a rejected token, [HaTimeoutException] or [HaConnectionClosedException].
  static Future<HaSession> connect(
    StreamChannel<String> channel, {
    required String accessToken,
    Duration authTimeout = const Duration(seconds: 10),
    Duration commandTimeout = const Duration(seconds: 10),
  }) async {
    final session = HaSession._(channel, accessToken, commandTimeout);
    try {
      await session._auth.future.timeout(
        authTimeout,
        onTimeout: () => throw const HaTimeoutException('Authentication timed out'),
      );
      return session;
    } on Object {
      await session.close();
      rethrow;
    }
  }

  static final _log = Logger('HaSession');
  static const _closeTimeout = Duration(seconds: 2);

  final StreamChannel<String> _channel;
  final String _accessToken;
  final Duration _commandTimeout;
  late final StreamSubscription<String> _subscription;

  final _auth = Completer<void>();
  final _done = Completer<void>();
  final _pending = <int, Completer<Object?>>{};
  final _eventControllers = <int, StreamController<Map<String, Object?>>>{};
  var _nextId = 1;

  /// HA version reported during authentication.
  String? haVersion;

  bool get isClosed => _done.isCompleted;

  /// Completes when the connection is closed, from either side.
  Future<void> get done => _done.future;

  /// Sends a command and returns its `result`.
  ///
  /// Throws [HaCommandException] when HA answers with an error.
  Future<Object?> sendCommand(String type, [Map<String, Object?> payload = const {}]) {
    return _request(type, payload: payload);
  }

  /// Subscribes to [eventType] and returns the stream of `event` objects.
  Future<Stream<Map<String, Object?>>> subscribeEvents(String eventType) async {
    final controller = StreamController<Map<String, Object?>>();
    int? subscriptionId;
    try {
      await _request(
        'subscribe_events',
        payload: {'event_type': eventType},
        onId: (int id) {
          subscriptionId = id;
          _eventControllers[id] = controller;
        },
      );
    } on Object {
      _eventControllers.remove(subscriptionId);
      await controller.close();
      rethrow;
    }
    return controller.stream;
  }

  /// Round trip to check that the connection is alive.
  Future<void> ping() => _request('ping');

  Future<void> close() async {
    if (isClosed) return;
    await _channel.sink.close().timeout(_closeTimeout, onTimeout: () {});
    _onDone();
  }

  Future<Object?> _request(String type, {Map<String, Object?> payload = const {}, void Function(int id)? onId}) {
    if (isClosed) return Future.error(const HaConnectionClosedException());
    final id = _nextId++;
    final completer = Completer<Object?>();
    _pending[id] = completer;
    onId?.call(id);
    _send({'id': id, 'type': type, ...payload});
    return completer.future.timeout(
      _commandTimeout,
      onTimeout: () {
        _pending.remove(id);
        throw HaTimeoutException('Command "$type" timed out');
      },
    );
  }

  void _send(Map<String, Object?> message) => _channel.sink.add(jsonEncode(message));

  void _onRaw(String raw) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException catch (e) {
      _log.warning('Ignoring malformed message: $e');
      return;
    }
    // HA may coalesce several messages into one JSON array.
    final messages = decoded is List<Object?> ? decoded : [decoded];
    for (final message in messages) {
      if (message is Map<String, Object?>) _onMessage(message);
    }
  }

  void _onMessage(Map<String, Object?> message) {
    switch (message['type']) {
      case 'auth_required':
        haVersion = message['ha_version'] as String?;
        _send({'type': 'auth', 'access_token': _accessToken});
      case 'auth_ok':
        haVersion = (message['ha_version'] as String?) ?? haVersion;
        if (!_auth.isCompleted) _auth.complete();
      case 'auth_invalid':
        if (!_auth.isCompleted) {
          _auth.completeError(HaAuthException((message['message'] as String?) ?? 'Invalid access token'));
        }
      case 'result':
        final completer = _pending.remove(message['id'] as int?);
        if (completer == null) return;
        if (message['success'] == true) {
          completer.complete(message['result']);
        } else {
          final error = (message['error'] as Map<String, Object?>?) ?? const {};
          completer.completeError(
            HaCommandException(
              code: (error['code'] as String?) ?? 'unknown_error',
              message: (error['message'] as String?) ?? 'Unknown error',
            ),
          );
        }
      case 'pong':
        _pending.remove(message['id'] as int?)?.complete(null);
      case 'event':
        final event = message['event'];
        if (event is Map<String, Object?>) {
          _eventControllers[message['id'] as int?]?.add(event);
        }
    }
  }

  void _onDone() {
    if (isClosed) return;
    unawaited(_subscription.cancel());
    for (final completer in _pending.values) {
      completer.completeError(const HaConnectionClosedException());
    }
    _pending.clear();
    for (final controller in _eventControllers.values) {
      unawaited(controller.close());
    }
    _eventControllers.clear();
    if (!_auth.isCompleted) {
      _auth.completeError(const HaConnectionClosedException('Connection closed during authentication'));
    }
    _done.complete();
  }
}
