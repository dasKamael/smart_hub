import 'dart:convert';

import 'package:http/http.dart' as http;

/// UPnP calls to one Sonos speaker in the home network (port 1400) – the same local interface the speakers' own
/// apps use. Replies are XML; values are read with small patterns instead of a full parser.
class SonosSoap {
  SonosSoap({required this.host, required this.client});

  static const _timeout = Duration(seconds: 4);

  final String host;
  final http.Client client;

  Uri get base => Uri.http('$host:1400');

  /// Calls [action] of [service] at [path]; returns the reply body.
  Future<String> call(String path, String service, String action, [Map<String, String> arguments = const {}]) async {
    final type = 'urn:schemas-upnp-org:service:$service:1';
    final body =
        '<?xml version="1.0"?>'
        '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" '
        's:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body>'
        '<u:$action xmlns:u="$type">'
        '${arguments.entries.map((entry) => '<${entry.key}>${escape(entry.value)}</${entry.key}>').join()}'
        '</u:$action></s:Body></s:Envelope>';
    final response = await client
        .post(
          base.replace(path: path),
          headers: {'Content-Type': 'text/xml; charset="utf-8"', 'SOAPACTION': '"$type#$action"'},
          body: utf8.encode(body),
        )
        .timeout(_timeout);
    if (response.statusCode != 200) throw SonosException('$action failed at $host: ${response.statusCode}');
    return utf8.decode(response.bodyBytes);
  }

  Future<String> avTransport(String action, [Map<String, String> arguments = const {}]) =>
      call('/MediaRenderer/AVTransport/Control', 'AVTransport', action, {'InstanceID': '0', ...arguments});

  Future<String> renderingControl(String action, [Map<String, String> arguments = const {}]) => call(
    '/MediaRenderer/RenderingControl/Control',
    'RenderingControl',
    action,
    {'InstanceID': '0', 'Channel': 'Master', ...arguments},
  );

  Future<String> zoneGroupTopology(String action) => call('/ZoneGroupTopology/Control', 'ZoneGroupTopology', action);

  Future<String> contentDirectory(String action, Map<String, String> arguments) =>
      call('/MediaServer/ContentDirectory/Control', 'ContentDirectory', action, arguments);

  /// The text of the first [tag] in [xml], unescaped; `null` when there is none.
  static String? value(String xml, String tag) {
    final match = RegExp('<$tag(?: [^>]*)?>(.*?)</$tag>', dotAll: true).firstMatch(xml);
    return match == null ? null : unescape(match.group(1)!);
  }

  static String escape(String text) =>
      text.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');

  static String unescape(String text) => text
      .replaceAllMapped(
        RegExp(r'&#(x?)([0-9a-fA-F]+);'),
        (match) => String.fromCharCode(int.parse(match.group(2)!, radix: match.group(1)!.isEmpty ? 10 : 16)),
      )
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&amp;', '&');

  /// Seconds of `H:MM:SS`; `null` for missing or not-implemented values.
  static int? seconds(String? time) {
    final parts = time?.split(':').map(int.tryParse).toList();
    if (parts == null || parts.length != 3 || parts.contains(null)) return null;
    return parts[0]! * 3600 + parts[1]! * 60 + parts[2]!;
  }
}

class SonosException implements Exception {
  const SonosException(this.message);

  final String message;

  @override
  String toString() => message;
}
