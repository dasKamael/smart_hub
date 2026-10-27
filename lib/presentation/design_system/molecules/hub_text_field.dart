import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Labeled text input on an elevated surface.
class HubTextField extends StatelessWidget {
  const HubTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hint,
    this.helper,
    this.initialValue,
    this.obscure = false,
    this.keyboardType,
    this.onSubmitted,
    this.controller,
    this.maxLines = 1,
    this.style,
  });

  final String label;
  final String? hint;
  final String? helper;
  final String? initialValue;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  /// For text set from outside, e.g. pasted; [initialValue] is ignored then.
  final TextEditingController? controller;
  final int maxLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HubSpacing.s8,
      children: [
        Text(label, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          maxLines: maxLines,
          obscureText: obscure,
          keyboardType: keyboardType,
          autocorrect: false,
          enableSuggestions: false,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          style: style ?? HubTextStyles.body.copyWith(fontWeight: FontWeight.w500),
          cursorColor: HubColorPalette.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: HubTextStyles.body.copyWith(fontWeight: FontWeight.w500, color: HubColorPalette.text3),
            filled: true,
            fillColor: HubColorPalette.elevated,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HubRadius.tile),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HubRadius.tile),
              borderSide: const BorderSide(color: HubColorPalette.accent, width: 2),
            ),
          ),
        ),
        if (helper case final helper?) Text(helper, style: HubTextStyles.label.copyWith(color: HubColorPalette.text3)),
      ],
    );
  }
}
