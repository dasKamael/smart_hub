import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/screens/zen/zen.controller.dart';

/// Starts the zen mode by hand.
class ZenButton extends ConsumerWidget {
  const ZenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HubIconButton(
      glyph: HubGlyph.moon,
      semanticLabel: 'Zen mode',
      onPressed: ref.read(zenControllerProvider.notifier).enter,
    );
  }
}
