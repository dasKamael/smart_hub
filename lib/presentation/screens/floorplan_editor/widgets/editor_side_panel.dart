import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/floorplan/editing/plan_editing.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
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

/// Tools, the selected room or opening (or the list of rooms), undo / redo and the JSON export.
class EditorSidePanel extends ConsumerWidget {
  const EditorSidePanel({super.key});

  static const width = 300.0;

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
              child: switch ((state.selectedRoom, state.selectedOpening)) {
                (final room?, _) => _RoomPanel(key: ValueKey(room.id), room: room),
                (_, final opening?) => _OpeningPanel(opening: opening),
                _ => _RoomList(rooms: state.plan.rooms),
              },
            ),
          ),
          _HistoryBar(canUndo: state.past.isNotEmpty, canRedo: state.future.isNotEmpty),
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
    (EditorTool.room, HubGlyph.room, 'Room'),
    (EditorTool.rectangle, HubGlyph.rectangle, 'Rectangle'),
    (EditorTool.door, HubGlyph.door, 'Door'),
    (EditorTool.window, HubGlyph.window, 'Window'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    return Row(
      spacing: HubSpacing.s4,
      children: [
        for (final (tool, glyph, label) in _tools)
          Expanded(
            child: Semantics(
              button: true,
              selected: tool == selected,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.selectTool(tool),
                child: AnimatedContainer(
                  duration: HubMotion.fadeDuration,
                  curve: HubMotion.fade,
                  height: 60,
                  decoration: BoxDecoration(
                    color: tool == selected ? HubColorPalette.accent : HubColorPalette.elevated,
                    borderRadius: BorderRadius.circular(HubRadius.tile),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: HubSpacing.s4,
                    children: [
                      HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(18)),
                      Text(label, style: HubTextStyles.label.copyWith(fontSize: 10), maxLines: 1),
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

class _RoomPanel extends ConsumerStatefulWidget {
  const _RoomPanel({super.key, required this.room});

  final Room room;

  @override
  ConsumerState<_RoomPanel> createState() => _RoomPanelState();
}

class _RoomPanelState extends ConsumerState<_RoomPanel> {
  late final _name = TextEditingController(text: widget.room.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s12,
      children: [
        TextField(
          controller: _name,
          onChanged: controller.renameRoom,
          style: HubTextStyles.widgetTitle,
          cursorColor: HubColorPalette.accent,
          decoration: InputDecoration(
            filled: true,
            fillColor: HubColorPalette.elevated,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(HubRadius.tile),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        Text(
          '${PlanGeometryUtil.areaInSquareMeters(widget.room.polygon).toStringAsFixed(1)} m²',
          style: HubTextStyles.secondary.tabular,
        ),
        const Spacer(),
        HubButton(
          label: 'Delete',
          glyph: HubGlyph.trash,
          variant: HubButtonVariant.destructive,
          onPressed: controller.deleteSelection,
        ),
      ],
    );
  }
}

class _OpeningPanel extends ConsumerWidget {
  const _OpeningPanel({required this.opening});

  final Door opening;

  static const _typeLabels = {DoorType.door: 'Door', DoorType.open: 'Opening', DoorType.window: 'Window'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    final width = opening.a.distanceTo(opening.b).round();
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
            for (final option in PlanEditingUtil.widthsFor(opening.type))
              _WidthChip(
                centimeters: option.round(),
                selected: option.round() == width,
                onTap: () => controller.setOpeningWidth(option),
              ),
          ],
        ),
        const Spacer(),
        HubButton(
          label: 'Delete',
          glyph: HubGlyph.trash,
          variant: HubButtonVariant.destructive,
          onPressed: controller.deleteSelection,
        ),
      ],
    );
  }
}

class _WidthChip extends StatelessWidget {
  const _WidthChip({required this.centimeters, required this.selected, required this.onTap});

  final int centimeters;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          height: HubSizes.minTouchTarget,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? HubColorPalette.accent : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(HubRadius.pill),
          ),
          child: Center(widthFactor: 1, child: Text('$centimeters cm', style: HubTextStyles.label.tabular)),
        ),
      ),
    );
  }
}

class _RoomList extends ConsumerWidget {
  const _RoomList({required this.rooms});

  final List<Room> rooms;

  static String _area(List<Room> rooms) =>
      '${rooms.fold(0.0, (sum, room) => sum + PlanGeometryUtil.areaInSquareMeters(room.polygon)).toStringAsFixed(1)} m²';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanEditorControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s8,
      children: [
        Text(_area(rooms), style: HubTextStyles.widgetTitle.tabular),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (final room in rooms)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.select(EditorSelection.room(room.id)),
                  child: SizedBox(
                    height: HubSizes.minTouchTarget,
                    child: Row(
                      children: [
                        Expanded(child: Text(room.name, style: HubTextStyles.body.copyWith(fontSize: 15))),
                        Text(_area([room]), style: HubTextStyles.secondary.tabular),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryBar extends ConsumerStatefulWidget {
  const _HistoryBar({required this.canUndo, required this.canRedo});

  final bool canUndo;
  final bool canRedo;

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
        _BarButton(glyph: HubGlyph.undo, label: 'Undo', onTap: widget.canUndo ? controller.undo : null),
        _BarButton(glyph: HubGlyph.redo, label: 'Redo', onTap: widget.canRedo ? controller.redo : null),
        const Spacer(),
        _BarButton(
          glyph: _copied == null ? HubGlyph.export : HubGlyph.check,
          label: 'Copy plan as JSON',
          onTap: _export,
        ),
      ],
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({required this.glyph, required this.label, required this.onTap});

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
        onTap: onTap,
        child: AnimatedOpacity(
          opacity: onTap == null ? 0.35 : 1,
          duration: HubMotion.fadeDuration,
          child: Container(
            width: 52,
            height: 52,
            decoration: PageCard.decoration(radius: 26),
            alignment: Alignment.center,
            child: HubGlyphIcon(glyph, color: HubColorPalette.text),
          ),
        ),
      ),
    );
  }
}
