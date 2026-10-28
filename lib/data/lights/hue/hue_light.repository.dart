import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

/// Lights of a Philips Hue Bridge, through its local API (CLIP v2) – no cloud, no Home Assistant.
///
/// Reads all lights once, then follows the bridge's event stream: a change made with a switch or the Hue app shows
/// at once. When the stream breaks, it reads everything again and reconnects. A stream can also go quiet without
/// breaking (the connection looks open but carries nothing); the bridge echoes every command, so a command without
/// an echo restarts it at once.
class HueLightRepository implements LightRepository {
  HueLightRepository({required this.host, required this.appKey, required this.client});

  static final _log = Logger('HueLightRepository');
  static const _reconnectDelay = Duration(seconds: 5);
  static const _echoTimeout = Duration(milliseconds: 1500);

  final String host;
  final String appKey;
  final http.Client client;

  final _lights = StreamController<List<LightState>>.broadcast();
  final _online = StreamController<bool>.broadcast();

  /// The bridge's light resources by id, kept up to date with the event stream.
  final _raw = <String, Map<String, Object?>>{};
  var _isOnline = false;
  var _started = false;
  var _disposed = false;
  StreamSubscription<String>? _events;

  /// Completes when the event stream ends; with `true` when it went quiet and has to be restarted at once.
  Completer<bool>? _streamEnd;
  Timer? _echoWatch;
  Timer? _reconnect;

  Map<String, String> get _headers => {'hue-application-key': appKey};

  @override
  Stream<List<LightState>> watchLights() async* {
    _start();
    if (_raw.isNotEmpty) yield _mapped();
    yield* _lights.stream;
  }

  @override
  Stream<bool> watchOnline() async* {
    _start();
    yield _isOnline;
    yield* _online.stream;
  }

  @override
  Future<void> turnOn(List<String> ids, {int? brightnessPercent, RgbColor? color, int? kelvin}) {
    return Future.wait([
      for (final id in ids)
        _put(id, {
          'on': {'on': true},
          if (brightnessPercent != null) 'dimming': {'brightness': brightnessPercent.clamp(1, 100).toDouble()},
          if (color != null) 'color': {'xy': xyOf(color)},
          if (kelvin != null) 'color_temperature': {'mirek': _mirekFor(id, kelvin)},
        }),
    ]);
  }

  @override
  Future<void> turnOff(List<String> ids) {
    return Future.wait([
      for (final id in ids)
        _put(id, {
          'on': {'on': false},
        }),
    ]);
  }

  void dispose() {
    _disposed = true;
    _reconnect?.cancel();
    _echoWatch?.cancel();
    unawaited(_events?.cancel());
    unawaited(_lights.close());
    unawaited(_online.close());
    client.close();
  }

  void _start() {
    if (_started) return;
    _started = true;
    unawaited(_connect());
  }

  Future<void> _connect() async {
    if (_disposed) return;
    var wentQuiet = false;
    try {
      final response = await client.get(Uri.https(host, '/clip/v2/resource/light'), headers: _headers);
      if (response.statusCode != 200) throw StateError('Bridge answered ${response.statusCode}');
      final data = (jsonDecode(response.body) as Map<String, Object?>)['data'] as List<Object?>? ?? const [];
      _raw
        ..clear()
        ..addEntries([
          for (final light in data.whereType<Map<String, Object?>>())
            if (light['id'] case final String id) MapEntry(id, light),
        ]);
      _setOnline(true);
      _publish();
      wentQuiet = await _listen();
    } on Object catch (e) {
      _log.warning('Lost the bridge at $host: $e');
      _setOnline(false);
    }
    if (!_disposed) _reconnect = Timer(wentQuiet ? Duration.zero : _reconnectDelay, () => unawaited(_connect()));
  }

  /// Follows the event stream until it ends. Returns whether it went quiet.
  Future<bool> _listen() async {
    final request = http.Request('GET', Uri.https(host, '/eventstream/clip/v2'))
      ..headers.addAll({..._headers, 'Accept': 'text/event-stream'});
    final response = await client.send(request);
    final done = _streamEnd = Completer<bool>();
    _events = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            _echoWatch?.cancel();
            _echoWatch = null;
            if (line.startsWith('data:')) _apply(line.substring(5).trim());
          },
          onDone: () => done.isCompleted ? null : done.complete(false),
          onError: (Object e) => done.isCompleted ? null : done.completeError(e),
          cancelOnError: true,
        );
    try {
      return await done.future;
    } finally {
      _echoWatch?.cancel();
      _echoWatch = null;
    }
  }

  /// Ends a stream that did not echo a command, so [_connect] reads everything again and listens anew.
  void _restartQuietStream() {
    _echoWatch = null;
    final end = _streamEnd;
    if (end == null || end.isCompleted) return;
    _log.info('The event stream of $host went quiet – reconnecting');
    unawaited(_events?.cancel());
    end.complete(true);
  }

  /// Merges the changed parts of lights from one event message.
  void _apply(String json) {
    final Object? events;
    try {
      events = jsonDecode(json);
    } on FormatException {
      return;
    }
    var changed = false;
    for (final event in (events is List<Object?> ? events : const <Object?>[]).whereType<Map<String, Object?>>()) {
      for (final item in (event['data'] as List<Object?>? ?? const []).whereType<Map<String, Object?>>()) {
        if (item['type'] != 'light' || item['id'] is! String) continue;
        final id = item['id']! as String;
        switch (event['type']) {
          case 'update':
            final current = _raw[id];
            if (current == null) continue;
            _raw[id] = mergeInto(current, item);
          case 'add':
            _raw[id] = item;
          case 'delete':
            _raw.remove(id);
        }
        changed = true;
      }
    }
    if (changed) _publish();
  }

  Future<void> _put(String id, Map<String, Object?> body) async {
    final response = await client.put(
      Uri.https(host, '/clip/v2/resource/light/$id'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) throw StateError('The bridge refused the command: ${response.body}');
    if (!_disposed && _streamEnd?.isCompleted == false) _echoWatch ??= Timer(_echoTimeout, _restartQuietStream);
  }

  int _mirekFor(String id, int kelvin) {
    final schema = (_raw[id]?['color_temperature'] as Map<String, Object?>?)?['mirek_schema'] as Map<String, Object?>?;
    final min = (schema?['mirek_minimum'] as num?)?.toInt() ?? 153;
    final max = (schema?['mirek_maximum'] as num?)?.toInt() ?? 500;
    return (1000000 / kelvin).round().clamp(min, max);
  }

  void _setOnline(bool online) {
    if (online == _isOnline || _disposed) return;
    _isOnline = online;
    _online.add(online);
  }

  void _publish() {
    if (!_disposed) _lights.add(_mapped());
  }

  List<LightState> _mapped() => [for (final light in _raw.values) toLight(light)];

  /// A copy of [current] with the values of [change] laid over it, nested maps included.
  static Map<String, Object?> mergeInto(Map<String, Object?> current, Map<String, Object?> change) {
    return {
      ...current,
      for (final MapEntry(:key, :value) in change.entries)
        key: switch ((current[key], value)) {
          (final Map<String, Object?> before, final Map<String, Object?> after) => mergeInto(before, after),
          _ => value,
        },
    };
  }

  static LightState toLight(Map<String, Object?> json) {
    Map<String, Object?>? part(String key) => json[key] as Map<String, Object?>?;
    final isOn = part('on')?['on'] == true;
    final dimming = part('dimming');
    final temperature = part('color_temperature');
    final color = part('color');
    final schema = temperature?['mirek_schema'] as Map<String, Object?>?;
    final mirek = (temperature?['mirek'] as num?)?.toInt();
    final isWhite = temperature != null && temperature['mirek_valid'] == true && mirek != null;
    final xy = color?['xy'] as Map<String, Object?>?;
    return LightState(
      id: json['id']! as String,
      name: (part('metadata')?['name'] as String?) ?? 'Light',
      isOn: isOn,
      brightnessPercent: isOn && dimming != null
          ? ((dimming['brightness'] as num?)?.round() ?? 100).clamp(1, 100)
          : null,
      kelvin: isOn && isWhite ? (1000000 / mirek).round() : null,
      color: isOn && !isWhite && xy != null
          ? rgbOf((xy['x'] as num?)?.toDouble() ?? 0.3127, (xy['y'] as num?)?.toDouble() ?? 0.329)
          : null,
      minKelvin: (1000000 / ((schema?['mirek_maximum'] as num?) ?? 500)).round(),
      maxKelvin: (1000000 / ((schema?['mirek_minimum'] as num?) ?? 153)).round(),
      capabilities: {
        if (dimming != null) LightCapability.brightness,
        if (temperature != null) LightCapability.colorTemperature,
        if (color != null) LightCapability.color,
      },
    );
  }

  /// CIE xy of an sRGB color, as the bridge takes colors (Philips' wide gamut conversion).
  static Map<String, double> xyOf(RgbColor color) {
    double linear(int channel) {
      final v = channel / 255;
      return v > 0.04045 ? math.pow((v + 0.055) / 1.055, 2.4).toDouble() : v / 12.92;
    }

    final (r, g, b) = (linear(color.red), linear(color.green), linear(color.blue));
    final x = r * 0.664511 + g * 0.154324 + b * 0.162028;
    final y = r * 0.283881 + g * 0.668433 + b * 0.047685;
    final z = r * 0.000088 + g * 0.072310 + b * 0.986039;
    final sum = x + y + z;
    if (sum == 0) return {'x': 0.3127, 'y': 0.329};
    double round(double value) => (value * 10000).round() / 10000;
    return {'x': round(x / sum), 'y': round(y / sum)};
  }

  /// The sRGB color of CIE [x], [y] at full brightness.
  static RgbColor rgbOf(double x, double y) {
    if (y <= 0) return const RgbColor(255, 255, 255);
    final bigX = x / y;
    final bigZ = (1 - x - y) / y;
    var r = bigX * 1.656492 - 0.354851 - bigZ * 0.255038;
    var g = -bigX * 0.707196 + 1.655397 + bigZ * 0.036152;
    var b = bigX * 0.051713 - 0.121364 + bigZ * 1.011530;
    final peak = [r, g, b].reduce(math.max);
    if (peak > 1) {
      r /= peak;
      g /= peak;
      b /= peak;
    }
    int gamma(double v) {
      final c = v <= 0.0031308 ? 12.92 * v : 1.055 * math.pow(v, 1 / 2.4) - 0.055;
      return (c.clamp(0, 1) * 255).round();
    }

    return RgbColor(gamma(r), gamma(g), gamma(b));
  }
}
