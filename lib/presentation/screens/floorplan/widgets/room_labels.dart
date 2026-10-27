import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_transform.dart';

/// Room name and area in the top left area of every room.
class RoomLabels extends StatelessWidget {
  const RoomLabels({super.key, required this.plan, required this.transform, this.selectedRoomId});

  static const _padding = Offset(12, 9);

  final FloorPlan plan;
  final PlanTransform transform;
  final String? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          for (final room in plan.rooms)
            Positioned(
              left: transform.toPx(_topLeft(room)).dx + _padding.dx,
              top: transform.toPx(_topLeft(room)).dy + _padding.dy,
              width: _labelWidth(room),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: HubTextStyles.secondary.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: room.id == selectedRoomId ? HubColorPalette.accentText : HubColorPalette.text2,
                      ),
                    ),
                    Text(
                      '${PlanGeometryUtil.areaInSquareMeters(room.polygon).toStringAsFixed(1)} m²',
                      style: HubTextStyles.label.copyWith(fontSize: 12, color: HubColorPalette.text3).tabular,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Labels shrink to fit narrow rooms.
  double _labelWidth(Room room) {
    final xs = room.polygon.map((p) => p.x);
    return ((xs.reduce(math.max) - xs.reduce(math.min)) * transform.scale - 2 * _padding.dx).clamp(1, double.infinity);
  }

  static PlanPoint _topLeft(Room room) {
    return PlanPoint(room.polygon.map((p) => p.x).reduce(math.min), room.polygon.map((p) => p.y).reduce(math.min));
  }
}
