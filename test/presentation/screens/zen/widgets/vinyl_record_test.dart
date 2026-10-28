import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/screens/zen/widgets/vinyl_record.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

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

    testWidgets('Given a turning record, '
        'when the music stops, '
        'then it runs out and asks for no more frames', (tester) async {
      // Given
      final playing = ValueNotifier(true);
      addTearDown(playing.dispose);
      await loadWidgetTestApp(
        tester: tester,
        pumpAndSettle: false,
        underTestWidget: ValueListenableBuilder(
          valueListenable: playing,
          builder: (context, playing, _) => VinylRecord(seed: 'Morning Light', size: 400, playing: playing),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));
      final turning = tester.binding.hasScheduledFrame;

      // When
      playing.value = false;
      for (var passed = Duration.zero; passed <= VinylRecord.runUp; passed += const Duration(milliseconds: 16)) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Then
      expect(turning, isTrue);
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('Given a record with one track, '
        'when the next track comes, '
        'then its cover fades in over the old one instead of replacing it at once', (tester) async {
      // Given
      final seed = ValueNotifier('Highway');
      addTearDown(seed.dispose);
      await loadWidgetTestApp(
        tester: tester,
        underTestWidget: Center(
          child: ValueListenableBuilder(
            valueListenable: seed,
            builder: (context, seed, _) => VinylRecord(seed: seed, size: 300),
          ),
        ),
      );

      // When
      seed.value = 'Ghost';
      await tester.pump();
      await tester.pump(VinylRecord.labelBlend ~/ 2);
      final midway = find.byType(Artwork).evaluate().length;
      await tester.pump(VinylRecord.labelBlend);

      // Then
      expect(midway, 2, reason: 'both covers while blending');
      expect(find.byType(Artwork), findsOneWidget);
    });
  });
}
