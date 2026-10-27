import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/http/http_client.provider.dart';

part 'place_name.repository.g.dart';

/// The name of the town at a position, from OpenStreetMap's Nominatim (open source). Its usage policy asks for an
/// identifying user agent and few requests – the hub asks once per position and keeps the answer.
class PlaceNameRepository {
  PlaceNameRepository({required this.client});

  static final api = Uri.parse('https://nominatim.openstreetmap.org/reverse');
  static const userAgent = 'SmartHub/1.0 (home wall tablet)';

  final http.Client client;

  Future<String?> nameAt(double latitude, double longitude) async {
    final url = api.replace(
      queryParameters: {
        'format': 'jsonv2',
        'lat': '$latitude',
        'lon': '$longitude',
        'zoom': '10',
        'accept-language': 'en',
      },
    );
    final response = await client.get(url, headers: {'User-Agent': userAgent}).timeout(const Duration(seconds: 15));
    if (response.statusCode >= 300) return null;
    final json = jsonDecode(response.body) as Map<String, Object?>;
    final address = json['address'] as Map<String, Object?>? ?? const {};
    for (final key in ['city', 'town', 'village', 'municipality', 'county']) {
      if (address[key] case final String name when name.isNotEmpty) return name;
    }
    return json['name'] as String?;
  }
}

/// Providers
@Riverpod(keepAlive: true)
PlaceNameRepository placeNameRepository(Ref ref) => PlaceNameRepository(client: ref.watch(httpClientProvider));
