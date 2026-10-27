import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/apps/installed_apps.repository.dart';

import '../../mocks/apps.mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InstalledAppsRepository', () {
    final calls = <MethodCall>[];

    setUp(() {
      calls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel(InstalledAppsRepository.channelName),
        (call) async {
          calls.add(call);
          return switch (call.method) {
            'installedApps' => [
              {'package': 'com.example.mail', 'label': 'mail', 'isVideo': false, 'icon': testIcon},
              {'package': 'com.netflix.mediaclient', 'label': 'Netflix', 'isVideo': false, 'icon': testIcon},
              {'package': 'com.example.films', 'label': 'Films', 'isVideo': true, 'icon': testIcon},
              {'package': 'com.example.broken', 'label': 'Broken'},
            ],
            'launch' => true,
            _ => null,
          };
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel(InstalledAppsRepository.channelName),
        null,
      );
    });

    test('Given apps reported by Android, '
        'when loading, '
        'then they are sorted by name, known streaming apps count as video and incomplete ones are left out', () async {
      // When
      final apps = await InstalledAppsRepository().load();

      // Then
      expect(apps.map((app) => '${app.label} ${app.isVideo}'), ['Films true', 'mail false', 'Netflix true']);
    });

    test('Given an app, when launching it, then Android is asked to open its package', () async {
      // When
      final launched = await InstalledAppsRepository().launch('com.example.films');

      // Then
      expect(launched, isTrue);
      expect(calls.single.arguments, {'package': 'com.example.films'});
    });
  });
}
