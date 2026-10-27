import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/music/sonos/sonos_config.repository.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';

part 'network_speakers.service.g.dart';

/// Speakers the hub talks to directly in the home network instead of through Home Assistant, by address. Empty
/// when the speakers come from Home Assistant.
@Riverpod(keepAlive: true)
class NetworkSpeakersService extends _$NetworkSpeakersService {
  @override
  Future<List<String>> build() => ref.watch(sonosHostsProvider.future);

  /// Speaker addresses found in the home network; empty when the search does not get through (e.g. an emulator).
  Future<List<String>> discover() => ref.read(sonosConfigRepositoryProvider).discover();

  /// Adds the speaker at [host] and every speaker of its system; `false` when no speaker answers there.
  Future<bool> add(String host) async {
    final system = await ref.read(sonosConfigRepositoryProvider).systemOf(host.trim());
    if (system.isEmpty) return false;
    await ref.read(sonosHostsProvider.notifier).set({...await future, ...system}.toList()..sort());
    return true;
  }

  /// Forgets the speakers; they come from Home Assistant again.
  Future<void> removeAll() => ref.read(sonosHostsProvider.notifier).set(const []);
}

/// Whether the speakers can be controlled right now: the network speakers answer, or Home Assistant is online.
@riverpod
bool speakersOnline(Ref ref) {
  if (ref.watch(networkSpeakersServiceProvider).value?.isEmpty ?? true) {
    return ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false;
  }
  return ref.watch(_networkSpeakersOnlineProvider).value ?? false;
}

@riverpod
Stream<bool> _networkSpeakersOnline(Ref ref) => ref.watch(speakerRepositoryProvider).watchOnline();
