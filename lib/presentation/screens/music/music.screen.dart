import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_page.enum.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/library_view.enum.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/presentation/screens/music/widgets/connect_device_tile.dart';
import 'package:smart_hub/presentation/screens/music/widgets/now_playing_card.dart';
import 'package:smart_hub/presentation/screens/music/widgets/playlist_grid.dart';
import 'package:smart_hub/presentation/screens/music/widgets/queue_list.dart';
import 'package:smart_hub/presentation/screens/music/widgets/speaker_tile.dart';

/// Music page: now playing, speakers and Spotify devices, "Jump back in" and "Up next".
///
/// Each part watches only what it shows, so a Spotify poll or a volume change does not rebuild the covers.
class MusicScreen extends ConsumerWidget {
  const MusicScreen({super.key});

  static const _tileWidth = 250.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tabs stay mounted; Spotify is only polled while this tab is on screen.
    final visible = TickerMode.valuesOf(context).enabled;
    final hasTarget = ref.watch(currentTargetProvider(visible: visible).select((target) => target != null));
    if (!hasTarget) return const PageCard(child: _NothingToPlayOn());
    return GestureDetector(
      // A tap next to a tile hides its options.
      behavior: HitTestBehavior.translucent,
      onTap: ref.read(musicControllerProvider.notifier).closeOptions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s16,
        children: [
          _NowPlaying(visible: visible),
          SizedBox(height: 76, child: _Tiles(visible: visible)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: HubSpacing.s16,
              children: [
                Expanded(flex: 14, child: _JumpBackIn(visible: visible)),
                Expanded(flex: 10, child: _UpNext(visible: visible)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// No speaker and no Spotify device: says what is missing.
class _NothingToPlayOn extends ConsumerWidget {
  const _NothingToPlayOn();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(spotifyAccountServiceProvider).value;
    final (title, text, action) = switch (account) {
      SpotifySignedIn() => (
        'Nothing to play on',
        'Open Spotify on your phone, a computer or this tablet – it shows up here to play on.',
        null,
      ),
      SpotifySignedOut() => (
        'Connect Spotify',
        'Play your music on your phone, a computer or this tablet – and on speakers once Home Assistant is '
            'connected.',
        'Open settings',
      ),
      SpotifyNotConfigured() || null => ('No speakers yet', 'Speakers show up once Home Assistant is connected.', null),
    };
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: HubSpacing.s12,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const HubGlyphIcon(HubGlyph.note, color: HubColorPalette.text2, size: Size.square(28)),
            ),
            Text(title, style: HubTextStyles.widgetTitle, textAlign: TextAlign.center),
            Text(text, style: HubTextStyles.secondary, textAlign: TextAlign.center),
            if (action != null) HubButton(label: action, onPressed: () => context.push(HubPage.settings.path)),
          ],
        ),
      ),
    );
  }
}

/// Spotify devices are steered over the internet, so they work while Home Assistant is offline.
bool _transportEnabled(WidgetRef ref, PlaybackTarget? target) {
  return target is ConnectTarget || (ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false);
}

class _NowPlaying extends ConsumerWidget {
  const _NowPlaying({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = ref.watch(currentTargetProvider(visible: visible));
    if (target == null) return const SizedBox.shrink();
    final controller = ref.read(musicControllerProvider.notifier);
    return NowPlayingCard(
      target: target,
      enabled: _transportEnabled(ref, target),
      onPrevious: () => controller.previous(target),
      onPlayPause: () => controller.playPause(target),
      onNext: () => controller.next(target),
    );
  }
}

/// One tile per speaker and Spotify device. Grouped speakers stand side by side, linked, and count as one target.
class _Tiles extends ConsumerWidget {
  const _Tiles({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openTileId = ref.watch(musicControllerProvider.select((state) => state.openTileId));
    final controller = ref.read(musicControllerProvider.notifier);
    final activeId = ref.watch(currentTargetProvider(visible: visible).select((target) => target?.id));
    final activeGroup = ref.watch(
      currentTargetProvider(visible: visible).select((target) => target is SpeakerGroupTarget ? target.group : null),
    );
    final groups = ref.watch(speakerGroupsProvider);
    PlaybackTarget? current() => ref.read(currentTargetProvider(visible: visible));
    final devices = ref.watch(connectTargetsProvider(visible: visible));
    final enabled = ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false;
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (final group in groups)
          for (final (index, speaker) in group.members.indexed) ...[
            SizedBox(
              width: MusicScreen._tileWidth,
              child: SpeakerTile(
                speaker: speaker,
                active: SpeakerGroupTarget(group).id == activeId,
                optionsShown: openTileId == speaker.id,
                enabled: enabled,
                canJoin: activeGroup != null && !activeGroup.contains(speaker.id),
                onTap: () => controller.tapTile(SpeakerGroupTarget(group), current: current(), tileId: speaker.id),
                onLongPress: () => controller.showOptions(speaker.id),
                onVolumeChanged: (percent) => controller.changeVolume(speaker.id, percent),
                onVolumeEnd: (percent) => controller.endVolume(speaker.id, percent),
                onToggleGroup: () {
                  if (activeGroup != null) controller.toggleMembership(speaker, activeGroup);
                },
              ),
            ),
            if (index < group.members.length - 1)
              _GroupLink(active: SpeakerGroupTarget(group).id == activeId)
            else
              const SizedBox(width: HubSpacing.s12),
          ],
        for (final device in devices) ...[
          SizedBox(
            width: MusicScreen._tileWidth,
            child: ConnectDeviceTile(
              device: device.device,
              playing: device.nowPlaying.isPlaying,
              active: device.id == activeId,
              optionsShown: openTileId == device.id,
              onTap: () => controller.tapTile(device, current: current(), tileId: device.id),
              onLongPress: () => controller.showOptions(device.id),
              onVolumeChanged: (percent) => controller.changeDeviceVolume(device.device, percent),
              onVolumeEnd: (percent) => controller.endDeviceVolume(device.device, percent),
            ),
          ),
          const SizedBox(width: HubSpacing.s12),
        ],
      ],
    );
  }
}

/// Joins two tiles of the same speaker group.
class _GroupLink extends StatelessWidget {
  const _GroupLink({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: HubSpacing.s12,
      child: Center(
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          height: 3,
          color: active ? HubColorPalette.text.withValues(alpha: 0.8) : const Color(0x33FFFFFF),
        ),
      ),
    );
  }
}

class _JumpBackIn extends ConsumerWidget {
  const _JumpBackIn({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // With Spotify connected its library is the source, otherwise the favorites of the active group's leader.
    final spotify = ref.watch(spotifyAccountServiceProvider).value is SpotifySignedIn;
    final shown = currentTargetProvider(visible: visible);
    final leaderId = ref.watch(
      shown.select((target) => target is SpeakerGroupTarget && !spotify ? target.group.leaderId : null),
    );
    final enabled = ref.watch(shown.select((target) => target is ConnectTarget)) || _transportEnabled(ref, null);
    final view = ref.watch(musicControllerProvider.select((state) => state.libraryView));
    final favorites = switch ((leaderId, view)) {
      (final leaderId?, _) => ref.watch(mediaFavoritesProvider(leaderId)),
      (null, LibraryView.recent) => ref.watch(spotifyRecentProvider),
      (null, LibraryView.playlists) => ref.watch(spotifyPlaylistsProvider),
    };
    return PageCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s12,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  leaderId == null && view == LibraryView.playlists ? 'Playlists' : 'Jump back in',
                  style: HubTextStyles.widgetTitle,
                ),
              ),
              if (leaderId == null)
                _LibraryToggle(view: view, onChanged: ref.read(musicControllerProvider.notifier).showLibrary),
            ],
          ),
          Expanded(
            child: switch (favorites) {
              AsyncData(value: final items) when items.isNotEmpty => PlaylistGrid(
                key: ValueKey(view),
                items: items,
                enabled: enabled,
                onPlay: (item) {
                  if (ref.read(shown) case final target?) ref.read(musicControllerProvider.notifier).play(target, item);
                },
              ),
              AsyncLoading() => const SizedBox.shrink(),
              _ => const Center(child: Text('Nothing here yet', style: HubTextStyles.secondary)),
            },
          ),
        ],
      ),
    );
  }
}

/// Switches "Jump back in" between recently played and own playlists.
class _LibraryToggle extends StatelessWidget {
  const _LibraryToggle({required this.view, required this.onChanged});

  final LibraryView view;
  final ValueChanged<LibraryView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: HubColorPalette.control, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (option, glyph, label) in const [
            (LibraryView.recent, HubGlyph.clock, 'Recently played'),
            (LibraryView.playlists, HubGlyph.library, 'Playlists'),
          ])
            Semantics(
              button: true,
              selected: option == view,
              label: label,
              child: GestureDetector(
                onTap: () => onChanged(option),
                child: AnimatedContainer(
                  duration: HubMotion.fadeDuration,
                  width: 44,
                  height: 30,
                  decoration: BoxDecoration(
                    color: option == view ? const Color(0x33FFFFFF) : const Color(0x00FFFFFF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: HubGlyphIcon(
                    glyph,
                    color: option == view ? HubColorPalette.text : HubColorPalette.text2,
                    size: const Size(15, 15),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UpNext extends ConsumerWidget {
  const _UpNext({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shown = ref.watch(
      currentTargetProvider(visible: visible).select(
        (target) => (
          leaderId: target is SpeakerGroupTarget ? target.group.leaderId : null,
          spotifyPlays: target is ConnectTarget && target.playback != null,
          title: target?.nowPlaying.title,
        ),
      ),
    );
    final queue = switch (shown) {
      (leaderId: final leaderId?, spotifyPlays: _, title: _) => ref.watch(playQueueProvider(leaderId)),
      (leaderId: null, spotifyPlays: true, title: _) => ref.watch(spotifyQueueProvider),
      _ => const AsyncData<List<QueueItem>?>(null),
    };
    return PageCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s8,
        children: [
          const Text('Up next', style: HubTextStyles.widgetTitle),
          Expanded(
            child: switch (queue) {
              AsyncData(value: final items?) when items.isNotEmpty => QueueList(
                items: items,
                currentTitle: shown.title,
              ),
              AsyncLoading() => const SizedBox.shrink(),
              _ => const Center(child: Text('Nothing queued here', style: HubTextStyles.secondary)),
            },
          ),
        ],
      ),
    );
  }
}
