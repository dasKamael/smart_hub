import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/domain/weather/weather_summary.util.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_icon.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_parts.dart';

/// The weather in full (`Widget Kit` → Weather → Full page): now with a short outlook, the next 12 hours, details
/// and the next 10 days.
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(weatherServiceProvider).value;
    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: SafeArea(
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
                  const Expanded(child: Text('Weather', style: HubTextStyles.pageTitle)),
                  if (forecast != null)
                    Text(
                      'Updated ${WeatherFormat.time(forecast.fetchedAt)}',
                      style: HubTextStyles.label.copyWith(color: HubColorPalette.text3),
                    ),
                ],
              ),
              Expanded(
                child: forecast == null
                    ? const PageCard(
                        child: Center(child: Text('Weather not available', style: HubTextStyles.secondary)),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: HubSpacing.s16,
                        children: [
                          Expanded(flex: 13, child: _Today(forecast)),
                          Expanded(flex: 10, child: _Days(forecast)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Today extends StatelessWidget {
  const _Today(this.forecast);

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final now = forecast.now;
    final today = forecast.days.firstOrNull;
    final rainNextDay = forecast.hours.take(24).fold(0.0, (sum, hour) => sum + hour.precipitation);
    final feels = now.apparentTemperature - now.temperature;
    final headline = WeatherSummaryUtil.headline(forecast.hours);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s16,
      children: [
        Expanded(
          flex: 6,
          child: PageCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 18,
                  children: [
                    WeatherIcon(now.condition, isDay: now.isDay, size: 56),
                    Text(
                      WeatherFormat.degrees(now.temperature),
                      style: HubTextStyles.display.copyWith(fontSize: 76, height: 1, letterSpacing: -2).tabular,
                    ),
                    const Spacer(),
                    Text(
                      forecast.place.name,
                      style: HubTextStyles.body.copyWith(fontSize: 17, color: HubColorPalette.text2),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  [
                    WeatherFormat.condition(now.condition),
                    if (today != null)
                      '${WeatherFormat.degrees(today.maxTemperature)} / ${WeatherFormat.degrees(today.minTemperature)}',
                    'Feels ${WeatherFormat.degrees(now.apparentTemperature)}',
                  ].join(' · '),
                  style: HubTextStyles.secondary.copyWith(fontSize: 17),
                ),
                if (headline.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(12)),
                    child: Text(headline, style: HubTextStyles.secondary.copyWith(color: HubColorPalette.text)),
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(child: HourBars(hours: forecast.hours.take(12).toList())),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Builder(
            builder: (context) {
              final details = <Widget>[
                _Detail(
                  label: 'Feels like',
                  value: WeatherFormat.degrees(now.apparentTemperature),
                  detail: switch (feels) {
                    < -1 => 'Wind makes it feel cooler.',
                    > 1 => 'Humidity makes it feel warmer.',
                    _ => 'Feels as warm as it is.',
                  },
                ),
                _Detail(
                  label: 'Precipitation',
                  value: '${rainNextDay.toStringAsFixed(rainNextDay < 10 && rainNextDay > 0 ? 1 : 0)} mm',
                  detail: 'Expected in the next 24 h.',
                ),
                _Detail(
                  label: 'Wind',
                  value: '${now.windSpeed.round()} km/h',
                  detail: '${WeatherSummaryUtil.windFrom(now.windDirection)} · gusts ${now.windGusts.round()} km/h',
                ),
                _Detail(
                  label: 'Humidity',
                  value: '${now.humidity}%',
                  detail: 'Dew point ${WeatherFormat.degrees(now.dewPoint)}',
                ),
                _Detail(
                  label: 'UV index',
                  value: '${now.uvIndex.round()}',
                  detail: switch (today?.uvIndexMax ?? now.uvIndex) {
                    < 3 => 'Low for the rest of the day.',
                    < 6 => 'Moderate around midday.',
                    < 8 => 'High – protect your skin.',
                    _ => 'Very high – stay in the shade.',
                  },
                ),
                _Detail(
                  label: 'Sunset',
                  value: today == null ? '–' : WeatherFormat.time(today.sunset),
                  detail: today == null ? '' : 'Sunrise ${WeatherFormat.time(today.sunrise)}',
                ),
              ];
              Widget row(List<Widget> tiles) => Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: HubSpacing.s16,
                  children: [for (final tile in tiles) Expanded(child: tile)],
                ),
              );
              return Column(spacing: HubSpacing.s16, children: [row(details.sublist(0, 3)), row(details.sublist(3))]);
            },
          ),
        ),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value, required this.detail});

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return PageCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
          Text(value, style: HubTextStyles.sectionTitle.copyWith(fontSize: 26).tabular),
          Text(
            detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: HubTextStyles.label.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: HubColorPalette.text2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Days extends StatelessWidget {
  const _Days(this.forecast);

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final today = clock.now();
    return PageCard(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Next ${forecast.days.length} days', style: HubTextStyles.widgetTitle),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final (index, day) in forecast.days.indexed) ...[
                  if (index > 0) const Divider(height: 1, color: HubColorPalette.separator),
                  DayRow(day: day, today: today, fontSize: 17),
                ],
              ],
            ),
          ),
          Text(
            'Weather data by Open-Meteo.com (CC BY 4.0)',
            style: HubTextStyles.label.copyWith(fontSize: 11, color: HubColorPalette.text3),
          ),
        ],
      ),
    );
  }
}
