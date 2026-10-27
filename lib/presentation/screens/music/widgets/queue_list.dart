import 'package:flutter/material.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/widgets/sliding_queue.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

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
        child: Semantics(
          button: !current && onPlay != null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: current || onPlay == null ? null : () => onPlay!(item),
            child: AnimatedContainer(
              duration: HubMotion.fadeDuration,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: current ? HubColorPalette.elevated : const Color(0x00000000),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                spacing: 12,
                children: [
                  Artwork(seed: item.title, url: item.artworkUrl, size: 40, radius: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HubTextStyles.body.copyWith(
                            fontSize: 16,
                            color: current ? HubColorPalette.playing : HubColorPalette.text,
                          ),
                        ),
                        if (item.artist case final artist?)
                          Text(
                            artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HubTextStyles.label.copyWith(
                              fontWeight: FontWeight.w400,
                              color: HubColorPalette.text2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
