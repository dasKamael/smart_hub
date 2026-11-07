import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/config/env.dart';

part 'perenual_config.g.dart';

/// Perenual plant database key (perenual.com, free tier), from `.env` ([Env]).
class PerenualConfig {
  const PerenualConfig({required this.apiKey});

  static final fromEnvironment = PerenualConfig(apiKey: Env.perenualApiKey);

  final String apiKey;

  bool get isConfigured => apiKey.isNotEmpty;
}

@Riverpod(keepAlive: true)
PerenualConfig perenualConfig(Ref ref) => PerenualConfig.fromEnvironment;
