import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/network_speakers.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/presentation/screens/music/widgets/now_playing_card.dart';
import 'package:smart_hub/presentation/utils/extension/connect_device_type.extension.dart';

HubGlyph _glyphOf(PlaybackTarget target) => switch (target) {
  ConnectTarget(:final device) => device.type.glyph,
  SpeakerGroupTarget() => HubGlyph.speaker,
};

/// Where the music plays; a tap fans out every place above it to move the music there.
class PlaybackPlaceButton extends ConsumerWidget {
  const PlaybackPlaceButton({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = ref.watch(currentTargetProvider(visible: visible));
    if (target == null) return const SizedBox.shrink();
    return Semantics(
      button: true,
      label: 'Playing on ${target.name}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () => unawaited(_showPlaces(context, visible: visible)),
        child: AnimatedContainer(
          duration: HubMotion.tintDuration,
          curve: HubMotion.tint,
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: PageCard.decoration(
            color: NowPlayingCard.fillOf(ref.watch(coverTintProvider(visible: visible))),
            radius: 20,
          ),
          child: Row(
            spacing: 10,
            children: [
              _PlaceIcon(glyph: _glyphOf(target), playing: target.nowPlaying.isPlaying),
              Expanded(
                child: Text(
                  target.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: HubTextStyles.label.copyWith(fontSize: 14, height: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fans the places out upwards from [context]'s button and dims the rest of the page.
Future<void> _showPlaces(BuildContext context, {required bool visible}) {
  final box = context.findRenderObject()! as RenderBox;
  final anchor = box.localToGlobal(Offset.zero) & box.size;
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: const Color(0x99000000),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (context, animation, _) => Material(
      type: MaterialType.transparency,
      child: _PlaceFan(anchor: anchor, animation: animation, visible: visible),
    ),
  );
}

class _PlaceFan extends ConsumerWidget {
  const _PlaceFan({required this.anchor, required this.animation, required this.visible});

  /// The button in global coordinates; the places stack up from its top edge, right-aligned with it.
  final Rect anchor;
  final Animation<double> animation;
  final bool visible;

  static const _width = 300.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentTargetProvider(visible: visible));
    final groups = ref.watch(speakerGroupsProvider);
    final devices = ref.watch(connectTargetsProvider(visible: visible));
    final controller = ref.read(musicControllerProvider.notifier);
    final speakersEnabled = ref.watch(speakersOnlineProvider);
    final activeGroup = current is SpeakerGroupTarget ? current.group : null;

    void moveTo(PlaybackTarget target) {
      controller.moveTo(target, current: current);
      Navigator.of(context).pop();
    }

    // Every speaker on its own row, then the devices with Spotify open; the current place at the bottom, next to
    // the button.
    final rows = <Widget>[
      for (final device in devices.reversed)
        _PlaceRow(
          glyph: _glyphOf(device),
          name: device.name,
          playing: device.nowPlaying.isPlaying,
          active: device.id == current?.id,
          onTap: () => moveTo(device),
        ),
      for (final group in groups.reversed)
        for (final speaker in group.members.reversed)
          _PlaceRow(
            glyph: HubGlyph.speaker,
            name: speaker.name,
            playing: speaker.playback.isPlaying,
            active: activeGroup?.contains(speaker.id) ?? false,
            onTap: speakersEnabled ? () => moveTo(SpeakerGroupTarget(group)) : null,
            // Speakers can play along with the current group.
            grouped: activeGroup?.contains(speaker.id),
            onToggleGroup: activeGroup == null || !speakersEnabled || _onlyMember(activeGroup.members, speaker)
                ? null
                : () => controller.toggleMembership(speaker, activeGroup),
          ),
    ];

    final screen = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Positioned(
          right: screen.width - anchor.right,
          bottom: screen.height - anchor.top + 12,
          width: _width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              for (final (index, row) in rows.indexed)
                // Each row rises from the button, the lower ones first.
                _FanIn(animation: animation, delay: (rows.length - 1 - index) / (rows.length + 2), child: row),
            ],
          ),
        ),
      ],
    );
  }

  static bool _onlyMember(List<SpeakerState> members, SpeakerState speaker) =>
      members.length == 1 && members.single.id == speaker.id;
}

class _FanIn extends StatelessWidget {
  const _FanIn({required this.animation, required this.delay, required this.child});

  final Animation<double> animation;

  /// 0–1: when in the opening the row starts to move.
  final double delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(delay * 0.6, (delay * 0.6 + 0.4).clamp(0, 1), curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.6), end: Offset.zero).animate(curved),
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          alignment: Alignment.bottomRight,
          child: child,
        ),
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.glyph,
    required this.name,
    required this.playing,
    required this.active,
    required this.onTap,
    this.grouped,
    this.onToggleGroup,
  });

  final HubGlyph glyph;
  final String name;
  final bool playing;
  final bool active;
  final VoidCallback? onTap;

  /// Whether the speaker plays with the current group; `null` where grouping does not apply.
  final bool? grouped;
  final VoidCallback? onToggleGroup;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: name,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 60,
          padding: const EdgeInsets.only(left: 12, right: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2B3A52) : HubColorPalette.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: active ? HubColorPalette.accent : const Color(0x22FFFFFF), width: active ? 2 : 1),
            boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 18, offset: Offset(0, 6))],
          ),
          child: Opacity(
            opacity: onTap == null ? 0.5 : 1,
            child: Row(
              spacing: 12,
              children: [
                _PlaceIcon(glyph: glyph, playing: playing),
                Expanded(
                  // The row's label says it already.
                  child: ExcludeSemantics(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HubTextStyles.body.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                if (grouped case final grouped?)
                  Semantics(
                    container: true,
                    button: true,
                    label: grouped ? 'Remove $name from the group' : 'Add $name to the group',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onToggleGroup ?? () {},
                      child: Opacity(
                        opacity: onToggleGroup == null ? 0.35 : 1,
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: grouped ? HubColorPalette.accent : HubColorPalette.control,
                            shape: BoxShape.circle,
                          ),
                          child: HubGlyphIcon(
                            grouped ? HubGlyph.check : HubGlyph.plus,
                            color: HubColorPalette.text,
                            size: const Size.square(15),
                          ),
                        ),
                      ),
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

/// The place's symbol with a green dot while music plays there.
class _PlaceIcon extends StatelessWidget {
  const _PlaceIcon({required this.glyph, required this.playing});

  final HubGlyph glyph;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 38,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: HubColorPalette.control, shape: BoxShape.circle),
            child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(16)),
          ),
          if (playing)
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: HubColorPalette.playing,
                  shape: BoxShape.circle,
                  border: Border.all(color: HubColorPalette.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
