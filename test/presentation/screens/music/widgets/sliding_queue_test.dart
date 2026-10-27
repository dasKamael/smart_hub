import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/presentation/screens/music/widgets/sliding_queue.dart';

void main() {
  group('SlidingQueue', () {
    const queue = [
      QueueItem(title: 'Morning Light'),
      QueueItem(title: 'Slow Rivers'),
      QueueItem(title: 'Late Tram'),
      QueueItem(title: 'Copper Sky'),
    ];

    Widget queueOf(String current) => MaterialApp(
      home: SizedBox(
        height: 400,
        child: SlidingQueue(
          items: queue,
          currentTitle: current,
          itemExtent: 60,
          itemBuilder: (context, item, {required current}) => Text(current ? '> ${item.title}' : item.title),
        ),
      ),
    );

    testWidgets('Given the first track plays, '
        'when the third one starts, '
        'then the two before it slide out at the top and the list starts with it', (tester) async {
      // Given
      await tester.pumpWidget(queueOf('Morning Light'));

      // When
      await tester.pumpWidget(queueOf('Late Tram'));
      await tester.pump(const Duration(milliseconds: 200));
      final midway = (find.text('Morning Light').evaluate().length, tester.getTopLeft(find.text('> Late Tram')).dy);
      await tester.pumpAndSettle();

      // Then
      expect(midway.$1, 1, reason: 'still sliding out');
      expect(midway.$2, inExclusiveRange(0, 120), reason: 'on its way up from 120');
      expect(find.text('Morning Light'), findsNothing);
      expect(find.text('Slow Rivers'), findsNothing);
      expect(tester.getTopLeft(find.text('> Late Tram')).dy, 0);
    });
  });
}
