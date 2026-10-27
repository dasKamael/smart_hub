import 'package:flutter/material.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// "Up next": the play queue; the playing track is highlighted.
class QueueList extends StatelessWidget {
  const QueueList({super.key, required this.items, required this.currentTitle});

  final List<QueueItem> items;
  final String? currentTitle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final item = items[index];
        final current = item.title == currentTitle;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: current ? HubColorPalette.elevated : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            spacing: 12,
            children: [
              Artwork(seed: item.title, url: item.artworkUrl, size: 40, radius: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: HubTextStyles.label.copyWith(fontWeight: FontWeight.w400, color: HubColorPalette.text2),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
