import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection_url.util.dart';

void main() {
  group('ConnectionUrlUtil.normalizeBaseUrl', () {
    final cases = {
      'homeassistant.local': 'http://homeassistant.local:8123',
      '  homeassistant.local  ': 'http://homeassistant.local:8123',
      '192.168.1.20:8123': 'http://192.168.1.20:8123',
      'http://ha:8123/': 'http://ha:8123',
      'http://ha:8123/lovelace/0': 'http://ha:8123',
      'https://home.example.com': 'https://home.example.com',
      'ws://ha:8123/api/websocket': 'http://ha:8123',
      'wss://home.example.com/api/websocket': 'https://home.example.com',
      'https://home.example.com:8443': 'https://home.example.com:8443',
    };
    for (final MapEntry(key: input, value: expected) in cases.entries) {
      test('Given "$input", when normalizing, then the base URL is $expected', () {
        expect(ConnectionUrlUtil.normalizeBaseUrl(input).toString(), expected);
      });
    }

    for (final input in ['', '   ', 'ftp://ha', 'http://', '://nohost']) {
      test('Given "$input", when normalizing, then it is rejected', () {
        expect(ConnectionUrlUtil.normalizeBaseUrl(input), isNull);
      });
    }
  });
}
