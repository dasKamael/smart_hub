import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/presentation/utils/extension/connect_device_type.extension.dart';
import 'package:smart_hub/presentation/screens/music/widgets/track_progress.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// Current track of the active target: where it plays, cover tint, title, live progress and transport controls.
class NowPlayingCard extends StatelessWidget {
  const NowPlayingCard({
    super.key,
    required this.target,
    required this.tint,
    required this.enabled,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.onSeek,
  });

  final PlaybackTarget target;

  /// The cover's color (`coverTintProvider`).
  final Color tint;
  final bool enabled;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final ValueChanged<int> onSeek;

  /// The card's gradient in the cover's [tint], from the tinted to the plain end; the volume beside it uses it too.
  static List<Color> colorsOf(Color tint) => [
    Color.alphaBlend(tint.withValues(alpha: 0.3), HubColorPalette.surface),
    HubColorPalette.surface,
  ];

  /// Side of the cover; the next track's cover is loaded ahead at this size.
  static const coverSize = 124.0;

  /// One plain tone of that gradient for the cards around it.
  static Color fillOf(Color tint) => Color.alphaBlend(tint.withValues(alpha: 0.15), HubColorPalette.surface);

  @override
  Widget build(BuildContext context) {
    final track = target.nowPlaying;
    final seed = track.title ?? target.name;
    return AnimatedContainer(
      duration: HubMotion.tintDuration,
      curve: HubMotion.tint,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HubRadius.pageCard),
        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: colorsOf(tint)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 24, 18),
      child: Row(
        spacing: 20,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 8))],
            ),
            // A new track crossfades in as the card's color blends over.
            child: AnimatedSwitcher(
              duration: HubMotion.tintDuration,
              switchInCurve: HubMotion.tint,
              switchOutCurve: HubMotion.tint,
              child: Artwork(
                key: ValueKey(track.artworkUrl ?? seed),
                seed: seed,
                url: track.artworkUrl,
                size: coverSize,
                radius: 16,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    HubGlyphIcon(
                      switch (target) {
                        ConnectTarget(:final device) => device.type.glyph,
                        SpeakerGroupTarget() => HubGlyph.speaker,
                      },
                      color: HubColorPalette.text2,
                      size: const Size(12, 12),
                    ),
                    Flexible(
                      child: Text(
                        target.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: HubMotion.tintDuration,
                  switchInCurve: HubMotion.tint,
                  switchOutCurve: HubMotion.tint,
                  layoutBuilder: (current, previous) =>
                      Stack(alignment: Alignment.centerLeft, children: [...previous, ?current]),
                  child: Column(
                    key: ValueKey((track.title, track.artist)),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        track.title ?? 'Nothing playing',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HubTextStyles.sectionTitle,
                      ),
                      Text(
                        [?track.artist, ?track.source].where((part) => part.isNotEmpty).join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HubTextStyles.secondary.copyWith(fontSize: 16, color: const Color(0xB3EBEBF5)),
                      ),
                    ],
                  ),
                ),
                TrackProgress(track: track, onSeek: enabled ? onSeek : null),
              ],
            ),
          ),
          _Transport(
            playing: track.isPlaying,
            enabled: enabled,
            onPrevious: onPrevious,
            onPlayPause: onPlayPause,
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}

class _Transport extends StatelessWidget {
  const _Transport({
    required this.playing,
    required this.enabled,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
  });

  final bool playing;
  final bool enabled;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Row(
        spacing: 12,
        children: [
          _RoundButton(glyph: HubGlyph.previous, label: 'Previous', size: 48, onTap: enabled ? onPrevious : null),
          _RoundButton(
            glyph: playing ? HubGlyph.pause : HubGlyph.play,
            label: playing ? 'Pause' : 'Play',
            size: 64,
            light: true,
            onTap: enabled ? onPlayPause : null,
          ),
          _RoundButton(glyph: HubGlyph.next, label: 'Next', size: 48, onTap: enabled ? onNext : null),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.glyph, required this.label, required this.size, this.light = false, this.onTap});

  final HubGlyph glyph;
  final String label;
  final double size;
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
            size: Size.square(size * 0.36),
          ),
        ),
      ),
    );
  }
}
