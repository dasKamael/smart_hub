import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.service.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.controller.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard_catalog.dart';

Future<void> showWidgetGallery(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => const WidgetGalleryDialog(),
  );
}

/// Adding a widget, like Apple's widget gallery: the kinds on the left, on the right a live preview to swipe
/// through its sizes, and "Add Widget".
class WidgetGalleryDialog extends ConsumerStatefulWidget {
  const WidgetGalleryDialog({super.key});

  @override
  ConsumerState<WidgetGalleryDialog> createState() => _WidgetGalleryDialogState();
}

class _WidgetGalleryDialogState extends ConsumerState<WidgetGalleryDialog> {
  var _kind = DashboardWidgetKind.values.first;
  var _page = 0;
  PageController _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _select(DashboardWidgetKind kind) {
    final old = _pages;
    setState(() {
      _kind = kind;
      _page = 0;
      _pages = PageController();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
  }

  Future<void> _add() async {
    final size = _kind.sizes[_page];
    final added = await ref.read(dashboardControllerProvider.notifier).add(_kind, size);
    if (added && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Keeps the layout fresh while the dialog is open.
    ref.watch(dashboardLayoutServiceProvider);
    final fitting = ref.read(dashboardLayoutServiceProvider.notifier).sizesThatFit(_kind);
    final size = _kind.sizes[_page.clamp(0, _kind.sizes.length - 1)];
    final fits = fitting.contains(size);

    return Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: SizedBox(
        width: 1000,
        height: 600,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 280,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: HubColorPalette.separator)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: HubSpacing.s8,
                children: [
                  const Text('Widgets', style: HubTextStyles.pageTitle),
                  const SizedBox(height: HubSpacing.s8),
                  for (final kind in DashboardWidgetKind.values)
                    _KindRow(kind: kind, selected: kind == _kind, onTap: () => _select(kind)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    Text(DashboardCatalog.name(_kind), style: HubTextStyles.sectionTitle),
                    const SizedBox(height: 4),
                    Text(DashboardCatalog.description(_kind), style: HubTextStyles.secondary),
                    const SizedBox(height: HubSpacing.s20),
                    Expanded(
                      // On the dashboard's black, so the widget shows as the tile it will be.
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: HubColorPalette.bg, borderRadius: BorderRadius.circular(20)),
                        child: PageView(
                          key: ValueKey(_kind),
                          controller: _pages,
                          onPageChanged: (page) => setState(() => _page = page),
                          children: [
                            for (final size in _kind.sizes)
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: IgnorePointer(child: DashboardCatalog.build(_kind, size)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: HubSpacing.s12),
                    if (_kind.sizes.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8,
                        children: [
                          for (var page = 0; page < _kind.sizes.length; page++)
                            AnimatedContainer(
                              duration: HubMotion.fadeDuration,
                              width: page == _page ? 18 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: page == _page ? HubColorPalette.text : HubColorPalette.text3,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: HubSpacing.s8),
                    Text(
                      fits ? DashboardCatalog.sizeName(size) : '${DashboardCatalog.sizeName(size)} · no room left',
                      style: HubTextStyles.label.copyWith(
                        color: fits ? HubColorPalette.text2 : HubColorPalette.dangerText,
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
                        HubButton(
                          label: 'Add Widget',
                          glyph: HubGlyph.plus,
                          onPressed: fits ? () => unawaited(_add()) : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KindRow extends StatelessWidget {
  const _KindRow({required this.kind, required this.selected, required this.onTap});

  final DashboardWidgetKind kind;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: DashboardCatalog.name(kind),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? HubColorPalette.elevated : const Color(0x00000000),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: HubColorPalette.control, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: HubGlyphIcon(
                  DashboardCatalog.glyph(kind),
                  color: HubColorPalette.text,
                  size: const Size(16, 16),
                ),
              ),
              Text(
                DashboardCatalog.name(kind),
                style: HubTextStyles.body.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
