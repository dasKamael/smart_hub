import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/lights/light_bridge.service.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_filter_chip.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.state.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/glow_layer.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/inspector_card.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/marker_layer.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/not_placed_tray.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_marker.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_transform.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_view.dart';

/// Full page floor plan: plan card on top, inspector and "not placed" tray below.
///
/// Owns the drag gestures: global finger positions are mapped onto the plan here. A device dragged out of the
/// tray follows the finger as a ghost until it is over the plan.
class FloorplanScreen extends ConsumerStatefulWidget {
  const FloorplanScreen({super.key});

  static const bottomRowHeight = 168.0;

  @override
  ConsumerState<FloorplanScreen> createState() => _FloorplanScreenState();
}

class _FloorplanScreenState extends ConsumerState<FloorplanScreen> {
  final _screenKey = GlobalKey();
  final _planKey = GlobalKey();
  final _ghost = ValueNotifier<Offset?>(null);
  PlanTransform? _transform;
  PlanDevice? _ghostDevice;

  FloorplanController get _controller => ref.read(floorplanControllerProvider.notifier);

  late final _dragCallbacks = MarkerDragCallbacks(
    onStart: (device, global) {
      _ghostDevice = device;
      _controller.startDrag(device);
    },
    onUpdate: (global) {
      final onPlan = _planPointAt(global);
      _ghost.value = onPlan == null ? _screenOffsetOf(global) : null;
      _controller.updateDrag(onPlan ?? (_ghostDevice?.isPlaced == true ? _clampedPlanPointAt(global) : null));
    },
    onEnd: () {
      _ghost.value = null;
      _controller.endDrag();
    },
    onCancel: () {
      _ghost.value = null;
      _controller.cancelDrag();
    },
  );

  @override
  void dispose() {
    _ghost.dispose();
    super.dispose();
  }

  /// The plan position under [global], or `null` when the finger is not over the plan area.
  PlanPoint? _planPointAt(Offset global) {
    final box = _planKey.currentContext?.findRenderObject() as RenderBox?;
    final transform = _transform;
    if (box == null || transform == null) return null;
    final local = box.globalToLocal(global);
    if (!(Offset.zero & box.size).contains(local)) return null;
    return transform.toPlan(local);
  }

  /// Like [_planPointAt], but outside of the plan area the point is kept at the border (the controller clamps).
  PlanPoint? _clampedPlanPointAt(Offset global) {
    final box = _planKey.currentContext?.findRenderObject() as RenderBox?;
    final transform = _transform;
    if (box == null || transform == null) return null;
    return transform.toPlan(box.globalToLocal(global));
  }

  Offset? _screenOffsetOf(Offset global) {
    final box = _screenKey.currentContext?.findRenderObject() as RenderBox?;
    return box?.globalToLocal(global);
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(floorPlanServiceProvider).value;
    final devices = ref.watch(planDevicesProvider);
    final draggedId = ref.watch(floorplanControllerProvider.select((s) => s.drag?.deviceId));

    return Stack(
      key: _screenKey,
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: HubSpacing.s16,
          children: [
            Expanded(
              child: PageCard(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: HubSpacing.s12,
                  children: [
                    const _LayerChips(),
                    Expanded(
                      child: plan == null
                          ? const SizedBox.shrink()
                          : _Plan(
                              plan: plan,
                              planKey: _planKey,
                              dragCallbacks: _dragCallbacks,
                              onLayout: (transform) => _transform = transform,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: FloorplanScreen.bottomRowHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: HubSpacing.s16,
                children: [
                  Expanded(flex: 16, child: plan == null ? const SizedBox.shrink() : InspectorCard(plan: plan)),
                  Expanded(
                    flex: 10,
                    child: NotPlacedTray(
                      devices: devices.where((d) => !d.isPlaced).toList(),
                      draggedId: draggedId,
                      dragCallbacks: _dragCallbacks,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ValueListenableBuilder<Offset?>(
          valueListenable: _ghost,
          builder: (context, offset, _) {
            final device = _ghostDevice;
            if (offset == null || device == null || draggedId == null) return const SizedBox.shrink();
            return Positioned(
              left: offset.dx - MarkerLayer.markerSize / 2,
              top: offset.dy - MarkerLayer.markerSize / 2,
              child: IgnorePointer(
                child: PlanMarker(device: device, highlight: MarkerHighlight.lifted),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LayerChips extends ConsumerWidget {
  const _LayerChips();

  static const _labels = {
    PlanLayer.plants: 'Plants',
    PlanLayer.lights: 'Lights',
    PlanLayer.speakers: 'Speakers',
    PlanLayer.glow: 'Glow',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers = ref.watch(floorplanControllerProvider.select((s) => s.layers));
    final controller = ref.read(floorplanControllerProvider.notifier);
    // Without lights and speakers there are only plants – nothing to switch between.
    if (!ref.watch(hasLightsProvider)) return const SizedBox(height: 36);
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 6,
        children: [
          for (final MapEntry(key: layer, value: label) in _labels.entries)
            HubFilterChip(label: label, selected: layers.contains(layer), onTap: () => controller.toggleLayer(layer)),
        ],
      ),
    );
  }
}

class _Plan extends ConsumerWidget {
  const _Plan({required this.plan, required this.planKey, required this.dragCallbacks, required this.onLayout});

  final FloorPlan plan;
  final GlobalKey planKey;
  final MarkerDragCallbacks dragCallbacks;
  final ValueChanged<PlanTransform> onLayout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(floorplanControllerProvider);
    final controller = ref.read(floorplanControllerProvider.notifier);
    final drag = state.drag;
    // The dragged device is shown where the finger is, including devices from the tray.
    final devices = [
      for (final device in ref.watch(planDevicesProvider))
        device.id == drag?.deviceId ? device.withPosition(drag?.position) : device,
    ];
    final selection = state.selection;

    return PlanView(
      plan: plan,
      stackKey: planKey,
      onLayout: onLayout,
      selectedRoomId: selection is RoomSelection ? selection.roomId : null,
      onTapPlan: (point) {
        final room = RoomLookupUtil.roomAt(plan, point);
        room == null ? controller.clearSelection() : controller.tapRoom(room.id);
      },
      glowBuilder: (context, transform) => GlowLayer(
        plan: plan,
        transform: transform,
        lights: devices.whereType<PlanLight>().toList(),
        visible: state.layers.containsAll({PlanLayer.lights, PlanLayer.glow}),
      ),
      markerBuilder: (context, transform) => MarkerLayer(
        devices: devices,
        transform: transform,
        layers: state.layers,
        groups: ref.watch(planGroupsProvider),
        drag: drag,
        openGroupKey: state.openGroupKey,
        selectedDeviceId: selection is DeviceSelection ? selection.deviceId : null,
        dragCallbacks: dragCallbacks,
        onTapDevice: controller.tapDevice,
        onTapGroup: controller.openGroup,
        onCloseGroup: controller.closeGroup,
      ),
    );
  }
}
