import 'package:flutter/material.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_icon.dart';

/// Building blocks shared by the weather widgets and the weather page.
abstract final class WeatherFormat {
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static String degrees(double value) => '${value.round()}°';

  static String time(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  static String day(WeatherDay day, DateTime today) {
    final days = DateTime(
      day.date.year,
      day.date.month,
      day.date.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    return days == 0 ? 'Today' : _weekdays[day.date.weekday - 1];
  }

  static String condition(WeatherCondition condition) {
    return switch (condition) {
      WeatherCondition.clear => 'Clear',
      WeatherCondition.partlyCloudy => 'Partly cloudy',
      WeatherCondition.cloudy => 'Cloudy',
      WeatherCondition.fog => 'Fog',
      WeatherCondition.drizzle => 'Drizzle',
      WeatherCondition.rain => 'Rain',
      WeatherCondition.snow => 'Snow',
      WeatherCondition.thunderstorm => 'Thunderstorm',
    };
  }
}

/// Temperatures of the coming hours as bars; the current hour stands out.
class HourBars extends StatelessWidget {
  const HourBars({super.key, required this.hours, this.showIcons = true});

  static const _now = Color(0xFF0A84FF);
  static const _later = Color(0xFF1C4374);

  final List<WeatherHour> hours;
  final bool showIcons;

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) return const SizedBox.shrink();
    final temperatures = [for (final hour in hours) hour.temperature];
    final low = temperatures.reduce((a, b) => a < b ? a : b);
    final high = temperatures.reduce((a, b) => a > b ? a : b);
    final label = HubTextStyles.label.copyWith(color: HubColorPalette.text2).tabular;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final (index, hour) in hours.indexed)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 6,
              children: [
                Text(WeatherFormat.degrees(hour.temperature), style: HubTextStyles.label.tabular),
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // The coldest bar keeps 40 % of the height, so the shape reads at a glance.
                      final share = high == low ? 1.0 : 0.4 + 0.6 * (hour.temperature - low) / (high - low);
                      return Container(
                        width: 24,
                        height: constraints.maxHeight * share,
                        decoration: BoxDecoration(
                          color: index == 0 ? _now : _later,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      );
                    },
                  ),
                ),
                if (showIcons) WeatherIcon(hour.condition, isDay: hour.isDay, size: 18),
                Text(
                  index == 0 ? 'Now' : '${hour.time.hour}',
                  style: index == 0 ? label.copyWith(color: HubColorPalette.text) : label,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// One day: name, symbol, chance of rain, high / low.
class DayRow extends StatelessWidget {
  const DayRow({super.key, required this.day, required this.today, this.fontSize = 16});

  final WeatherDay day;
  final DateTime today;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final wet = day.precipitationProbability >= 50;
    return Row(
      children: [
        Expanded(
          child: Text(
            WeatherFormat.day(day, today),
            style: HubTextStyles.body.copyWith(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
        ),
        WeatherIcon(day.condition, size: 22),
        const SizedBox(width: 12),
        Container(
          width: 44,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: wet ? const Color(0x400A84FF) : HubColorPalette.control,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            '${day.precipitationProbability}%',
            style: HubTextStyles.label
                .copyWith(fontSize: 12, color: wet ? const Color(0xFF64D2FF) : HubColorPalette.text2)
                .tabular,
          ),
        ),
        SizedBox(
          width: 86,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: WeatherFormat.degrees(day.maxTemperature)),
                TextSpan(
                  text: ' / ${WeatherFormat.degrees(day.minTemperature)}',
                  style: const TextStyle(color: HubColorPalette.text2, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            textAlign: TextAlign.right,
            style: HubTextStyles.body.copyWith(fontSize: fontSize, fontWeight: FontWeight.w700).tabular,
          ),
        ),
      ],
    );
  }
}
