import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/presentation/screens/music/widgets/track_progress.dart';

import '../../../../utils/widget.test_util.dart';

void main() {
  group('TrackProgress', () {
    final now = DateTime(2026);
    final track = NowPlaying(
      isPlaying: false,
      title: 'Morning Light',
      durationSeconds: 200,
      positionSeconds: 10,
      positionAt: now,
    );

    Future<List<int>> load(WidgetTester tester, NowPlaying track) async {
      final seeks = <int>[];
      await withClock(Clock.fixed(now), () async {
        await loadWidgetTestApp(
          tester: tester,
          underTestWidget: Center(
            child: SizedBox(
              width: 400,
              child: TrackProgress(track: track, onSeek: seeks.add),
            ),
          ),
        );
      });
      return seeks;
    }

    Rect bar(WidgetTester tester) => tester.getRect(find.bySemanticsLabel('Position'));

    testWidgets('Given a track of 3:20, '
        'when dragging the bar to its middle and letting go, '
        'then it jumps once to 1:40 and shows it', (tester) async {
      // Given
      final seeks = await load(tester, track);
      final rect = bar(tester);

      // When
      await withClock(Clock.fixed(now), () async {
        final gesture = await tester.startGesture(rect.centerLeft + const Offset(40, 0));
        await gesture.moveTo(rect.centerLeft + Offset(rect.width * 0.3, 0));
        await gesture.moveTo(rect.center);
        await tester.pump();
        final whileDragging = seeks.length;
        await gesture.up();
        await tester.pumpAndSettle();
        expect(whileDragging, 0);
      });

      // Then
      expect(seeks, [100]);
      expect(find.text('1:40'), findsOneWidget);
    });

    testWidgets('Given a track, when tapping the bar, then it does not jump', (tester) async {
      // Given
      final seeks = await load(tester, track);

      // When
      await tester.tapAt(bar(tester).center);
      await tester.pumpAndSettle();

      // Then
      expect(seeks, isEmpty);
    });

    testWidgets('Given a stream without a length, when shown, then there is nothing to drag', (tester) async {
      // When
      await load(tester, NowPlaying(isPlaying: true, title: 'Radio', positionSeconds: 10, positionAt: now));

      // Then
      expect(find.bySemanticsLabel('Position'), findsNothing);
    });
  });
}
