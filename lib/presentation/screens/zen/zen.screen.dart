import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';
import 'package:smart_hub/presentation/screens/music/playback_target.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/presentation/screens/zen/widgets/ambient_background.dart';
import 'package:smart_hub/presentation/screens/zen/zen.controller.dart';
import 'package:smart_hub/presentation/shared_widgets/cover_colors.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// Calm full screen for the time nobody stands at the tablet: the time, what plays and one play / pause button over
/// the blurred cover. A tap anywhere else goes back. Dimmed at night.
///
/// Once a minute the content shifts a few pixels (against burn-in); the background drifts slowly in the cover's
/// colors. The next track's cover is loaded ahead, so a track change shows no placeholder.
class ZenScreen extends ConsumerStatefulWidget {
  const ZenScreen({super.key});

  /// From 22:00 to 6:00 the screen is dimmed.
  static bool isNight(DateTime time) => time.hour >= 22 || time.hour < 6;

  @override
  ConsumerState<ZenScreen> createState() => _ZenScreenState();
}

class _ZenScreenState extends ConsumerState<ZenScreen> {
  static const _shifts = [Offset.zero, Offset(14, -10), Offset(-12, 12), Offset(10, 14)];
  static const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late DateTime _now = clock.now();
  Timer? _timer;

  /// Side of the big cover as last laid out; the next cover is loaded ahead at this size.
  var _coverSide = 520.0;
  List<Color> _colors = ambientFallback;
  String? _colorsOf;

  /// Colors of the cover, read once per cover; the old ones stay until the new ones are known.
  List<Color> _colorsFor(String? url, String seed) {
    final key = url ?? seed;
    if (key != _colorsOf) {
      _colorsOf = key;
      unawaited(
        CoverColors.of(url, seed: seed).then((colors) {
          if (mounted && _colorsOf == key) setState(() => _colors = colors);
        }),
      );
    }
    return _colors;
  }

  /// Loads the next track's cover (and its colors) ahead, so it shows at once when the track changes.
  void _preload(QueueItem? next) {
    final url = next?.coverUrl;
    if (next == null || url == null) return;
    final image = Artwork.imageOf(url, side: _coverSide, devicePixelRatio: MediaQuery.devicePixelRatioOf(context));
    unawaited(precacheImage(image, context, onError: (_, _) {}));
    unawaited(CoverColors.of(url, seed: next.title));
  }

  @override
  void initState() {
    super.initState();
    _scheduleMinute();
    // After the first frame: preloading needs the device pixel ratio.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.listenManual(upNextProvider(visible: true), (_, next) => _preload(next), fireImmediately: true);
    });
  }

  void _scheduleMinute() {
    final next = DateTime(_now.year, _now.month, _now.day, _now.hour, _now.minute + 1);
    _timer = Timer(next.difference(clock.now()) + const Duration(milliseconds: 50), () {
      setState(() => _now = clock.now());
      _scheduleMinute();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = ref.watch(currentTargetProvider(visible: true));
    final track = target?.nowPlaying;
    final night = ZenScreen.isNight(_now);
    final seed = track?.title ?? 'zen';
    final shift = _shifts[_now.minute % _shifts.length];
    final time = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    final date = '${_weekdays[_now.weekday - 1]}, ${_now.day} ${_months[_now.month - 1]}';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ref.read(zenControllerProvider.notifier).exit,
      child: ColoredBox(
        color: HubColorPalette.bg,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AmbientBackground(colors: _colorsFor(track?.artworkUrl, seed), playing: track?.isPlaying ?? false),
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(shift.dx, shift.dy, 0),
              padding: const EdgeInsets.fromLTRB(96, 72, 96, 72),
              child: Row(
                spacing: 72,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          time,
                          style: HubTextStyles.pageTitle
                              .copyWith(fontSize: 128, fontWeight: FontWeight.w200, height: 1, letterSpacing: -4)
                              .tabular,
                        ),
                        const SizedBox(height: 6),
                        Text(date, style: HubTextStyles.sectionTitle.copyWith(color: HubColorPalette.text2)),
                        if (target != null && track?.title != null) ...[
                          const SizedBox(height: 64),
                          _TrackInfo(target: target),
                        ],
                      ],
                    ),
                  ),
                  if (track?.title != null)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final side = _coverSide = constraints.maxHeight.clamp(0, 520).toDouble();
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [
                              BoxShadow(color: Color(0x99000000), blurRadius: 60, offset: Offset(0, 24)),
                            ],
                          ),
                          child: Artwork(seed: seed, url: track?.artworkUrl, size: side, radius: 28),
                        );
                      },
                    ),
                ],
              ),
            ),
            // Dimmed at night, so the tablet does not light up the hall.
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: night ? 0.6 : 0,
                duration: const Duration(seconds: 2),
                child: const ColoredBox(color: Color(0xFF000000)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackInfo extends ConsumerWidget {
  const _TrackInfo({required this.target});

  final PlaybackTarget target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = target.nowPlaying;
    final enabled = target is ConnectTarget || (ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false);
    final controller = ref.read(musicControllerProvider.notifier);
    return Row(
      spacing: 16,
      children: [
        Semantics(
          button: true,
          label: track.isPlaying ? 'Pause' : 'Play',
          child: GestureDetector(
            // Absorbs the tap, so it does not also leave the zen mode.
            onTap: enabled ? () => controller.playPause(target) : () {},
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: Color(0x26FFFFFF), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: HubGlyphIcon(
                track.isPlaying ? HubGlyph.pause : HubGlyph.play,
                color: HubColorPalette.text,
                size: const Size.square(22),
              ),
            ),
          ),
        ),
        // Quieter than play / pause: there, but not in the way.
        Semantics(
          button: true,
          label: 'Next',
          child: GestureDetector(
            onTap: enabled ? () => controller.next(target) : () {},
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: Color(0x14FFFFFF), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const HubGlyphIcon(HubGlyph.next, color: HubColorPalette.text2, size: Size.square(15)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                track.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: HubTextStyles.pageTitle.copyWith(fontSize: 30, height: 1.15),
              ),
              Text(
                [?track.artist, target.name].where((part) => part.isNotEmpty).join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HubTextStyles.secondary.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
