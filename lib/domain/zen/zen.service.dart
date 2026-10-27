import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/zen/zen_settings.repository.dart';

part 'zen.service.g.dart';

/// Minutes without a touch until the zen mode starts; 0 = only by hand.
@Riverpod(keepAlive: true)
class ZenIdleService extends _$ZenIdleService {
  static const choices = [0, 1, 2, 5, 10, 30];
  static const defaultMinutes = 5;

  @override
  Stream<int> build() => ref.watch(zenSettingsRepositoryProvider).watchIdleMinutes();

  Future<void> set(int minutes) => ref.read(zenSettingsRepositoryProvider).setIdleMinutes(minutes);
}
