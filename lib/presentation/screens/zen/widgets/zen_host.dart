import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/presentation/screens/zen/zen.controller.dart';
import 'package:smart_hub/presentation/screens/zen/zen.screen.dart';

/// Lays the zen mode over the whole app and counts every touch as activity. Not during the setup.
class ZenHost extends ConsumerWidget {
  const ZenHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configured = ref.watch(connectionConfigServiceProvider.select((config) => config.value != null));
    final active = ref.watch(zenControllerProvider) && configured;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => ref.read(zenControllerProvider.notifier).activity(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          // Above the navigator: Material brings the theme's text style.
          Material(
            type: MaterialType.transparency,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: active ? const ZenScreen() : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
