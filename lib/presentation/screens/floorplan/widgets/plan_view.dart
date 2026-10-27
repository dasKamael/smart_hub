import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_painter.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_transform.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/room_labels.dart';

typedef PlanLayerBuilder = Widget Function(BuildContext context, PlanTransform transform);

/// The floor plan scaled to the available space.
///
/// Layers from bottom to top: plan, [glowBuilder], room labels, [markerBuilder].
class PlanView extends StatelessWidget {
  const PlanView({
    super.key,
    required this.plan,
    this.selectedRoomId,
    this.onTapPlan,
    this.glowBuilder,
    this.markerBuilder,
    this.stackKey,
    this.onLayout,
  });

  /// Keeps the 12 px outer wall and markers at the border visible.
  static const inset = 8.0;

  final FloorPlan plan;
  final String? selectedRoomId;

  /// Tap on the plan background (not on a marker), in plan coordinates.
  final ValueChanged<PlanPoint>? onTapPlan;
  final PlanLayerBuilder? glowBuilder;
  final PlanLayerBuilder? markerBuilder;

  /// Key of the plan area, to map global positions onto the plan.
  final GlobalKey? stackKey;

  /// Reports the transform of every layout, e.g. to convert drag positions.
  final ValueChanged<PlanTransform>? onLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final transform = PlanTransform.fit(PlanGeometryUtil.bounds(plan), constraints.biggest, inset: inset);
        onLayout?.call(transform);
        return Stack(
          key: stackKey,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: switch (onTapPlan) {
                  final onTap? => (details) => onTap(transform.toPlan(details.localPosition)),
                  null => null,
                },
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: PlanPainter(plan: plan, transform: transform, selectedRoomId: selectedRoomId),
                  ),
                ),
              ),
            ),
            // Own layers: moving markers must not repaint the glow (radial gradients clipped per room).
            if (glowBuilder case final builder?)
              Positioned.fill(child: RepaintBoundary(child: builder(context, transform))),
            Positioned.fill(
              child: RoomLabels(plan: plan, transform: transform, selectedRoomId: selectedRoomId),
            ),
            if (markerBuilder case final builder?)
              Positioned.fill(child: RepaintBoundary(child: builder(context, transform))),
          ],
        );
      },
    );
  }
}
