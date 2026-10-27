import 'package:smart_hub/domain/music/model/queue_item.dart';

abstract final class PlayQueueUtil {
  /// The track after [title] in [queue]; the first one when [title] is not in it (e.g. Spotify's queue, which starts
  /// after the current track). `null` when the queue is unknown or ends there.
  static QueueItem? nextAfter(List<QueueItem>? queue, String? title) {
    if (queue == null) return null;
    return queue.skip(queue.indexWhere((item) => item.title == title) + 1).firstOrNull;
  }
}
