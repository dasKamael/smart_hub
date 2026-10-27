import 'package:flutter/material.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';

/// Name of the room [device] stands in, derived from its position.
String roomNameOf(PlanDevice device, FloorPlan plan) {
  final position = device.position;
  if (position == null) return 'Not placed';
  return RoomLookupUtil.roomAt(plan, position)?.name ?? 'Outside';
}

/// Title 20/700 with a secondary line below, ellipsized.
class InspectorTitle extends StatelessWidget {
  const InspectorTitle({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: HubTextStyles.widgetTitle),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: HubTextStyles.secondary.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
