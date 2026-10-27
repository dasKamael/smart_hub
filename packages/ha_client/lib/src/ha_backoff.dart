import 'dart:math';

/// Exponential reconnect delay: [initial], doubled per failed attempt, capped at [max].
final class HaBackoff {
  HaBackoff({this.initial = const Duration(seconds: 1), this.max = const Duration(seconds: 30), this.factor = 2});

  final Duration initial;
  final Duration max;
  final num factor;

  var _attempt = 0;

  Duration next() {
    final millis = initial.inMilliseconds * pow(factor, _attempt);
    if (millis < max.inMilliseconds) _attempt++;
    return Duration(milliseconds: min(millis, max.inMilliseconds).round());
  }

  void reset() => _attempt = 0;
}
