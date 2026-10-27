import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Horizontal slider that fills with the device color and shows its value inside (`UI Library` → "SliderBar").
class SliderBar extends StatefulWidget {
  const SliderBar({
    super.key,
    required this.value,
    required this.fillColor,
    required this.labelBuilder,
    this.onChanged,
    this.onChangeEnd,
    this.min = 0,
    this.height = 40,
  });

  /// 0–100.
  final int value;
  final int min;
  final Color fillColor;
  final String Function(int value) labelBuilder;

  /// Called while dragging; `null` disables the slider.
  final ValueChanged<int>? onChanged;
  final ValueChanged<int>? onChangeEnd;
  final double height;

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  static const _labelInset = 14.0;

  /// Value while the finger is down; the widget value may lag behind until the device reports back.
  int? _dragValue;

  bool get _enabled => widget.onChanged != null;

  int _valueAt(Offset local, double width) => (local.dx / width * 100).round().clamp(widget.min, 100);

  void _update(Offset local, double width) {
    final value = _valueAt(local, width);
    if (value == _dragValue) return;
    setState(() => _dragValue = value);
    widget.onChanged?.call(value);
  }

  void _end() {
    final value = _dragValue;
    if (value != null) widget.onChangeEnd?.call(value);
    setState(() => _dragValue = null);
  }

  @override
  Widget build(BuildContext context) {
    final value = _dragValue ?? widget.value;
    final fraction = value / 100;
    final label = widget.labelBuilder(value);
    final labelStyle = HubTextStyles.label.copyWith(fontSize: 14, fontWeight: FontWeight.w700).tabular;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Dark text only where a light fill really covers the label, otherwise it would vanish on the dark track.
        final labelWidth = (TextPainter(
          text: TextSpan(text: label, style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout()).width;
        final darkText = width * fraction >= _labelInset + labelWidth && widget.fillColor.computeLuminance() > 0.4;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled ? (details) => _update(details.localPosition, width) : null,
          onTapUp: _enabled ? (_) => _end() : null,
          onHorizontalDragStart: _enabled ? (details) => _update(details.localPosition, width) : null,
          onHorizontalDragUpdate: _enabled ? (details) => _update(details.localPosition, width) : null,
          onHorizontalDragEnd: _enabled ? (_) => _end() : null,
          child: AnimatedOpacity(
            opacity: _enabled ? 1 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(HubRadius.slider),
              child: SizedBox(
                height: widget.height,
                child: Stack(
                  children: [
                    const Positioned.fill(child: ColoredBox(color: HubColorPalette.control)),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: width * fraction,
                      child: ColoredBox(color: widget.fillColor),
                    ),
                    Positioned(
                      left: _labelInset,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Text(
                          label,
                          style: labelStyle.copyWith(color: darkText ? HubColorPalette.surface : HubColorPalette.text),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
