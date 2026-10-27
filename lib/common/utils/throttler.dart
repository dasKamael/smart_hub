import 'dart:async';

/// Runs an action at most once per [interval]. A call during the interval is kept and runs when the
/// interval ends, so the last value always arrives.
class Throttler {
  Throttler(this.interval);

  final Duration interval;
  Timer? _timer;
  void Function()? _pending;

  void call(void Function() action) {
    if (_timer != null) {
      _pending = action;
      return;
    }
    action();
    _timer = Timer(interval, _onIntervalEnd);
  }

  /// Runs [action] now and drops a pending call, e.g. the final value when a slider is released.
  void flush(void Function() action) {
    _timer?.cancel();
    _timer = null;
    _pending = null;
    action();
  }

  void dispose() {
    _timer?.cancel();
    _pending = null;
  }

  void _onIntervalEnd() {
    _timer = null;
    final pending = _pending;
    _pending = null;
    if (pending != null) call(pending);
  }
}
