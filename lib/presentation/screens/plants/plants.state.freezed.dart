// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plants.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantsPageState {

/// 0 is today, 1–6 the following days, `allPlantsDay` shows every plant.
 int get selectedDay;/// The card whose options (water, edit) are shown.
 String? get openPlantId;
/// Create a copy of PlantsPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantsPageStateCopyWith<PlantsPageState> get copyWith => _$PlantsPageStateCopyWithImpl<PlantsPageState>(this as PlantsPageState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlantsPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantsPageState&&(identical(other.selectedDay, _this.selectedDay) || other.selectedDay == _this.selectedDay)&&(identical(other.openPlantId, _this.openPlantId) || other.openPlantId == _this.openPlantId));
}


@override
int get hashCode {
  final _this = this as PlantsPageState;
  return Object.hash(runtimeType,_this.selectedDay,_this.openPlantId);
}

@override
String toString() {
  final _this = this as PlantsPageState;
  return 'PlantsPageState(selectedDay: ${_this.selectedDay}, openPlantId: ${_this.openPlantId})';
}


}

/// @nodoc
abstract mixin class $PlantsPageStateCopyWith<$Res>  {
  factory $PlantsPageStateCopyWith(PlantsPageState value, $Res Function(PlantsPageState) _then) = _$PlantsPageStateCopyWithImpl;
@useResult
$Res call({
 int selectedDay, String? openPlantId
});




}
/// @nodoc
class _$PlantsPageStateCopyWithImpl<$Res>
    implements $PlantsPageStateCopyWith<$Res> {
  _$PlantsPageStateCopyWithImpl(this._self, this._then);

  final PlantsPageState _self;
  final $Res Function(PlantsPageState) _then;

/// Create a copy of PlantsPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedDay = null,Object? openPlantId = freezed,}) {
  return _then(PlantsPageState(
selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as int,openPlantId: freezed == openPlantId ? _self.openPlantId : openPlantId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantsPageState].
extension PlantsPageStatePatterns on PlantsPageState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantsPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantsPageState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantsPageState value)  $default,){
final _that = this;
switch (_that) {
case _PlantsPageState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantsPageState value)?  $default,){
final _that = this;
switch (_that) {
case _PlantsPageState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int selectedDay,  String? openPlantId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantsPageState() when $default != null:
return $default(_that.selectedDay,_that.openPlantId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int selectedDay,  String? openPlantId)  $default,) {final _that = this;
switch (_that) {
case _PlantsPageState():
return $default(_that.selectedDay,_that.openPlantId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int selectedDay,  String? openPlantId)?  $default,) {final _that = this;
switch (_that) {
case _PlantsPageState() when $default != null:
return $default(_that.selectedDay,_that.openPlantId);case _:
  return null;

}
}

}

/// @nodoc


class _PlantsPageState implements PlantsPageState {
  const _PlantsPageState({this.selectedDay = 0, this.openPlantId});
  

/// 0 is today, 1–6 the following days, `allPlantsDay` shows every plant.
@override@JsonKey() final  int selectedDay;
/// The card whose options (water, edit) are shown.
@override final  String? openPlantId;

/// Create a copy of PlantsPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantsPageStateCopyWith<_PlantsPageState> get copyWith => __$PlantsPageStateCopyWithImpl<_PlantsPageState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantsPageState&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&(identical(other.openPlantId, openPlantId) || other.openPlantId == openPlantId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,selectedDay,openPlantId);
}

@override
String toString() {
    return 'PlantsPageState(selectedDay: $selectedDay, openPlantId: $openPlantId)';
}


}

/// @nodoc
abstract mixin class _$PlantsPageStateCopyWith<$Res> implements $PlantsPageStateCopyWith<$Res> {
  factory _$PlantsPageStateCopyWith(_PlantsPageState value, $Res Function(_PlantsPageState) _then) = __$PlantsPageStateCopyWithImpl;
@override @useResult
$Res call({
 int selectedDay, String? openPlantId
});




}
/// @nodoc
class __$PlantsPageStateCopyWithImpl<$Res>
    implements _$PlantsPageStateCopyWith<$Res> {
  __$PlantsPageStateCopyWithImpl(this._self, this._then);

  final _PlantsPageState _self;
  final $Res Function(_PlantsPageState) _then;

/// Create a copy of PlantsPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedDay = null,Object? openPlantId = freezed,}) {
  return _then(_PlantsPageState(
selectedDay: null == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as int,openPlantId: freezed == openPlantId ? _self.openPlantId : openPlantId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
