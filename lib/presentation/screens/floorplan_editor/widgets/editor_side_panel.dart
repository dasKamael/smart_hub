import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/floorplan/editing/layout_editing.util.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_segmented_control.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';

/// Tools, then what belongs to the selection (a room's type and furniture, a wall's thickness, an opening's width,
/// a piece of furniture) or – with nothing selected – the rooms; undo / redo, 3D and the JSON copy at the bottom.
class EditorSidePanel extends ConsumerWidget {
  const EditorSidePanel({super.key});

  static const width = 320.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(floorplanEditorControllerProvider);
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s16,
        children: [
          PageCard(
            padding: const EdgeInsets.all(HubSpacing.s12),
            child: _Tools(selected: state.tool),
          ),
          Expanded(
            child: PageCard(
              padding: const EdgeInsets.all(HubSpacing.s16),
              child: switch (state) {
                FloorplanEditorState(selectedRoom: final room?) => _RoomPanel(key: ValueKey(room.id), room: room),
                FloorplanEditorState(selectedOpening: final opening?) => _OpeningPanel(opening: opening),
                FloorplanEditorState(selectedFurniture: final item?) => _FurniturePanel(
                  item: item,
                  palette: state.tool == EditorTool.furniture ? state.furnitureKind : null,
                ),
                FloorplanEditorState(selectedWall: final wall?) => _WallPanel(wall: wall),
                FloorplanEditorState(tool: EditorTool.furniture) => _FurniturePalette(selected: state.furnitureKind),
                _ => _RoomList(layout: state.layout),
              },
            ),
          ),
          _HistoryBar(canUndo: state.past.isNotEmpty, canRedo: state.future.isNotEmpty, preview: state.preview),
        ],
      ),
    );
  }
}

class _Tools extends ConsumerWidget {
  const _Tools({required this.selected});

  final EditorTool selected;

  static const _tools = [
    (EditorTool.select, HubGlyph.pointer, 'Select'),
    (EditorTool.room, HubGlyph.rectangle, 'Room'),
    (EditorTool.wall, HubGlyph.wall, 'Wall'),
    (EditorTool.furniture, HubGlyph.sofa, 'Furniture'),
    (EditorTool.door, HubGlyph.door, 'Door'),
    (EditorTool.window, HubGlyph.window, 'Window'),
    (EditorTool.opening, HubGlyph.gap, 'Opening'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    return Wrap(
      spacing: HubSpacing.s4,
      runSpacing: HubSpacing.s4,
      children: [
        for (final (tool, glyph, label) in _tools)
          _Choice(
            width: (EditorSidePanel.width - 2 * HubSpacing.s12 - 3 * HubSpacing.s4) / 4,
            height: 56,
            selected: tool == selected,
            onTap: () => controller.selectTool(tool),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: HubSpacing.s4,
              children: [
                HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(18)),
                Text(label, style: HubTextStyles.label.copyWith(fontSize: 10), maxLines: 1),
              ],
            ),
          ),
      ],
    );
  }
}

/// A tile that can be picked, as tools, room types and widths are.
class _Choice extends StatelessWidget {
  const _Choice({required this.selected, required this.onTap, required this.child, this.width, this.height = 40});

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          width: width,
          height: height,
          padding: width == null ? const EdgeInsets.symmetric(horizontal: 12) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: selected ? HubColorPalette.accent : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(HubRadius.tile),
          ),
          child: Center(widthFactor: width == null ? 1 : null, child: child),
        ),
      ),
    );
  }
}

class _RoomPanel extends ConsumerStatefulWidget {
  const _RoomPanel({super.key, required this.room});

  final LayoutRoom room;

  @override
  ConsumerState<_RoomPanel> createState() => _RoomPanelState();
}

class _RoomPanelState extends ConsumerState<_RoomPanel> {
  late final _name = TextEditingController(text: widget.room.name);

  @override
  void didUpdateWidget(_RoomPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A type picked sets the name; typing keeps the cursor where it is.
    if (widget.room.name != _name.text) _name.text = widget.room.name;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    final layout = ref.watch(floorplanEditorControllerProvider.select((state) => state.layout));
    final outline = LayoutRoomsUtil.outlineOf(layout, widget.room.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s12,
      children: [
        Row(
          spacing: HubSpacing.s8,
          children: [
            Expanded(
              child: TextField(
                controller: _name,
                onChanged: controller.renameRoom,
                style: HubTextStyles.widgetTitle,
                cursorColor: HubColorPalette.accent,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: HubColorPalette.elevated,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(HubRadius.tile),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (outline != null)
              Text(
                '${PlanGeometryUtil.areaInSquareMeters(outline).toStringAsFixed(1)} m²',
                style: HubTextStyles.secondary.tabular,
              ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: HubSpacing.s4,
              runSpacing: HubSpacing.s4,
              children: [
                for (final type in RoomType.values)
                  _Choice(
                    selected: widget.room.type == type,
                    onTap: () => controller.setRoomType(type),
                    child: Text(type.label, style: HubTextStyles.label),
                  ),
              ],
            ),
          ),
        ),
        Row(
          spacing: HubSpacing.s8,
          children: [
            Expanded(
              child: HubButton(
                label: 'Furnish',
                glyph: HubGlyph.sofa,
                variant: HubButtonVariant.secondary,
                onPressed: widget.room.type == RoomType.other ? null : controller.furnishRoom,
              ),
            ),
            _IconAction(glyph: HubGlyph.trash, label: 'Delete room', danger: true, onTap: controller.deleteRoom),
          ],
        ),
      ],
    );
  }
}

class _WallPanel extends ConsumerWidget {
  const _WallPanel({required this.wall});

  final LayoutWall wall;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    final layout = ref.watch(floorplanEditorControllerProvider.select((state) => state.layout));
    final (a, b) = LayoutGraphUtil.endsOf(layout, wall);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s16,
      children: [
        Text('${(a.distanceTo(b) / 100).toStringAsFixed(2)} m', style: HubTextStyles.widgetTitle.tabular),
        HubSegmentedControl<double>(
          values: const [LayoutWall.innerThickness, LayoutWall.outerThickness],
          selected: wall.thickness,
          labelOf: (thickness) => thickness == LayoutWall.innerThickness ? 'Inner wall' : 'Outer wall',
          onChanged: controller.setWallThickness,
        ),
        const Spacer(),
        HubButton(
          label: 'Remove wall',
          glyph: HubGlyph.gap,
          variant: HubButtonVariant.secondary,
          onPressed: controller.removeWall,
        ),
        HubButton(
          label: _dividesRooms(layout, a, b) ? 'Merge rooms' : 'Delete',
          glyph: HubGlyph.trash,
          variant: HubButtonVariant.destructive,
          onPressed: controller.deleteWall,
        ),
      ],
    );
  }
}

/// Whether the wall from [a] to [b] has a room on both sides: deleting it makes them one.
bool _dividesRooms(HomeLayout layout, PlanPoint a, PlanPoint b) {
  final length = a.distanceTo(b);
  if (length == 0) return false;
  final middle = PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);
  final reach = PlanPoint(-(b.y - a.y) / length * 20, (b.x - a.x) / length * 20);
  return LayoutEditingUtil.roomAt(layout, middle + reach) != null &&
      LayoutEditingUtil.roomAt(layout, middle - reach) != null;
}

class _OpeningPanel extends ConsumerWidget {
  const _OpeningPanel({required this.opening});

  final LayoutOpening opening;

  static const _typeLabels = {DoorType.door: 'Door', DoorType.open: 'Opening', DoorType.window: 'Window'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    final layout = ref.watch(floorplanEditorControllerProvider.select((state) => state.layout));
    final wall = layout.walls.where((wall) => wall.id == opening.wallId).firstOrNull;
    final wallLength = wall == null
        ? 0.0
        : LayoutGraphUtil.endsOf(layout, wall).$1.distanceTo(LayoutGraphUtil.endsOf(layout, wall).$2);
    final width = opening.width.round();
    final wholeWall = (opening.width - wallLength).abs() < 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s16,
      children: [
        HubSegmentedControl<DoorType>(
          values: DoorType.values,
          selected: opening.type,
          labelOf: (type) => _typeLabels[type]!,
          onChanged: controller.setOpeningType,
        ),
        Wrap(
          spacing: HubSpacing.s8,
          runSpacing: HubSpacing.s8,
          children: [
            for (final option in LayoutEditingUtil.widthsFor(opening.type))
              if (option < wallLength)
                _Choice(
                  selected: !wholeWall && option.round() == width,
                  onTap: () => controller.setOpeningWidth(option),
                  child: Text('${option.round()} cm', style: HubTextStyles.label.tabular),
                ),
            _Choice(
              selected: wholeWall,
              onTap: () => controller.setOpeningWidth(null),
              child: Text('Whole wall', style: HubTextStyles.label),
            ),
          ],
        ),
        const Spacer(),
        Row(
          spacing: HubSpacing.s8,
          children: [
            if (opening.type == DoorType.door)
              Expanded(
                child: HubButton(
                  label: 'Swing',
                  glyph: HubGlyph.rotate,
                  variant: HubButtonVariant.secondary,
                  onPressed: controller.flipOpening,
                ),
              )
            else
              const Spacer(),
            _IconAction(glyph: HubGlyph.trash, label: 'Delete', danger: true, onTap: controller.deleteOpening),
          ],
        ),
      ],
    );
  }
}

/// The selected piece: its size in steps, turn, copy and delete. With the furniture tool the palette stays below,
/// so the next piece is one tap away.
class _FurniturePanel extends ConsumerWidget {
  const _FurniturePanel({required this.item, this.palette});

  final Furniture item;

  /// What the furniture tool puts down next; `null` hides the palette.
  final FurnitureKind? palette;

  static const _sizeStep = 10.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    final palette = this.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s12,
      children: [
        Text(item.kind.label, style: HubTextStyles.widgetTitle),
        _SizeStepper(
          label: 'Width',
          value: item.width,
          onChanged: (width) => controller.setFurnitureSize(width: width),
          step: _sizeStep,
        ),
        _SizeStepper(
          label: 'Depth',
          value: item.depth,
          onChanged: (depth) => controller.setFurnitureSize(depth: depth),
          step: _sizeStep,
        ),
        Row(
          spacing: HubSpacing.s8,
          children: [
            Expanded(
              child: HubButton(
                label: 'Turn',
                glyph: HubGlyph.rotate,
                variant: HubButtonVariant.secondary,
                onPressed: controller.rotateFurniture,
              ),
            ),
            _IconAction(glyph: HubGlyph.copy, label: 'Copy', onTap: controller.duplicateFurniture),
            _IconAction(glyph: HubGlyph.trash, label: 'Delete', danger: true, onTap: controller.deleteFurniture),
          ],
        ),
        if (palette != null) ...[
          const SizedBox(height: HubSpacing.s4),
          Expanded(child: _FurniturePalette(selected: palette)),
        ],
      ],
    );
  }
}

/// A size in cm with buttons to make it smaller or larger by [step].
class _SizeStepper extends StatelessWidget {
  const _SizeStepper({required this.label, required this.value, required this.onChanged, required this.step});

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double step;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: HubSpacing.s8,
      children: [
        Expanded(child: Text(label, style: HubTextStyles.secondary)),
        Semantics(
          label: '$label smaller',
          child: _Choice(
            selected: false,
            width: 40,
            onTap: () => onChanged(value - step),
            child: const HubGlyphIcon(HubGlyph.minus, color: HubColorPalette.text),
          ),
        ),
        SizedBox(
          width: 64,
          child: Text('${value.round()} cm', textAlign: TextAlign.center, style: HubTextStyles.label.tabular),
        ),
        Semantics(
          label: '$label larger',
          child: _Choice(
            selected: false,
            width: 40,
            onTap: () => onChanged(value + step),
            child: const HubGlyphIcon(HubGlyph.plus, color: HubColorPalette.text),
          ),
        ),
      ],
    );
  }
}

class _FurniturePalette extends ConsumerWidget {
  const _FurniturePalette({required this.selected});

  final FurnitureKind selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    return SingleChildScrollView(
      child: Wrap(
        spacing: HubSpacing.s4,
        runSpacing: HubSpacing.s4,
        children: [
          for (final kind in FurnitureKind.values)
            // Tap picks what a tap on the plan puts down; dragging sideways onto the plan puts it right there.
            Draggable<FurnitureKind>(
              data: kind,
              affinity: Axis.horizontal,
              dragAnchorStrategy: pointerDragAnchorStrategy,
              feedback: _DragChip(label: kind.label),
              child: _Choice(
                selected: kind == selected,
                onTap: () => controller.selectFurnitureKind(kind),
                child: Text(kind.label, style: HubTextStyles.label),
              ),
            ),
        ],
      ),
    );
  }
}

/// What follows the finger while a piece of furniture is dragged out of the palette.
class _DragChip extends StatelessWidget {
  const _DragChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -1.4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: HubColorPalette.accent, borderRadius: BorderRadius.circular(HubRadius.tile)),
        child: Text(label, style: HubTextStyles.label.copyWith(decoration: TextDecoration.none)),
      ),
    );
  }
}

class _RoomList extends ConsumerWidget {
  const _RoomList({required this.layout});

  final HomeLayout layout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    final outlines = LayoutRoomsUtil.outlines(layout);
    double area(String id) => outlines[id] == null ? 0 : PlanGeometryUtil.areaInSquareMeters(outlines[id]!);
    final total = layout.rooms.fold(0.0, (sum, room) => sum + area(room.id));
    final bare = layout.rooms.any(
      (room) =>
          room.type != RoomType.other &&
          outlines[room.id] != null &&
          !layout.furniture.any((item) => PlanGeometryUtil.containsPoint(outlines[room.id]!, item.position)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s8,
      children: [
        Text('${total.toStringAsFixed(1)} m²', style: HubTextStyles.widgetTitle.tabular),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (final room in layout.rooms)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.select(EditorSelection.room(room.id)),
                  child: SizedBox(
                    height: HubSizes.minTouchTarget,
                    child: Row(
                      children: [
                        Expanded(child: Text(room.name, style: HubTextStyles.body.copyWith(fontSize: 15))),
                        Text('${area(room.id).toStringAsFixed(1)} m²', style: HubTextStyles.secondary.tabular),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (bare)
          HubButton(
            label: 'Furnish all',
            glyph: HubGlyph.sofa,
            variant: HubButtonVariant.secondary,
            onPressed: controller.furnishAll,
          ),
      ],
    );
  }
}

class _HistoryBar extends ConsumerStatefulWidget {
  const _HistoryBar({required this.canUndo, required this.canRedo, required this.preview});

  final bool canUndo;
  final bool canRedo;
  final bool preview;

  @override
  ConsumerState<_HistoryBar> createState() => _HistoryBarState();
}

class _HistoryBarState extends ConsumerState<_HistoryBar> {
  static const _copiedFor = Duration(seconds: 2);

  Timer? _copied;

  @override
  void dispose() {
    _copied?.cancel();
    super.dispose();
  }

  Future<void> _export() async {
    await Clipboard.setData(ClipboardData(text: ref.read(floorplanEditorControllerProvider.notifier).exportJson()));
    if (!mounted) return;
    _copied?.cancel();
    setState(() => _copied = Timer(_copiedFor, () => mounted ? setState(() => _copied = null) : null));
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    return Row(
      spacing: HubSpacing.s8,
      children: [
        _IconAction(glyph: HubGlyph.undo, label: 'Undo', onTap: widget.canUndo ? controller.undo : null),
        _IconAction(glyph: HubGlyph.redo, label: 'Redo', onTap: widget.canRedo ? controller.redo : null),
        const Spacer(),
        _IconAction(glyph: HubGlyph.cube, label: '3D', selected: widget.preview, onTap: controller.togglePreview),
        _IconAction(
          glyph: _copied == null ? HubGlyph.export : HubGlyph.check,
          label: 'Copy plan as JSON',
          onTap: _export,
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.glyph,
    required this.label,
    required this.onTap,
    this.danger = false,
    this.selected = false,
  });

  final HubGlyph glyph;
  final String label;

  /// `null` disables the button.
  final VoidCallback? onTap;
  final bool danger;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          opacity: onTap == null ? 0.35 : 1,
          duration: HubMotion.fadeDuration,
          child: Container(
            width: 52,
            height: 52,
            decoration: selected
                ? BoxDecoration(color: HubColorPalette.accent, borderRadius: BorderRadius.circular(26))
                : PageCard.decoration(radius: 26),
            alignment: Alignment.center,
            child: HubGlyphIcon(glyph, color: danger ? HubColorPalette.dangerText : HubColorPalette.text),
          ),
        ),
      ),
    );
  }
}
