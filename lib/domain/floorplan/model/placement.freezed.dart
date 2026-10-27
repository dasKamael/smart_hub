// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'placement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Placement {

/// Entity id for lights and speakers, local id for plants.
 String get deviceId; DeviceKind get kind; PlanPoint get position;
/// Create a copy of Placement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacementCopyWith<Placement> get copyWith => _$PlacementCopyWithImpl<Placement>(this as Placement, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Placement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Placement&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.position, _this.position) || other.position == _this.position));
}


@override
int get hashCode {
  final _this = this as Placement;
  return Object.hash(runtimeType,_this.deviceId,_this.kind,_this.position);
}

@override
String toString() {
  final _this = this as Placement;
  return 'Placement(deviceId: ${_this.deviceId}, kind: ${_this.kind}, position: ${_this.position})';
}


}

/// @nodoc
abstract mixin class $PlacementCopyWith<$Res>  {
  factory $PlacementCopyWith(Placement value, $Res Function(Placement) _then) = _$PlacementCopyWithImpl;
@useResult
$Res call({
 String deviceId, DeviceKind kind, PlanPoint position
});




}
/// @nodoc
class _$PlacementCopyWithImpl<$Res>
    implements $PlacementCopyWith<$Res> {
  _$PlacementCopyWithImpl(this._self, this._then);

  final Placement _self;
  final $Res Function(Placement) _then;

/// Create a copy of Placement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? kind = null,Object? position = null,}) {
  return _then(Placement(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}

}


/// Adds pattern-matching-related methods to [Placement].
extension PlacementPatterns on Placement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Placement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Placement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Placement value)  $default,){
final _that = this;
switch (_that) {
case _Placement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Placement value)?  $default,){
final _that = this;
switch (_that) {
case _Placement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  DeviceKind kind,  PlanPoint position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Placement() when $default != null:
return $default(_that.deviceId,_that.kind,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  DeviceKind kind,  PlanPoint position)  $default,) {final _that = this;
switch (_that) {
case _Placement():
return $default(_that.deviceId,_that.kind,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  DeviceKind kind,  PlanPoint position)?  $default,) {final _that = this;
switch (_that) {
case _Placement() when $default != null:
return $default(_that.deviceId,_that.kind,_that.position);case _:
  return null;

}
}

}

/// @nodoc


class _Placement implements Placement {
  const _Placement({required this.deviceId, required this.kind, required this.position});
  

/// Entity id for lights and speakers, local id for plants.
@override final  String deviceId;
@override final  DeviceKind kind;
@override final  PlanPoint position;

/// Create a copy of Placement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacementCopyWith<_Placement> get copyWith => __$PlacementCopyWithImpl<_Placement>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Placement&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,kind,position);
}

@override
String toString() {
    return 'Placement(deviceId: $deviceId, kind: $kind, position: $position)';
}


}

/// @nodoc
abstract mixin class _$PlacementCopyWith<$Res> implements $PlacementCopyWith<$Res> {
  factory _$PlacementCopyWith(_Placement value, $Res Function(_Placement) _then) = __$PlacementCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, DeviceKind kind, PlanPoint position
});




}
/// @nodoc
class __$PlacementCopyWithImpl<$Res>
    implements _$PlacementCopyWith<$Res> {
  __$PlacementCopyWithImpl(this._self, this._then);

  final _Placement _self;
  final $Res Function(_Placement) _then;

/// Create a copy of Placement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? kind = null,Object? position = null,}) {
  return _then(_Placement(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}


}

// dart format on
