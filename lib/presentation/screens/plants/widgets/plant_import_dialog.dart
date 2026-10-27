import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/plant_care_import.util.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';

Future<void> showPlantImport(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => const PlantImportDialog(),
  );
}

/// Care data from a chat assistant: copy the prompt (with the hub's plant names), paste the JSON answer, import.
class PlantImportDialog extends ConsumerStatefulWidget {
  const PlantImportDialog({super.key});

  @override
  ConsumerState<PlantImportDialog> createState() => _PlantImportDialogState();
}

class _PlantImportDialogState extends ConsumerState<PlantImportDialog> {
  final _answer = TextEditingController();

  /// The plants the prompt asks about, one per line; starts with the hub's plants.
  TextEditingController? _names;
  var _copied = false;
  var _importing = false;
  ({int updated, int added})? _result;

  @override
  void initState() {
    super.initState();
    _answer.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _names?.dispose();
    _answer.dispose();
    super.dispose();
  }

  Future<void> _copyPrompt() async {
    final names = [
      for (final line in (_names?.text ?? '').split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
    ];
    await Clipboard.setData(ClipboardData(text: PlantCareImportUtil.prompt(names)));
    if (mounted) setState(() => _copied = true);
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text case final text?) _answer.text = text;
  }

  Future<void> _import(List<PlantCareEntry> entries) async {
    setState(() => _importing = true);
    final result = await ref.read(plantsControllerProvider.notifier).importCare(entries);
    if (!mounted) return;
    setState(() {
      _importing = false;
      _result = result ?? (updated: 0, added: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the controller alive while importing.
    ref.watch(plantsControllerProvider);
    final plants = ref.watch(plantsServiceProvider).value ?? const <Plant>[];
    final names = {for (final plant in plants) plant.name.trim().toLowerCase()};
    final plantNames = _names ??= TextEditingController(text: plants.map((plant) => plant.name).join('\n'));
    final parsed = _answer.text.trim().isEmpty ? null : PlantCareImportUtil.parse(_answer.text, now: clock.now());

    return Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s20,
            children: [
              const Text('Import care data', style: HubTextStyles.pageTitle),
              if (_result case (:final updated, :final added)) ...[
                Text(
                  added == 0 && updated == 0
                      ? 'Nothing was imported.'
                      : '$updated ${updated == 1 ? 'plant' : 'plants'} updated, $added added. Their watering and '
                            'feeding follow the imported data '
                            'now – new plants wait in the tray of the floor plan.',
                  style: HubTextStyles.secondary,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: HubButton(label: 'Done', onPressed: () => Navigator.of(context).pop()),
                ),
              ] else ...[
                _Step(
                  number: 1,
                  text: 'Copy the prompt for these plants and send it to ChatGPT, Claude or another assistant.',
                  action: HubButton(
                    label: _copied ? 'Copied' : 'Copy prompt',
                    glyph: _copied ? HubGlyph.check : null,
                    variant: HubButtonVariant.secondary,
                    onPressed: () => unawaited(_copyPrompt()),
                  ),
                ),
                HubTextField(
                  label: 'Plants – one per line, add any you like',
                  hint: 'Basil\nMonstera',
                  controller: plantNames,
                  maxLines: 4,
                  onChanged: (_) => setState(() => _copied = false),
                ),
                _Step(
                  number: 2,
                  text: 'Paste its answer here. Plants are matched by name; new names become new plants.',
                  action: HubButton(
                    label: 'Paste',
                    variant: HubButtonVariant.secondary,
                    onPressed: () => unawaited(_paste()),
                  ),
                ),
                HubTextField(
                  label: 'Answer (JSON)',
                  hint: '{ "format": "smart-hub-plant-care", … }',
                  controller: _answer,
                  maxLines: 6,
                  style: HubTextStyles.label.copyWith(fontFamily: 'monospace', color: HubColorPalette.text),
                  onChanged: (_) {},
                ),
                if (parsed != null) _Preview(parsed: parsed, existingNames: names),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: HubSpacing.s12,
                  children: [
                    HubButton(
                      label: 'Cancel',
                      variant: HubButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    HubButton(
                      label: 'Import',
                      glyph: HubGlyph.import,
                      isLoading: _importing,
                      onPressed: parsed == null || parsed.plants.isEmpty || _importing
                          ? null
                          : () => unawaited(_import(parsed.plants)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text, required this.action});

  final int number;
  final String text;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: HubSpacing.s12,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(color: HubColorPalette.accentTint, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text('$number', style: HubTextStyles.label.copyWith(color: HubColorPalette.accentText)),
        ),
        Expanded(child: Text(text, style: HubTextStyles.secondary)),
        action,
      ],
    );
  }
}

/// What the import will do: plants found (new ones marked) and entries that are skipped.
class _Preview extends StatelessWidget {
  const _Preview({required this.parsed, required this.existingNames});

  final ({List<PlantCareEntry> plants, List<String> problems}) parsed;
  final Set<String> existingNames;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HubSpacing.s8,
      children: [
        if (parsed.plants.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (:name, :profile) in parsed.plants)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    [
                      name,
                      if ((profile.wateringMinDays, profile.wateringMaxDays) case (final min?, final max?))
                        '$min–$max d',
                      if (!existingNames.contains(name.trim().toLowerCase())) 'new',
                    ].join(' · '),
                    style: HubTextStyles.label,
                  ),
                ),
            ],
          ),
        for (final problem in parsed.problems)
          Text(problem, style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText)),
      ],
    );
  }
}
