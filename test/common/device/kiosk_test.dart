import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/common/device/kiosk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Kiosk', () {
    const channel = MethodChannel(Kiosk.channelName);
    late List<MethodCall> calls;
    var homeAppEnabled = false;

    setUp(() {
      calls = [];
      homeAppEnabled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return switch (call.method) {
          'isHomeApp' => homeAppEnabled,
          _ => null,
        };
      });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null),
      );
    });

    test('Given the alias is enabled, when asking, then the hub is the home app', () async {
      homeAppEnabled = true;

      expect(await Kiosk().isHomeApp(), isTrue);
    });

    test('Given the hub, when enabling it as home app, then the alias is enabled and the home setting opens', () async {
      await Kiosk().setHomeApp(enabled: true);

      expect(calls.map((c) => '${c.method} ${c.arguments ?? ''}'), ['setHomeApp {enabled: true}', 'openHomeSettings ']);
    });

    test('Given the hub is the home app, when disabling it, then only the alias is disabled', () async {
      await Kiosk().setHomeApp(enabled: false);

      expect(calls.map((c) => c.method), ['setHomeApp']);
    });

    test('Given the kiosk, when keeping the screen on, then the wakelock is enabled', () async {
      var enabled = false;

      await Kiosk(enableWakelock: () async => enabled = true).keepScreenOn();

      expect(enabled, isTrue);
    });

    test('Given the kiosk, when entering fullscreen, then the system UI is set to immersive sticky', () async {
      final systemCalls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => systemCalls.add(call),
      );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await Kiosk().enterFullscreen();

      expect(systemCalls.single.method, 'SystemChrome.setEnabledSystemUIMode');
      expect(systemCalls.single.arguments, 'SystemUiMode.immersiveSticky');
    });
  });
}
