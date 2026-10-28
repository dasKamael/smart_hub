import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/progress_ring.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';
import 'package:smart_hub/presentation/shared_widgets/plant_photo.dart';

/// Compact plant tile with thirst ring, watering status and a fertilizer badge when feeding is due. A tap shows its
/// options (water or undo, feed when due, profile, edit) on the tile.
class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.entry,
    required this.optionsShown,
    required this.onTap,
    required this.onWater,
    required this.onFeed,
    required this.onProfile,
    required this.onEdit,
  });

  final ScheduledPlant entry;
  final bool optionsShown;
  final VoidCallback onTap;

  /// Waters the plant, or undoes today's watering.
  final VoidCallback onWater;
  final VoidCallback onFeed;
  final VoidCallback onProfile;
  final VoidCallback onEdit;

  bool get feedDue => (entry.feedInDays ?? 1) <= 0;

  @override
  Widget build(BuildContext context) {
    final veil = HubAreaColors.veil(PageCard.tintOf(context));
    final state = entry.state;
    final accent = colorOf(state);
    final overdue = state == WateringState.overdue;
    return Semantics(
      button: true,
      label: entry.plant.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.alphaBlend(accent.withValues(alpha: overdue ? 0.16 : 0.07), veil),
                veil,
              ],
            ),
            border: Border.all(
              color: optionsShown
                  ? HubColorPalette.text.withValues(alpha: 0.5)
                  : overdue
                  ? accent.withValues(alpha: 0.45)
                  : const Color(0x14FFFFFF),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProgressRing(
                          progress: thirstOf(entry),
                          color: accent,
                          strokeWidth: 3,
                          gap: 2,
                          child: PlantPhoto(plant: entry.plant, size: 46, radius: 23),
                        ),
                        const Spacer(),
                        if (feedDue) ...[
                          Semantics(
                            label: 'Fertilize',
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: HubColorPalette.feed.withValues(alpha: 0.18),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const HubGlyphIcon(HubGlyph.feed, color: HubColorPalette.feed, size: Size(12, 12)),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        _StatusPill(entry: entry, color: accent),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      entry.plant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${entry.room ?? 'Not placed'} · every ${entry.plant.everyDays} d',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HubTextStyles.label.copyWith(fontWeight: FontWeight.w500, color: HubColorPalette.text2),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: _Options(
                  shown: optionsShown,
                  watered: state == WateringState.wateredToday,
                  feedDue: feedDue,
                  onWater: onWater,
                  onFeed: onFeed,
                  onProfile: onProfile,
                  onEdit: onEdit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 0 right after watering, 1 when due; overdue and watered today show a full ring.
  static double thirstOf(ScheduledPlant entry) {
    if (entry.state == WateringState.wateredToday) return 1;
    final every = entry.plant.everyDays;
    return ((every - entry.dueInDays) / every).clamp(0.0, 1.0);
  }

  static Color colorOf(WateringState state) {
    return switch (state) {
      WateringState.overdue => HubColorPalette.danger,
      WateringState.dueToday => HubColorPalette.accent,
      WateringState.wateredToday || WateringState.upcoming => HubColorPalette.success,
    };
  }
}

/// Water (or undo), feed when due, profile and edit, laid over the tile.
class _Options extends StatelessWidget {
  const _Options({
    required this.shown,
    required this.watered,
    required this.feedDue,
    required this.onWater,
    required this.onFeed,
    required this.onProfile,
    required this.onEdit,
  });

  final bool shown;
  final bool watered;
  final bool feedDue;
  final VoidCallback onWater;
  final VoidCallback onFeed;
  final VoidCallback onProfile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !shown,
      child: AnimatedOpacity(
        opacity: shown ? 1 : 0,
        duration: HubMotion.fadeDuration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            // Only while shown: a blur on every tile would cost raster time for nothing.
            enabled: shown,
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ColoredBox(
              color: HubColorPalette.surface.withValues(alpha: 0.72),
              child: AnimatedScale(
                scale: shown ? 1 : 0.85,
                duration: HubMotion.popDuration,
                curve: HubMotion.pop,
                // Four options get tight on narrow tiles; scale down rather than overflow.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: feedDue ? 8 : 16,
                      children: [
                        _OptionButton(
                          glyph: watered ? HubGlyph.undo : HubGlyph.drop,
                          label: watered ? 'Undo' : 'Water',
                          background: watered ? HubColorPalette.control : HubColorPalette.accent,
                          onTap: onWater,
                        ),
                        if (feedDue)
                          _OptionButton(
                            glyph: HubGlyph.feed,
                            label: 'Feed',
                            background: HubColorPalette.feed.withValues(alpha: 0.85),
                            onTap: onFeed,
                          ),
                        _OptionButton(
                          glyph: HubGlyph.leaf,
                          label: 'Info',
                          background: HubColorPalette.control,
                          onTap: onProfile,
                        ),
                        _OptionButton(
                          glyph: HubGlyph.pencil,
                          label: 'Edit',
                          background: HubColorPalette.control,
                          onTap: onEdit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({required this.glyph, required this.label, required this.background, required this.onTap});

  final HubGlyph glyph;
  final String label;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Own node, not merged into the tile.
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: background, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size(20, 20)),
            ),
            Text(label, style: HubTextStyles.label),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.entry, required this.color});

  final ScheduledPlant entry;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final (glyph, text) = switch (entry.state) {
      WateringState.overdue => (HubGlyph.alert, '${-entry.dueInDays} d late'),
      WateringState.dueToday => (HubGlyph.drop, 'Today'),
      WateringState.wateredToday => (HubGlyph.check, 'Done'),
      WateringState.upcoming => (HubGlyph.drop, 'in ${entry.dueInDays} d'),
    };
    final muted = entry.state == WateringState.upcoming;
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: muted ? HubColorPalette.control : color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          HubGlyphIcon(glyph, color: muted ? HubColorPalette.text2 : color, size: const Size(11, 11)),
          Text(text, style: HubTextStyles.label.copyWith(color: muted ? HubColorPalette.text2 : color).tabular),
        ],
      ),
    );
  }
}
