import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/common/logging/logging.setup.dart';
import 'package:smart_hub/presentation/hub_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  runApp(const ProviderScope(child: HubApp()));
}
