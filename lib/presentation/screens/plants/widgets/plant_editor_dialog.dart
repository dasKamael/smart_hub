import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/common/device/photo_picker.dart';
import 'package:smart_hub/domain/plants/care_suggestion.util.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';
import 'package:smart_hub/domain/plants/plant_care_import.util.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/species_picker.dart';
import 'package:smart_hub/presentation/shared_widgets/camera_capture.dart';
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

  /// Camera and gallery shown over the photo.
  var _photoOptions = false;

  /// The intervals as suggested; a tile marks its value as long as it is unchanged.
  int? _suggestedDays;
  int? _suggestedWeeks;

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
      _suggest(profile.commonName);
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
        _suggest(profile.commonName);
      });
    } on Object {
      // Linking is tried again on save; the intervals stay as they are.
    }
  }

  void _suggest(String species) {
    _suggestedBy = species;
    _suggestedDays = _everyDays;
    _suggestedWeeks = _fertilizeEveryWeeks;
  }

  /// Drops the pasted care data; the intervals stay as they are.
  void _removeImport() => setState(() {
    _imported = null;
    _suggestedBy = null;
  });

  bool get _canSave => _name.trim().isNotEmpty;

  Future<void> _pick(PhotoSource source) async {
    setState(() => _photoOptions = false);
    final path = switch (source) {
      PhotoSource.camera => await showCameraCapture(context),
      PhotoSource.gallery => await ref.read(photoPickerProvider).pick(source),
    };
    if (path != null && mounted) setState(() => _photoSource = path);
  }

  void _save() => Navigator.of(context).pop(
    SavePlant(
      name: _name.trim(),
      everyDays: _everyDays,
      fertilizeEveryWeeks: _fertilizeEveryWeeks,
      speciesId: _speciesId,
      importedProfile: _imported,
      photoSource: _photoSource,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final plant = widget.plant;
    final profile = plant == null ? null : ref.watch(plantProfileProvider(plant.id)).value;
    final preview = plant ?? Plant(id: 'new', name: _name, everyDays: _everyDays, lastWatered: DateTime(0));
    final suggestedBy = _suggestedBy;
    return Dialog(
      backgroundColor: HubColorPalette.surface,
      insetPadding: const EdgeInsets.all(HubSpacing.s24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 940),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s24,
            children: [
              Row(
                spacing: HubSpacing.s12,
                children: [
                  Expanded(child: Text(plant == null ? 'Add plant' : 'Edit plant', style: HubTextStyles.pageTitle)),
                  if (plant != null)
                    HubIconButton(
                      glyph: HubGlyph.trash,
                      semanticLabel: 'Delete',
                      onPressed: () => Navigator.of(context).pop(const DeletePlant()),
                    ),
                  HubIconButton(
                    glyph: HubGlyph.close,
                    semanticLabel: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  HubButton(label: 'Save', glyph: HubGlyph.check, onPressed: _canSave ? _save : null),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 28,
                children: [
                  // What the plant is: its photo and name.
                  SizedBox(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: HubSpacing.s16,
                      children: [
                        _PhotoTile(
                          photo: switch (_photoSource) {
                            final path? => Image.file(File(path), fit: BoxFit.cover),
                            null => PlantPhoto(plant: preview.copyWith(name: _name), size: 260),
                          },
                          optionsShown: _photoOptions,
                          onTap: () => setState(() => _photoOptions = !_photoOptions),
                          onPick: (source) => unawaited(_pick(source)),
                        ),
                        HubTextField(
                          // Picking a species can fill in the name.
                          key: ValueKey(_speciesId),
                          label: 'Name',
                          hint: 'e.g. Monstera',
                          initialValue: _name,
                          style: HubTextStyles.sectionTitle,
                          onChanged: (value) => setState(() {
                            _name = value;
                            // The copied prompt names the plant; a new name needs a new prompt.
                            _promptCopied = false;
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Where its care comes from and the plan that follows.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: HubSpacing.s16,
                      children: [
                        _CareSource(
                          picker: ref.watch(plantDatabaseAvailableProvider) && _imported == null
                              ? SpeciesPicker(
                                  initialQuery: plant == null ? '' : profile?.commonName ?? plant.name,
                                  selectedId: _speciesId ?? profile?.speciesId,
                                  maxResults: 3,
                                  onPicked: (match) => unawaited(_pickSpecies(match)),
                                )
                              : null,
                          canCopy: _name.trim().isNotEmpty,
                          copied: _promptCopied,
                          imported: _imported,
                          problem: _importProblem,
                          onCopy: () => unawaited(_copyPrompt()),
                          onPaste: () => unawaited(_pasteAnswer()),
                          onRemoveImport: _removeImport,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: HubSpacing.s16,
                          children: [
                            Expanded(
                              child: _ValueTile(
                                glyph: HubGlyph.drop,
                                caption: 'Watering',
                                value: '$_everyDays',
                                unit: _everyDays == 1 ? 'day' : 'days',
                                suggestedBy: _everyDays == _suggestedDays ? suggestedBy : null,
                                controls: _DayStepper(
                                  everyDays: _everyDays,
                                  onChanged: (value) => setState(() => _everyDays = value),
                                ),
                              ),
                            ),
                            Expanded(
                              child: _ValueTile(
                                glyph: HubGlyph.feed,
                                caption: 'Fertilizing · Mar – Sep',
                                value: switch (_fertilizeEveryWeeks) {
                                  final weeks? => '$weeks',
                                  null => 'Off',
                                },
                                unit: switch (_fertilizeEveryWeeks) {
                                  null => '',
                                  1 => 'week',
                                  _ => 'weeks',
                                },
                                suggestedBy: _fertilizeEveryWeeks == _suggestedWeeks ? suggestedBy : null,
                                controls: _WeekStepper(
                                  everyWeeks: _fertilizeEveryWeeks,
                                  onChanged: (value) => setState(() => _fertilizeEveryWeeks = value),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

/// The plant's photo; a tap lays camera and gallery over it.
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.photo, required this.optionsShown, required this.onTap, required this.onPick});

  final Widget photo;
  final bool optionsShown;
  final VoidCallback onTap;
  final ValueChanged<PhotoSource> onPick;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Photo',
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                photo,
                AnimatedOpacity(
                  duration: HubMotion.fadeDuration,
                  opacity: optionsShown ? 1 : 0,
                  child: IgnorePointer(
                    ignoring: !optionsShown,
                    child: ColoredBox(
                      color: const Color(0x99000000),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: HubSpacing.s20,
                        children: [
                          _RoundAction(
                            glyph: HubGlyph.camera,
                            label: 'Camera',
                            onTap: () => onPick(PhotoSource.camera),
                          ),
                          _RoundAction(
                            glyph: HubGlyph.image,
                            label: 'Gallery',
                            onTap: () => onPick(PhotoSource.gallery),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!optionsShown) const Positioned(right: 12, bottom: 12, child: _Badge(glyph: HubGlyph.camera)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.glyph, required this.label, required this.onTap});

  final HubGlyph glyph;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: HubColorPalette.card,
            shape: BoxShape.circle,
            border: Border.all(color: HubColorPalette.cardBorder),
          ),
          child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(26)),
        ),
      ),
    );
  }
}

/// A small round mark in a corner, e.g. that the photo can be changed.
class _Badge extends StatelessWidget {
  const _Badge({required this.glyph});

  final HubGlyph glyph;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color(0x8C000000), shape: BoxShape.circle),
      child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(16)),
    );
  }
}

/// Where the care data comes from: the plant database, or a chat assistant when it does not know the plant.
class _CareSource extends StatelessWidget {
  const _CareSource({
    required this.picker,
    required this.canCopy,
    required this.copied,
    required this.imported,
    required this.problem,
    required this.onCopy,
    required this.onPaste,
    required this.onRemoveImport,
  });

  /// The species search; `null` without the database or once care data was pasted.
  final Widget? picker;
  final bool canCopy;
  final bool copied;
  final PlantProfile? imported;
  final String? problem;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onRemoveImport;

  @override
  Widget build(BuildContext context) {
    final imported = this.imported;
    return Container(
      padding: const EdgeInsets.all(HubSpacing.s16),
      decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s12,
        children: [
          ?picker,
          if (imported != null)
            Row(
              spacing: HubSpacing.s12,
              children: [
                const HubGlyphIcon(HubGlyph.sparkle, color: HubColorPalette.success, size: Size.square(18)),
                Expanded(
                  child: Text(
                    [
                      imported.commonName,
                      if ((imported.wateringMinDays, imported.wateringMaxDays) case (final min?, final max?))
                        'summer $min–$max d',
                      if ((imported.wateringWinterMinDays, imported.wateringWinterMaxDays) case (
                        final min?,
                        final max?,
                      ))
                        'winter $min–$max d',
                    ].join(' · '),
                    style: HubTextStyles.body.copyWith(fontSize: 15),
                  ),
                ),
                HubIconButton(glyph: HubGlyph.close, semanticLabel: 'Remove care data', onPressed: onRemoveImport),
              ],
            ),
          Row(
            spacing: HubSpacing.s8,
            children: [
              Expanded(
                child: Text(
                  picker == null && imported == null
                      ? 'Care data from ChatGPT, Claude or another assistant'
                      : 'Not found? Ask an assistant',
                  style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
                ),
              ),
              HubButton(
                label: copied ? 'Prompt copied' : 'Copy prompt',
                glyph: copied ? HubGlyph.check : null,
                variant: HubButtonVariant.secondary,
                height: 36,
                onPressed: canCopy ? onCopy : null,
              ),
              HubButton(
                label: 'Paste answer',
                glyph: HubGlyph.import,
                variant: HubButtonVariant.secondary,
                height: 36,
                onPressed: onPaste,
              ),
            ],
          ),
          if (problem case final problem?)
            Text(problem, style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText)),
        ],
      ),
    );
  }
}

/// One value of the plan as a large number with its [controls] below.
class _ValueTile extends StatelessWidget {
  const _ValueTile({
    required this.glyph,
    required this.caption,
    required this.value,
    required this.unit,
    required this.suggestedBy,
    required this.controls,
  });

  final HubGlyph glyph;
  final String caption;
  final String value;
  final String unit;

  /// The species the value was suggested for, as long as it is unchanged.
  final String? suggestedBy;
  final Widget controls;

  @override
  Widget build(BuildContext context) {
    final suggestedBy = this.suggestedBy;
    return Container(
      padding: const EdgeInsets.all(HubSpacing.s16),
      decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s8,
        children: [
          Row(
            spacing: HubSpacing.s8,
            children: [
              HubGlyphIcon(glyph, color: HubColorPalette.text2, size: const Size.square(16)),
              Expanded(
                child: Text(caption, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
              ),
              if (suggestedBy != null)
                Semantics(
                  label: 'Suggested for $suggestedBy',
                  child: const HubGlyphIcon(HubGlyph.sparkle, color: HubColorPalette.success, size: Size.square(18)),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: 6,
            children: [
              Text(value, style: HubTextStyles.display.copyWith(fontSize: 44, height: 1.1).tabular),
              Text(unit, style: HubTextStyles.body.copyWith(color: HubColorPalette.text2)),
            ],
          ),
          controls,
        ],
      ),
    );
  }
}

class _DayStepper extends StatelessWidget {
  const _DayStepper({required this.everyDays, required this.onChanged});

  static const maxDays = 60;

  final int everyDays;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: HubSpacing.s12,
      children: [
        _StepButton(
          glyph: HubGlyph.minus,
          label: 'Fewer days',
          onTap: everyDays > 1 ? () => onChanged(everyDays - 1) : null,
        ),
        _StepButton(
          glyph: HubGlyph.plus,
          label: 'More days',
          onTap: everyDays < maxDays ? () => onChanged(everyDays + 1) : null,
        ),
      ],
    );
  }
}

/// Off or every few weeks in the growing season: one less than a week is off, one more than off is a week.
class _WeekStepper extends StatelessWidget {
  const _WeekStepper({required this.everyWeeks, required this.onChanged});

  static const maxWeeks = 12;

  final int? everyWeeks;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final weeks = everyWeeks;
    return Row(
      spacing: HubSpacing.s12,
      children: [
        _StepButton(
          glyph: HubGlyph.minus,
          label: 'Fewer weeks',
          onTap: weeks == null ? null : () => onChanged(weeks > 1 ? weeks - 1 : null),
        ),
        _StepButton(
          glyph: HubGlyph.plus,
          label: 'More weeks',
          onTap: (weeks ?? 0) < maxWeeks ? () => onChanged((weeks ?? 0) + 1) : null,
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
