import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/status_pill.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// Header pill that appears while the hub is not online.
class ConnectionIndicator extends ConsumerWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectionStatusServiceProvider).value;
    final pill = switch (status) {
      ConnectionStatus.offline => const StatusPill(glyph: HubGlyph.offline, label: 'Offline'),
      ConnectionStatus.connecting => const StatusPill(
        glyph: HubGlyph.sync,
        label: 'Connecting',
        color: HubColorPalette.text2,
      ),
      ConnectionStatus.authFailed => const StatusPill(
        glyph: HubGlyph.key,
        label: 'Token rejected',
        color: HubColorPalette.dangerText,
      ),
      ConnectionStatus.online || ConnectionStatus.notConfigured || null => null,
    };
    return AnimatedSwitcher(
      duration: HubMotion.fadeDuration,
      child: pill ?? const SizedBox.shrink(key: ValueKey('none')),
    );
  }
}
