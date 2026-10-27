// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'light_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LightState {

 String get id; String get name; bool get isOn;/// `false` while the light is unreachable.
 bool get isAvailable;/// 1–100 while on, `null` while off or for on/off-only lights.
 int? get brightnessPercent;/// Color while the light is in a color mode; `null` while off or in white mode.
 RgbColor? get color;/// Color temperature while the light is in white mode.
 int? get kelvin;/// Range of the color temperature, for lights that support it.
 int get minKelvin; int get maxKelvin; Set<LightCapability> get capabilities;
/// Create a copy of LightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LightStateCopyWith<LightState> get copyWith => _$LightStateCopyWithImpl<LightState>(this as LightState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LightState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LightState&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isOn, _this.isOn) || other.isOn == _this.isOn)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&(identical(other.brightnessPercent, _this.brightnessPercent) || other.brightnessPercent == _this.brightnessPercent)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.kelvin, _this.kelvin) || other.kelvin == _this.kelvin)&&(identical(other.minKelvin, _this.minKelvin) || other.minKelvin == _this.minKelvin)&&(identical(other.maxKelvin, _this.maxKelvin) || other.maxKelvin == _this.maxKelvin)&&const DeepCollectionEquality().equals(other.capabilities, _this.capabilities));
}


@override
int get hashCode {
  final _this = this as LightState;
  return Object.hash(runtimeType,_this.id,_this.name,_this.isOn,_this.isAvailable,_this.brightnessPercent,_this.color,_this.kelvin,_this.minKelvin,_this.maxKelvin,const DeepCollectionEquality().hash(_this.capabilities));
}

@override
String toString() {
  final _this = this as LightState;
  return 'LightState(id: ${_this.id}, name: ${_this.name}, isOn: ${_this.isOn}, isAvailable: ${_this.isAvailable}, brightnessPercent: ${_this.brightnessPercent}, color: ${_this.color}, kelvin: ${_this.kelvin}, minKelvin: ${_this.minKelvin}, maxKelvin: ${_this.maxKelvin}, capabilities: ${_this.capabilities})';
}


}

/// @nodoc
abstract mixin class $LightStateCopyWith<$Res>  {
  factory $LightStateCopyWith(LightState value, $Res Function(LightState) _then) = _$LightStateCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isOn, bool isAvailable, int? brightnessPercent, RgbColor? color, int? kelvin, int minKelvin, int maxKelvin, Set<LightCapability> capabilities
});




}
/// @nodoc
class _$LightStateCopyWithImpl<$Res>
    implements $LightStateCopyWith<$Res> {
  _$LightStateCopyWithImpl(this._self, this._then);

  final LightState _self;
  final $Res Function(LightState) _then;

/// Create a copy of LightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isOn = null,Object? isAvailable = null,Object? brightnessPercent = freezed,Object? color = freezed,Object? kelvin = freezed,Object? minKelvin = null,Object? maxKelvin = null,Object? capabilities = null,}) {
  return _then(LightState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isOn: null == isOn ? _self.isOn : isOn // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,brightnessPercent: freezed == brightnessPercent ? _self.brightnessPercent : brightnessPercent // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as RgbColor?,kelvin: freezed == kelvin ? _self.kelvin : kelvin // ignore: cast_nullable_to_non_nullable
as int?,minKelvin: null == minKelvin ? _self.minKelvin : minKelvin // ignore: cast_nullable_to_non_nullable
as int,maxKelvin: null == maxKelvin ? _self.maxKelvin : maxKelvin // ignore: cast_nullable_to_non_nullable
as int,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as Set<LightCapability>,
  ));
}

}


/// Adds pattern-matching-related methods to [LightState].
extension LightStatePatterns on LightState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LightState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LightState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LightState value)  $default,){
final _that = this;
switch (_that) {
case _LightState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LightState value)?  $default,){
final _that = this;
switch (_that) {
case _LightState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isOn,  bool isAvailable,  int? brightnessPercent,  RgbColor? color,  int? kelvin,  int minKelvin,  int maxKelvin,  Set<LightCapability> capabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LightState() when $default != null:
return $default(_that.id,_that.name,_that.isOn,_that.isAvailable,_that.brightnessPercent,_that.color,_that.kelvin,_that.minKelvin,_that.maxKelvin,_that.capabilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isOn,  bool isAvailable,  int? brightnessPercent,  RgbColor? color,  int? kelvin,  int minKelvin,  int maxKelvin,  Set<LightCapability> capabilities)  $default,) {final _that = this;
switch (_that) {
case _LightState():
return $default(_that.id,_that.name,_that.isOn,_that.isAvailable,_that.brightnessPercent,_that.color,_that.kelvin,_that.minKelvin,_that.maxKelvin,_that.capabilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isOn,  bool isAvailable,  int? brightnessPercent,  RgbColor? color,  int? kelvin,  int minKelvin,  int maxKelvin,  Set<LightCapability> capabilities)?  $default,) {final _that = this;
switch (_that) {
case _LightState() when $default != null:
return $default(_that.id,_that.name,_that.isOn,_that.isAvailable,_that.brightnessPercent,_that.color,_that.kelvin,_that.minKelvin,_that.maxKelvin,_that.capabilities);case _:
  return null;

}
}

}

/// @nodoc


class _LightState extends LightState {
  const _LightState({required this.id, required this.name, required this.isOn, this.isAvailable = true, this.brightnessPercent, this.color, this.kelvin, this.minKelvin = 2000, this.maxKelvin = 6500,  Set<LightCapability> capabilities = const {}}): _capabilities = capabilities,super._();
  

@override final  String id;
@override final  String name;
@override final  bool isOn;
/// `false` while the light is unreachable.
@override@JsonKey() final  bool isAvailable;
/// 1–100 while on, `null` while off or for on/off-only lights.
@override final  int? brightnessPercent;
/// Color while the light is in a color mode; `null` while off or in white mode.
@override final  RgbColor? color;
/// Color temperature while the light is in white mode.
@override final  int? kelvin;
/// Range of the color temperature, for lights that support it.
@override@JsonKey() final  int minKelvin;
@override@JsonKey() final  int maxKelvin;
 final  Set<LightCapability> _capabilities;
@override@JsonKey() Set<LightCapability> get capabilities {
  if (_capabilities is EqualUnmodifiableSetView) return _capabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_capabilities);
}


/// Create a copy of LightState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LightStateCopyWith<_LightState> get copyWith => __$LightStateCopyWithImpl<_LightState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LightState&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isOn, isOn) || other.isOn == isOn)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.brightnessPercent, brightnessPercent) || other.brightnessPercent == brightnessPercent)&&(identical(other.color, color) || other.color == color)&&(identical(other.kelvin, kelvin) || other.kelvin == kelvin)&&(identical(other.minKelvin, minKelvin) || other.minKelvin == minKelvin)&&(identical(other.maxKelvin, maxKelvin) || other.maxKelvin == maxKelvin)&&const DeepCollectionEquality().equals(other.capabilities, _capabilities));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,isOn,isAvailable,brightnessPercent,color,kelvin,minKelvin,maxKelvin,const DeepCollectionEquality().hash(_capabilities));
}

@override
String toString() {
    return 'LightState(id: $id, name: $name, isOn: $isOn, isAvailable: $isAvailable, brightnessPercent: $brightnessPercent, color: $color, kelvin: $kelvin, minKelvin: $minKelvin, maxKelvin: $maxKelvin, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class _$LightStateCopyWith<$Res> implements $LightStateCopyWith<$Res> {
  factory _$LightStateCopyWith(_LightState value, $Res Function(_LightState) _then) = __$LightStateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isOn, bool isAvailable, int? brightnessPercent, RgbColor? color, int? kelvin, int minKelvin, int maxKelvin, Set<LightCapability> capabilities
});




}
/// @nodoc
class __$LightStateCopyWithImpl<$Res>
    implements _$LightStateCopyWith<$Res> {
  __$LightStateCopyWithImpl(this._self, this._then);

  final _LightState _self;
  final $Res Function(_LightState) _then;

/// Create a copy of LightState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isOn = null,Object? isAvailable = null,Object? brightnessPercent = freezed,Object? color = freezed,Object? kelvin = freezed,Object? minKelvin = null,Object? maxKelvin = null,Object? capabilities = null,}) {
  return _then(_LightState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isOn: null == isOn ? _self.isOn : isOn // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,brightnessPercent: freezed == brightnessPercent ? _self.brightnessPercent : brightnessPercent // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as RgbColor?,kelvin: freezed == kelvin ? _self.kelvin : kelvin // ignore: cast_nullable_to_non_nullable
as int?,minKelvin: null == minKelvin ? _self.minKelvin : minKelvin // ignore: cast_nullable_to_non_nullable
as int,maxKelvin: null == maxKelvin ? _self.maxKelvin : maxKelvin // ignore: cast_nullable_to_non_nullable
as int,capabilities: null == capabilities ? _self._capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as Set<LightCapability>,
  ));
}


}

// dart format on
