import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/apps/app_choice.util.dart';
import 'package:smart_hub/domain/apps/installed_apps.service.dart';
import 'package:smart_hub/domain/apps/model/installed_app.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Apps on the tablet to open with one tap (`DashboardWidget.selection`: package names; empty: the video apps).
class AppsWidget extends ConsumerWidget {
  const AppsWidget({super.key, required this.size, this.packageNames = const [], this.card = true});

  final WidgetSize size;
  final List<String> packageNames;

  /// `false`: no card behind the widget (`DashboardWidget.card`).
  final bool card;

  /// Columns × rows per size.
  static (int, int) gridOf(WidgetSize size) => switch (size) {
    WidgetSize.small => (2, 2),
    WidgetSize.medium => (4, 1),
    WidgetSize.large => (3, 3),
    WidgetSize.extraLarge => (6, 2),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = AppChoiceUtil.shown(
      ref.watch(installedAppsServiceProvider).value ?? const <InstalledApp>[],
      packageNames,
    );
    final loaded = ref.watch(installedAppsServiceProvider).hasValue;
    final (columns, rows) = gridOf(size);
    final shown = apps.take(columns * rows).toList();

    return WidgetTile(
      card: card,
      size: size,
      padding: size == WidgetSize.small ? 18 : 16,
      child: switch ((loaded, shown)) {
        (false, _) => const SizedBox.shrink(),
        (true, []) => const _NoApps(),
        // Fixed cells; fewer apps than cells sit in the middle instead of the top left corner.
        _ => LayoutBuilder(
          builder: (context, constraints) {
            const gap = 8.0;
            final cell = Size(
              (constraints.maxWidth - (columns - 1) * gap) / columns,
              (constraints.maxHeight - (rows - 1) * gap) / rows,
            );
            return Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final app in shown)
                    SizedBox.fromSize(
                      size: cell,
                      child: _AppButton(
                        app,
                        showLabel: size != WidgetSize.small,
                        onTap: () => unawaited(ref.read(installedAppsServiceProvider.notifier).launch(app.packageName)),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      },
    );
  }
}

class _AppButton extends StatelessWidget {
  const _AppButton(this.app, {required this.showLabel, required this.onTap});

  final InstalledApp app;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: app.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // The icon takes what the label leaves, at most 64 px.
            final side = (showLabel ? constraints.maxHeight - 22 : constraints.maxHeight)
                .clamp(0.0, constraints.maxWidth)
                .clamp(0.0, 64.0);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(side * 0.22),
                  child: Image.memory(
                    app.icon,
                    width: side,
                    height: side,
                    cacheWidth: (side * MediaQuery.devicePixelRatioOf(context)).round().clamp(1, 512),
                    gaplessPlayback: true,
                  ),
                ),
                if (showLabel)
                  Text(
                    app.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: HubTextStyles.label.copyWith(fontSize: 12),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// No video apps and nothing chosen yet.
class _NoApps extends StatelessWidget {
  const _NoApps();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const HubGlyphIcon(HubGlyph.tablet, color: HubColorPalette.text2),
          Text(
            'Hold, then tap here to pick apps',
            textAlign: TextAlign.center,
            style: HubTextStyles.secondary.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
