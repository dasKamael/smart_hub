import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// The main colors of a cover, read from a tiny decoded copy, e.g. for an ambient background. Cached per URL.
abstract final class CoverColors {
  static const _size = 16;
  static const _count = 3;
  static final _cache = <String, Future<List<Color>>>{};

  /// Colors of [url]; the colors of an image-less [seed] cover when there is no URL or it does not load.
  static Future<List<Color>> of(String? url, {required String seed}) {
    if (url == null) return Future.value(ofSeed(seed));
    return _cache.putIfAbsent(url, () => _load(url).catchError((Object _) => ofSeed(seed)));
  }

  /// Shades of the color an image-less cover of [seed] gets.
  static List<Color> ofSeed(String seed) {
    final color = HSVColor.fromColor(Artwork.colorOf(seed));
    return [
      for (final (hueShift, value) in const [(0.0, 0.62), (24.0, 0.48), (-30.0, 0.38)])
        color.withHue((color.hue + hueShift) % 360).withValue(value).toColor(),
    ];
  }

  /// The [_count] most present hues of RGBA [pixels], favouring colorful ones, darkened for a background.
  static List<Color> fromPixels(Uint8List pixels) {
    const bins = 12;
    final counts = List.filled(bins, 0.0);
    final sums = List.generate(bins, (_) => [0.0, 0.0, 0.0]);
    var gray = [0.0, 0.0, 0.0];
    var grayCount = 0;
    for (var i = 0; i + 3 < pixels.length; i += 4) {
      final color = Color.fromARGB(255, pixels[i], pixels[i + 1], pixels[i + 2]);
      final hsv = HSVColor.fromColor(color);
      if (hsv.value < 0.12) continue;
      if (hsv.saturation < 0.18) {
        gray = [gray[0] + pixels[i], gray[1] + pixels[i + 1], gray[2] + pixels[i + 2]];
        grayCount++;
        continue;
      }
      final bin = (hsv.hue / 360 * bins).floor() % bins;
      counts[bin] += 0.5 + hsv.saturation;
      sums[bin] = [sums[bin][0] + pixels[i], sums[bin][1] + pixels[i + 1], sums[bin][2] + pixels[i + 2]];
    }
    final order = [for (var bin = 0; bin < bins; bin++) bin]..sort((a, b) => counts[b].compareTo(counts[a]));
    final colors = <Color>[for (final bin in order.where((bin) => counts[bin] > 0).take(_count)) _mix(sums[bin])];
    if (colors.isEmpty && grayCount > 0) colors.add(_mix(gray));
    if (colors.isEmpty) return ofSeed('');
    while (colors.length < _count) {
      final base = HSVColor.fromColor(colors.first);
      colors.add(base.withValue(base.value * (colors.length == 1 ? 0.7 : 0.5)).toColor());
    }
    return [
      for (final color in colors)
        () {
          final hsv = HSVColor.fromColor(color);
          return hsv.withValue(hsv.value.clamp(0.25, 0.7)).toColor();
        }(),
    ];
  }

  /// The color mix of summed RGB channels, at full brightness (brightness is set afterwards).
  static Color _mix(List<double> sum) {
    final max = [sum[0], sum[1], sum[2]].reduce((a, b) => a > b ? a : b);
    if (max == 0) return const Color(0xFF000000);
    return Color.fromARGB(
      255,
      (sum[0] / max * 255).round(),
      (sum[1] / max * 255).round(),
      (sum[2] / max * 255).round(),
    );
  }

  static Future<List<Color>> _load(String url) async {
    final provider = ResizeImage(NetworkImage(url), width: _size, height: _size);
    final completer = Completer<ui.Image>();
    final stream = provider.resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        completer.complete(info.image.clone());
        info.dispose();
      },
      onError: (Object error, StackTrace? stackTrace) {
        stream.removeListener(listener);
        completer.completeError(error, stackTrace);
      },
    );
    stream.addListener(listener);
    final image = await completer.future;
    final bytes = await image.toByteData();
    image.dispose();
    if (bytes == null) throw StateError('Cover without pixels');
    return fromPixels(bytes.buffer.asUint8List());
  }
}
