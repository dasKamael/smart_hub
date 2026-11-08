import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_painter.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_viewport.dart';

enum _Gesture { none, edit, pan, zoom }

/// The drawing surface. One finger edits (or pans where there is nothing to drag), two fingers zoom and pan.
class EditorCanvas extends ConsumerStatefulWidget {
  const EditorCanvas({super.key});

  @override
  ConsumerState<EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends ConsumerState<EditorCanvas> {
  EditorViewport? _viewport;
  Size _size = Size.zero;
  var _gesture = _Gesture.none;

  /// Fingers on the canvas, and whether they zoomed since the first one touched.
  var _pointers = 0;
  var _zoomedSinceDown = false;

  /// Where the last finger touched down. A drag starts there: the scale gesture only reports its start once the
  /// finger has moved a little, which can be off a corner handle already.
  var _downAt = Offset.zero;

  // Zoom gesture: scale and the plan point under the fingers when it started.
  var _zoomStartScale = 1.0;
  var _zoomStartFactor = 1.0;
  var _zoomAnchor = PlanPoint.zero;

  FloorplanEditorController get _controller => ref.read(floorplanEditorControllerProvider.notifier);

  /// Fitted once and then only changed by the user, so the plan never moves under a finger while it is edited.
  EditorViewport get _view => _viewport ??= _fit();

  EditorViewport _fit() {
    final layout = ref.read(floorplanEditorControllerProvider).layout;
    return EditorViewport.fit([for (final node in layout.nodes) node.position], _size);
  }

  void _zoomBy(double factor) {
    final center = Offset(_size.width / 2, _size.height / 2);
    setState(() => _viewport = _view.zoomed(_view.scale * factor, anchor: _view.toPlan(center), focal: center));
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount > 1) return _startZoom(details.localFocalPoint, 1);
    // The finger left after a pinch only pans; it should not grab what happens to be under it.
    if (_zoomedSinceDown) {
      _gesture = _Gesture.pan;
      return;
    }
    final editing = _controller.startDrag(_view.toPlan(_downAt), cmPerPx: _view.cmPerPx);
    _gesture = editing ? _Gesture.edit : _Gesture.pan;
  }

  void _startZoom(Offset focal, double factor) {
    if (_gesture == _Gesture.edit) _controller.cancelDrag();
    _gesture = _Gesture.zoom;
    _zoomedSinceDown = true;
    _zoomStartScale = _view.scale;
    _zoomStartFactor = factor;
    _zoomAnchor = _view.toPlan(focal);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount > 1 && _gesture != _Gesture.zoom) _startZoom(details.localFocalPoint, details.scale);
    switch (_gesture) {
      case _Gesture.edit:
        _controller.updateDrag(_view.toPlan(details.localFocalPoint), cmPerPx: _view.cmPerPx);
      case _Gesture.pan:
        setState(() => _viewport = _view.panned(details.focalPointDelta));
      case _Gesture.zoom:
        final scale = _zoomStartScale * details.scale / _zoomStartFactor;
        setState(() => _viewport = _view.zoomed(scale, anchor: _zoomAnchor, focal: details.localFocalPoint));
      case _Gesture.none:
        break;
    }
  }

  void _pointerGone() {
    _pointers = (_pointers - 1).clamp(0, 10);
    if (_pointers == 0) _zoomedSinceDown = false;
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // With fingers still down the gesture did not finish: another finger touched and a zoom starts.
    if (_gesture == _Gesture.edit) _pointers > 0 ? _controller.cancelDrag() : _controller.endDrag();
    _gesture = _Gesture.none;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(floorplanEditorControllerProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.biggest != _size) {
          _size = constraints.biggest;
          _viewport = null;
        }
        final view = _view;
        return ClipRRect(
          borderRadius: BorderRadius.circular(HubRadius.pageCard),
          child: Stack(
            children: [
              Positioned.fill(
                child: Listener(
                  onPointerDown: (event) {
                    _pointers++;
                    _downAt = event.localPosition;
                  },
                  onPointerUp: (_) => _pointerGone(),
                  onPointerCancel: (_) => _pointerGone(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) => _controller.tap(view.toPlan(details.localPosition), cmPerPx: view.cmPerPx),
                    onLongPressStart: (details) =>
                        _controller.longPress(view.toPlan(details.localPosition), cmPerPx: view.cmPerPx),
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: _onScaleUpdate,
                    onScaleEnd: _onScaleEnd,
                    child: CustomPaint(
                      painter: EditorPainter(state: state, viewport: view),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                child: _ZoomBar(
                  onZoomOut: () => _zoomBy(1 / 1.25),
                  onFit: () => setState(() => _viewport = _fit()),
                  onZoomIn: () => _zoomBy(1.25),
                ),
              ),
              Positioned(right: 18, bottom: 20, child: _ScaleBar(pxPerMeter: view.scale * 100)),
              Positioned(
                top: 14,
                left: 0,
                right: 0,
                child: Center(child: _ToolBar(state: state)),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// While drawing walls: take back the last one, finish. Otherwise a short hint for the tool.
class _ToolBar extends ConsumerWidget {
  const _ToolBar({required this.state});

  final FloorplanEditorState state;

  static const _hints = {
    EditorTool.select: 'Drag outside: new room · across a room: split it',
    EditorTool.room: 'Drag across',
    EditorTool.wall: 'Tap from corner to corner',
    EditorTool.door: 'Tap or drag along a wall',
    EditorTool.window: 'Tap or drag along a wall',
    EditorTool.opening: 'Tap or drag along a wall',
    EditorTool.furniture: 'Tap in a room: place · drag a piece: move · handles: size and turn',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    if (state.tool == EditorTool.wall && state.chain.isNotEmpty) {
      return _Pill(
        children: [
          _PillButton(glyph: HubGlyph.undo, label: 'Take back the last wall', onTap: controller.removeLastChainPoint),
          _PillButton(glyph: HubGlyph.check, label: 'Finish walls', onTap: controller.finishChain),
        ],
      );
    }
    final hint = _hints[state.tool];
    if (hint == null) return const SizedBox.shrink();
    return IgnorePointer(
      child: _Pill(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(hint, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
          ),
        ],
      ),
    );
  }
}

class _ZoomBar extends StatelessWidget {
  const _ZoomBar({required this.onZoomOut, required this.onFit, required this.onZoomIn});

  final VoidCallback onZoomOut;
  final VoidCallback onFit;
  final VoidCallback onZoomIn;

  @override
  Widget build(BuildContext context) {
    return _Pill(
      children: [
        _PillButton(glyph: HubGlyph.minus, label: 'Zoom out', onTap: onZoomOut),
        Semantics(
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onFit,
            child: SizedBox(
              height: HubSizes.minTouchTarget,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: Text('Fit', style: HubTextStyles.label)),
              ),
            ),
          ),
        ),
        _PillButton(glyph: HubGlyph.plus, label: 'Zoom in', onTap: onZoomIn),
      ],
    );
  }
}

class _ScaleBar extends StatelessWidget {
  const _ScaleBar({required this.pxPerMeter});

  final double pxPerMeter;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: HubSpacing.s4,
        children: [
          Text('1 m', style: HubTextStyles.label.copyWith(fontSize: 11, color: HubColorPalette.text2)),
          Container(
            width: pxPerMeter,
            height: 6,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: HubColorPalette.text2, width: 1.5),
                right: BorderSide(color: HubColorPalette.text2, width: 1.5),
                bottom: BorderSide(color: HubColorPalette.text2, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HubSpacing.s4),
      decoration: BoxDecoration(
        color: HubColorPalette.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, spacing: HubSpacing.s4, children: children),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.glyph, required this.label, required this.onTap});

  final HubGlyph glyph;
  final String label;

  /// `null` disables the button.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox.square(
          dimension: HubSizes.minTouchTarget,
          child: Center(
            child: HubGlyphIcon(
              glyph,
              color: onTap == null ? HubColorPalette.text3 : HubColorPalette.text,
              size: const Size.square(16),
            ),
          ),
        ),
      ),
    );
  }
}
