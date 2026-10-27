import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

/// Writes the frame timing summary of `integration_test/*_perf_test.dart` to `build/<name>.timeline_summary.json`.
Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data == null) return;
      for (final MapEntry(key: name, value: timeline) in data.entries) {
        final summary = driver.TimelineSummary.summarize(driver.Timeline.fromJson(timeline as Map<String, dynamic>));
        await summary.writeTimelineToFile(name, pretty: true, includeSummary: true);
      }
    },
  );
}
