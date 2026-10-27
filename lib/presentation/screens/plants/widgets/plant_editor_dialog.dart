import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/common/device/photo_picker.dart';
import 'package:smart_hub/domain/plants/care_suggestion.util.dart';
import 'package:smart_hub/domain/plants/fertilizing.util.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';
import 'package:smart_hub/domain/plants/plant_care_import.util.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/species_picker.dart';
import 'package:smart_hub/presentation/shared_widgets/plant_photo.dart';

/// Adds a plant ([plant] is `null`) or edits one. Returns the [PlantEdit] or `null` when cancelled.
Future<PlantEdit?> showPlantEditor(BuildContext context, {Plant? plant}) {
  return showDialog<PlantEdit>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => PlantEditorDialog(plant: plant),
  );
}

class PlantEditorDialog extends ConsumerStatefulWidget {
  const PlantEditorDialog({super.key, this.plant});

  final Plant? plant;

  @override
  ConsumerState<PlantEditorDialog> createState() => _PlantEditorDialogState();
}

class _PlantEditorDialogState extends ConsumerState<PlantEditorDialog> {
  late String _name = widget.plant?.name ?? '';
  late int _everyDays = widget.plant?.everyDays ?? 7;
  late int? _fertilizeEveryWeeks = widget.plant?.fertilizeEveryWeeks;
  String? _photoSource;

  /// Species picked in this dialog; `null` keeps the current link.
  int? _speciesId;

  /// Where the suggested intervals come from, e.g. "Swiss cheese plant".
  String? _suggestedBy;

  /// Care data pasted from a chat assistant; saved with the plant.
  PlantProfile? _imported;
  String? _importProblem;
  var _promptCopied = false;

  Future<void> _copyPrompt() async {
    await Clipboard.setData(ClipboardData(text: PlantCareImportUtil.prompt([_name.trim()])));
    if (mounted) setState(() => _promptCopied = true);
  }

  /// Reads the assistant's answer from the clipboard; its first plant belongs to this one, whatever its name.
  Future<void> _pasteAnswer() async {
    final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    final now = clock.now();
    final result = PlantCareImportUtil.parse(text, now: now);
    if (!mounted) return;
    setState(() {
      final profile = result.plants.firstOrNull?.profile;
      if (profile == null) {
        _importProblem = result.problems.firstOrNull ?? 'No plant found in the answer';
        return;
      }
      _importProblem = null;
      _imported = profile;
      _speciesId = null;
      _everyDays = CareSuggestionUtil.everyDays(profile, now) ?? _everyDays;
      _fertilizeEveryWeeks = CareSuggestionUtil.fertilizeEveryWeeks(profile);
      _suggestedBy = profile.commonName;
    });
  }

  Future<void> _pickSpecies(SpeciesMatch match) async {
    setState(() {
      _speciesId = match.id;
      if (_name.trim().isEmpty) _name = match.commonName;
    });
    try {
      final profile = await ref.read(plantProfileServiceProvider.notifier).preview(match.id);
      if (!mounted || _speciesId != match.id) return;
      setState(() {
        _everyDays = CareSuggestionUtil.everyDays(profile, clock.now()) ?? _everyDays;
        _fertilizeEveryWeeks ??= CareSuggestionUtil.fertilizeEveryWeeks(profile);
        _suggestedBy = profile.commonName;
      });
    } on Object {
      // Linking is tried again on save; the intervals stay as they are.
    }
  }

  bool get _canSave => _name.trim().isNotEmpty;

  Future<void> _pick(PhotoSource source) async {
    final path = await ref.read(photoPickerProvider).pick(source);
    if (path != null && mounted) setState(() => _photoSource = path);
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.plant;
    final profile = plant == null ? null : ref.watch(plantProfileProvider(plant.id)).value;
    final preview = plant ?? Plant(id: 'new', name: _name, everyDays: _everyDays, lastWatered: DateTime(0));
    return Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s20,
            children: [
              Text(plant == null ? 'Add plant' : 'Edit plant', style: HubTextStyles.pageTitle),
              Row(
                spacing: HubSpacing.s16,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: switch (_photoSource) {
                      final path? => Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover),
                      null => PlantPhoto(plant: preview.copyWith(name: _name), size: 100),
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: HubSpacing.s8,
                      children: [
                        const Text('Photo', style: HubTextStyles.label),
                        Wrap(
                          spacing: HubSpacing.s8,
                          runSpacing: HubSpacing.s8,
                          children: [
                            HubButton(
                              label: 'Camera',
                              variant: HubButtonVariant.secondary,
                              height: 40,
                              onPressed: () => _pick(PhotoSource.camera),
                            ),
                            HubButton(
                              label: 'Gallery',
                              variant: HubButtonVariant.secondary,
                              height: 40,
                              onPressed: () => _pick(PhotoSource.gallery),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              HubTextField(
                // Picking a species can fill in the name.
                key: ValueKey(_speciesId),
                label: 'Name',
                hint: 'e.g. Monstera',
                initialValue: _name,
                onChanged: (value) => setState(() {
                  _name = value;
                  // The copied prompt names the plant; a new name needs a new prompt.
                  _promptCopied = false;
                }),
              ),
              _CareDataSection(
                canCopy: _name.trim().isNotEmpty,
                copied: _promptCopied,
                imported: _imported,
                problem: _importProblem,
                onCopy: () => unawaited(_copyPrompt()),
                onPaste: () => unawaited(_pasteAnswer()),
              ),
              if (ref.watch(plantDatabaseAvailableProvider) && _imported == null)
                SpeciesPicker(
                  initialQuery: plant == null ? '' : profile?.commonName ?? plant.name,
                  selectedId: _speciesId ?? profile?.speciesId,
                  maxResults: 4,
                  onPicked: (match) => unawaited(_pickSpecies(match)),
                ),
              _IntervalStepper(everyDays: _everyDays, onChanged: (value) => setState(() => _everyDays = value)),
              _FertilizeChoice(
                everyWeeks: _fertilizeEveryWeeks,
                onChanged: (value) => setState(() => _fertilizeEveryWeeks = value),
              ),
              if (_suggestedBy case final species?)
                Text(
                  'Suggested for $species – change them as you like.',
                  style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
                ),
              Row(
                spacing: HubSpacing.s12,
                children: [
                  if (plant != null)
                    HubButton(
                      label: 'Delete',
                      variant: HubButtonVariant.destructive,
                      onPressed: () => Navigator.of(context).pop(const DeletePlant()),
                    ),
                  const Spacer(),
                  HubButton(
                    label: 'Cancel',
                    variant: HubButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  HubButton(
                    label: 'Save',
                    onPressed: _canSave
                        ? () => Navigator.of(context).pop(
                            SavePlant(
                              name: _name.trim(),
                              everyDays: _everyDays,
                              fertilizeEveryWeeks: _fertilizeEveryWeeks,
                              speciesId: _speciesId,
                              importedProfile: _imported,
                              photoSource: _photoSource,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Care data from a chat assistant: copy a prompt for this plant, paste the answer.
class _CareDataSection extends StatelessWidget {
  const _CareDataSection({
    required this.canCopy,
    required this.copied,
    required this.imported,
    required this.problem,
    required this.onCopy,
    required this.onPaste,
  });

  final bool canCopy;
  final bool copied;
  final PlantProfile? imported;
  final String? problem;
  final VoidCallback onCopy;
  final VoidCallback onPaste;

  @override
  Widget build(BuildContext context) {
    final imported = this.imported;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HubSpacing.s8,
      children: [
        Text(
          'Care data – ask ChatGPT, Claude or another assistant',
          style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
        ),
        Wrap(
          spacing: HubSpacing.s8,
          runSpacing: HubSpacing.s8,
          children: [
            HubButton(
              label: copied ? 'Prompt copied' : 'Copy prompt',
              glyph: copied ? HubGlyph.check : null,
              variant: HubButtonVariant.secondary,
              height: 40,
              onPressed: canCopy ? onCopy : null,
            ),
            HubButton(
              label: 'Paste answer',
              glyph: HubGlyph.import,
              variant: HubButtonVariant.secondary,
              height: 40,
              onPressed: onPaste,
            ),
          ],
        ),
        if (imported != null)
          Text(
            [
              imported.commonName,
              if ((imported.wateringMinDays, imported.wateringMaxDays) case (final min?, final max?))
                'summer $min–$max d',
              if ((imported.wateringWinterMinDays, imported.wateringWinterMaxDays) case (final min?, final max?))
                'winter $min–$max d',
            ].join(' · '),
            style: HubTextStyles.label.copyWith(color: HubColorPalette.success),
          ),
        if (problem case final problem?)
          Text(problem, style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText)),
      ],
    );
  }
}

/// Off or every few weeks in the growing season.
class _FertilizeChoice extends StatelessWidget {
  const _FertilizeChoice({required this.everyWeeks, required this.onChanged});

  final int? everyWeeks;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HubSpacing.s8,
      children: [
        Text('Fertilizing, March to September', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: HubColorPalette.control, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              for (final choice in FertilizingUtil.choices)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: choice == everyWeeks,
                    child: GestureDetector(
                      onTap: () => onChanged(choice),
                      child: AnimatedContainer(
                        duration: HubMotion.fadeDuration,
                        height: 34,
                        decoration: BoxDecoration(
                          color: choice == everyWeeks ? const Color(0x33FFFFFF) : const Color(0x00FFFFFF),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          choice == null ? 'Off' : '$choice wk',
                          style: HubTextStyles.label.copyWith(
                            color: choice == everyWeeks ? HubColorPalette.text : HubColorPalette.text2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntervalStepper extends StatelessWidget {
  const _IntervalStepper({required this.everyDays, required this.onChanged});

  static const maxDays = 60;

  final int everyDays;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HubSpacing.s8,
      children: [
        Text('Watering', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
        Row(
          spacing: HubSpacing.s16,
          children: [
            _StepButton(
              glyph: HubGlyph.minus,
              label: 'Fewer days',
              onTap: everyDays > 1 ? () => onChanged(everyDays - 1) : null,
            ),
            Text(everyDays == 1 ? 'Every day' : 'Every $everyDays days', style: HubTextStyles.body.tabular),
            _StepButton(
              glyph: HubGlyph.plus,
              label: 'More days',
              onTap: everyDays < maxDays ? () => onChanged(everyDays + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.glyph, required this.label, this.onTap});

  final HubGlyph glyph;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1,
          child: Container(
            width: HubSizes.minTouchTarget,
            height: HubSizes.minTouchTarget,
            decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: HubGlyphIcon(glyph, color: HubColorPalette.text),
          ),
        ),
      ),
    );
  }
}
