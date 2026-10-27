import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/database/secure_storage.provider.dart';
import 'package:smart_hub/data/music/sonos/sonos_soap.dart';

part 'sonos_config.repository.g.dart';

/// Which Sonos speakers the hub talks to directly, and finding them in the home network.
class SonosConfigRepository {
  SonosConfigRepository({required this.storage, required this.client});

  static const _storageKey = 'sonos_hosts';

  final FlutterSecureStorage storage;
  final http.Client client;

  Future<List<String>> load() async {
    final json = await storage.read(key: _storageKey);
    if (json == null) return const [];
    return (jsonDecode(json) as List<Object?>).whereType<String>().toList();
  }

  Future<void> save(List<String> hosts) => storage.write(key: _storageKey, value: jsonEncode(hosts));

  /// Addresses of the Sonos speakers that answer in the home network (SSDP); empty when multicast does not get
  /// through, e.g. in an emulator.
  Future<List<String>> discover({Duration wait = const Duration(seconds: 3)}) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    final found = <String>{};
    final subscription = socket.listen((event) {
      if (event != RawSocketEvent.read) return;
      final datagram = socket.receive();
      if (datagram == null) return;
      if (utf8.decode(datagram.data, allowMalformed: true).contains('Sonos')) found.add(datagram.address.address);
    });
    const search =
        'M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: "ssdp:discover"\r\nMX: 2\r\n'
        'ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n\r\n';
    for (var i = 0; i < 3; i++) {
      socket.send(utf8.encode(search), InternetAddress('239.255.255.250'), 1900);
    }
    await Future<void>.delayed(wait);
    await subscription.cancel();
    socket.close();
    return found.toList()..sort();
  }

  /// All speakers of the system [host] belongs to, by address; empty when [host] is no Sonos speaker.
  Future<List<String>> systemOf(String host) async {
    try {
      final reply = await SonosSoap(host: host, client: client).zoneGroupTopology('GetZoneGroupState');
      final state = SonosSoap.value(reply, 'ZoneGroupState') ?? '';
      return {for (final match in RegExp(r'Location="http://([\d.]+):1400').allMatches(state)) match.group(1)!}.toList()
        ..sort();
    } on Object {
      return const [];
    }
  }
}

/// Providers
@Riverpod(keepAlive: true)
http.Client sonosHttpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
SonosConfigRepository sonosConfigRepository(Ref ref) {
  return SonosConfigRepository(storage: ref.watch(secureStorageProvider), client: ref.watch(sonosHttpClientProvider));
}

/// The addresses of the speakers the hub talks to directly; empty when the speakers come from Home Assistant.
@Riverpod(keepAlive: true)
class SonosHosts extends _$SonosHosts {
  @override
  Future<List<String>> build() => ref.watch(sonosConfigRepositoryProvider).load();

  Future<void> set(List<String> hosts) async {
    await ref.read(sonosConfigRepositoryProvider).save(hosts);
    state = AsyncData(hosts);
  }
}
