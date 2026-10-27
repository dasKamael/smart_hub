import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_hub/domain/floorplan/grouping.util.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.state.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_marker.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_transform.dart';

/// Callbacks for dragging markers; positions are global, the screen maps them onto the plan.
class MarkerDragCallbacks {
  const MarkerDragCallbacks({
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
    required this.onCancel,
  });

  final void Function(PlanDevice device, Offset globalPosition) onStart;
  final ValueChanged<Offset> onUpdate;
  final VoidCallback onEnd;
  final VoidCallback onCancel;
}

/// Placed devices as markers, collapsed groups as stacks and the open group fanned out.
///
/// One widget per device with a stable key, so moves, stacking and fanning out animate.
class MarkerLayer extends StatelessWidget {
  const MarkerLayer({
    super.key,
    required this.devices,
    required this.transform,
    required this.layers,
    required this.groups,
    required this.dragCallbacks,
    required this.onTapDevice,
    required this.onTapGroup,
    required this.onCloseGroup,
    this.selectedDeviceId,
    this.drag,
    this.openGroupKey,
  });

  static const markerSize = 44.0;
  static const dragThreshold = 5.0;
  static const _stackOffsets = [Offset.zero, Offset(-7, -6), Offset(-14, -12)];

  final List<PlanDevice> devices;
  final PlanTransform transform;
  final Set<PlanLayer> layers;
  final List<List<String>> groups;
  final MarkerDragCallbacks dragCallbacks;
  final ValueChanged<String> onTapDevice;
  final ValueChanged<String> onTapGroup;
  final VoidCallback onCloseGroup;
  final String? selectedDeviceId;
  final PlanDrag? drag;
  final String? openGroupKey;

  @override
  Widget build(BuildContext context) {
    final centers = <String, Offset>{
      for (final device in devices)
        if ((device.id == drag?.deviceId ? drag?.position : device.position) case final position?)
          device.id: transform.toPx(position),
    };
    final groupOf = <String, ({List<String> members, int index, Offset center})>{};
    for (final members in groups) {
      final center = members.map((id) => centers[id]!).reduce((a, b) => a + b) / members.length.toDouble();
      for (final (index, id) in members.indexed) {
        groupOf[id] = (members: members, index: index, center: center);
      }
    }
    final targetId = drag?.targetId;

    final slots = <_Slot>[];
    for (final device in devices) {
      final center = centers[device.id];
      if (center == null) continue;
      slots.add(_slotFor(device, center, groupOf[device.id], targetId));
    }
    slots.sort((a, b) => a.z.compareTo(b.z));

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final slot in slots) slot.widget,
        // Above the markers: collapsed markers ignore taps, so the stack's tap target and count pill sit on top.
        for (final members in groups) ..._groupControls(members, groupOf[members.first]!.center, targetId),
        if (targetId != null && centers[targetId] != null && !_isInClosedGroup(targetId, groupOf))
          _pillAbove(centers[targetId]!, 'Group', key: const ValueKey('target-pill')),
      ],
    );
  }

  bool _isInClosedGroup(String id, Map<String, ({List<String> members, int index, Offset center})> groupOf) {
    final group = groupOf[id];
    return group != null && GroupingUtil.groupKey(group.members) != openGroupKey;
  }

  _Slot _slotFor(
    PlanDevice device,
    Offset center,
    ({List<String> members, int index, Offset center})? group,
    String? targetId,
  ) {
    final visible = isLayerVisible(device.kind, layers);
    final isDragged = device.id == drag?.deviceId;
    var position = center;
    var scale = 1.0;
    var opacity = 1.0;
    var interactive = visible;
    var z = 1;
    var delay = Duration.zero;
    var highlight = device.id == selectedDeviceId ? MarkerHighlight.selected : MarkerHighlight.none;
    var showBadges = true;

    if (isDragged) {
      scale = 1.12;
      highlight = MarkerHighlight.lifted;
      z = 10;
    } else if (group != null && GroupingUtil.groupKey(group.members) == openGroupKey) {
      // Fan out: full circle starting at 12 o'clock.
      final count = group.members.length;
      final radius = 44.0 + count * 4;
      final angle = -math.pi / 2 + group.index * 2 * math.pi / count;
      position = group.center + Offset(math.cos(angle), math.sin(angle)) * radius;
      delay = HubMotion.fanOutStagger * group.index;
      z = 9;
    } else if (group != null) {
      interactive = false;
      showBadges = false;
      position = group.center;
      if (group.index < _stackOffsets.length) {
        final isHot = group.members.contains(targetId);
        position += _stackOffsets[group.index];
        scale = (1 - group.index * 0.1) * (isHot ? 1.12 : 1);
        highlight = group.index == 0
            ? (isHot ? MarkerHighlight.dropTarget : MarkerHighlight.stackFront)
            : MarkerHighlight.stackBehind;
        z = 4 - group.index;
      } else {
        scale = 0.3;
        opacity = 0;
      }
    } else if (device.id == targetId) {
      scale = 1.18;
      highlight = MarkerHighlight.dropTarget;
      z = 6;
    } else if (highlight == MarkerHighlight.selected) {
      z = 5;
    }

    if (!visible) {
      scale = 0.3;
      opacity = 0;
    }

    return _Slot(
      z: z,
      widget: _StaggeredPositioned(
        key: ValueKey(device.id),
        left: position.dx - markerSize / 2,
        top: position.dy - markerSize / 2,
        size: markerSize,
        delay: delay,
        // The dragged marker follows the finger 1:1.
        animate: !isDragged,
        child: IgnorePointer(
          ignoring: !interactive,
          child: AnimatedScale(
            scale: scale,
            duration: HubMotion.popDuration,
            curve: HubMotion.pop,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: HubMotion.fadeDuration,
              child: _DragOrTap(
                onTap: () => onTapDevice(device.id),
                onDragStart: (global) => dragCallbacks.onStart(device, global),
                onDragUpdate: dragCallbacks.onUpdate,
                onDragEnd: dragCallbacks.onEnd,
                onDragCancel: dragCallbacks.onCancel,
                child: PlanMarker(device: device, highlight: highlight, showBadges: showBadges),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _groupControls(List<String> members, Offset center, String? targetId) {
    final key = GroupingUtil.groupKey(members);
    if (key == openGroupKey) {
      return [
        Positioned(
          key: ValueKey('close-$key'),
          left: center.dx - 15,
          top: center.dy - 15,
          width: 30,
          height: 30,
          child: Semantics(
            button: true,
            label: 'Close group',
            child: GestureDetector(
              onTap: onCloseGroup,
              child: Container(
                decoration: const BoxDecoration(color: HubColorPalette.controlStrong, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const HubGlyphIcon(HubGlyph.close, color: HubColorPalette.text, size: Size(14, 14)),
              ),
            ),
          ),
        ),
      ];
    }
    return [
      // Tap target over the stack; the count pill sits at its bottom right.
      Positioned(
        key: ValueKey('group-$key'),
        left: center.dx - markerSize / 2,
        top: center.dy - markerSize / 2,
        width: markerSize,
        height: markerSize,
        child: Semantics(
          button: true,
          label: 'Group of ${members.length}',
          child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => onTapGroup(key)),
        ),
      ),
      Positioned(
        key: ValueKey('count-$key'),
        left: center.dx + markerSize / 2 + 6 - 22,
        top: center.dy + markerSize / 2 + 2 - 22,
        child: IgnorePointer(
          child: _CountPill(
            count: members.length,
            // Red when a plant in the group is overdue.
            alert: devices.any((d) => members.contains(d.id) && d is PlanPlant && d.state == WateringState.overdue),
          ),
        ),
      ),
      if (members.contains(targetId)) _pillAbove(center, 'Add to group', key: ValueKey('add-$key')),
    ];
  }

  Widget _pillAbove(Offset center, String text, {required Key key}) {
    return Positioned(
      key: key,
      left: center.dx - 80,
      width: 160,
      top: center.dy - markerSize / 2 - 32,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(color: HubColorPalette.accent, borderRadius: BorderRadius.circular(9)),
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: HubColorPalette.text),
            ),
          ),
        ),
      ),
    );
  }
}

class _Slot {
  const _Slot({required this.z, required this.widget});

  final int z;
  final Widget widget;
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count, required this.alert});

  final int count;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: alert ? HubColorPalette.danger : HubColorPalette.controlStrong,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: HubColorPalette.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: HubColorPalette.text, height: 1),
      ),
    );
  }
}

/// [AnimatedPositioned] that starts moving to a new position only after [delay] (fan out stagger).
class _StaggeredPositioned extends StatefulWidget {
  const _StaggeredPositioned({
    super.key,
    required this.left,
    required this.top,
    required this.size,
    required this.child,
    this.delay = Duration.zero,
    this.animate = true,
  });

  final double left;
  final double top;
  final double size;
  final Duration delay;
  final bool animate;
  final Widget child;

  @override
  State<_StaggeredPositioned> createState() => _StaggeredPositionedState();
}

class _StaggeredPositionedState extends State<_StaggeredPositioned> {
  late Offset _shown = Offset(widget.left, widget.top);
  Timer? _timer;

  @override
  void didUpdateWidget(_StaggeredPositioned oldWidget) {
    super.didUpdateWidget(oldWidget);
    final target = Offset(widget.left, widget.top);
    if (target == _shown) return;
    _timer?.cancel();
    if (widget.delay == Duration.zero || !widget.animate) {
      _shown = target;
    } else {
      _timer = Timer(widget.delay, () => setState(() => _shown = Offset(widget.left, widget.top)));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.animate ? HubMotion.moveDuration : Duration.zero,
      curve: HubMotion.move,
      left: _shown.dx,
      top: _shown.dy,
      width: widget.size,
      height: widget.size,
      child: widget.child,
    );
  }
}

/// Tap, or drag after moving more than [MarkerLayer.dragThreshold] pixels.
class _DragOrTap extends StatefulWidget {
  const _DragOrTap({
    required this.onTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    required this.child,
  });

  final VoidCallback onTap;
  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onDragCancel;
  final Widget child;

  @override
  State<_DragOrTap> createState() => _DragOrTapState();
}

class _DragOrTapState extends State<_DragOrTap> {
  int? _pointer;
  Offset _down = Offset.zero;
  var _dragging = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (_pointer != null) return;
        _pointer = event.pointer;
        _down = event.position;
        _dragging = false;
      },
      onPointerMove: (event) {
        if (event.pointer != _pointer) return;
        if (!_dragging && (event.position - _down).distance > MarkerLayer.dragThreshold) {
          _dragging = true;
          widget.onDragStart(event.position);
        }
        if (_dragging) widget.onDragUpdate(event.position);
      },
      onPointerUp: (event) {
        if (event.pointer != _pointer) return;
        _pointer = null;
        _dragging ? widget.onDragEnd() : widget.onTap();
      },
      onPointerCancel: (event) {
        if (event.pointer != _pointer) return;
        _pointer = null;
        if (_dragging) widget.onDragCancel();
      },
      child: widget.child,
    );
  }
}
