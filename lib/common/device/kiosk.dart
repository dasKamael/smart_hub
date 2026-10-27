import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'kiosk.g.dart';

/// Wall tablet behaviour: fullscreen, screen always on and optionally the hub as the home screen.
class Kiosk {
  Kiosk({MethodChannel? channel, Future<void> Function()? enableWakelock})
    : _channel = channel ?? const MethodChannel(channelName),
      _enableWakelock = enableWakelock ?? WakelockPlus.enable;

  static const channelName = 'smart_hub/kiosk';

  final MethodChannel _channel;
  final Future<void> Function() _enableWakelock;

  /// Hides status and navigation bar; a swipe from the edge shows them briefly.
  Future<void> enterFullscreen() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  Future<void> keepScreenOn() => _enableWakelock();

  Future<bool> isHomeApp() async => await _channel.invokeMethod<bool>('isHomeApp') ?? false;

  /// As home app the hub starts on boot and replaces the launcher. Enabling opens the system setting where the
  /// hub has to be chosen as default home app once.
  Future<void> setHomeApp({required bool enabled}) async {
    await _channel.invokeMethod<void>('setHomeApp', {'enabled': enabled});
    if (enabled) await _channel.invokeMethod<void>('openHomeSettings');
  }
}

@Riverpod(keepAlive: true)
Kiosk kiosk(Ref ref) => Kiosk();
