import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Asks for a name, e.g. of a new scene. Returns the trimmed name, or `null` when cancelled or left empty.
Future<String?> showNameDialog(BuildContext context, {required String title, String initial = ''}) async {
  var name = initial;
  final result = await showDialog<String>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s20,
            children: [
              Text(title, style: HubTextStyles.pageTitle),
              HubTextField(
                label: 'Name',
                initialValue: initial,
                onChanged: (value) => name = value,
                onSubmitted: (value) => Navigator.of(context).pop(value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: HubSpacing.s12,
                children: [
                  HubButton(
                    label: 'Cancel',
                    variant: HubButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  HubButton(label: 'Save', onPressed: () => Navigator.of(context).pop(name)),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  final trimmed = result?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
