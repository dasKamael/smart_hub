import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:smart_hub/domain/focus/focus_due.util.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/focus/focus.controller.dart';
import 'package:smart_hub/presentation/screens/focus/widgets/focus_due_picker.dart';

/// Takes on a focus point ([point] is `null`) or changes one: what it is and the day it has to be done, nothing
/// else. Returns the [FocusEdit] or `null` when cancelled.
Future<FocusEdit?> showFocusEditor(BuildContext context, {FocusPoint? point}) {
  return showDialog<FocusEdit>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => FocusEditorDialog(point: point),
  );
}

class FocusEditorDialog extends StatefulWidget {
  const FocusEditorDialog({super.key, this.point});

  final FocusPoint? point;

  @override
  State<FocusEditorDialog> createState() => _FocusEditorDialogState();
}

class _FocusEditorDialogState extends State<FocusEditorDialog> {
  late final DateTime _today = FocusDueUtil.dayOf(clock.now());
  late String _title = widget.point?.title ?? '';
  late DateTime? _dueDate = widget.point?.dueDate;

  bool get _canSave => _title.trim().isNotEmpty && _dueDate != null;

  void _save() => Navigator.of(context).pop(SaveFocus(title: _title.trim(), dueDate: _dueDate!));

  @override
  Widget build(BuildContext context) {
    final point = widget.point;
    return Dialog(
      backgroundColor: HubColorPalette.surface,
      insetPadding: const EdgeInsets.all(HubSpacing.s24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HubSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s20,
            children: [
              Row(
                children: [
                  Expanded(child: Text(point == null ? 'New focus' : 'Focus', style: HubTextStyles.sectionTitle)),
                  HubIconButton(
                    glyph: HubGlyph.close,
                    semanticLabel: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              HubTextField(
                label: 'What',
                hint: 'e.g. Hub on the wall',
                initialValue: _title,
                onChanged: (value) => setState(() => _title = value),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: HubSpacing.s8,
                children: [
                  Text('By when', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
                  FocusDuePicker(today: _today, value: _dueDate, onChanged: (day) => setState(() => _dueDate = day)),
                ],
              ),
              Row(
                spacing: HubSpacing.s12,
                children: [
                  if (point != null)
                    HubIconButton(
                      glyph: HubGlyph.trash,
                      semanticLabel: 'Delete',
                      onPressed: () => Navigator.of(context).pop(const RemoveFocus()),
                    ),
                  const Spacer(),
                  HubButton(label: 'Save', glyph: HubGlyph.check, onPressed: _canSave ? _save : null),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
