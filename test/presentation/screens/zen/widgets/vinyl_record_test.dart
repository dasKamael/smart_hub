import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/screens/zen/widgets/vinyl_record.dart';

import '../../../../utils/widget.test_util.dart';

void main() {
  group('VinylRecord', () {
    test('Given a record that stands still, '
        'when the music plays, '
        'then it needs the run up time to come up to speed', () {
      // Given
      var throttle = 0.0;

      // When
      for (var passed = Duration.zero; passed < VinylRecord.runUp; passed += const Duration(milliseconds: 50)) {
        throttle = VinylRecord.throttleAfter(throttle, const Duration(milliseconds: 50), playing: true);
      }

      // Then
      expect(throttle, 1);
    });

    test('Given a record at full speed, '
        'when the music stops, '
        'then it runs out instead of stopping at once', () {
      // Given
      var throttle = 1.0;
      var turns = 0.0;

      // When
      throttle = VinylRecord.throttleAfter(throttle, VinylRecord.runUp ~/ 2, playing: false);
      turns = VinylRecord.turnsAfter(turns, throttle, VinylRecord.runUp ~/ 2);

      // Then
      expect(throttle, closeTo(0.5, 0.001));
      expect(turns, greaterThan(0));
      expect(VinylRecord.throttleAfter(throttle, VinylRecord.runUp, playing: false), 0);
    });

    test('Given a record that stands still, '
        'when it is not playing, '
        'then it does not turn', () {
      // Given
      const throttle = 0.0;

      // When
      final turns = VinylRecord.turnsAfter(0, throttle, VinylRecord.turn);

      // Then
      expect(turns, 0);
    });

    test('Given a record at full speed, '
        'when one turn has passed, '
        'then it is back where it started', () {
      // Given / When
      final turns = VinylRecord.turnsAfter(0, 1, VinylRecord.turn);

      // Then
      expect(turns, closeTo(0, 0.001));
    });

    testWidgets('Given a track with a cover, '
        'when the record shows, '
        'then it does not keep the screen busy with frames', (tester) async {
      // Given / When
      await loadWidgetTestApp(
        tester: tester,
        underTestWidget: const VinylRecord(seed: 'Morning Light', size: 400, playing: true),
      );

      // Then
      expect(find.byType(VinylRecord), findsOneWidget);
    });
  });
}
