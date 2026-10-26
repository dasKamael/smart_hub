import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_theme.dart';
import 'package:smart_hub/presentation/hub_router.dart';

class HubApp extends StatefulWidget {
  const HubApp({super.key, this.router});

  /// Injected in tests; defaults to the app router.
  final GoRouter? router;

  @override
  State<HubApp> createState() => _HubAppState();
}

class _HubAppState extends State<HubApp> {
  late final GoRouter _router = widget.router ?? createHubRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Hub',
      debugShowCheckedModeBanner: false,
      theme: HubTheme.dark,
      routerConfig: _router,
    );
  }
}
