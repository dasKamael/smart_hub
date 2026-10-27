import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/lights/color_temperature.util.dart';
import 'package:smart_hub/domain/lights/light_bridge.service.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/slider_bar.dart';
import 'package:smart_hub/presentation/design_system/molecules/color_wheel.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_segmented_control.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/lights/lights.controller.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// Colors and white light of a room, or of one of its lights (as in the lights app of the bridge).
Future<void> showLightColorDialog(BuildContext context, {required String roomId, String? lightId}) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => LightColorDialog(roomId: roomId, lightId: lightId),
  );
}

enum _Mode { color, white }

/// Quick picks of white light: name and color temperature.
const _whites = [('Candle', 2200), ('Warm', 2700), ('Soft', 3500), ('Neutral', 4000), ('Day', 5500), ('Cool', 6500)];

class LightColorDialog extends ConsumerStatefulWidget {
  const LightColorDialog({super.key, required this.roomId, this.lightId});

  final String roomId;

  /// The light chosen at first; `null` for all lights of the room.
  final String? lightId;

  @override
  ConsumerState<LightColorDialog> createState() => _LightColorDialogState();
}

class _LightColorDialogState extends ConsumerState<LightColorDialog> {
  static const _wheelSize = 320.0;

  /// Lamps that move together, by id; every lamp starts in a group with the lamps of the same color.
  List<List<String>>? _groups;

  /// The pin (its first lamp) whose lamps the brightness and the quick picks change; `null` for all.
  late String? _selected = widget.lightId;

  /// `null` until chosen: then it follows what the lamps show.
  _Mode? _mode;

  /// Where white pins were let go sideways – on the white wheel only the height counts.
  final _whiteX = <String, double>{};

  /// Lamps showing (almost) the same color start as one group, as in the lights app.
  List<List<String>> _groupsOf(List<LightState> lights) {
    final groups = <List<LightState>>[];
    for (final light in lights) {
      final group = groups.where((group) => _sameLook(group.first, light)).firstOrNull;
      group == null ? groups.add([light]) : group.add(light);
    }
    return [
      for (final group in groups) [for (final light in group) light.id],
    ];
  }

  static bool _sameLook(LightState a, LightState b) {
    if (a.isOn != b.isOn) return false;
    if (!a.isOn) return true;
    return switch ((a.displayColor, b.displayColor)) {
      (final x?, final y?) => (x.red - y.red).abs() + (x.green - y.green).abs() + (x.blue - y.blue).abs() < 30,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(lightRoomsProvider).where((room) => room.id == widget.roomId).firstOrNull;
    if (room == null) return const SizedBox.shrink();
    final tunable = [
      for (final light in room.lights)
        if (light.capabilities.contains(LightCapability.color) ||
            light.capabilities.contains(LightCapability.colorTemperature))
          light,
    ];
    final byId = {for (final light in tunable) light.id: light};
    final groups = [
      for (final group in _groups ??= _groupsOf(tunable))
        if (group.where(byId.containsKey).toList() case final members when members.isNotEmpty) members,
      // Lamps that joined the room meanwhile.
      for (final light in tunable)
        if (!(_groups ?? const []).any((group) => group.contains(light.id))) [light.id],
    ];
    final canColor = tunable.any((light) => light.capabilities.contains(LightCapability.color));
    final canWhite = tunable.any((light) => light.capabilities.contains(LightCapability.colorTemperature));
    final selectedGroup = groups.where((group) => group.contains(_selected)).firstOrNull;
    final targets = [
      for (final id in selectedGroup ?? [for (final group in groups) ...group]) byId[id]!,
    ];
    final lead =
        targets.where((light) => light.displayColor != null).firstOrNull ??
        targets.where((light) => light.isOn).firstOrNull ??
        targets.firstOrNull;
    final mode = switch (_mode) {
      _ when !canColor => _Mode.white,
      _ when !canWhite => _Mode.color,
      final chosen? => chosen,
      null => lead?.color == null ? _Mode.white : _Mode.color,
    };
    bool fits(LightState light) =>
        light.capabilities.contains(mode == _Mode.color ? LightCapability.color : LightCapability.colorTemperature);
    // Keeps the controller (and its throttling) alive while the dialog is open, also when opened from the plan.
    ref.listen(lightsControllerProvider, (_, _) {});
    final controller = ref.read(lightsControllerProvider.notifier);
    final enabled = ref.watch(lightsOnlineProvider);
    final white = WhiteWheelScale(
      minKelvin: tunable.map((light) => light.minKelvin).fold(10000, (a, b) => a < b ? a : b),
      maxKelvin: tunable.map((light) => light.maxKelvin).fold(0, (a, b) => a > b ? a : b),
      colorOf: (kelvin) => ColorTemperatureUtil.toRgb(kelvin).toColor(),
    );
    final shownColor = lead?.displayColor?.toColor();

    // One pin per group, for the lamps of the group that this wheel can change.
    final visible = [
      for (final group in groups)
        if ([
              for (final id in group)
                if (fits(byId[id]!)) byId[id]!,
            ]
            case final lamps when lamps.isNotEmpty)
          lamps,
    ];
    final center = const Offset(_wheelSize / 2, _wheelSize / 2);
    final pins = [
      for (final (index, lamps) in visible.indexed)
        _pinOf(
          lamps,
          index: index,
          count: visible.length,
          mode: mode,
          white: white,
          center: center,
          selected: lamps.any((light) => light.id == _selected),
        ),
    ];
    List<LightState> lampsOf(String pinId) => visible.firstWhere((lamps) => lamps.first.id == pinId);

    void apply(List<LightState> lamps, Offset local, {required bool done}) {
      switch (mode) {
        case _Mode.color:
          final color = ColorWheelScale.colorAt(local, _wheelSize).toRgb();
          done ? controller.endColor(lamps, color) : controller.changeColor(lamps, color);
        case _Mode.white:
          _whiteX[lamps.first.id] = local.dx;
          final kelvin = white.kelvinAt(local, _wheelSize);
          done ? controller.endKelvin(lamps, kelvin) : controller.changeKelvin(lamps, kelvin);
      }
    }

    void merge(String dropped, String target) {
      final moving = lampsOf(dropped);
      setState(() {
        _groups = [
          for (final group in groups)
            if (!group.contains(dropped) && !group.contains(target)) group,
          [
            for (final group in groups)
              if (group.contains(target) || group.contains(dropped)) ...group,
          ],
        ];
        _selected = target;
      });
      // The dropped lamps take on the color of the ones they joined.
      final pin = pins.firstWhere((pin) => pin.id == target);
      apply(moving, pin.position, done: true);
    }

    void tap(String pinId) {
      final group = groups.firstWhere((group) => group.contains(pinId));
      setState(() {
        if (group.length > 1) {
          // A group comes apart into its lamps.
          _groups = [
            for (final other in groups)
              if (other != group) other else for (final id in other) [id],
          ];
          _selected = null;
        } else {
          _selected = _selected == pinId ? null : pinId;
        }
      });
    }

    void groupAll() {
      final anchor = pins.where((pin) => pin.selected).firstOrNull ?? pins.firstOrNull;
      if (anchor == null) return;
      final others = [
        for (final lamps in visible)
          if (lamps.first.id != anchor.id) ...lamps,
      ];
      setState(() {
        _groups = [
          [for (final group in groups) ...group],
        ];
        _selected = anchor.id;
      });
      if (others.isNotEmpty) apply(others, anchor.position, done: true);
    }

    return Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 28, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 24,
            children: [
              _Header(
                title: selectedGroup == null
                    ? room.name
                    : selectedGroup.length == 1
                    ? byId[selectedGroup.single]!.name
                    : '${selectedGroup.length} lights',
                subtitle: _describe(targets, lead),
                onClose: () => Navigator.of(context).pop(),
              ),
              if (tunable.isEmpty)
                const Text('The lights here can only be switched and dimmed.', style: HubTextStyles.secondary)
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 36,
                  children: [
                    Column(
                      spacing: 16,
                      children: [
                        // A soft halo in the shown color behind the wheel; room above for pins on the top rim.
                        AnimatedContainer(
                          duration: HubMotion.fadeDuration,
                          margin: const EdgeInsets.only(top: 56),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (shownColor ?? HubColorPalette.lightWarm).withValues(alpha: 0.28),
                                blurRadius: 60,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: PinWheel(
                            size: _wheelSize,
                            enabled: enabled,
                            background: mode == _Mode.color ? ColorWheelScale.painter : white.painter,
                            pins: pins,
                            colorAt: (local) => switch (mode) {
                              _Mode.color => ColorWheelScale.colorAt(local, _wheelSize),
                              _Mode.white => white.colorOf(white.kelvinAt(local, _wheelSize)),
                            },
                            onMove: (id, local) => apply(lampsOf(id), local, done: false),
                            onMoveEnd: (id, local) => apply(lampsOf(id), local, done: true),
                            onMerge: merge,
                            onTap: tap,
                          ),
                        ),
                        SizedBox(
                          width: _wheelSize,
                          child: Text(
                            pins.length > 1
                                ? 'Drag lamps onto each other to group them'
                                : (visible.firstOrNull?.length ?? 0) > 1
                                ? 'Tap the group to move lamps one by one'
                                : 'Drag the lamp to change its color',
                            textAlign: TextAlign.center,
                            style: HubTextStyles.secondary.copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 22,
                        children: [
                          if (canColor && canWhite)
                            HubSegmentedControl(
                              values: _Mode.values,
                              selected: mode,
                              labelOf: (mode) => switch (mode) {
                                _Mode.color => 'Color',
                                _Mode.white => 'White',
                              },
                              onChanged: (mode) => setState(() => _mode = mode),
                            ),
                          _QuickPicks(
                            children: switch (mode) {
                              _Mode.white => [
                                for (final (name, kelvin) in _whites)
                                  if (kelvin >= white.minKelvin - 100 && kelvin <= white.maxKelvin + 100)
                                    _Swatch(
                                      color: ColorTemperatureUtil.toRgb(kelvin).toColor(),
                                      label: name,
                                      selected: lead?.kelvin != null && (lead!.kelvin! - kelvin).abs() <= 120,
                                      onTap: enabled
                                          ? () => controller.endKelvin(targets.where(fits).toList(), kelvin)
                                          : null,
                                    ),
                              ],
                              _Mode.color => [
                                for (final preset in [...HubColorPalette.lightPresets, ..._vivid])
                                  _Swatch(
                                    color: preset,
                                    selected: _isClose(lead?.color?.toColor(), preset),
                                    onTap: enabled
                                        ? () => controller.endColor(targets.where(fits).toList(), preset.toRgb())
                                        : null,
                                  ),
                              ],
                            },
                          ),
                          SliderBar(
                            value: lead?.isOn == true ? lead?.brightnessPercent ?? 100 : 0,
                            height: 52,
                            fillColor: shownColor ?? HubColorPalette.lightWarm,
                            labelBuilder: (value) => value == 0 ? 'Off' : '$value %',
                            onChanged: enabled
                                ? (value) => controller.changeBrightnessOf(targets, value.clamp(1, 100))
                                : null,
                            onChangeEnd: (value) => controller.endBrightnessOf(targets, value.clamp(1, 100)),
                          ),
                          if (pins.length > 1)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: HubButton(
                                label: 'Group all',
                                variant: HubButtonVariant.secondary,
                                height: 40,
                                onPressed: enabled ? groupAll : null,
                              ),
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

  /// The pin of [lamps]: where the first lamp with a color sits; lamps that are off or unknown wait near the middle.
  WheelPin _pinOf(
    List<LightState> lamps, {
    required int index,
    required int count,
    required _Mode mode,
    required WhiteWheelScale white,
    required Offset center,
    required bool selected,
  }) {
    final lead = lamps.where((light) => light.displayColor != null).firstOrNull;
    final spread = (index - (count - 1) / 2) * 56;
    final position = switch ((mode, lead)) {
      (_Mode.color, LightState(:final color?)) => ColorWheelScale.positionOf(color.toColor(), _wheelSize),
      (_Mode.color, LightState(:final kelvin?)) => ColorWheelScale.positionOf(
        ColorTemperatureUtil.toRgb(kelvin).toColor(),
        _wheelSize,
      ),
      (_Mode.white, LightState(:final kelvin?)) => Offset(
        _whiteX[lamps.first.id] ?? center.dx + spread,
        white.heightOf(kelvin, _wheelSize),
      ),
      _ => center + Offset(spread, 0),
    };
    return WheelPin(
      id: lamps.first.id,
      position: position,
      color: lead?.displayColor?.toColor() ?? const Color(0xFF8A8F99),
      label: lamps.length == 1 ? lamps.single.name : '${lamps.length} lights',
      count: lamps.length,
      selected: selected,
    );
  }

  /// Saturated colors next to the soft presets.
  static const _vivid = [Color(0xFFFF453A), Color(0xFF30D158), Color(0xFF0A84FF)];

  static String _describe(List<LightState> targets, LightState? shown) {
    final count = targets.length == 1 ? '1 light' : '${targets.length} lights';
    final on = targets.where((light) => light.isOn).length;
    if (on == 0) return '$count · off';
    return switch (shown) {
      LightState(:final kelvin?) => '$count · white $kelvin K',
      LightState(color: _?) => '$count · color',
      _ => '$count · on',
    };
  }

  static bool _isClose(Color? actual, Color preset) {
    if (actual == null) return false;
    final a = actual.toRgb();
    final b = preset.toRgb();
    return (a.red - b.red).abs() + (a.green - b.green).abs() + (a.blue - b.blue).abs() < 45;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle, required this.onClose});

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: HubTextStyles.pageTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(subtitle, style: HubTextStyles.secondary),
            ],
          ),
        ),
        HubIconButton(glyph: HubGlyph.close, semanticLabel: 'Close', onPressed: onClose),
      ],
    );
  }
}

class _QuickPicks extends StatelessWidget {
  const _QuickPicks({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 12, runSpacing: 12, children: children);
  }
}

/// A round color to pick at once; white tones carry a name.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.selected, required this.onTap, this.label});

  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final dot = AnimatedContainer(
      duration: HubMotion.fadeDuration,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? HubColorPalette.text : const Color(0x00FFFFFF),
          width: 2.5,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1,
          child: switch (label) {
            final label? => SizedBox(
              width: 52,
              child: Column(
                spacing: 4,
                children: [
                  dot,
                  Text(label, style: HubTextStyles.label.copyWith(fontSize: 11, color: HubColorPalette.text2)),
                ],
              ),
            ),
            null => dot,
          },
        ),
      ),
    );
  }
}
