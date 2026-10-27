import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/lights/color_temperature.util.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/presentation/design_system/atoms/color_swatch_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/power_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/slider_bar.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/inspector_header.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_marker.dart';
import 'package:smart_hub/presentation/screens/lights/lights.controller.dart';
import 'package:smart_hub/presentation/screens/lights/widgets/light_color_dialog.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// Power, brightness and color of one light. Only controls the light supports are shown.
class LightInspector extends ConsumerWidget {
  const LightInspector({super.key, required this.device, required this.plan, required this.enabled});

  static const presets = [
    HubColorPalette.lightWarm,
    HubColorPalette.lightSoft,
    HubColorPalette.lightSunset,
    HubColorPalette.lightCool,
    HubColorPalette.lightViolet,
  ];

  final PlanLight device;
  final FloorPlan plan;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanControllerProvider.notifier);
    final light = device.light;
    final color = planLightColor(device);
    final canDim = light.capabilities.contains(LightCapability.brightness);
    final canColor = light.capabilities.contains(LightCapability.color);
    final canTune = light.capabilities.contains(LightCapability.colorTemperature);
    final brightness = light.brightnessPercent;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        Row(
          spacing: 14,
          children: [
            PowerButton(
              glyph: HubGlyph.bulb,
              background: light.isOn ? color : HubColorPalette.control,
              foreground: light.isOn ? HubColorPalette.surface : HubColorPalette.text2,
              glowColor: light.isOn ? color : null,
              semanticLabel: light.isOn ? 'Turn off' : 'Turn on',
              onTap: enabled ? () => controller.setLightsOn([light.id], on: !light.isOn) : null,
            ),
            Expanded(
              child: InspectorTitle(
                title: light.name,
                subtitle:
                    '${roomNameOf(device, plan)} · ${switch ((light.isOn, brightness)) {
                      (false, _) => 'Off',
                      (true, final percent?) => '$percent%',
                      (true, null) => 'On',
                    }}',
              ),
            ),
            HubButton(
              label: 'Remove',
              variant: HubButtonVariant.destructive,
              height: 36,
              onPressed: () => controller.removeDevice(light.id),
            ),
          ],
        ),
        if (canDim || canColor || canTune)
          Row(
            spacing: 14,
            children: [
              if (canDim)
                Expanded(
                  child: SliderBar(
                    value: light.isOn ? brightness ?? 100 : 0,
                    min: 1,
                    fillColor: color,
                    // The slider never goes below 1 %, so 0 means the light is off.
                    labelBuilder: (value) => value == 0 ? 'Off' : '$value%',
                    onChanged: enabled ? (value) => controller.changeBrightness(light.id, value) : null,
                    onChangeEnd: (value) => controller.endBrightness(light.id, value),
                  ),
                )
              else
                const Spacer(),
              if (canTune)
                SizedBox(
                  width: canColor ? 150 : 220,
                  child: ColorTemperatureSlider(
                    light: light,
                    enabled: enabled,
                    onChanged: (kelvin) => controller.changeKelvin(light.id, kelvin),
                    onChangeEnd: (kelvin) => controller.endKelvin(light.id, kelvin),
                  ),
                ),
              if (canColor)
                Row(
                  spacing: HubSpacing.s8,
                  children: [
                    for (final preset in presets)
                      ColorSwatchButton(
                        color: preset,
                        // White light (color temperature) never matches a color preset.
                        selected: _isClose(light.color, preset),
                        onTap: enabled ? () => controller.setLightColor(light.id, _rgbOf(preset)) : null,
                      ),
                    _MoreColors(
                      onTap: enabled
                          ? () {
                              final room = ref
                                  .read(lightRoomsProvider)
                                  .where((room) => room.lights.any((l) => l.id == light.id))
                                  .firstOrNull;
                              if (room != null) showLightColorDialog(context, roomId: room.id, lightId: light.id);
                            }
                          : null,
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }

  static RgbColor _rgbOf(Color color) {
    return RgbColor((color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round());
  }

  /// Lights report colors slightly converted, so presets are matched with a tolerance.
  static bool _isClose(RgbColor? actual, Color preset) {
    if (actual == null) return false;
    final target = _rgbOf(preset);
    return (actual.red - target.red).abs() + (actual.green - target.green).abs() + (actual.blue - target.blue).abs() <
        30;
  }
}

/// Warm ↔ cool slider for lights with color temperature (`README` → "Capability model").
class ColorTemperatureSlider extends StatelessWidget {
  const ColorTemperatureSlider({
    super.key,
    required this.light,
    required this.enabled,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final LightState light;
  final bool enabled;
  final ValueChanged<int> onChanged;
  final ValueChanged<int> onChangeEnd;

  /// Rounded to 50 K – finer steps are neither visible nor meaningful.
  int _kelvinAt(int percent) {
    final kelvin = light.minKelvin + (light.maxKelvin - light.minKelvin) * percent / 100;
    return (kelvin / 50).round() * 50;
  }

  int _percentOf(int kelvin) {
    final range = light.maxKelvin - light.minKelvin;
    return range <= 0 ? 0 : ((kelvin - light.minKelvin) * 100 / range).round().clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final kelvin = light.kelvin;
    return SliderBar(
      // Not in white mode: the knob rests in the middle, the label tells it.
      value: kelvin == null ? 50 : _percentOf(kelvin),
      fillColor: ColorTemperatureUtil.toRgb(kelvin ?? _kelvinAt(50)).toColor(),
      labelBuilder: (percent) => kelvin == null && percent == 50 ? 'Warm – cool' : '${_kelvinAt(percent)} K',
      onChanged: enabled ? (percent) => onChanged(_kelvinAt(percent)) : null,
      onChangeEnd: (percent) => onChangeEnd(_kelvinAt(percent)),
    );
  }
}

/// A swatch in all colors that opens the color wheel for this light.
class _MoreColors extends StatelessWidget {
  const _MoreColors({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'More colors',
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  Color(0xFFFF5F5F),
                  Color(0xFFFFC85F),
                  Color(0xFF8CF06E),
                  Color(0xFF5FD2FF),
                  Color(0xFF8C6EFF),
                  Color(0xFFFF6EC8),
                  Color(0xFFFF5F5F),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
