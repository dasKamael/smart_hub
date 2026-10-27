import 'dart:async';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_day.provider.g.dart';

/// Today at midnight; emits again right after every midnight, so day based states (e.g. plants due today)
/// update on their own.
@Riverpod(keepAlive: true)
Stream<DateTime> currentDay(Ref ref) {
  Timer? timer;
  late final StreamController<DateTime> controller;

  void emitAndSchedule() {
    final now = clock.now();
    controller.add(DateTime(now.year, now.month, now.day));
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    timer = Timer(nextMidnight.difference(now) + const Duration(seconds: 1), emitAndSchedule);
  }

  controller = StreamController<DateTime>(onListen: emitAndSchedule, onCancel: () => timer?.cancel());
  ref.onDispose(() {
    timer?.cancel();
    unawaited(controller.close());
  });
  return controller.stream;
}
