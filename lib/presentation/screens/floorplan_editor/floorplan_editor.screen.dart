import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/layouts/hub_background.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene_view.dart';
import 'package:smart_hub/presentation/design_system/tokens/home_scene.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_canvas.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/widgets/editor_side_panel.dart';

/// Draws the apartment: rooms, doors, openings and windows (`Floor Plan Editor.dc.html`). Changes are saved at once.
///
/// A self-contained module: it reads and saves the apartment through `HomeLayoutService` and nothing else, so it can be
/// replaced as a whole (see the architecture test "floor plan editor is a replaceable module").
class FloorplanEditorScreen extends ConsumerWidget {
  const FloorplanEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaded = ref.watch(homeLayoutServiceProvider.select((layout) => layout.hasValue));
    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: HubBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(HubSpacing.s24, HubSpacing.s20, HubSpacing.s24, HubSpacing.s24),
            child: !loaded
                ? const SizedBox.expand()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: HubSpacing.s16,
                    children: [
                      Expanded(
                        child: PageCard(
                          padding: EdgeInsets.zero,
                          child: Stack(
                            children: [
                              const Positioned.fill(child: _Surface()),
                              Positioned(
                                left: 14,
                                top: 14,
                                child: HubIconButton(
                                  glyph: HubGlyph.back,
                                  semanticLabel: 'Back',
                                  onPressed: () => context.canPop() ? context.pop() : context.go(HubRoute.plan.path),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const EditorSidePanel(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// The plan to edit, or the apartment in 3D.
class _Surface extends ConsumerWidget {
  const _Surface();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = ref.watch(floorplanEditorControllerProvider.select((state) => state.preview));
    if (!preview) return const EditorCanvas();
    final layout = ref.watch(floorplanEditorControllerProvider.select((state) => state.layout));
    return ClipRRect(
      borderRadius: BorderRadius.circular(HubRadius.pageCard),
      child: ColoredBox(
        color: HomeSceneColorPalette.background,
        child: HomeSceneView(scene: HomeScene.of(layout), tilted: true, padding: 48),
      ),
    );
  }
}
