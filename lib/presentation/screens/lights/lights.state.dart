import 'package:freezed_annotation/freezed_annotation.dart';

part 'lights.state.freezed.dart';

@freezed
abstract class LightsPageState with _$LightsPageState {
  const factory LightsPageState({String? selectedRoomId}) = _LightsPageState;
}
