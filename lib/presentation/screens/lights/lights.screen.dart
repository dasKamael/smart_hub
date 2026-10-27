import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/lights/lights.controller.dart';
import 'package:smart_hub/presentation/screens/lights/widgets/room_detail_card.dart';
import 'package:smart_hub/presentation/screens/lights/widgets/room_tile.dart';
import 'package:smart_hub/presentation/shared_widgets/home_assistant_hint.dart';

/// Lights page: room tiles on the left, brightness and scenes of the selected room on the right.
class LightsScreen extends ConsumerWidget {
  const LightsScreen({super.key});

  static const _columns = 3;
  static const _gap = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(lightRoomsProvider);
    final selectedId = ref.watch(lightsControllerProvider.select((s) => s.selectedRoomId));
    final controller = ref.read(lightsControllerProvider.notifier);
    final enabled = ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false;
    final selected = rooms.where((room) => room.id == selectedId).firstOrNull ?? rooms.firstOrNull;
    final onCount = rooms.where((room) => room.isOn).length;

    if (!ref.watch(hasHomeAssistantProvider)) {
      return const PageCard(
        child: HomeAssistantHint(
          glyph: HubGlyph.bulb,
          title: 'Lights need Home Assistant',
          text: 'Connect Home Assistant to switch and dim your lights here and on the plan.',
        ),
      );
    }
    if (rooms.isEmpty) {
      return const PageCard(
        child: Center(child: Text('No lights yet', style: HubTextStyles.secondary)),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s16,
      children: [
        Expanded(
          flex: 15,
          child: PageCard(
            tint: ref.watch(lightsTintProvider),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: HubSpacing.s16,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rooms', style: HubTextStyles.sectionTitle),
                          Text(
                            onCount > 0 ? '$onCount of ${rooms.length} rooms on' : 'Everything is off',
                            style: HubTextStyles.secondary,
                          ),
                        ],
                      ),
                    ),
                    HubButton(
                      label: onCount > 0 ? 'All off' : 'All on',
                      variant: HubButtonVariant.secondary,
                      height: 42,
                      onPressed: enabled ? () => controller.toggleAll(rooms) : null,
                    ),
                  ],
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final rows = (rooms.length / _columns).ceil();
                      final tileWidth = (constraints.maxWidth - (_columns - 1) * _gap) / _columns;
                      final tileHeight = (constraints.maxHeight - (rows - 1) * _gap) / rows;
                      return GridView.count(
                        crossAxisCount: _columns,
                        mainAxisSpacing: _gap,
                        crossAxisSpacing: _gap,
                        childAspectRatio: tileWidth / tileHeight.clamp(120, double.infinity),
                        padding: const EdgeInsets.all(3),
                        children: [
                          for (final room in rooms)
                            RoomTile(
                              room: room,
                              selected: room.id == selected?.id,
                              onSelect: () => controller.selectRoom(room.id),
                              onToggle: enabled ? () => controller.toggleRoom(room) : null,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: selected == null
              ? const SizedBox.shrink()
              : RoomDetailCard(
                  tint: ref.watch(lightsTintProvider),
                  room: selected,
                  enabled: enabled,
                  onBrightnessChanged: (percent) => controller.changeBrightness(selected, percent),
                  onBrightnessEnd: (percent) => controller.endBrightness(selected, percent),
                  onScene: (scene) => controller.applyScene(selected, scene),
                ),
        ),
      ],
    );
  }
}
