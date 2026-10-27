import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// Tall slider that fills from the bottom, e.g. room brightness (`Widget Kit` → Lights, full page).
class VerticalSlider extends StatefulWidget {
  const VerticalSlider({
    super.key,
    required this.value,
    required this.fillColor,
    required this.label,
    this.onChanged,
    this.onChangeEnd,
    this.width = 110,
  });

  /// 0–100.
  final int value;
  final Color fillColor;
  final String label;

  /// `null` disables the slider.
  final ValueChanged<int>? onChanged;
  final ValueChanged<int>? onChangeEnd;
  final double width;

  @override
  State<VerticalSlider> createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  int? _dragValue;

  bool get _enabled => widget.onChanged != null;

  void _update(Offset local, double height) {
    final value = ((height - local.dy) / height * 100).round().clamp(1, 100);
    if (value == _dragValue) return;
    setState(() => _dragValue = value);
    widget.onChanged?.call(value);
  }

  void _end() {
    if (_dragValue case final value?) widget.onChangeEnd?.call(value);
    setState(() => _dragValue = null);
  }

  @override
  Widget build(BuildContext context) {
    final value = _dragValue ?? widget.value;
    final label = _dragValue == null ? widget.label : '$value%';
    final darkText = value > 15 && widget.fillColor.computeLuminance() > 0.4;
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Semantics(
          slider: true,
          value: label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled ? (details) => _update(details.localPosition, height) : null,
            onTapUp: _enabled ? (_) => _end() : null,
            onVerticalDragStart: _enabled ? (details) => _update(details.localPosition, height) : null,
            onVerticalDragUpdate: _enabled ? (details) => _update(details.localPosition, height) : null,
            onVerticalDragEnd: _enabled ? (_) => _end() : null,
            child: AnimatedOpacity(
              opacity: _enabled ? 1 : 0.4,
              duration: HubMotion.fadeDuration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SizedBox(
                  width: widget.width,
                  child: Stack(
                    children: [
                      const Positioned.fill(child: ColoredBox(color: HubColorPalette.elevated)),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: height * value / 100,
                        child: ColoredBox(color: widget.fillColor),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 16,
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            color: darkText ? HubColorPalette.surface : HubColorPalette.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
