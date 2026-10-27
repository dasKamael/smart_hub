import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// Searches the plant database as you type and offers the species to pick.
class SpeciesPicker extends ConsumerStatefulWidget {
  const SpeciesPicker({
    super.key,
    required this.onPicked,
    this.initialQuery = '',
    this.selectedId,
    this.maxResults = 5,
  });

  final ValueChanged<SpeciesMatch> onPicked;
  final String initialQuery;
  final int? selectedId;
  final int maxResults;

  @override
  ConsumerState<SpeciesPicker> createState() => _SpeciesPickerState();
}

class _SpeciesPickerState extends ConsumerState<SpeciesPicker> {
  /// Waits for a pause in typing, so the database (100 requests a day) is not asked per letter.
  static const _debounce = Duration(milliseconds: 600);

  late String _query = widget.initialQuery;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onChanged(String text) {
    _timer?.cancel();
    _timer = Timer(_debounce, () => setState(() => _query = text));
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(speciesSearchProvider(_query));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s8,
      children: [
        HubTextField(
          label: 'Species',
          hint: 'e.g. Monstera, Snake plant',
          initialValue: widget.initialQuery,
          onChanged: _onChanged,
        ),
        switch (results) {
          AsyncData(value: final matches) when matches.isNotEmpty => Column(
            spacing: 6,
            children: [
              for (final match in matches.take(widget.maxResults))
                _MatchRow(
                  match: match,
                  selected: match.id == widget.selectedId,
                  onTap: match.available ? () => widget.onPicked(match) : null,
                ),
            ],
          ),
          AsyncData() when _query.trim().length >= 3 => Text(
            'No species found',
            style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
          ),
          AsyncError() => Text(
            'The plant database is not reachable',
            style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText),
          ),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _MatchRow extends StatelessWidget {
  const _MatchRow({required this.match, required this.selected, required this.onTap});

  final SpeciesMatch match;
  final bool selected;

  /// `null` for species without care data in the free plan.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: match.commonName,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.45 : 1,
          child: AnimatedContainer(
            duration: HubMotion.fadeDuration,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: selected ? HubColorPalette.accentTint : HubColorPalette.elevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              spacing: 12,
              children: [
                Artwork(seed: match.commonName, url: match.thumbnailUrl, size: 40, radius: 8, showNote: false),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.commonName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HubTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      if (match.scientificName case final name?)
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HubTextStyles.label.copyWith(
                            color: HubColorPalette.text2,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                if (selected) const HubGlyphIcon(HubGlyph.check, color: HubColorPalette.accentText, size: Size(14, 14)),
                if (onTap == null)
                  Text('Premium only', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
