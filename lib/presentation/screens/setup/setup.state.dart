import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup.state.freezed.dart';

enum SetupError { invalidAddress, missingToken, authFailed, unreachable }

@freezed
abstract class SetupState with _$SetupState {
  const factory SetupState({
    @Default('') String address,
    @Default('') String token,
    @Default(false) bool isConnecting,

    /// The running connection attempt is the demo, so its button shows the progress.
    @Default(false) bool isStartingDemo,
    SetupError? error,
  }) = _SetupState;
}
