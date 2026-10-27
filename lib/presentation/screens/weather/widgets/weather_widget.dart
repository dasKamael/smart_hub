import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_page.enum.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_icon.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_parts.dart';

/// The weather as a dashboard widget in any [WidgetSize] (`Widget Kit` → Weather). A tap opens the weather page.
class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key, required this.size});

  final WidgetSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(weatherServiceProvider);
    return WidgetTile(
      size: size,
      onTap: () => context.push(HubPage.weather.path),
      // An error stays visible while a retry is loading.
      child: switch ((forecast.value, forecast.error)) {
        (final forecast?, _) => switch (size) {
          WidgetSize.small => _Small(forecast),
          WidgetSize.medium => _Medium(forecast),
          WidgetSize.large => _Large(forecast),
          WidgetSize.extraLarge => _ExtraLarge(forecast),
        },
        (null, final error?) => _Problem(needsPlace: error is WeatherLocationUnavailableException, size: size),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

/// Symbol and the current temperature.
class _Now extends StatelessWidget {
  const _Now(this.forecast, {required this.temperatureSize, required this.iconSize});

  final Forecast forecast;
  final double temperatureSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: iconSize * 0.4,
      children: [
        WeatherIcon(forecast.now.condition, isDay: forecast.now.isDay, size: iconSize),
        Text(
          WeatherFormat.degrees(forecast.now.temperature),
          style: HubTextStyles.display.copyWith(fontSize: temperatureSize, height: 1, letterSpacing: -1.5).tabular,
        ),
      ],
    );
  }
}

class _Place extends StatelessWidget {
  const _Place(this.forecast);

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    return Text(
      forecast.place.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: HubTextStyles.label.copyWith(fontSize: 15, color: HubColorPalette.text2),
    );
  }
}

String _todayRange(Forecast forecast) => switch (forecast.days.firstOrNull) {
  final today? => '${WeatherFormat.degrees(today.maxTemperature)} / ${WeatherFormat.degrees(today.minTemperature)}',
  null => '',
};

class _Small extends StatelessWidget {
  const _Small(this.forecast);

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final rain = forecast.days.firstOrNull?.precipitationProbability ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherIcon(forecast.now.condition, isDay: forecast.now.isDay, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Align(alignment: Alignment.topRight, child: _Place(forecast)),
            ),
          ],
        ),
        const Spacer(),
        Text(
          WeatherFormat.degrees(forecast.now.temperature),
          style: HubTextStyles.display.copyWith(fontSize: 36, height: 1).tabular,
        ),
        Text(
          WeatherFormat.condition(forecast.now.condition),
          style: HubTextStyles.body.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          '${_todayRange(forecast)} · Rain $rain%',
          style: HubTextStyles.label.copyWith(fontSize: 12, color: HubColorPalette.text2),
        ),
      ],
    );
  }
}

class _Medium extends StatelessWidget {
  const _Medium(this.forecast);

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherIcon(forecast.now.condition, isDay: forecast.now.isDay, size: 30),
            const Spacer(),
            Text(
              WeatherFormat.degrees(forecast.now.temperature),
              style: HubTextStyles.display.copyWith(fontSize: 42, height: 1).tabular,
            ),
            Text(_todayRange(forecast), style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
          ],
        ),
        Expanded(child: HourBars(hours: forecast.hours.take(5).toList(), showIcons: false)),
      ],
    );
  }
}

class _Large extends StatelessWidget {
  const _Large(this.forecast);

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final today = clock.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_Now(forecast, temperatureSize: 46, iconSize: 34), const Spacer(), _Place(forecast)],
        ),
        const SizedBox(height: 6),
        Text(
          '${WeatherFormat.condition(forecast.now.condition)} · ${_todayRange(forecast)}',
          style: HubTextStyles.secondary,
        ),
        const SizedBox(height: 12),
        SizedBox(height: 68, child: HourBars(hours: forecast.hours.take(6).toList(), showIcons: false)),
        const Spacer(),
        for (final (index, day) in forecast.days.take(3).indexed) ...[
          if (index > 0) const Divider(height: 12, color: HubColorPalette.separator),
          DayRow(day: day, today: today, fontSize: 15),
        ],
      ],
    );
  }
}

class _ExtraLarge extends StatelessWidget {
  const _ExtraLarge(this.forecast);

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final today = clock.now();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_Now(forecast, temperatureSize: 60, iconSize: 42), const Spacer(), _Place(forecast)],
              ),
              const SizedBox(height: 8),
              Text(
                '${WeatherFormat.condition(forecast.now.condition)} · '
                'Feels ${WeatherFormat.degrees(forecast.now.apparentTemperature)}',
                style: HubTextStyles.secondary,
              ),
              const SizedBox(height: 16),
              Expanded(child: HourBars(hours: forecast.hours.take(8).toList())),
            ],
          ),
        ),
        const VerticalDivider(width: 40, color: HubColorPalette.separator),
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final (index, day) in forecast.days.take(5).indexed) ...[
                if (index > 0) const Divider(height: 1, color: HubColorPalette.separator),
                DayRow(day: day, today: today),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// No forecast: the place is unknown, or the weather service cannot be reached.
class _Problem extends StatelessWidget {
  const _Problem({required this.needsPlace, required this.size});

  final bool needsPlace;
  final WidgetSize size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          const WeatherIcon(WeatherCondition.partlyCloudy, size: 36),
          Text(
            needsPlace ? 'Where is the hub?' : 'Weather not available',
            textAlign: TextAlign.center,
            style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          if (needsPlace && size != WidgetSize.small)
            HubButton(
              label: 'Choose a place',
              variant: HubButtonVariant.secondary,
              height: 38,
              onPressed: () => context.push(HubPage.settings.path),
            ),
        ],
      ),
    );
  }
}
