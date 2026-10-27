// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lights.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LightsPageState {

 String? get selectedRoomId;/// The scene whose options (overwrite, rename, delete) are shown.
 String? get openSceneId;
/// Create a copy of LightsPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LightsPageStateCopyWith<LightsPageState> get copyWith => _$LightsPageStateCopyWithImpl<LightsPageState>(this as LightsPageState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LightsPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LightsPageState&&(identical(other.selectedRoomId, _this.selectedRoomId) || other.selectedRoomId == _this.selectedRoomId)&&(identical(other.openSceneId, _this.openSceneId) || other.openSceneId == _this.openSceneId));
}


@override
int get hashCode {
  final _this = this as LightsPageState;
  return Object.hash(runtimeType,_this.selectedRoomId,_this.openSceneId);
}

@override
String toString() {
  final _this = this as LightsPageState;
  return 'LightsPageState(selectedRoomId: ${_this.selectedRoomId}, openSceneId: ${_this.openSceneId})';
}


}

/// @nodoc
abstract mixin class $LightsPageStateCopyWith<$Res>  {
  factory $LightsPageStateCopyWith(LightsPageState value, $Res Function(LightsPageState) _then) = _$LightsPageStateCopyWithImpl;
@useResult
$Res call({
 String? selectedRoomId, String? openSceneId
});




}
/// @nodoc
class _$LightsPageStateCopyWithImpl<$Res>
    implements $LightsPageStateCopyWith<$Res> {
  _$LightsPageStateCopyWithImpl(this._self, this._then);

  final LightsPageState _self;
  final $Res Function(LightsPageState) _then;

/// Create a copy of LightsPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedRoomId = freezed,Object? openSceneId = freezed,}) {
  return _then(LightsPageState(
selectedRoomId: freezed == selectedRoomId ? _self.selectedRoomId : selectedRoomId // ignore: cast_nullable_to_non_nullable
as String?,openSceneId: freezed == openSceneId ? _self.openSceneId : openSceneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LightsPageState].
extension LightsPageStatePatterns on LightsPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LightsPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LightsPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LightsPageState value)  $default,){
final _that = this;
switch (_that) {
case _LightsPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LightsPageState value)?  $default,){
final _that = this;
switch (_that) {
case _LightsPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? selectedRoomId,  String? openSceneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LightsPageState() when $default != null:
return $default(_that.selectedRoomId,_that.openSceneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? selectedRoomId,  String? openSceneId)  $default,) {final _that = this;
switch (_that) {
case _LightsPageState():
return $default(_that.selectedRoomId,_that.openSceneId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? selectedRoomId,  String? openSceneId)?  $default,) {final _that = this;
switch (_that) {
case _LightsPageState() when $default != null:
return $default(_that.selectedRoomId,_that.openSceneId);case _:
  return null;

}
}

}

/// @nodoc


class _LightsPageState implements LightsPageState {
  const _LightsPageState({this.selectedRoomId, this.openSceneId});
  

@override final  String? selectedRoomId;
/// The scene whose options (overwrite, rename, delete) are shown.
@override final  String? openSceneId;

/// Create a copy of LightsPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LightsPageStateCopyWith<_LightsPageState> get copyWith => __$LightsPageStateCopyWithImpl<_LightsPageState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LightsPageState&&(identical(other.selectedRoomId, selectedRoomId) || other.selectedRoomId == selectedRoomId)&&(identical(other.openSceneId, openSceneId) || other.openSceneId == openSceneId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,selectedRoomId,openSceneId);
}

@override
String toString() {
    return 'LightsPageState(selectedRoomId: $selectedRoomId, openSceneId: $openSceneId)';
}


}

/// @nodoc
abstract mixin class _$LightsPageStateCopyWith<$Res> implements $LightsPageStateCopyWith<$Res> {
  factory _$LightsPageStateCopyWith(_LightsPageState value, $Res Function(_LightsPageState) _then) = __$LightsPageStateCopyWithImpl;
@override @useResult
$Res call({
 String? selectedRoomId, String? openSceneId
});




}
/// @nodoc
class __$LightsPageStateCopyWithImpl<$Res>
    implements _$LightsPageStateCopyWith<$Res> {
  __$LightsPageStateCopyWithImpl(this._self, this._then);

  final _LightsPageState _self;
  final $Res Function(_LightsPageState) _then;

/// Create a copy of LightsPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedRoomId = freezed,Object? openSceneId = freezed,}) {
  return _then(_LightsPageState(
selectedRoomId: freezed == selectedRoomId ? _self.selectedRoomId : selectedRoomId // ignore: cast_nullable_to_non_nullable
as String?,openSceneId: freezed == openSceneId ? _self.openSceneId : openSceneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
