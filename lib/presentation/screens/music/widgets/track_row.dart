import 'package:flutter/material.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// A track with small cover, title and artist, as "Up next" and an opened playlist list them.
class TrackRow extends StatelessWidget {
  const TrackRow({super.key, required this.item, this.highlighted = false, this.onTap});

  final QueueItem item;

  /// The playing track.
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: highlighted ? HubColorPalette.elevated : const Color(0x00000000),
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
                        color: highlighted ? HubColorPalette.playing : HubColorPalette.text,
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
        ),
      ),
    );
  }
}
