import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_logo.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/setup/setup.controller.dart';
import 'package:smart_hub/presentation/screens/setup/setup.state.dart';

/// First start: connect to Home Assistant, start without it or try the demo home. Without Home Assistant it is
/// opened again from the settings to connect one.
class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);
    final standalone = ref.watch(connectionConfigServiceProvider).value is StandaloneConnectionConfig;
    // Starting without Home Assistant keeps the setup reachable, so leave it here.
    ref.listen(connectionConfigServiceProvider, (previous, next) {
      if (next.value is StandaloneConnectionConfig && previous?.value is! StandaloneConnectionConfig) {
        GoRouter.maybeOf(context)?.go(HubRoute.home.path);
      }
    });

    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(HubSpacing.s24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: PageCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: HubSpacing.s20,
                  children: [
                    Row(
                      spacing: HubSpacing.s16,
                      children: [
                        if (GoRouter.maybeOf(context)?.canPop() ?? false)
                          HubIconButton(glyph: HubGlyph.back, semanticLabel: 'Back', onPressed: context.pop),
                        const HubLogo(size: 56),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: HubSpacing.s4,
                            children: [
                              Text('Connect your home', style: HubTextStyles.pageTitle),
                              Text(
                                'The hub controls your lights and speakers through Home Assistant.',
                                style: HubTextStyles.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    HubTextField(
                      label: 'Home Assistant address',
                      hint: 'homeassistant.local:8123',
                      keyboardType: TextInputType.url,
                      onChanged: controller.updateAddress,
                    ),
                    HubTextField(
                      label: 'Access token',
                      hint: 'Long-lived access token',
                      helper: 'Home Assistant → Profile → Security → Long-lived access tokens',
                      obscure: true,
                      onChanged: controller.updateToken,
                      onSubmitted: (_) => controller.connect(),
                    ),
                    if (state.error case final error?)
                      Text(_errorText(error), style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: HubSpacing.s12,
                      children: [
                        HubButton(
                          label: 'Try demo',
                          variant: HubButtonVariant.secondary,
                          isLoading: state.isStartingDemo,
                          onPressed: state.isConnecting && !state.isStartingDemo ? null : controller.startDemo,
                        ),
                        HubButton(
                          label: 'Connect',
                          isLoading: state.isConnecting && !state.isStartingDemo,
                          onPressed: state.isStartingDemo ? null : controller.connect,
                        ),
                      ],
                    ),
                    if (!standalone)
                      Semantics(
                        button: true,
                        child: GestureDetector(
                          onTap: state.isConnecting ? null : controller.startWithoutHomeAssistant,
                          child: Text(
                            'No Home Assistant? Start with plants and Spotify',
                            textAlign: TextAlign.center,
                            style: HubTextStyles.label.copyWith(
                              color: HubColorPalette.text2,
                              decoration: TextDecoration.underline,
                              decorationColor: HubColorPalette.text3,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _errorText(SetupError error) {
    return switch (error) {
      SetupError.invalidAddress => 'Enter the address of your Home Assistant, e.g. homeassistant.local:8123.',
      SetupError.missingToken => 'Enter a long-lived access token.',
      SetupError.authFailed => 'Home Assistant rejected the token.',
      SetupError.unreachable => 'Home Assistant could not be reached. Check the address and the network.',
    };
  }
}
