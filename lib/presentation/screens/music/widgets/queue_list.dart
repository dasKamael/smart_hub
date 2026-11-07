import 'package:flutter/material.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/presentation/screens/music/widgets/sliding_queue.dart';
import 'package:smart_hub/presentation/screens/music/widgets/track_row.dart';

/// "Up next": the play queue from the playing track on, which is highlighted; a tap on a later track plays it.
class QueueList extends StatelessWidget {
  const QueueList({super.key, required this.items, required this.currentTitle, this.onPlay});

  final List<QueueItem> items;
  final String? currentTitle;

  /// Plays a track of the queue; `null` while the speaker cannot be controlled.
  final ValueChanged<QueueItem>? onPlay;

  @override
  Widget build(BuildContext context) {
    return SlidingQueue(
      items: items,
      currentTitle: currentTitle,
      itemExtent: 60,
      itemBuilder: (context, item, {required current}) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: TrackRow(
          item: item,
          highlighted: current,
          onTap: current || onPlay == null ? null : () => onPlay!(item),
        ),
      ),
    );
  }
}
