import 'package:flutter/material.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// Favorites and playlists as a two-column list with small covers; a tap plays one on the active target.
class PlaylistGrid extends StatelessWidget {
  const PlaylistGrid({super.key, required this.items, required this.enabled, required this.onPlay});

  static const rowHeight = 60.0;

  final List<MediaItem> items;
  final bool enabled;
  final ValueChanged<MediaItem> onPlay;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: rowHeight,
        mainAxisSpacing: 8,
        crossAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _PlaylistRow(item: item, onTap: enabled ? () => onPlay(item) : null);
      },
    );
  }
}

class _PlaylistRow extends StatefulWidget {
  const _PlaylistRow({required this.item, this.onTap});

  final MediaItem item;
  final VoidCallback? onTap;

  @override
  State<_PlaylistRow> createState() => _PlaylistRowState();
}

class _PlaylistRowState extends State<_PlaylistRow> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Semantics(
      button: true,
      label: 'Play ${item.title}',
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _pressed ? HubColorPalette.control : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            spacing: 12,
            children: [
              SizedBox.square(
                dimension: PlaylistGrid.rowHeight - 12,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Artwork(seed: item.title, url: item.artworkUrl, radius: 9, showNote: !item.isLikedSongs),
                    if (item.isLikedSongs)
                      const Center(
                        child: HubGlyphIcon(HubGlyph.heart, color: Color(0xE6FFFFFF), size: Size.square(20)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HubTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Text(switch (item.contentType) {
                      'album' => 'Album',
                      'playlist' => 'Playlist',
                      _ => 'Favorite',
                    }, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
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
