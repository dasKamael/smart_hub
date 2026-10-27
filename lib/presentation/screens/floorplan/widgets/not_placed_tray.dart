import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/marker_layer.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_marker.dart';

/// Devices that are not on the plan yet.
///
/// Items are dragged upwards out of the tray (horizontal moves scroll it).
class NotPlacedTray extends StatelessWidget {
  const NotPlacedTray({super.key, required this.devices, required this.dragCallbacks, this.draggedId});

  final List<PlanDevice> devices;
  final MarkerDragCallbacks dragCallbacks;
  final String? draggedId;

  @override
  Widget build(BuildContext context) {
    return PageCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s4,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Not placed', style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(
                'Drag onto the plan',
                style: HubTextStyles.label.copyWith(fontWeight: FontWeight.w400, color: HubColorPalette.text2),
              ),
            ],
          ),
          Expanded(
            child: devices.isEmpty
                ? Center(child: Text('Everything is placed', style: HubTextStyles.secondary))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    itemCount: devices.length,
                    separatorBuilder: (_, _) => const SizedBox(width: HubSpacing.s8),
                    itemBuilder: (context, index) => _TrayItem(
                      device: devices[index],
                      isDragged: devices[index].id == draggedId,
                      dragCallbacks: dragCallbacks,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TrayItem extends StatelessWidget {
  const _TrayItem({required this.device, required this.isDragged, required this.dragCallbacks});

  final PlanDevice device;
  final bool isDragged;
  final MarkerDragCallbacks dragCallbacks;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        dragCallbacks.onStart(device, details.globalPosition);
        dragCallbacks.onUpdate(details.globalPosition);
      },
      onVerticalDragUpdate: (details) => dragCallbacks.onUpdate(details.globalPosition),
      onVerticalDragEnd: (_) => dragCallbacks.onEnd(),
      onVerticalDragCancel: dragCallbacks.onCancel,
      child: AnimatedOpacity(
        opacity: isDragged ? 0.35 : 1,
        duration: HubMotion.fadeDuration,
        child: SizedBox(
          width: 62,
          child: Column(
            spacing: 6,
            children: [
              PlanMarker(device: device),
              Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xB3EBEBF5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
