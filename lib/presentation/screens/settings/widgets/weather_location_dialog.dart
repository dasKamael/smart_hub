import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/weather/model/weather_location.dart';
import 'package:smart_hub/domain/weather/model/weather_place.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/molecules/hub_text_field.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Picks where the weather is for: where the hub is, or a searched place.
Future<WeatherLocation?> showWeatherLocationDialog(BuildContext context) {
  return showDialog<WeatherLocation>(
    context: context,
    barrierColor: const Color(0xB3000000),
    builder: (context) => const _WeatherLocationDialog(),
  );
}

class _WeatherLocationDialog extends ConsumerStatefulWidget {
  const _WeatherLocationDialog();

  @override
  ConsumerState<_WeatherLocationDialog> createState() => _WeatherLocationDialogState();
}

class _WeatherLocationDialogState extends ConsumerState<_WeatherLocationDialog> {
  var _query = '';
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(placeSearchProvider(_query));
    return Dialog(
      backgroundColor: HubColorPalette.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HubRadius.pageCard)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s12,
            children: [
              const Text('Weather for', style: HubTextStyles.pageTitle),
              _Choice(
                glyph: HubGlyph.pottedPlant,
                title: 'Where the hub is',
                subtitle: 'Uses the tablet\'s location',
                onTap: () => Navigator.of(context).pop(const WeatherLocation.device()),
              ),
              HubTextField(
                label: 'Or a place',
                hint: 'e.g. Mainz',
                onChanged: (value) {
                  _timer?.cancel();
                  _timer = Timer(const Duration(milliseconds: 400), () => setState(() => _query = value));
                },
              ),
              ...switch (results) {
                AsyncData(value: final places) => [
                  for (final place in places)
                    _Choice(
                      glyph: HubGlyph.sun,
                      title: place.name,
                      subtitle: place.region ?? '',
                      onTap: () => Navigator.of(context).pop(WeatherLocation.place(place)),
                    ),
                  if (places.isEmpty && _query.trim().length >= 2)
                    Text('No place found', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
                ],
                AsyncError() => [
                  Text(
                    'The place search is not reachable',
                    style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText),
                  ),
                ],
                _ => const <Widget>[],
              },
              Align(
                alignment: Alignment.centerRight,
                child: HubButton(
                  label: 'Cancel',
                  variant: HubButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.glyph, required this.title, required this.subtitle, required this.onTap});

  final HubGlyph glyph;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(14)),
          child: Row(
            spacing: 12,
            children: [
              HubGlyphIcon(glyph, color: HubColorPalette.text2, size: const Size(16, 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: HubTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
                    if (subtitle.isNotEmpty)
                      Text(subtitle, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
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

/// Name of a chosen place with its region, for the settings.
String describePlace(WeatherPlace place) => [place.name, ?place.region].join(', ');
