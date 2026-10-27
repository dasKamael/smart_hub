import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

enum HubButtonVariant { primary, secondary, destructive }

/// Pill button (`UI Library` → "Buttons"). Pressed state scales to .96.
class HubButton extends StatefulWidget {
  const HubButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = HubButtonVariant.primary,
    this.isLoading = false,
    this.height = 44,
    this.glyph,
  });

  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final HubButtonVariant variant;
  final bool isLoading;
  final double height;

  /// Optional icon in front of the label.
  final HubGlyph? glyph;

  @override
  State<HubButton> createState() => _HubButtonState();
}

class _HubButtonState extends State<HubButton> {
  var _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (widget.variant) {
      HubButtonVariant.primary => (HubColorPalette.accent, HubColorPalette.text),
      HubButtonVariant.secondary => (HubColorPalette.elevated, HubColorPalette.text),
      HubButtonVariant.destructive => (HubColorPalette.elevated, HubColorPalette.dangerText),
    };
    return Semantics(
      button: true,
      enabled: _enabled,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
        onTap: _enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          child: AnimatedOpacity(
            opacity: widget.onPressed == null ? 0.4 : 1,
            duration: HubMotion.fadeDuration,
            child: Container(
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(widget.height / 2)),
              // Hugs its label; a parent can still stretch it.
              child: Center(
                widthFactor: 1,
                child: widget.isLoading
                    ? SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          if (widget.glyph case final glyph?) HubGlyphIcon(glyph, color: foreground),
                          Text(widget.label, style: HubTextStyles.body.copyWith(fontSize: 15, color: foreground)),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
