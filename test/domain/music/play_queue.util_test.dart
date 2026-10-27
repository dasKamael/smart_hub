import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/play_queue.util.dart';

void main() {
  group('PlayQueueUtil', () {
    const queue = [QueueItem(title: 'Morning Light'), QueueItem(title: 'Slow Rivers'), QueueItem(title: 'Late Tram')];

    test('Given the current track in the queue, when asking for the next, then it is the one after it', () {
      expect(PlayQueueUtil.nextAfter(queue, 'Slow Rivers')?.title, 'Late Tram');
    });

    test('Given a queue without the current track, when asking for the next, then it is the first', () {
      expect(PlayQueueUtil.nextAfter(queue, 'Copper Sky')?.title, 'Morning Light');
    });

    test('Given the last track or no queue, when asking for the next, then there is none', () {
      expect((PlayQueueUtil.nextAfter(queue, 'Late Tram'), PlayQueueUtil.nextAfter(null, 'Late Tram')), (null, null));
    });
  });
}
