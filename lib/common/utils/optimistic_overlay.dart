import 'dart:async';

/// Desired states laid over the reported ones, so the UI reacts at once (`README` → "Optimistic UI").
///
/// A pending change is dropped when the reported item confirms it, when the command fails ([remove]) or after
/// [timeout] – then the reported state shows again, which rolls the UI back.
class OptimisticOverlay<T> {
  OptimisticOverlay({required this.idOf, required this.onChanged, this.timeout = const Duration(seconds: 3)});

  final String Function(T item) idOf;

  /// Called when a pending change appears or disappears without a new report, e.g. on expiry.
  final void Function() onChanged;
  final Duration timeout;

  final _pending = <String, _Pending<T>>{};

  bool isPending(String id) => _pending.containsKey(id);

  /// Lays [apply] over item [id] until an item satisfies [isConfirmed], at most [timeout] (default: the overlay's).
  /// Replaces an earlier change of the item.
  void add(
    String id, {
    required T Function(T item) apply,
    required bool Function(T item) isConfirmed,
    Duration? timeout,
  }) {
    _pending.remove(id)?.timer.cancel();
    _pending[id] = _Pending(
      apply: apply,
      isConfirmed: isConfirmed,
      timer: Timer(timeout ?? this.timeout, () {
        _pending.remove(id);
        onChanged();
      }),
    );
    onChanged();
  }

  void remove(Iterable<String> ids) {
    var changed = false;
    for (final id in ids) {
      final pending = _pending.remove(id);
      if (pending != null) {
        pending.timer.cancel();
        changed = true;
      }
    }
    if (changed) onChanged();
  }

  /// [reported] with pending changes applied. Confirmed changes are dropped.
  List<T> applyTo(List<T> reported) {
    return [
      for (final item in reported)
        switch (_pending[idOf(item)]) {
          final pending? when pending.isConfirmed(item) => _confirm(item),
          final pending? => pending.apply(item),
          null => item,
        },
    ];
  }

  void dispose() {
    for (final pending in _pending.values) {
      pending.timer.cancel();
    }
    _pending.clear();
  }

  T _confirm(T item) {
    _pending.remove(idOf(item))?.timer.cancel();
    return item;
  }
}

class _Pending<T> {
  _Pending({required this.apply, required this.isConfirmed, required this.timer});

  final T Function(T item) apply;
  final bool Function(T item) isConfirmed;
  final Timer timer;
}
