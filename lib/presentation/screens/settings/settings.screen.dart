import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_hub/domain/lights/light_bridge.service.dart';
import 'package:smart_hub/presentation/screens/settings/widgets/light_bridge_dialog.dart';
import 'package:smart_hub/presentation/design_system/layouts/hub_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_page.enum.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/hub_entity.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';
import 'package:smart_hub/domain/weather/model/weather_location.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/domain/zen/zen.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_switch.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/settings/settings.controller.dart';
import 'package:smart_hub/presentation/screens/settings/widgets/weather_location_dialog.dart';
import 'package:smart_hub/presentation/shared_widgets/connection_indicator.dart';
import 'package:smart_hub/presentation/shared_widgets/home_assistant_hint.dart';

/// Connection details and all entities the hub can see.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(connectionConfigServiceProvider).value;
    final entities = ref.watch(hubEntitiesServiceProvider).value ?? const [];
    final hasHomeAssistant = ref.watch(hasHomeAssistantProvider);

    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: HubBackground(
        child: SafeArea(
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
                    const Expanded(child: Text('Settings', style: HubTextStyles.pageTitle)),
                    const ConnectionIndicator(),
                  ],
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: HubSpacing.s16,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: HubSpacing.s16,
                            children: [
                              PageCard(
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: HubSpacing.s4,
                                        children: [
                                          const Text('Home Assistant', style: HubTextStyles.widgetTitle),
                                          Text(switch (config) {
                                            HomeAssistantConnectionConfig(:final baseUrl) => baseUrl.toString(),
                                            DemoConnectionConfig() => 'Demo home – no Home Assistant needed',
                                            StandaloneConnectionConfig() || null => 'Not connected',
                                          }, style: HubTextStyles.secondary),
                                        ],
                                      ),
                                    ),
                                    if (hasHomeAssistant)
                                      HubButton(
                                        label: 'Disconnect',
                                        variant: HubButtonVariant.destructive,
                                        onPressed: () => ref.read(connectionConfigServiceProvider.notifier).clear(),
                                      )
                                    else
                                      HubButton(label: 'Connect', onPressed: () => context.push(HubPage.setup.path)),
                                  ],
                                ),
                              ),
                              const _HomeAppCard(),
                              const _LightsCard(),
                              const _SpotifyCard(),
                              const _SpeakersCard(),
                              const _ZenCard(),
                              const _WeatherCard(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageCard(
                          padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                          child: hasHomeAssistant
                              ? _EntityList(entities: entities)
                              : const HomeAssistantHint(
                                  glyph: HubGlyph.bulb,
                                  title: 'No Home Assistant',
                                  text: 'Lights and speakers show up here once the hub is connected to Home Assistant.',
                                  showConnect: false,
                                ),
                        ),
                      ),
                    ],
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

class _HomeAppCard extends ConsumerWidget {
  const _HomeAppCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHomeApp = ref.watch(homeAppControllerProvider);
    return PageCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        spacing: HubSpacing.s16,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: HubSpacing.s4,
              children: [
                Text('Hub as home screen', style: HubTextStyles.widgetTitle),
                Text(
                  'Starts with the tablet and replaces the home screen. Turn off to use the tablet normally again.',
                  style: HubTextStyles.secondary,
                ),
              ],
            ),
          ),
          HubSwitch(
            value: isHomeApp.value ?? false,
            semanticLabel: 'Hub as home screen',
            onChanged: isHomeApp.hasValue
                ? (enabled) => ref.read(homeAppControllerProvider.notifier).setHomeApp(enabled: enabled)
                : null,
          ),
        ],
      ),
    );
  }
}

/// Spotify as content source for "Jump back in". Hidden when the build has no Spotify client id.
/// Lights from a light bridge directly, instead of Home Assistant.
class _LightsCard extends ConsumerWidget {
  const _LightsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bridge = ref.watch(lightBridgeServiceProvider).value;
    final hasHomeAssistant = ref.watch(hasHomeAssistantProvider);
    return PageCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        spacing: HubSpacing.s16,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: HubSpacing.s4,
              children: [
                const Text('Lights', style: HubTextStyles.widgetTitle),
                Text(switch ((bridge, hasHomeAssistant)) {
                  (final bridge?, _) => 'From ${bridge.name ?? 'the light bridge'} at ${bridge.host}',
                  (null, true) => 'From Home Assistant. A paired light bridge would take over.',
                  (null, false) => 'Pair your light bridge to switch lights without Home Assistant.',
                }, style: HubTextStyles.secondary),
              ],
            ),
          ),
          if (bridge != null)
            HubButton(
              label: 'Disconnect',
              variant: HubButtonVariant.destructive,
              onPressed: () => unawaited(ref.read(lightBridgeServiceProvider.notifier).disconnect()),
            )
          else
            HubButton(label: 'Pair bridge', onPressed: () => unawaited(showLightBridgeDialog(context))),
        ],
      ),
    );
  }
}

class _SpotifyCard extends ConsumerWidget {
  const _SpotifyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(spotifyAccountServiceProvider).value;
    final connect = ref.watch(spotifyConnectControllerProvider);
    final controller = ref.read(spotifyConnectControllerProvider.notifier);
    if (account == null || account is SpotifyNotConfigured) return const SizedBox.shrink();
    final signedIn = account is SpotifySignedIn;
    return PageCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        spacing: HubSpacing.s16,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: HubSpacing.s4,
              children: [
                const Text('Spotify', style: HubTextStyles.widgetTitle),
                Text(switch (account) {
                  SpotifySignedIn(:final displayName) => 'Connected as $displayName',
                  _ => 'Your playlists and recently played music in Jump back in.',
                }, style: HubTextStyles.secondary),
                if (connect.error case final error?)
                  Text(error, style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText)),
              ],
            ),
          ),
          if (signedIn)
            HubButton(label: 'Disconnect', variant: HubButtonVariant.destructive, onPressed: controller.disconnect)
          else
            HubButton(label: 'Connect', isLoading: connect.busy, onPressed: controller.connect),
        ],
      ),
    );
  }
}

class _SpeakersCard extends StatelessWidget {
  const _SpeakersCard();

  @override
  Widget build(BuildContext context) {
    return PageCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        spacing: HubSpacing.s16,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: HubSpacing.s4,
              children: [
                Text('Speakers', style: HubTextStyles.widgetTitle),
                Text('Names, hidden speakers and the default speaker.', style: HubTextStyles.secondary),
              ],
            ),
          ),
          HubButton(
            label: 'Manage',
            variant: HubButtonVariant.secondary,
            onPressed: () => context.push(HubPage.speakers.path),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends ConsumerWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(weatherLocationServiceProvider).value;
    final here = ref.watch(weatherServiceProvider).value?.place.name;
    return PageCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Row(
        spacing: HubSpacing.s16,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: HubSpacing.s4,
              children: [
                const Text('Weather', style: HubTextStyles.widgetTitle),
                Text(switch (location) {
                  PlaceWeatherLocation(:final place) => describePlace(place),
                  _ => here == null ? 'Where the hub is' : 'Where the hub is · $here',
                }, style: HubTextStyles.secondary),
              ],
            ),
          ),
          HubButton(
            label: 'Change',
            variant: HubButtonVariant.secondary,
            onPressed: () async {
              final chosen = await showWeatherLocationDialog(context);
              if (chosen != null) await ref.read(weatherLocationServiceProvider.notifier).set(chosen);
            },
          ),
        ],
      ),
    );
  }
}

class _ZenCard extends ConsumerWidget {
  const _ZenCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minutes = ref.watch(zenIdleServiceProvider).value ?? ZenIdleService.defaultMinutes;
    return PageCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: HubSpacing.s12,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: HubSpacing.s4,
            children: [
              Text('Zen mode', style: HubTextStyles.widgetTitle),
              Text('Starts when nobody touched the hub for a while.', style: HubTextStyles.secondary),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: HubColorPalette.control, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                for (final choice in ZenIdleService.choices)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: choice == minutes,
                      child: GestureDetector(
                        onTap: () => unawaited(ref.read(zenIdleServiceProvider.notifier).set(choice)),
                        child: AnimatedContainer(
                          duration: HubMotion.fadeDuration,
                          height: 34,
                          decoration: BoxDecoration(
                            color: choice == minutes ? const Color(0x33FFFFFF) : const Color(0x00FFFFFF),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            choice == 0 ? 'Off' : '$choice min',
                            style: HubTextStyles.label.copyWith(
                              color: choice == minutes ? HubColorPalette.text : HubColorPalette.text2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntityList extends StatelessWidget {
  const _EntityList({required this.entities});

  final List<HubEntity> entities;

  static const _sections = {'light': 'Lights', 'media_player': 'Speakers'};

  @override
  Widget build(BuildContext context) {
    final others = entities.where((e) => !_sections.containsKey(e.domain)).length;
    return ListView(
      children: [
        for (final MapEntry(key: domain, value: title) in _sections.entries) ...[
          _SectionTitle(title: title, count: entities.where((e) => e.domain == domain).length),
          for (final entity in entities.where((e) => e.domain == domain)) _EntityRow(entity: entity),
          const SizedBox(height: HubSpacing.s16),
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: HubSpacing.s20),
          child: Text('$others other entities', style: HubTextStyles.secondary),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HubSpacing.s8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: title, style: HubTextStyles.widgetTitle),
            TextSpan(
              text: '  $count',
              style: HubTextStyles.widgetTitle.copyWith(color: HubColorPalette.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntityRow extends StatelessWidget {
  const _EntityRow({required this.entity});

  final HubEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: HubColorPalette.separator, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entity.name, style: HubTextStyles.body),
                Text(entity.id, style: HubTextStyles.label.copyWith(color: HubColorPalette.text3)),
              ],
            ),
          ),
          Text(entity.state, style: HubTextStyles.secondary),
        ],
      ),
    );
  }
}
