import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';

/// Short texts about the weather ahead.
abstract final class WeatherSummaryUtil {
  /// Rain from this chance on counts as expected.
  static const wetChance = 50;

  /// Gusts from this speed on (km/h) are worth a mention.
  static const strongGusts = 40.0;

  static const _directions = ['North', 'Northeast', 'East', 'Southeast', 'South', 'Southwest', 'West', 'Northwest'];

  /// One or two sentences about the next 12 [hours] (the first is now), e.g.
  /// "Rain expected around 17:00. Gusts up to 45 km/h in the evening."
  static String headline(List<WeatherHour> hours) {
    final ahead = hours.take(12).toList();
    if (ahead.isEmpty) return '';
    bool wet(WeatherHour hour) => hour.condition.isWet || hour.precipitationProbability >= wetChance;

    final String sky;
    if (wet(ahead.first)) {
      final dryAt = ahead.where((hour) => !wet(hour)).firstOrNull;
      final what = _nameOf(ahead.first);
      sky = dryAt == null ? '$what for the next hours.' : '$what until around ${_time(dryAt.time)}.';
    } else if (ahead.where(wet).firstOrNull case final first?) {
      sky = '${_nameOf(first)} expected around ${_time(first.time)}.';
    } else {
      sky = 'Dry for the next 12 hours.';
    }

    final gustiest = ahead.reduce((a, b) => b.windGusts > a.windGusts ? b : a);
    if (gustiest.windGusts < strongGusts) return sky;
    return '$sky Gusts up to ${gustiest.windGusts.round()} km/h ${_partOfDay(gustiest.time)}.';
  }

  /// Compass name of the direction the wind comes from, e.g. "West".
  static String windFrom(int degrees) => _directions[((degrees % 360) / 45).round() % 8];

  static String _nameOf(WeatherHour hour) {
    return switch (hour.condition) {
      WeatherCondition.snow => 'Snow',
      WeatherCondition.thunderstorm => 'Thunderstorms',
      WeatherCondition.drizzle => 'Drizzle',
      _ => 'Rain',
    };
  }

  static String _time(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:00';

  static String _partOfDay(DateTime time) {
    return switch (time.hour) {
      >= 5 && < 12 => 'in the morning',
      >= 12 && < 17 => 'in the afternoon',
      >= 17 && < 22 => 'in the evening',
      _ => 'at night',
    };
  }
}
