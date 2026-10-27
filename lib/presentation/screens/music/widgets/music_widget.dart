import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/presentation/shared_widgets/empty_mark.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/play_queue.util.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/presentation/screens/music/widgets/sliding_queue.dart';
import 'package:smart_hub/presentation/screens/music/widgets/track_progress.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// What plays as a dashboard widget in any [WidgetSize] (`Widget Kit` → Music): the same target as the music page's
/// "Now playing". The buttons control it, a tap elsewhere opens the music page.
class MusicWidget extends ConsumerWidget {
  const MusicWidget({super.key, required this.size, this.card = true});

  final WidgetSize size;

  /// `false`: no card behind the widget (`DashboardWidget.card`).
  final bool card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Spotify is only polled while the dashboard is on screen.
    final visible = TickerMode.valuesOf(context).enabled;
    final target = ref.watch(currentTargetProvider(visible: visible));
    final online = ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false;
    final controller = ref.read(musicControllerProvider.notifier);

    return WidgetTile(
      card: card,
      // The small one is all cover.
      tint: switch (target) {
        final target? when size != WidgetSize.small => HubAreaColors.musicFor(
          Artwork.colorOf(target.nowPlaying.title ?? target.name),
          playing: target.nowPlaying.isPlaying,
        ),
        _ => null,
      },
      size: size,
      padding: 0,
      onTap: () => context.go(HubRoute.music.path),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: switch (target) {
          null => const _NothingToPlayOn(),
          final target => _Player(
            size: size,
            card: card,
            target: target,
            controls: _Controls(
              // Spotify devices work without Home Assistant.
              enabled: target is ConnectTarget || online,
              onPrevious: () => controller.previous(target),
              onPlayPause: () => controller.playPause(target),
              onNext: () => controller.next(target),
              onPlayFromQueue: (item) => controller.playFromQueue(target, item),
            ),
          ),
        },
      ),
    );
  }
}

final class _Controls {
  const _Controls({
    required this.enabled,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.onPlayFromQueue,
  });

  final bool enabled;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final ValueChanged<QueueItem> onPlayFromQueue;
}

class _Player extends StatelessWidget {
  const _Player({required this.size, required this.card, required this.target, required this.controls});

  final WidgetSize size;
  final bool card;
  final PlaybackTarget target;
  final _Controls controls;

  @override
  Widget build(BuildContext context) {
    final track = target.nowPlaying;
    final seed = track.title ?? target.name;
    if (size == WidgetSize.small) return _Small(track: track, seed: seed, controls: controls);
    return Padding(
      padding: EdgeInsets.all(size == WidgetSize.medium ? 16 : 18),
      child: switch (size) {
        WidgetSize.medium => _Medium(track: track, seed: seed, controls: controls),
        WidgetSize.large => _Large(target: target, seed: seed, controls: controls),
        _ => _ExtraLarge(target: target, seed: seed, controls: controls),
      },
    );
  }
}

/// The cover fills the widget; title at the bottom, play / pause in the corner.
class _Small extends StatelessWidget {
  const _Small({required this.track, required this.seed, required this.controls});

  final NowPlaying track;
  final String seed;
  final _Controls controls;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Artwork(seed: seed, url: track.artworkUrl, radius: 0, showNote: false),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.35, 1],
              colors: [Color(0x00000000), Color(0x99000000)],
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: _PlayButton(playing: track.isPlaying, size: 40, controls: controls),
        ),
        Positioned(left: 14, right: 14, bottom: 12, child: _Title(track: track, titleSize: 15, artistSize: 12)),
      ],
    );
  }
}

/// Cover, title, play / pause and the progress with times.
class _Medium extends StatelessWidget {
  const _Medium({required this.track, required this.seed, required this.controls});

  final NowPlaying track;
  final String seed;
  final _Controls controls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 14,
          children: [
            _Cover(seed: seed, url: track.artworkUrl, size: 76, radius: 12),
            Expanded(child: _Title(track: track, titleSize: 17, artistSize: 14)),
            _PlayButton(playing: track.isPlaying, size: 48, controls: controls),
          ],
        ),
        TrackProgress(track: track),
      ],
    );
  }
}

/// Cover with title and where it plays, progress, the transport and what comes next.
class _Large extends ConsumerWidget {
  const _Large({required this.target, required this.seed, required this.controls});

  final PlaybackTarget target;
  final String seed;
  final _Controls controls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = target.nowPlaying;
    final queue = _queue(ref, target);
    final hasNext = PlayQueueUtil.nextAfter(queue, track.title) != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        Row(
          spacing: 14,
          children: [
            _Cover(seed: seed, url: track.artworkUrl, size: 110, radius: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  _Title(track: track, titleSize: 18, artistSize: 14),
                  _Where(target: target),
                ],
              ),
            ),
          ],
        ),
        TrackProgress(track: track, showTimes: false),
        _Transport(playing: track.isPlaying, controls: controls, gap: 28, playSize: 52),
        if (hasNext)
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x24FFFFFF), width: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 6,
                children: [
                  Text('Up next', style: HubTextStyles.label.copyWith(fontSize: 12, color: HubColorPalette.text2)),
                  SizedBox(
                    height: 2 * 34,
                    child: SlidingQueue(
                      items: queue ?? const [],
                      currentTitle: track.title,
                      showCurrent: false,
                      maxItems: 2,
                      itemExtent: 34,
                      itemBuilder: (context, item, {required current}) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _QueueRow(item, onTap: controls.enabled ? () => controls.onPlayFromQueue(item) : null),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The player on the left, "Jump back in" on the right.
class _ExtraLarge extends ConsumerWidget {
  const _ExtraLarge({required this.target, required this.seed, required this.controls});

  final PlaybackTarget target;
  final String seed;
  final _Controls controls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = target.nowPlaying;
    final queue = _queue(ref, target);
    final hasNext = PlayQueueUtil.nextAfter(queue, track.title) != null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        SizedBox(
          width: 290,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              // The cover spans the column and takes the height that is left.
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Color(0x59000000), blurRadius: 18, offset: Offset(0, 6))],
                  ),
                  child: Artwork(seed: seed, url: track.artworkUrl, radius: 16),
                ),
              ),
              _Title(track: track, titleSize: 20, artistSize: 15),
              TrackProgress(track: track),
              _Where(target: target),
              _Transport(playing: track.isPlaying, controls: controls, gap: 18, playSize: 50),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Text(
                'Up next',
                style: HubTextStyles.label.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HubColorPalette.text2,
                ),
              ),
              Expanded(
                child: hasNext
                    ? LayoutBuilder(
                        builder: (context, constraints) => SlidingQueue(
                          items: queue ?? const [],
                          currentTitle: track.title,
                          showCurrent: false,
                          maxItems: (constraints.maxHeight / 52).floor(),
                          itemExtent: 52,
                          itemBuilder: (context, item, {required current}) => _QueueRow(
                            item,
                            large: true,
                            onTap: controls.enabled ? () => controls.onPlayFromQueue(item) : null,
                          ),
                        ),
                      )
                    : const EmptyMark(glyph: HubGlyph.note, label: 'Nothing queued', size: 48),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The target's play queue; the last one stays while a new one loads.
List<QueueItem>? _queue(WidgetRef ref, PlaybackTarget target) {
  return switch (target) {
    SpeakerGroupTarget(:final group) => ref.watch(playQueueProvider(group.leaderId)).value,
    ConnectTarget(playback: _?) => ref.watch(spotifyQueueProvider).value,
    ConnectTarget() => null,
  };
}

class _Cover extends StatelessWidget {
  const _Cover({required this.seed, required this.url, required this.size, required this.radius});

  final String seed;
  final String? url;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [BoxShadow(color: Color(0x59000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: Artwork(seed: seed, url: url, size: size, radius: radius),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.track, required this.titleSize, required this.artistSize});

  final NowPlaying track;
  final double titleSize;
  final double artistSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          track.title ?? 'Nothing playing',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w700, color: HubColorPalette.text, height: 1.25),
        ),
        if (track.artist case final artist? when artist.isNotEmpty)
          Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: artistSize, color: const Color(0xB3EBEBF5), height: 1.3),
          ),
      ],
    );
  }
}

/// Where it plays: a green dot while playing, and the speaker or device name.
class _Where extends StatelessWidget {
  const _Where({required this.target});

  final PlaybackTarget target;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: target.nowPlaying.isPlaying ? HubColorPalette.playing : HubColorPalette.text3,
            shape: BoxShape.circle,
          ),
        ),
        Flexible(
          child: Text(
            target.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HubTextStyles.label.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: HubColorPalette.text2,
            ),
          ),
        ),
      ],
    );
  }
}

class _Transport extends StatelessWidget {
  const _Transport({required this.playing, required this.controls, required this.gap, required this.playSize});

  final bool playing;
  final _Controls controls;
  final double gap;
  final double playSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: gap,
      children: [
        _SkipButton(glyph: HubGlyph.previous, label: 'Previous', onTap: controls.enabled ? controls.onPrevious : null),
        _PlayButton(playing: playing, size: playSize, controls: controls),
        _SkipButton(glyph: HubGlyph.next, label: 'Next', onTap: controls.enabled ? controls.onNext : null),
      ],
    );
  }
}

/// Round glass button (`Widget Kit` → Music).
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.playing, required this.size, required this.controls});

  final bool playing;
  final double size;
  final _Controls controls;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: playing ? 'Pause' : 'Play',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // While offline the button swallows the tap instead of opening the music page.
        onTap: controls.enabled ? controls.onPlayPause : () {},
        child: Opacity(
          opacity: controls.enabled ? 1 : 0.4,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x2EFFFFFF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x59FFFFFF), width: 0.5),
            ),
            child: HubGlyphIcon(
              playing ? HubGlyph.pause : HubGlyph.play,
              color: HubColorPalette.text,
              size: Size.square(size * 0.34),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.glyph, required this.label, required this.onTap});

  final HubGlyph glyph;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ?? () {},
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1,
          child: SizedBox.square(
            dimension: 40,
            child: Center(
              child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(20)),
            ),
          ),
        ),
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow(this.item, {required this.onTap, this.large = false});

  final QueueItem item;
  final VoidCallback? onTap;

  /// Bigger cover and text, with the artist below the title (extra large widget).
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: item.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ?? () {},
        child: Row(
          spacing: large ? 14 : 10,
          children: [
            Artwork(
              seed: item.title,
              url: item.artworkUrl,
              size: large ? 42 : 28,
              radius: large ? 8 : 6,
              showNote: false,
            ),
            Expanded(
              child: large
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HubTextStyles.body.copyWith(fontSize: 16),
                        ),
                        if (item.artist case final artist? when artist.isNotEmpty)
                          Text(
                            artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HubTextStyles.label.copyWith(
                              fontWeight: FontWeight.w400,
                              color: HubColorPalette.text2,
                            ),
                          ),
                      ],
                    )
                  : Text.rich(
                      TextSpan(
                        text: item.title,
                        children: [
                          if (item.artist case final artist? when artist.isNotEmpty)
                            TextSpan(
                              text: ' · $artist',
                              style: const TextStyle(fontWeight: FontWeight.w400, color: HubColorPalette.text2),
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HubTextStyles.label.copyWith(fontSize: 14),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NothingToPlayOn extends StatelessWidget {
  const _NothingToPlayOn();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
            child: const HubGlyphIcon(HubGlyph.speaker, color: HubColorPalette.text2),
          ),
          Text('Nothing to play on', style: HubTextStyles.label.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
