import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_theme.dart';
import 'package:smart_hub/presentation/hub_router.dart';
import 'package:smart_hub/presentation/screens/zen/widgets/zen_host.dart';

class HubApp extends ConsumerWidget {
  const HubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Smart Hub',
      debugShowCheckedModeBanner: false,
      theme: HubTheme.dark,
      // Lists bounce at their ends everywhere, as on iOS.
      scrollBehavior: const _BouncingScrollBehavior(),
      routerConfig: ref.watch(hubRouterProvider),
      builder: (context, child) => _FadeIn(child: ZenHost(child: child ?? const SizedBox.shrink())),
    );
  }
}

/// Fades the app in from the black start screen once, instead of a hard cut.
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child});

  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final _opacity = AnimationController(vsync: this, duration: const Duration(milliseconds: 450))..forward();

  @override
  void dispose() {
    _opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HubColorPalette.bg,
      child: FadeTransition(
        opacity: CurvedAnimation(parent: _opacity, curve: Curves.easeOut),
        child: widget.child,
      ),
    );
  }
}

class _BouncingScrollBehavior extends MaterialScrollBehavior {
  const _BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics());
}
