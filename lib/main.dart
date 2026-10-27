import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:smart_hub/common/device/kiosk.dart';
import 'package:smart_hub/common/logging/logging.setup.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/presentation/hub_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();

  final container = ProviderContainer();
  final kiosk = container.read(kioskProvider);
  try {
    await kiosk.enterFullscreen();
    await kiosk.keepScreenOn();
  } on Object catch (e) {
    Logger('main').warning('Kiosk mode not available: $e');
  }
  try {
    // Load the saved connection before the first frame, so the router knows whether to show the setup.
    await container.read(connectionConfigServiceProvider.future);
  } on Object catch (e, stackTrace) {
    Logger('main').severe('Loading the connection config failed', e, stackTrace);
  }

  runApp(UncontrolledProviderScope(container: container, child: const HubApp()));
}
