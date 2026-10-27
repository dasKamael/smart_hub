import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'perenual_config.g.dart';

/// Perenual plant database key (perenual.com, free tier), passed in with `--dart-define-from-file=env/dev.json`.
class PerenualConfig {
  const PerenualConfig({required this.apiKey});

  static const fromEnvironment = PerenualConfig(apiKey: String.fromEnvironment('PERENUAL_API_KEY'));

  final String apiKey;

  bool get isConfigured => apiKey.isNotEmpty;
}

@Riverpod(keepAlive: true)
PerenualConfig perenualConfig(Ref ref) => PerenualConfig.fromEnvironment;
