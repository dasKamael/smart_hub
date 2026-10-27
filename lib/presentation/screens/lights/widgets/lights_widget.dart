import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/presentation/shared_widgets/empty_mark.dart';
import 'package:smart_hub/domain/lights/light_bridge.service.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/vertical_slider.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/lights/light_room.dart';
import 'package:smart_hub/presentation/screens/lights/lights.controller.dart';
import 'package:smart_hub/presentation/screens/lights/widgets/room_detail_card.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// The lights as a dashboard widget in any [WidgetSize] (`Widget Kit` → Lights). Tapping a bulb switches its room
/// (or all lights), tapping elsewhere opens the lights page.
class LightsWidget extends ConsumerWidget {
  const LightsWidget({super.key, required this.size, this.roomIds = const [], this.card = true});

  final WidgetSize size;

  /// `false`: no card behind the widget (`DashboardWidget.card`).
  final bool card;

  /// The rooms to show, in this order; empty: all rooms in plan order. Rooms that are gone are skipped.
  final List<String> roomIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(lightRoomsProvider);
    final chosen = [for (final id in roomIds) ?all.where((room) => room.id == id).firstOrNull];
    final rooms = chosen.isEmpty ? all : chosen;
    final enabled = ref.watch(lightsOnlineProvider);
    final controller = ref.read(lightsControllerProvider.notifier);
    final selectedId = ref.watch(lightsControllerProvider.select((state) => state.selectedRoomId));
    final selected = rooms.where((room) => room.id == selectedId).firstOrNull ?? rooms.firstOrNull;

    return WidgetTile(
      card: card,
      // The color of the rooms this widget shows.
      tint: HubAreaColors.lightsFor([
        for (final room in rooms)
          if (room.isOn) _colorOf(room),
      ]),
      size: size,
      padding: switch (size) {
        WidgetSize.extraLarge => 18,
        _ => 16,
      },
      onTap: () => context.go(HubRoute.lights.path),
      child: switch ((ref.watch(hasLightsProvider), rooms)) {
        (false, _) => _Message(
          glyph: HubGlyph.bulb,
          text: 'No lights yet',
          detail: size == WidgetSize.small ? null : 'Connect Home Assistant or a light bridge in the settings.',
        ),
        (_, []) => const EmptyMark(glyph: HubGlyph.bulb, label: 'No lights yet', size: 48),
        _ => switch (size) {
          WidgetSize.small => _Small(rooms, onToggle: enabled ? () => controller.toggleAll(rooms) : null),
          WidgetSize.medium => _Medium(rooms, onToggle: enabled ? controller.toggleRoom : null),
          WidgetSize.large => _Large(
            rooms,
            onToggle: enabled ? controller.toggleRoom : null,
            onToggleAll: enabled ? () => controller.toggleAll(rooms) : null,
          ),
          WidgetSize.extraLarge => _ExtraLarge(
            rooms,
            selected: selected!,
            onSelect: (room) => controller.selectRoom(room.id),
            onToggle: enabled ? controller.toggleRoom : null,
            onBrightnessChanged: enabled ? (percent) => controller.changeBrightness(selected, percent) : null,
            onBrightnessEnd: (percent) => controller.endBrightness(selected, percent),
            scenes: ref.watch(roomScenesProvider(selected.id)),
            onScene: enabled ? (scene) => controller.applyScene(selected, scene) : null,
          ),
        },
      },
    );
  }
}

Color _colorOf(LightRoom room) => room.color?.toColor() ?? HubColorPalette.lightWarm;

/// All colors of a mixed room; a single color for the others.
List<Color> _colorsOf(LightRoom room) => [for (final color in room.colors) color.toColor()];

/// A mixed room's colors as a soft diagonal gradient, e.g. behind its tile; `null` for a single color.
Gradient? _mixOf(LightRoom room, {required double alpha}) {
  final colors = _colorsOf(room);
  if (!room.isOn || colors.length < 2) return null;
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [for (final color in colors) color.withValues(alpha: alpha)],
  );
}

/// One bulb that switches all rooms shown, and how many of them are lit.
class _Small extends StatelessWidget {
  const _Small(this.rooms, {required this.onToggle});

  final List<LightRoom> rooms;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final lit = rooms.where((room) => room.isOn).toList();
    final color = lit.isEmpty ? HubColorPalette.lightWarm : _colorOf(lit.first);
    // One chosen room: the widget is that room's switch.
    final single = rooms.length == 1 ? rooms.single : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Bulb(
          on: lit.isNotEmpty,
          color: color,
          size: 48,
          label: switch ((single, lit.isEmpty)) {
            (final room?, true) => 'Turn ${room.name} on',
            (final room?, false) => 'Turn ${room.name} off',
            (null, true) => 'Turn all lights on',
            (null, false) => 'Turn all lights off',
          },
          onTap: onToggle,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              single?.name ?? 'Lights',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HubTextStyles.body.copyWith(height: 1.2),
            ),
            Text(
              switch ((single, lit.isEmpty)) {
                (_, true) => single == null ? 'All off' : 'Off',
                (final room?, false) => 'On · ${room.brightnessPercent}%',
                (null, false) => '${lit.length} of ${rooms.length} rooms on',
              },
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HubTextStyles.secondary.copyWith(fontSize: 14, color: lit.isEmpty ? null : color),
            ),
          ],
        ),
      ],
    );
  }
}

/// The first four rooms as round bulbs.
class _Medium extends StatelessWidget {
  const _Medium(this.rooms, {required this.onToggle});

  static const _shown = 4;

  final List<LightRoom> rooms;
  final ValueChanged<LightRoom>? onToggle;

  @override
  Widget build(BuildContext context) {
    final lit = rooms.where((room) => room.isOn).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        _Header(title: 'Lights', trailing: lit == 0 ? 'All off' : '$lit on', titleSize: 17),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fewer rooms share the width instead of leaving gaps.
            for (var i = 0; i < rooms.length.clamp(1, _shown); i++)
              Expanded(
                child: i < rooms.length
                    ? Column(
                        spacing: 6,
                        children: [
                          _Bulb(
                            on: rooms[i].isOn,
                            color: _colorOf(rooms[i]),
                            colors: _colorsOf(rooms[i]),
                            size: 60,
                            label: rooms[i].name,
                            onTap: onToggle == null ? null : () => onToggle!(rooms[i]),
                          ),
                          Text(
                            rooms[i].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HubTextStyles.label.copyWith(fontSize: 12),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
          ],
        ),
      ],
    );
  }
}

/// Room tiles in two columns and "All off" / "All on".
class _Large extends StatelessWidget {
  const _Large(this.rooms, {required this.onToggle, required this.onToggleAll});

  static const _shown = 8;

  final List<LightRoom> rooms;
  final ValueChanged<LightRoom>? onToggle;
  final VoidCallback? onToggleAll;

  @override
  Widget build(BuildContext context) {
    final shown = rooms.take(_shown).toList();
    // Up to three rooms as wide rows, more in two columns; the tiles always fill the widget.
    final columns = shown.length <= 3 ? 1 : 2;
    final rows = (shown.length / columns).ceil().clamp(1, 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Lights', style: HubTextStyles.widgetTitle)),
            HubButton(
              label: rooms.any((room) => room.isOn) ? 'All off' : 'All on',
              variant: HubButtonVariant.secondary,
              height: 32,
              onPressed: onToggleAll,
            ),
          ],
        ),
        Expanded(
          child: Column(
            spacing: 8,
            children: [
              for (var row = 0; row < rows; row++)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      for (var column = 0; column < columns; column++)
                        Expanded(
                          child: switch (row * columns + column) {
                            final i when i < shown.length => _RoomRow(
                              shown[i],
                              onTap: onToggle == null ? null : () => onToggle!(shown[i]),
                            ),
                            _ => const SizedBox(),
                          },
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A room in the large widget: the whole tile switches it.
class _RoomRow extends StatelessWidget {
  const _RoomRow(this.room, {required this.onTap});

  final LightRoom room;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(room);
    return Semantics(
      button: true,
      label: room.name,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // While offline the control swallows the tap instead of opening the lights page.
        onTap: onTap ?? () {},
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: room.isOn ? color.withValues(alpha: 0.18) : HubColorPalette.elevated,
            gradient: _mixOf(room, alpha: 0.22),
            borderRadius: BorderRadius.circular(16),
          ),
          // Few rooms make tall tiles: bulb and text grow with them.
          child: LayoutBuilder(
            builder: (context, constraints) {
              final big = constraints.maxHeight > 110;
              return Row(
                spacing: big ? 14 : 10,
                children: [
                  _Bulb(on: room.isOn, color: color, colors: _colorsOf(room), size: big ? 52 : 34),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HubTextStyles.label.copyWith(fontSize: big ? 18 : 14),
                        ),
                        Text(
                          room.isOn ? '${room.brightnessPercent}%' : 'Off',
                          style: HubTextStyles.label
                              .copyWith(
                                fontSize: big ? 15 : 12,
                                fontWeight: FontWeight.w400,
                                color: room.isOn ? color : HubColorPalette.text2,
                              )
                              .tabular,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Rooms to pick, the brightness of the picked room and its scenes – the lights page in small.
class _ExtraLarge extends StatelessWidget {
  const _ExtraLarge(
    this.rooms, {
    required this.selected,
    required this.onSelect,
    required this.onToggle,
    required this.onBrightnessChanged,
    required this.onBrightnessEnd,
    required this.scenes,
    required this.onScene,
  });

  final List<LightRoom> rooms;
  final LightRoom selected;
  final ValueChanged<LightRoom> onSelect;
  final ValueChanged<LightRoom>? onToggle;
  final ValueChanged<int>? onBrightnessChanged;
  final ValueChanged<int> onBrightnessEnd;
  final List<SceneEntry> scenes;
  final ValueChanged<RoomScene>? onScene;

  @override
  Widget build(BuildContext context) {
    // The tiles fill the space: 1–2 rooms side by side, up to 4 in a square, then three columns.
    final columns = switch (rooms.length) {
      <= 2 => rooms.length.clamp(1, 2),
      <= 4 => 2,
      _ => 3,
    };
    final rows = (rooms.length / columns).ceil().clamp(1, 3);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        Expanded(
          child: Column(
            spacing: 10,
            children: [
              for (var row = 0; row < rows; row++)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      for (var column = 0; column < columns; column++)
                        Expanded(
                          child: switch (row * columns + column) {
                            final i when i < rooms.length => _RoomTile(
                              rooms[i],
                              selected: rooms[i].id == selected.id,
                              compact: rows > 2,
                              onSelect: () => onSelect(rooms[i]),
                              onToggle: onToggle == null ? null : () => onToggle!(rooms[i]),
                            ),
                            _ => const SizedBox(),
                          },
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        VerticalSlider(
          width: 96,
          value: selected.brightnessPercent,
          fillColor: _colorOf(selected),
          fillColors: _colorsOf(selected),
          label: selected.isOn ? '${selected.brightnessPercent}%' : 'Off',
          onChanged: onBrightnessChanged,
          onChangeEnd: onBrightnessEnd,
        ),
        SizedBox(
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              // The first four of the room's scenes.
              for (final entry in scenes.take(4))
                Expanded(
                  child: _SceneButton(entry: entry, onTap: onScene == null ? null : () => onScene!(entry.scene)),
                ),
              for (var i = scenes.length; i < 4; i++) const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

/// A room in the extra large widget: a tap switches the room and picks it, a long press only picks it.
class _RoomTile extends StatelessWidget {
  const _RoomTile(
    this.room, {
    required this.selected,
    required this.compact,
    required this.onSelect,
    required this.onToggle,
  });

  final LightRoom room;
  final bool selected;

  /// Three rows of rooms: a smaller bulb, the name only.
  final bool compact;
  final VoidCallback onSelect;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(room);
    return Semantics(
      button: true,
      selected: selected,
      label: room.name,
      hint: room.isOn ? 'Turn ${room.name} off' : 'Turn ${room.name} on',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onSelect();
          onToggle?.call();
        },
        onLongPress: onSelect,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: room.isOn ? color.withValues(alpha: 0.18) : HubColorPalette.elevated,
            gradient: _mixOf(room, alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
            // Outside stroke: a shadow would shine through the translucent tile color.
            border: Border.all(
              color: selected ? HubColorPalette.accent : Colors.transparent,
              width: 2.5,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // The whole tile switches the room.
              IgnorePointer(
                child: _Bulb(on: room.isOn, color: color, colors: _colorsOf(room), size: compact ? 32 : 42),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HubTextStyles.body.copyWith(fontSize: 16, height: 1.2),
                  ),
                  if (!compact)
                    Text(
                      room.isOn ? 'On · ${room.brightnessPercent}%' : 'Off',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HubTextStyles.label
                          .copyWith(fontWeight: FontWeight.w400, color: room.isOn ? color : HubColorPalette.text2)
                          .tabular,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SceneButton extends StatelessWidget {
  const _SceneButton({required this.entry, required this.onTap});

  final SceneEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final active = entry.active;
    return Semantics(
      button: true,
      selected: active,
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: active ? HubColorPalette.accent : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            spacing: 8,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: entry.color, shape: BoxShape.circle),
              ),
              Expanded(
                child: Text(
                  entry.scene.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: HubTextStyles.label.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Round bulb in the light's color with a glow while on; grey while off.
class _Bulb extends StatelessWidget {
  const _Bulb({required this.on, required this.color, required this.size, this.label, this.onTap, this.colors});

  final bool on;
  final Color color;

  /// Several colors of a mixed room, as a diagonal gradient.
  final List<Color>? colors;
  final double size;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final glyph = HubGlyph.bulb.markerSize * (size / 48 * 1.1);
    return Semantics(
      container: true,
      button: onTap != null,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ?? () {},
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? color : HubColorPalette.control,
            gradient: switch (colors) {
              final colors? when on && colors.length > 1 => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              _ => null,
            },
            shape: BoxShape.circle,
            boxShadow: [if (on) BoxShadow(color: color.withValues(alpha: 0.66), blurRadius: size / 3)],
          ),
          child: HubGlyphIcon(HubGlyph.bulb, color: on ? HubColorPalette.surface : HubColorPalette.text2, size: glyph),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.trailing, required this.titleSize});

  final String title;
  final String trailing;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            title,
            style: HubTextStyles.body.copyWith(fontSize: titleSize, fontWeight: FontWeight.w700),
          ),
        ),
        Text(trailing, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
      ],
    );
  }
}

/// No Home Assistant or no lights: a grey bulb and a short line; the lights page explains more.
class _Message extends StatelessWidget {
  const _Message({required this.glyph, required this.text, this.detail});

  final HubGlyph glyph;
  final String text;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
            child: HubGlyphIcon(glyph, color: HubColorPalette.text2),
          ),
          Text(text, textAlign: TextAlign.center, style: HubTextStyles.label.copyWith(fontSize: 14)),
          if (detail case final detail?)
            Text(detail, textAlign: TextAlign.center, style: HubTextStyles.secondary.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}
