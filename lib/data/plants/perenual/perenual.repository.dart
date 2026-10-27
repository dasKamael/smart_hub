import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/config/perenual_config.dart';
import 'package:smart_hub/common/http/http_client.provider.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/species_match.dart';

part 'perenual.repository.g.dart';

/// The Perenual plant database: species search, care data and care guides.
///
/// The free plan has care data only for species 1–3000; others are found but cannot be loaded (HTTP 429 "Please
/// Upgrade Plan") and come with a placeholder image. Some fields answer with an "Upgrade Plans …" text instead of a
/// value; those count as unknown. Example values in the docs are not always valid JSON, so numbers are read from
/// text.
class PerenualRepository {
  PerenualRepository({required this.config, required this.client});

  static final apiBase = Uri.parse('https://perenual.com/api/');
  static const freePlanMaxId = 3000;

  /// Perenual often takes 10–30 s to answer.
  static const timeout = Duration(seconds: 60);
  static const _months = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  final PerenualConfig config;
  final http.Client client;

  /// Species matching [query]; the ones with care data in the free plan first.
  Future<List<SpeciesMatch>> search(String query) async {
    final json = await _get('v2/species-list', {'q': query});
    final matches = [
      for (final item in _list(json['data']))
        if (item['id'] case final num id)
          SpeciesMatch(
            id: id.toInt(),
            commonName: _text(item['common_name']) ?? 'Unknown',
            scientificName: _first(item['scientific_name']),
            thumbnailUrl: _image(item['default_image'], 'thumbnail'),
            available: id <= freePlanMaxId,
          ),
    ];
    return [...matches.where((match) => match.available), ...matches.where((match) => !match.available)];
  }

  /// Care data and care guide texts of species [id].
  Future<PlantProfile> profile(int id) async {
    final (details, guides) = await (
      _get('v2/species/details/$id'),
      _get('species-care-guide-list', {
        'species_id': '$id',
      }).then<Map<String, Object?>?>((json) => json, onError: (_) => null),
    ).wait;
    final benchmark = details['watering_general_benchmark'] as Map<String, Object?>?;
    final days = [
      for (final match in RegExp(r'\d+').allMatches('${benchmark?['value'] ?? ''}')) int.parse(match.group(0)!),
    ];
    final isDays = '${benchmark?['unit'] ?? 'days'}'.toLowerCase().startsWith('day');
    final sections = {
      for (final guide in _list(guides?['data']))
        for (final section in _list(guide['section']))
          _text(section['type'])?.toLowerCase(): _text(section['description']),
    };
    final image = details['default_image'];
    return PlantProfile(
      speciesId: id,
      commonName: _text(details['common_name']) ?? 'Unknown',
      scientificName: _first(details['scientific_name']),
      imageUrl: _image(image, 'medium_url') ?? _image(image, 'regular_url') ?? _image(image, 'small_url'),
      watering: _text(details['watering']),
      wateringMinDays: isDays && days.isNotEmpty ? days.first : null,
      wateringMaxDays: isDays && days.length > 1 ? days.last : null,
      sunlight: _texts(details['sunlight']),
      careLevel: _text(details['care_level']),
      indoor: details['indoor'] is bool ? details['indoor'] as bool : null,
      poisonousToPets: switch (details['poisonous_to_pets']) {
        final bool value => value,
        final num value => value != 0,
        _ => null,
      },
      pruningMonths: _monthsOf(details['pruning_month']),
      wateringGuide: sections['watering'],
      sunlightGuide: sections['sunlight'],
      pruningGuide: sections['pruning'],
      fetchedAt: clock.now(),
    );
  }

  Future<Map<String, Object?>> _get(String path, [Map<String, String> query = const {}]) async {
    final url = apiBase.resolve(path).replace(queryParameters: {'key': config.apiKey, ...query});
    final response = await client.get(url).timeout(timeout);
    if (response.statusCode >= 300) throw http.ClientException('Perenual answered ${response.statusCode}', url);
    return jsonDecode(response.body) as Map<String, Object?>;
  }

  static List<Map<String, Object?>> _list(Object? json) {
    return (json is List ? json : const <Object?>[]).whereType<Map<String, Object?>>().toList();
  }

  /// A text value; empty texts and "Upgrade Plans …" placeholders of the free tier are unknown.
  static String? _text(Object? value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty || text.startsWith('Upgrade Plans') ? null : text;
  }

  /// An image URL; the "upgrade access" placeholder of the free plan counts as none.
  static String? _image(Object? image, String size) {
    final url = _text(image is Map<String, Object?> ? image[size] : null);
    return url == null || url.contains('upgrade_access') ? null : url;
  }

  /// Months come repeated and unordered; once each, in calendar order.
  static List<String> _monthsOf(Object? value) {
    final months = {for (final month in _texts(value)) month.toLowerCase()};
    return [
      for (final month in _months)
        if (months.contains(month)) '${month[0].toUpperCase()}${month.substring(1)}',
    ];
  }

  static List<String> _texts(Object? value) {
    return [for (final item in value is List ? value : const <Object?>[]) ?_text(item)];
  }

  static String? _first(Object? value) => _texts(value).firstOrNull ?? _text(value);
}

/// Providers
@Riverpod(keepAlive: true)
PerenualRepository perenualRepository(Ref ref) {
  return PerenualRepository(config: ref.watch(perenualConfigProvider), client: ref.watch(httpClientProvider));
}
