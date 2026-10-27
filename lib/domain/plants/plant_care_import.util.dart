import 'dart:convert';

import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/model/plant_profile_source.enum.dart';

/// One plant of an import: the plant name it belongs to and its care data.
typedef PlantCareEntry = ({String name, PlantProfile profile});

/// Care data made outside the hub, e.g. by a chat assistant, imported as JSON. [prompt] asks for exactly the
/// format [parse] reads.
abstract final class PlantCareImportUtil {
  static const format = 'smart-hub-plant-care';
  static const version = 1;
  static const _maxDays = 90;

  /// The prompt for a chat assistant, with the hub's plant [names] filled in.
  static String prompt(List<String> names) {
    final plants = names.isEmpty ? '- <your plant names, one per line>' : names.map((name) => '- $name').join('\n');
    return '''
You are a houseplant expert. Give care data for each plant below, kept indoors in Central Europe (heated flat,
about 20 °C, window light). Answer with JSON only – no comments, no text around it – exactly in this format:

{
  "format": "$format",
  "version": $version,
  "plants": [
    {
      "name": "<the name exactly as in my list>",
      "commonName": "<common English name>",
      "scientificName": "<botanical name>",
      "wateringSummerDays": [<min>, <max>],
      "wateringWinterDays": [<min>, <max>],
      "wateringGuide": "<2–3 sentences: when and how to water>",
      "fertilizeEveryWeeks": <weeks between feeding from March to September, or null if it needs none>,
      "light": ["<e.g. bright indirect light>"],
      "lightGuide": "<1–2 sentences>",
      "careLevel": "<Low, Medium or High>",
      "indoor": <true or false>,
      "toxicToPets": <true or false>,
      "pruningMonths": ["<month names in English>"],
      "pruningGuide": "<1–2 sentences, or null>"
    }
  ]
}

Watering days are whole days between two waterings for a typical pot; winter means October to February.
Use straight double quotes (") in the JSON, not typographic ones.

My plants:
$plants
''';
  }

  /// Reads an import. Text around the JSON (e.g. a Markdown code block) is ignored; entries without a name or a
  /// watering range are skipped and named in `problems`.
  static ({List<PlantCareEntry> plants, List<String> problems}) parse(String text, {required DateTime now}) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) return (plants: const [], problems: const ['No JSON found']);
    final Object? json;
    try {
      json = _decode(text.substring(start, end + 1));
    } on FormatException catch (e) {
      return (plants: const [], problems: ['The JSON is not valid: ${e.message}']);
    }
    final items = switch (json) {
      {'plants': final List<Object?> plants} => plants,
      _ => null,
    };
    if (items == null) return (plants: const [], problems: const ['No "plants" list found']);

    final plants = <PlantCareEntry>[];
    final problems = <String>[];
    for (final (index, item) in items.indexed) {
      if (item is! Map<String, Object?>) {
        problems.add('Entry ${index + 1} is not an object');
        continue;
      }
      final name = _text(item['name']);
      final summer = _range(item['wateringSummerDays']);
      if (name == null || summer == null) {
        problems.add('${name ?? 'Entry ${index + 1}'}: needs a name and watering days');
        continue;
      }
      final winter = _range(item['wateringWinterDays']);
      plants.add((
        name: name,
        profile: PlantProfile(
          source: PlantProfileSource.imported,
          commonName: _text(item['commonName']) ?? name,
          scientificName: _text(item['scientificName']),
          wateringMinDays: summer.$1,
          wateringMaxDays: summer.$2,
          wateringWinterMinDays: winter?.$1,
          wateringWinterMaxDays: winter?.$2,
          fertilizeEveryWeeks: switch (item['fertilizeEveryWeeks']) {
            final num weeks when weeks >= 1 => weeks.round().clamp(1, 52),
            _ => null,
          },
          sunlight: _texts(item['light']),
          careLevel: _text(item['careLevel']),
          indoor: item['indoor'] is bool ? item['indoor'] as bool : null,
          poisonousToPets: item['toxicToPets'] is bool ? item['toxicToPets'] as bool : null,
          pruningMonths: _texts(item['pruningMonths']),
          wateringGuide: _text(item['wateringGuide']),
          sunlightGuide: _text(item['lightGuide']),
          pruningGuide: _text(item['pruningGuide']),
          fetchedAt: now,
        ),
      ));
    }
    return (plants: plants, problems: problems);
  }

  /// Some apps turn the quotes of a copied answer into typographic ones (“…”), which JSON does not accept. Those are
  /// straightened when the text cannot be read as it is; apostrophes (’) stay, they are fine inside strings.
  static Object? _decode(String json) {
    try {
      return jsonDecode(json);
    } on FormatException {
      return jsonDecode(json.replaceAll(RegExp('[“”„‟″]'), '"'));
    }
  }

  /// `[min, max]` (or a single number) of whole days, both within 1–90.
  static (int, int)? _range(Object? value) {
    final numbers = switch (value) {
      final num days => [days],
      final List<Object?> list => list.whereType<num>().toList(),
      _ => const <num>[],
    };
    if (numbers.isEmpty) return null;
    final days = [for (final number in numbers) number.round().clamp(1, _maxDays)]..sort();
    return (days.first, days.last);
  }

  static String? _text(Object? value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  static List<String> _texts(Object? value) => [
    for (final item in value is List ? value : const <Object?>[]) ?_text(item),
  ];
}
