import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/plants/care_suggestion.util.dart';
import 'package:smart_hub/domain/plants/fertilizing.util.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/plant_profile_source.enum.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';
import 'package:smart_hub/domain/plants/watering_due.util.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plant_profile.controller.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/species_picker.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';
import 'package:smart_hub/presentation/shared_widgets/plant_photo.dart';

/// Everything about one plant: when to water and feed, light and pruning, and the care guides of its species. The
/// species data is loaded once from the plant database and kept with the plant.
class PlantProfileScreen extends ConsumerWidget {
  const PlantProfileScreen({super.key, required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(
      plantsServiceProvider.select((plants) => plants.value?.where((plant) => plant.id == plantId).firstOrNull),
    );
    final profile = ref.watch(plantProfileProvider(plantId)).value;
    final busy = ref.watch(plantProfileControllerProvider(plantId));

    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(HubSpacing.s24, HubSpacing.s20, HubSpacing.s24, HubSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s16,
            children: [
              Row(
                spacing: HubSpacing.s16,
                children: [
                  HubIconButton(
                    glyph: HubGlyph.back,
                    semanticLabel: 'Back',
                    onPressed: () => context.canPop() ? context.pop() : context.go(HubRoute.plants.path),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plant?.name ?? '', style: HubTextStyles.pageTitle),
                        if (profile != null)
                          Text(
                            [profile.commonName, ?profile.scientificName].join(' · '),
                            style: HubTextStyles.secondary.copyWith(fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                  ),
                  if (profile?.source == PlantProfileSource.perenual)
                    HubButton(
                      label: 'Reload',
                      glyph: HubGlyph.sync,
                      variant: HubButtonVariant.secondary,
                      isLoading: busy,
                      onPressed: () => unawaited(ref.read(plantProfileControllerProvider(plantId).notifier).reload()),
                    ),
                ],
              ),
              if (plant != null)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: HubSpacing.s16,
                    children: [
                      SizedBox(
                        width: 380,
                        child: _Overview(plant: plant, profile: profile),
                      ),
                      Expanded(
                        child: profile == null
                            ? _LinkSpecies(plant: plant, busy: busy)
                            : _Care(plant: plant, profile: profile),
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

/// Photo (or the species picture) and the plan for watering and feeding.
class _Overview extends ConsumerWidget {
  const _Overview({required this.plant, required this.profile});

  final Plant plant;
  final PlantProfile? profile;

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = clock.now();
    final controller = ref.read(plantProfileControllerProvider(plant.id).notifier);
    final waterIn = WateringDueUtil.dueInDays(plant, now);
    final feedDue = FertilizingUtil.nextDue(plant, now);
    final feedIn = FertilizingUtil.dueInDays(plant, now);
    final profile = this.profile;
    final range = profile == null ? null : CareSuggestionUtil.wateringRange(profile, now);
    final suggestedDays = profile == null ? null : CareSuggestionUtil.everyDays(profile, now);
    final suggestedWeeks = profile == null ? null : CareSuggestionUtil.fertilizeEveryWeeks(profile);

    return PageCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s12,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: plant.photoPath == null && profile?.imageUrl != null
                  ? Artwork(seed: plant.name, url: profile?.imageUrl, radius: 18)
                  : LayoutBuilder(
                      builder: (context, constraints) => PlantPhoto(plant: plant, size: constraints.maxWidth),
                    ),
            ),
          ),
          _PlanRow(
            glyph: HubGlyph.drop,
            color: HubColorPalette.accent,
            title: 'Water every ${plant.everyDays} days',
            detail: switch (waterIn) {
              -1 => '1 day late',
              < 0 => '${-waterIn} days late',
              0 => 'Due today',
              1 => 'Tomorrow',
              _ => 'In $waterIn days',
            },
            suggestion: switch ((range, suggestedDays)) {
              ((:final min, :final max, :final winter), final days?) when days != plant.everyDays => (
                'Suggested${winter ? ' in winter' : ''}: ${min == max ? '$min' : '$min–$max'} days',
                () => controller.waterEvery(plant, days),
              ),
              _ => null,
            },
          ),
          _PlanRow(
            glyph: HubGlyph.feed,
            color: HubColorPalette.feed,
            title: switch (plant.fertilizeEveryWeeks) {
              null => 'Not fertilized',
              final weeks => 'Feed every $weeks weeks, Mar–Sep',
            },
            detail: switch ((feedIn, feedDue)) {
              (null, _) || (_, null) => 'Off',
              (final days?, _) when days <= 0 => 'Due today',
              (_, final due?) when !FertilizingUtil.inSeason(now) =>
                'Resting until ${due.day} ${_months[due.month - 1]}',
              (final days?, _) => 'In $days days',
            },
            suggestion: plant.fertilizeEveryWeeks == null && suggestedWeeks != null
                ? ('Feed every $suggestedWeeks weeks', () => controller.fertilizeEvery(plant, suggestedWeeks))
                : null,
          ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.glyph,
    required this.color,
    required this.title,
    required this.detail,
    this.suggestion,
  });

  final HubGlyph glyph;
  final Color color;
  final String title;
  final String detail;

  /// A suggestion from the species data and how to take it over.
  final (String, Future<void> Function())? suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(16)),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: HubGlyphIcon(glyph, color: color, size: const Size(16, 16)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: HubTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
                Text(detail, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
                if (suggestion case (final text, final apply))
                  GestureDetector(
                    onTap: () => unawaited(apply()),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '$text · Use',
                        style: HubTextStyles.label.copyWith(color: HubColorPalette.accentText),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Care facts and the care guides of the species.
class _Care extends StatelessWidget {
  const _Care({required this.plant, required this.profile});

  final Plant plant;
  final PlantProfile profile;

  @override
  Widget build(BuildContext context) {
    final guides = [
      ('Watering', HubGlyph.drop, profile.wateringGuide),
      ('Light', HubGlyph.sun, profile.sunlightGuide),
      ('Pruning', HubGlyph.leaf, profile.pruningGuide),
    ].where((guide) => guide.$3 != null);
    return PageCard(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (profile.sunlight.isNotEmpty)
                _Fact(glyph: HubGlyph.sun, label: 'Light', value: _capitalize(profile.sunlight.join(', '))),
              if (profile.watering case final watering?)
                _Fact(glyph: HubGlyph.drop, label: 'Water need', value: watering),
              if ((profile.wateringMinDays, profile.wateringMaxDays) case (final min?, final max?))
                _Fact(glyph: HubGlyph.drop, label: 'Summer', value: 'every $min–$max days'),
              if ((profile.wateringWinterMinDays, profile.wateringWinterMaxDays) case (final min?, final max?))
                _Fact(glyph: HubGlyph.drop, label: 'Winter', value: 'every $min–$max days'),
              if (profile.pruningMonths.isNotEmpty)
                _Fact(glyph: HubGlyph.leaf, label: 'Prune in', value: profile.pruningMonths.join(', ')),
              if (profile.careLevel case final level?) _Fact(glyph: HubGlyph.check, label: 'Care', value: level),
              if (profile.indoor case final indoor?)
                _Fact(glyph: HubGlyph.pottedPlant, label: 'Place', value: indoor ? 'Indoor' : 'Outdoor'),
              if (profile.poisonousToPets == true)
                const _Fact(glyph: HubGlyph.alert, label: 'Pets', value: 'Toxic', warning: true),
            ],
          ),
          const SizedBox(height: HubSpacing.s20),
          if (guides.isEmpty) ...[
            Text('No care guide for this species.', style: HubTextStyles.secondary),
            const SizedBox(height: HubSpacing.s20),
          ] else
            for (final (title, glyph, text) in guides) ...[
              Row(
                spacing: 8,
                children: [
                  HubGlyphIcon(glyph, color: HubColorPalette.text2, size: const Size(14, 14)),
                  Text(title, style: HubTextStyles.widgetTitle),
                ],
              ),
              const SizedBox(height: 6),
              Text(text ?? '', style: HubTextStyles.secondary.copyWith(height: 1.45)),
              const SizedBox(height: HubSpacing.s20),
            ],
          Text(switch (profile.source) {
            PlantProfileSource.perenual => 'Care data from perenual.com',
            PlantProfileSource.imported => 'Imported care data',
          }, style: HubTextStyles.label.copyWith(color: HubColorPalette.text3)),
        ],
      ),
    );
  }

  static String _capitalize(String text) => text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

class _Fact extends StatelessWidget {
  const _Fact({required this.glyph, required this.label, required this.value, this.warning = false});

  final HubGlyph glyph;
  final String label;
  final String value;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning ? HubColorPalette.danger : HubColorPalette.text2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: warning ? HubColorPalette.danger.withValues(alpha: 0.12) : HubColorPalette.elevated,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          HubGlyphIcon(glyph, color: color, size: const Size(15, 15)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Text(value, style: HubTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Not linked yet: search the species in the plant database.
class _LinkSpecies extends ConsumerWidget {
  const _LinkSpecies({required this.plant, required this.busy});

  final Plant plant;
  final bool busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(plantDatabaseAvailableProvider);
    return PageCard(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: HubSpacing.s12,
          children: [
            const Text('Which plant is it?', style: HubTextStyles.widgetTitle),
            Text(
              available
                  ? 'Pick the species, and the hub keeps its care data: how much water and light it wants, '
                        'when to prune – and suggests a plan for watering and feeding.'
                  : 'The plant database is not set up in this build.',
              style: HubTextStyles.secondary,
            ),
            if (busy)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  spacing: HubSpacing.s12,
                  children: [
                    const CircularProgressIndicator(color: HubColorPalette.text2),
                    Text(
                      'Loading the care data – the plant database can take up to half a minute.',
                      textAlign: TextAlign.center,
                      style: HubTextStyles.secondary,
                    ),
                  ],
                ),
              )
            else if (available)
              SpeciesPicker(
                initialQuery: plant.name,
                maxResults: 6,
                onPicked: (match) =>
                    unawaited(ref.read(plantProfileControllerProvider(plant.id).notifier).link(match.id)),
              ),
          ],
        ),
      ),
    );
  }
}
