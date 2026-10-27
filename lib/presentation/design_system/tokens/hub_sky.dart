import 'package:flutter/painting.dart';

/// Colors of the background sky at a time of day: a vertical gradient and two soft glows that drift over it.
typedef SkyColors = ({Color top, Color bottom, Color glow, Color glow2});

/// The background follows the day – night blue, a muted dawn, slate blue by day and a violet dusk – and blends
/// between them, so it changes without anyone noticing.
abstract final class HubSky {
  static const _night = (
    top: Color(0xFF111A2E),
    bottom: Color(0xFF070A12),
    glow: Color(0xFF1F2D52),
    glow2: Color(0xFF2A1F45),
  );
  static const _dawn = (
    top: Color(0xFF3A2A38),
    bottom: Color(0xFF121722),
    glow: Color(0xFF6B4237),
    glow2: Color(0xFF34406A),
  );
  static const _day = (
    top: Color(0xFF223246),
    bottom: Color(0xFF101823),
    glow: Color(0xFF2F5675),
    glow2: Color(0xFF2B4D52),
  );
  static const _dusk = (
    top: Color(0xFF2D2142),
    bottom: Color(0xFF0E0C1A),
    glow: Color(0xFF5A3058),
    glow2: Color(0xFF3B2E66),
  );

  /// Hour of the day → sky; in between the neighbours blend.
  static const _keys = [
    (0.0, _night),
    (5.0, _night),
    (7.0, _dawn),
    (10.0, _day),
    (17.0, _day),
    (19.5, _dusk),
    (21.5, _night),
    (24.0, _night),
  ];

  static SkyColors at(DateTime time) {
    final hour = time.hour + time.minute / 60 + time.second / 3600;
    for (var i = 1; i < _keys.length; i++) {
      final (toHour, to) = _keys[i];
      if (hour > toHour) continue;
      final (fromHour, from) = _keys[i - 1];
      final t = toHour == fromHour ? 1.0 : (hour - fromHour) / (toHour - fromHour);
      return (
        top: Color.lerp(from.top, to.top, t)!,
        bottom: Color.lerp(from.bottom, to.bottom, t)!,
        glow: Color.lerp(from.glow, to.glow, t)!,
        glow2: Color.lerp(from.glow2, to.glow2, t)!,
      );
    }
    return _night;
  }
}
