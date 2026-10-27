import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/connection_url.util.dart';
import 'package:smart_hub/domain/connection/model/connect_result.enum.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';
import 'package:smart_hub/presentation/screens/setup/demo_layout.dart';
import 'package:smart_hub/presentation/screens/setup/setup.state.dart';

part 'setup.controller.g.dart';

@riverpod
class SetupController extends _$SetupController {
  @override
  SetupState build() => const SetupState();

  void updateAddress(String address) => state = state.copyWith(address: address, error: null);

  void updateToken(String token) => state = state.copyWith(token: token, error: null);

  Future<void> connect() async {
    final baseUrl = ConnectionUrlUtil.normalizeBaseUrl(state.address);
    final token = state.token.trim();
    if (baseUrl == null) {
      state = state.copyWith(error: SetupError.invalidAddress);
      return;
    }
    if (token.isEmpty) {
      state = state.copyWith(error: SetupError.missingToken);
      return;
    }
    await _connect(ConnectionConfig.homeAssistant(baseUrl: baseUrl, token: token));
  }

  /// Fills the demo home first: once connected, the router leaves the setup and this controller is disposed.
  Future<void> startDemo() async {
    if (state.isConnecting) return;
    state = state.copyWith(isConnecting: true, isStartingDemo: true, error: null);
    await ref.read(plantsServiceProvider.notifier).addAllIfEmpty(demoPlants(clock.now()));
    await ref.read(placementServiceProvider.notifier).placeAllIfEmpty(demoLayout);
    if (!ref.mounted) return;
    state = state.copyWith(isConnecting: false);
    await _connect(const ConnectionConfig.demo(), isDemo: true);
  }

  /// Plants, the floor plan and Spotify work without Home Assistant; it can be connected later in the settings.
  Future<void> startWithoutHomeAssistant() => _connect(const ConnectionConfig.standalone());

  Future<void> _connect(ConnectionConfig config, {bool isDemo = false}) async {
    if (state.isConnecting) return;
    state = state.copyWith(isConnecting: true, isStartingDemo: isDemo, error: null);
    final result = await ref.read(connectionConfigServiceProvider.notifier).connect(config);
    if (!ref.mounted) return;
    state = state.copyWith(
      isConnecting: false,
      isStartingDemo: false,
      error: switch (result) {
        ConnectResult.connected => null,
        ConnectResult.authFailed => SetupError.authFailed,
        ConnectResult.unreachable => SetupError.unreachable,
      },
    );
  }
}
