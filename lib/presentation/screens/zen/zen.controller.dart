import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/zen/zen.service.dart';

part 'zen.controller.g.dart';

/// Whether the zen mode is shown. It starts after the set minutes without a touch, or by hand.
@riverpod
class ZenController extends _$ZenController {
  Timer? _timer;

  @override
  bool build() {
    ref
      ..onDispose(() => _timer?.cancel())
      ..listen(zenIdleServiceProvider, (_, _) => _restart());
    _restart();
    return false;
  }

  /// Any touch: the idle time starts over.
  void activity() {
    if (!state) _restart();
  }

  void enter() {
    _timer?.cancel();
    state = true;
  }

  void exit() {
    state = false;
    _restart();
  }

  void _restart() {
    _timer?.cancel();
    final minutes = ref.read(zenIdleServiceProvider).value ?? ZenIdleService.defaultMinutes;
    if (minutes > 0) _timer = Timer(Duration(minutes: minutes), enter);
  }
}
