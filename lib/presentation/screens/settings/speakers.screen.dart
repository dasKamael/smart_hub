import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/utils/extension/connect_device_type.extension.dart';
import 'package:smart_hub/presentation/screens/settings/speakers.controller.dart';
import 'package:smart_hub/presentation/screens/settings/widgets/rename_dialog.dart';

/// Settings → Speakers: names, hidden speakers, the default speaker and placing speakers on the plan.
class SpeakersScreen extends ConsumerWidget {
  const SpeakersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(speakerEntriesProvider);
    final open = ref.watch(speakersControllerProvider);
    final controller = ref.read(speakersControllerProvider.notifier);

    Future<void> rename(SpeakerEntry entry) async {
      controller.closeOptions();
      final name = await showRenameDialog(context, current: entry.name);
      if (name != null) controller.rename(entry.id, name);
    }

    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: controller.closeOptions,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(HubSpacing.s24, HubSpacing.s20, HubSpacing.s24, HubSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: HubSpacing.s16,
              children: [
                Row(
                  spacing: HubSpacing.s16,
                  children: [
                    HubIconButton(
                      glyph: HubGlyph.back,
                      semanticLabel: 'Back',
                      onPressed: () => context.canPop() ? context.pop() : context.go(HubRoute.home.path),
                    ),
                    const Expanded(child: Text('Speakers', style: HubTextStyles.pageTitle)),
                  ],
                ),
                Text(
                  'Wi-Fi, rooms and music services of the speakers are set up in their own app; Home Assistant '
                  'picks them up. Devices with Spotify open show up here while Spotify is open on them.',
                  style: HubTextStyles.secondary,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 420,
                      mainAxisExtent: 84,
                      crossAxisSpacing: HubSpacing.s12,
                      mainAxisSpacing: HubSpacing.s12,
                    ),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _SpeakerRow(
                        entry: entry,
                        optionsShown: open == entry.id,
                        onTap: () => controller.toggleOptions(entry.id),
                        onRename: () => rename(entry),
                        onToggleHidden: () => controller.setHidden(entry.id, hidden: !entry.setting.hidden),
                        onDefault: () => controller.setDefault(entry.id),
                        onPlace: () => context.go(HubRoute.plan.path),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeakerRow extends StatelessWidget {
  const _SpeakerRow({
    required this.entry,
    required this.optionsShown,
    required this.onTap,
    required this.onRename,
    required this.onToggleHidden,
    required this.onDefault,
    required this.onPlace,
  });

  final SpeakerEntry entry;
  final bool optionsShown;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onToggleHidden;
  final VoidCallback onDefault;
  final VoidCallback onPlace;

  @override
  Widget build(BuildContext context) {
    final hidden = entry.setting.hidden;
    final glyph = switch (entry.deviceType) {
      final type? => type.glyph,
      null => entry.source == SpeakerSource.homeAssistant ? HubGlyph.speaker : HubGlyph.note,
    };
    final status = [
      if (entry.source == SpeakerSource.homeAssistant) 'Home Assistant' else 'Spotify',
      if (entry.setting.isDefault) 'Default',
      if (hidden) 'Hidden',
      if (entry.source == SpeakerSource.homeAssistant && !entry.placed) 'Not on the plan',
      if (entry.source == SpeakerSource.spotify && !entry.online) 'Not open now',
    ].join(' · ');
    return Semantics(
      button: true,
      label: entry.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          decoration: BoxDecoration(
            color: HubColorPalette.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: optionsShown
                  ? HubColorPalette.text.withValues(alpha: 0.5)
                  : entry.setting.isDefault
                  ? HubColorPalette.accent.withValues(alpha: 0.6)
                  : const Color(0x14FFFFFF),
            ),
          ),
          child: Stack(
            children: [
              Opacity(
                opacity: hidden ? 0.45 : 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 14,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: HubGlyphIcon(glyph, color: HubColorPalette.text),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              status,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: HubTextStyles.label.copyWith(
                                fontWeight: FontWeight.w500,
                                color: HubColorPalette.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !optionsShown,
                  child: AnimatedOpacity(
                    opacity: optionsShown ? 1 : 0,
                    duration: HubMotion.fadeDuration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        enabled: optionsShown,
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ColoredBox(
                          color: HubColorPalette.surface.withValues(alpha: 0.75),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 4,
                            children: [
                              _Option(label: 'Rename', glyph: HubGlyph.pencil, onTap: onRename),
                              _Option(
                                label: hidden ? 'Show' : 'Hide',
                                glyph: hidden ? HubGlyph.check : HubGlyph.close,
                                onTap: onToggleHidden,
                              ),
                              if (!entry.setting.isDefault)
                                _Option(label: 'Default', glyph: HubGlyph.play, onTap: onDefault),
                              if (entry.source == SpeakerSource.homeAssistant && !entry.placed)
                                _Option(label: 'Place', glyph: HubGlyph.plus, onTap: onPlace),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.label, required this.glyph, required this.onTap});

  final String label;
  final HubGlyph glyph;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: HubColorPalette.control, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size(15, 15)),
              ),
              Text(label, style: HubTextStyles.label.copyWith(fontSize: 11, color: HubColorPalette.text2)),
            ],
          ),
        ),
      ),
    );
  }
}
