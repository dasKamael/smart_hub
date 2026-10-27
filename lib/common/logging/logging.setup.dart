import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Routes all [Logger] output to the Dart developer log (DevTools) and to the console (`adb logcat`).
///
/// This is the only place that may print; everything else logs through [Logger].
void setupLogging({Level level = Level.INFO}) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((record) {
    developer.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      error: record.error,
      stackTrace: record.stackTrace,
    );
    debugPrint(
      '${record.level.name} ${record.loggerName}: ${record.message}${record.error == null ? '' : ' – ${record.error}'}',
    );
  });
}
