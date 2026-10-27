import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/connection/connection_settings.repository.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connect_result.enum.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockConnectionSettingsRepository extends Mock implements ConnectionSettingsRepository {}

/// [ConnectionConfigService] without storage or network: starts with [initial] and answers [connect] with [result].
class FakeConnectionConfigService extends ConnectionConfigService {
  FakeConnectionConfigService({this.initial, this.result = ConnectResult.connected});

  final ConnectionConfig? initial;
  ConnectResult result;
  final connectCalls = <ConnectionConfig>[];
  var clearCalls = 0;

  @override
  Future<ConnectionConfig?> build() async => initial;

  @override
  Future<ConnectResult> connect(ConnectionConfig config) async {
    connectCalls.add(config);
    if (result == ConnectResult.connected) state = AsyncData(config);
    return result;
  }

  @override
  Future<void> clear() async {
    clearCalls++;
    state = const AsyncData(null);
  }
}
