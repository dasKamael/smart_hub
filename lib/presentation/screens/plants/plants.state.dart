import 'package:freezed_annotation/freezed_annotation.dart';

part 'plants.state.freezed.dart';

@freezed
abstract class PlantsPageState with _$PlantsPageState {
  const factory PlantsPageState({
    /// 0 is today, 1–6 the following days, `allPlantsDay` shows every plant.
    @Default(0) int selectedDay,

    /// The card whose options (water, edit) are shown.
    String? openPlantId,
  }) = _PlantsPageState;
}
