import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/widgets/track_row.dart';
import 'package:smart_hub/presentation/shared_widgets/empty_mark.dart';

/// A playlist, album or the liked songs looked into before playing: its tracks; a tap on one plays from there.
class OpenedPlaylist extends StatelessWidget {
  const OpenedPlaylist({super.key, required this.item, required this.tracks, required this.onClose, this.onPlay});

  final MediaItem item;
  final AsyncValue<List<QueueItem>> tracks;
  final VoidCallback onClose;

  /// Plays from a track, or from the start with `null`; `null` while nothing can be played.
  final void Function(QueueItem? from)? onPlay;

  @override
  Widget build(BuildContext context) {
    final play = onPlay;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          spacing: 12,
          children: [
            _RoundButton(glyph: HubGlyph.back, label: 'Back to Up next', onTap: onClose),
            Expanded(
              child: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: HubTextStyles.widgetTitle),
            ),
            _RoundButton(
              glyph: HubGlyph.play,
              label: 'Play ${item.title}',
              light: true,
              onTap: play == null ? null : () => play(null),
            ),
          ],
        ),
        Expanded(
          child: switch (tracks) {
            AsyncData(value: final items) when items.isNotEmpty => ListView.builder(
              padding: EdgeInsets.zero,
              itemExtent: 60,
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: TrackRow(item: items[index], onTap: play == null ? null : () => play(items[index])),
              ),
            ),
            AsyncLoading() => const SizedBox.shrink(),
            _ => const EmptyMark(glyph: HubGlyph.note, label: 'No tracks to show'),
          },
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.glyph, required this.label, this.light = false, this.onTap});

  static const size = 44.0;

  final HubGlyph glyph;
  final String label;
  final bool light;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: light ? HubColorPalette.text : const Color(0x26FFFFFF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: HubGlyphIcon(
            glyph,
            color: light ? HubColorPalette.surface : HubColorPalette.text,
            size: const Size.square(size * 0.36),
          ),
        ),
      ),
    );
  }
}
