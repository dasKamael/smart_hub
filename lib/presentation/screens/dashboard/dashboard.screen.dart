import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.service.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.util.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.controller.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.state.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard_catalog.dart';
import 'package:smart_hub/presentation/screens/dashboard/widgets/edit_widget_dialog.dart';
import 'package:smart_hub/presentation/screens/dashboard/widgets/widget_gallery_dialog.dart';

/// The start page: the widgets of all parts of the hub on one page of the 170 px grid. Long press to arrange them
/// like on an iPad.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const step = DashboardController.step;
  static final gridSize = Size(
    DashboardLayoutUtil.columns * step - WidgetSize.gap,
    DashboardLayoutUtil.rows * step - WidgetSize.gap,
  );

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with SingleTickerProviderStateMixin {
  late final _jiggle = AnimationController(vsync: this, duration: const Duration(milliseconds: 480));

  @override
  void dispose() {
    _jiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(dashboardControllerProvider);
    final layout = ref.watch(dashboardLayoutProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);
    if (page.editing && !_jiggle.isAnimating) {
      unawaited(_jiggle.repeat());
    } else if (!page.editing && _jiggle.isAnimating) {
      _jiggle.stop();
    }
    final frontId = page.draggedId ?? page.resizedId;
    final front = layout.widgets.where((widget) => widget.id == frontId).firstOrNull;
    final saved = {
      for (final widget in ref.watch(dashboardLayoutServiceProvider).value ?? const <DashboardWidget>[])
        widget.id: widget,
    };

    return Column(
      children: [
        SizedBox(
          height: 44,
          width: DashboardScreen.gridSize.width,
          child: page.editing
              ? Row(
                  children: [
                    HubButton(
                      label: 'Add widget',
                      glyph: HubGlyph.plus,
                      variant: HubButtonVariant.secondary,
                      onPressed: () => unawaited(showWidgetGallery(context)),
                    ),
                    const Spacer(),
                    HubButton(label: 'Done', onPressed: controller.stopEditing),
                  ],
                )
              : null,
        ),
        const SizedBox(height: HubSpacing.s16),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: page.editing ? null : controller.startEditing,
              // A tap next to the widgets ends editing, as on the iPad.
              onTap: page.editing ? controller.stopEditing : null,
              child: SizedBox.fromSize(
                size: DashboardScreen.gridSize,
                child: layout.widgets.isEmpty && !page.editing
                    ? const _Empty()
                    : Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Where the widget being resized will snap to.
                          if ((page.resizedId, page.resizeTo) case (final id?, final size?))
                            if (layout.cells[id] case final cell?)
                              Positioned(
                                left: cell.column * DashboardScreen.step,
                                top: cell.row * DashboardScreen.step,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  width: DashboardCatalog.tileSize(size).size.width,
                                  height: DashboardCatalog.tileSize(size).size.height,
                                  decoration: BoxDecoration(
                                    color: const Color(0x0FFFFFFF),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: const Color(0x40FFFFFF), width: 1.5),
                                  ),
                                ),
                              ),
                          // The dragged or resized widget last, so it is on top. All widgets keep the same structure
                          // while dragging – a rebuilt widget would lose the finger.
                          for (final widget in [...layout.widgets.where((widget) => widget.id != frontId), ?front])
                            if (_offsetOf(widget, layout, page) case final offset?)
                              AnimatedPositioned(
                                key: ValueKey(widget.id),
                                duration: widget.id == page.draggedId
                                    ? Duration.zero
                                    : const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                left: offset.dx,
                                top: offset.dy,
                                child: _Lift(
                                  lifted: widget.id == page.draggedId,
                                  child: _Tile(
                                    widget: widget,
                                    editing: page.editing,
                                    jiggle: _jiggle,
                                    lifted: widget.id == page.draggedId,
                                    frame: widget.id == page.resizedId
                                        ? _liveFrame(
                                            saved[widget.id] ?? widget,
                                            layout.cells[widget.id],
                                            page.resizeDelta,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The card of a widget being resized follows the finger: its size plus the corner's way, at least one unit and
/// within the page.
Size _liveFrame(DashboardWidget widget, GridCell? cell, Offset delta) {
  final natural = DashboardCatalog.tileSize(widget.size).size;
  final left = (cell?.column ?? 0) * DashboardScreen.step;
  final top = (cell?.row ?? 0) * DashboardScreen.step;
  return Size(
    (natural.width + delta.dx).clamp(WidgetSize.unit, DashboardScreen.gridSize.width - left),
    (natural.height + delta.dy).clamp(WidgetSize.unit, DashboardScreen.gridSize.height - top),
  );
}

/// Where a widget is drawn: its cell, or under the finger while dragged.
Offset? _offsetOf(DashboardWidget widget, DashboardLayout layout, DashboardPageState page) {
  if (widget.id == page.draggedId) return page.dragOrigin + page.dragOffset;
  final cell = layout.cells[widget.id];
  return cell == null ? null : Offset(cell.column * DashboardScreen.step, cell.row * DashboardScreen.step);
}

/// Lifts the dragged widget a little off the page.
class _Lift extends StatelessWidget {
  const _Lift({required this.lifted, required this.child});

  final bool lifted;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: lifted ? 1.05 : 1,
      duration: const Duration(milliseconds: 150),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: lifted
              ? const [BoxShadow(color: Color(0x99000000), blurRadius: 30, offset: Offset(0, 14))]
              : const [],
        ),
        child: child,
      ),
    );
  }
}

/// The card around a widget. It always has the same structure, so a resize gesture survives: while resizing it
/// follows the finger and clips the content, which keeps its own size; afterwards it glides to the new size.
class _Frame extends StatelessWidget {
  const _Frame({required this.size, required this.natural, required this.child});

  final Size? size;
  final Size natural;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resizing = size != null;
    final frame = size ?? natural;
    return AnimatedContainer(
      duration: resizing ? Duration.zero : const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: frame.width,
      height: frame.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: HubColorPalette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: resizing ? const Color(0x59FFFFFF) : const Color(0x00FFFFFF), width: 1.5),
      ),
      // The content is always whole: the size it snaps to, scaled down while the card is smaller, cross-faded when
      // the size changes – never cut off.
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Center(
          key: ValueKey(natural),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox.fromSize(size: natural, child: child),
          ),
        ),
      ),
    );
  }
}

/// A widget on the grid; while editing it jiggles and shows remove and resize handles.
class _Tile extends ConsumerWidget {
  const _Tile({required this.widget, required this.editing, required this.jiggle, this.lifted = false, this.frame});

  final DashboardWidget widget;
  final bool editing;
  final Animation<double> jiggle;

  /// Under the finger: no jiggle.
  final bool lifted;

  /// The card's size while it is being resized; `null` = the widget's own size.
  final Size? frame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(dashboardControllerProvider.notifier);
    final tile = DashboardCatalog.build(widget.kind, widget.size, selection: widget.selection, card: widget.card);
    if (!editing) return GestureDetector(onLongPress: controller.startEditing, child: tile);

    // Each widget swings a little out of step with the others.
    final phase = (widget.id.hashCode % 100) / 100;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: jiggle,
          builder: (context, child) => Transform.rotate(
            angle: lifted ? 0 : math.sin((jiggle.value + phase) * 2 * math.pi) * 0.004,
            child: child,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            // Like Apple's "Edit Widget": a tap while arranging opens the widget's options.
            onTap: () => unawaited(showEditWidget(context, widget)),
            onPanStart: (_) => controller.startDrag(widget.id),
            onPanUpdate: (details) => controller.dragBy(details.delta),
            onPanEnd: (_) => controller.endDrag(),
            onPanCancel: controller.endDrag,
            // The widget itself does not react while arranging.
            child: IgnorePointer(
              child: _Frame(size: frame, natural: DashboardCatalog.tileSize(widget.size).size, child: tile),
            ),
          ),
        ),
        if (!lifted)
          Positioned(
            left: -10,
            top: -10,
            child: _Badge(
              label: 'Remove ${DashboardCatalog.name(widget.kind)}',
              glyph: HubGlyph.minus,
              onTap: () => controller.remove(widget.id),
            ),
          ),
        // Inside the card's corner, clipped by its rounding (iOS 18 style).
        if (!lifted && widget.kind.sizes.length > 1)
          Positioned(
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
              child: _ResizeGrip(id: widget.id),
            ),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.glyph, required this.onTap});

  final String label;
  final HubGlyph glyph;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: HubColorPalette.controlStrong,
            shape: BoxShape.circle,
            border: Border.all(color: HubColorPalette.bg, width: 2),
          ),
          alignment: Alignment.center,
          child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size(12, 12)),
        ),
      ),
    );
  }
}

/// Corner handle: dragging it changes the widget's size to the closest one that fits (iOS 18 style).
class _ResizeGrip extends ConsumerStatefulWidget {
  const _ResizeGrip({required this.id});

  final String id;

  @override
  ConsumerState<_ResizeGrip> createState() => _ResizeGripState();
}

class _ResizeGripState extends ConsumerState<_ResizeGrip> {
  var _total = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(dashboardControllerProvider.notifier);
    return Semantics(
      label: 'Resize',
      child: GestureDetector(
        onPanStart: (_) => _total = Offset.zero,
        onPanUpdate: (details) {
          _total += details.delta;
          controller.resizeBy(widget.id, _total);
        },
        onPanEnd: (_) => controller.endResize(),
        onPanCancel: controller.endResize,
        // A finger sized area; the visible handle is the arc in its corner.
        child: CustomPaint(size: const Size.square(48), painter: _GripPainter()),
      ),
    );
  }
}

/// An arc along the card's rounded corner, a little inside its edge.
class _GripPainter extends CustomPainter {
  /// Corner radius of the card and how far inside the edge the arc runs.
  static const _radius = 24.0;
  static const _inset = 7.0;
  static const _straight = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final right = size.width - _inset;
    final bottom = size.height - _inset;
    final radius = _radius - _inset;
    final arc = Path()
      ..moveTo(right, bottom - radius - _straight)
      ..lineTo(right, bottom - radius)
      ..arcToPoint(Offset(right - radius, bottom), radius: Radius.circular(radius))
      ..lineTo(right - radius - _straight, bottom);
    canvas.drawPath(
      arc,
      Paint()
        ..color = HubColorPalette.text.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GripPainter oldDelegate) => false;
}

class _Empty extends ConsumerWidget {
  const _Empty();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: HubSpacing.s12,
        children: [
          const Text('No widgets yet', style: HubTextStyles.widgetTitle),
          HubButton(label: 'Add widget', glyph: HubGlyph.plus, onPressed: () => unawaited(showWidgetGallery(context))),
        ],
      ),
    );
  }
}
