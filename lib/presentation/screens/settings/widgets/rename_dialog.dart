import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Asks for a new name. Returns the name, an empty string to reset it, or `null` when cancelled.
Future<String?> showRenameDialog(BuildContext context, {required String current}) {
  var name = current;
  return showDialog<String>(
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
              const Text('Rename', style: HubTextStyles.pageTitle),
              HubTextField(label: 'Name in the hub', initialValue: current, onChanged: (value) => name = value),
              Row(
                spacing: HubSpacing.s12,
                children: [
                  HubButton(
                    label: 'Reset',
                    variant: HubButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(''),
                  ),
                  const Spacer(),
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
}
