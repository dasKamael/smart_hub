import 'dart:developer' as developer;

import 'package:logging/logging.dart';

/// Routes all [Logger] output to the Dart developer log (visible in `flutter logs` and DevTools).
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
  });
}
