import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.controller.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard_catalog.dart';
import 'package:smart_hub/presentation/screens/lights/lights.controller.dart';

Future<void> showEditWidget(BuildContext context, DashboardWidget widget) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => EditWidgetDialog(widget: widget),
  );
}

/// Choosing what a widget shows, like Apple's "Edit Widget": a live preview on the left, the choices on the right.
/// Nothing chosen means "Automatic".
class EditWidgetDialog extends ConsumerStatefulWidget {
  const EditWidgetDialog({super.key, required this.widget});

  final DashboardWidget widget;

  @override
  ConsumerState<EditWidgetDialog> createState() => _EditWidgetDialogState();
}

class _EditWidgetDialogState extends ConsumerState<EditWidgetDialog> {
  late final _selection = [...widget.widget.selection];

  void _toggle(String id) {
    setState(() => _selection.contains(id) ? _selection.remove(id) : _selection.add(id));
  }

  void _done() {
    ref.read(dashboardControllerProvider.notifier).select(widget.widget.id, _selection);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.widget.kind;
    final choices = switch (kind) {
      DashboardWidgetKind.lights => [
        for (final room in ref.watch(lightRoomsProvider))
          (id: room.id, name: room.name, detail: room.lights.length == 1 ? '1 light' : '${room.lights.length} lights'),
      ],
      _ => const <({String id, String name, String detail})>[],
    };

    return Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: SizedBox(
        width: 1000,
        height: 600,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28),
                // On the dashboard's black, so the widget shows as the tile it will be.
                child: DecoratedBox(
                  decoration: BoxDecoration(color: HubColorPalette.bg, borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: IgnorePointer(
                        child: DashboardCatalog.build(kind, widget.widget.size, selection: _selection),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 380,
              padding: const EdgeInsets.fromLTRB(20, 28, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(DashboardCatalog.name(kind), style: HubTextStyles.sectionTitle),
                  const SizedBox(height: 4),
                  Text(
                    'Pick ${DashboardCatalog.selectionName(kind)?.toLowerCase()} – the widget shows them in this order.',
                    style: HubTextStyles.secondary,
                  ),
                  const SizedBox(height: HubSpacing.s16),
                  Expanded(
                    child: ListView(
                      children: [
                        _ChoiceRow(
                          name: 'Automatic',
                          detail: 'All ${DashboardCatalog.selectionName(kind)?.toLowerCase()}, as on the plan',
                          position: _selection.isEmpty ? 0 : null,
                          onTap: () => setState(_selection.clear),
                        ),
                        const SizedBox(height: HubSpacing.s8),
                        for (final choice in choices)
                          _ChoiceRow(
                            name: choice.name,
                            detail: choice.detail,
                            position: switch (_selection.indexOf(choice.id)) {
                              -1 => null,
                              final index => index + 1,
                            },
                            onTap: () => _toggle(choice.id),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: HubSpacing.s16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: HubSpacing.s12,
                    children: [
                      HubButton(
                        label: 'Cancel',
                        variant: HubButtonVariant.secondary,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      HubButton(label: 'Done', onPressed: _done),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A choice with a round mark: its place in the order when chosen (0 = a plain check for "Automatic").
class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({required this.name, required this.detail, required this.position, required this.onTap});

  final String name;
  final String detail;
  final int? position;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chosen = position != null;
    return Semantics(
      button: true,
      selected: chosen,
      label: name,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: chosen ? HubColorPalette.elevated : const Color(0x00000000),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            spacing: 12,
            children: [
              AnimatedContainer(
                duration: HubMotion.fadeDuration,
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: chosen ? HubColorPalette.accent : null,
                  shape: BoxShape.circle,
                  border: chosen ? null : Border.all(color: HubColorPalette.controlStrong, width: 2),
                ),
                child: switch (position) {
                  null => null,
                  0 => const HubGlyphIcon(HubGlyph.check, color: HubColorPalette.text, size: Size(13, 13)),
                  final position => Text(
                    '$position',
                    style: HubTextStyles.label.copyWith(fontWeight: FontWeight.w700).tabular,
                  ),
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: HubTextStyles.body.copyWith(fontSize: 16)),
                    Text(detail, style: HubTextStyles.secondary.copyWith(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
