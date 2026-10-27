// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_scene.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomScene {

 String get id; String get roomId; String get name; int get brightnessPercent; RgbColor get color; int get kelvin;/// Per light id, for scenes saved from the room's current light.
 Map<String, SceneLight> get lights;
/// Create a copy of RoomScene
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSceneCopyWith<RoomScene> get copyWith => _$RoomSceneCopyWithImpl<RoomScene>(this as RoomScene, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RoomScene;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomScene&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.roomId, _this.roomId) || other.roomId == _this.roomId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.brightnessPercent, _this.brightnessPercent) || other.brightnessPercent == _this.brightnessPercent)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.kelvin, _this.kelvin) || other.kelvin == _this.kelvin)&&const DeepCollectionEquality().equals(other.lights, _this.lights));
}


@override
int get hashCode {
  final _this = this as RoomScene;
  return Object.hash(runtimeType,_this.id,_this.roomId,_this.name,_this.brightnessPercent,_this.color,_this.kelvin,const DeepCollectionEquality().hash(_this.lights));
}

@override
String toString() {
  final _this = this as RoomScene;
  return 'RoomScene(id: ${_this.id}, roomId: ${_this.roomId}, name: ${_this.name}, brightnessPercent: ${_this.brightnessPercent}, color: ${_this.color}, kelvin: ${_this.kelvin}, lights: ${_this.lights})';
}


}

/// @nodoc
abstract mixin class $RoomSceneCopyWith<$Res>  {
  factory $RoomSceneCopyWith(RoomScene value, $Res Function(RoomScene) _then) = _$RoomSceneCopyWithImpl;
@useResult
$Res call({
 String id, String roomId, String name, int brightnessPercent, RgbColor color, int kelvin, Map<String, SceneLight> lights
});




}
/// @nodoc
class _$RoomSceneCopyWithImpl<$Res>
    implements $RoomSceneCopyWith<$Res> {
  _$RoomSceneCopyWithImpl(this._self, this._then);

  final RoomScene _self;
  final $Res Function(RoomScene) _then;

/// Create a copy of RoomScene
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? name = null,Object? brightnessPercent = null,Object? color = null,Object? kelvin = null,Object? lights = null,}) {
  return _then(RoomScene(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brightnessPercent: null == brightnessPercent ? _self.brightnessPercent : brightnessPercent // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as RgbColor,kelvin: null == kelvin ? _self.kelvin : kelvin // ignore: cast_nullable_to_non_nullable
as int,lights: null == lights ? _self.lights : lights // ignore: cast_nullable_to_non_nullable
as Map<String, SceneLight>,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomScene].
extension RoomScenePatterns on RoomScene {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomScene value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomScene() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomScene value)  $default,){
final _that = this;
switch (_that) {
case _RoomScene():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomScene value)?  $default,){
final _that = this;
switch (_that) {
case _RoomScene() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String roomId,  String name,  int brightnessPercent,  RgbColor color,  int kelvin,  Map<String, SceneLight> lights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomScene() when $default != null:
return $default(_that.id,_that.roomId,_that.name,_that.brightnessPercent,_that.color,_that.kelvin,_that.lights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String roomId,  String name,  int brightnessPercent,  RgbColor color,  int kelvin,  Map<String, SceneLight> lights)  $default,) {final _that = this;
switch (_that) {
case _RoomScene():
return $default(_that.id,_that.roomId,_that.name,_that.brightnessPercent,_that.color,_that.kelvin,_that.lights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String roomId,  String name,  int brightnessPercent,  RgbColor color,  int kelvin,  Map<String, SceneLight> lights)?  $default,) {final _that = this;
switch (_that) {
case _RoomScene() when $default != null:
return $default(_that.id,_that.roomId,_that.name,_that.brightnessPercent,_that.color,_that.kelvin,_that.lights);case _:
  return null;

}
}

}

/// @nodoc


class _RoomScene implements RoomScene {
  const _RoomScene({required this.id, required this.roomId, required this.name, required this.brightnessPercent, required this.color, required this.kelvin,  Map<String, SceneLight> lights = const <String, SceneLight>{}}): _lights = lights;
  

@override final  String id;
@override final  String roomId;
@override final  String name;
@override final  int brightnessPercent;
@override final  RgbColor color;
@override final  int kelvin;
/// Per light id, for scenes saved from the room's current light.
 final  Map<String, SceneLight> _lights;
/// Per light id, for scenes saved from the room's current light.
@override@JsonKey() Map<String, SceneLight> get lights {
  if (_lights is EqualUnmodifiableMapView) return _lights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_lights);
}


/// Create a copy of RoomScene
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSceneCopyWith<_RoomScene> get copyWith => __$RoomSceneCopyWithImpl<_RoomScene>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomScene&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brightnessPercent, brightnessPercent) || other.brightnessPercent == brightnessPercent)&&(identical(other.color, color) || other.color == color)&&(identical(other.kelvin, kelvin) || other.kelvin == kelvin)&&const DeepCollectionEquality().equals(other.lights, _lights));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,roomId,name,brightnessPercent,color,kelvin,const DeepCollectionEquality().hash(_lights));
}

@override
String toString() {
    return 'RoomScene(id: $id, roomId: $roomId, name: $name, brightnessPercent: $brightnessPercent, color: $color, kelvin: $kelvin, lights: $lights)';
}


}

/// @nodoc
abstract mixin class _$RoomSceneCopyWith<$Res> implements $RoomSceneCopyWith<$Res> {
  factory _$RoomSceneCopyWith(_RoomScene value, $Res Function(_RoomScene) _then) = __$RoomSceneCopyWithImpl;
@override @useResult
$Res call({
 String id, String roomId, String name, int brightnessPercent, RgbColor color, int kelvin, Map<String, SceneLight> lights
});




}
/// @nodoc
class __$RoomSceneCopyWithImpl<$Res>
    implements _$RoomSceneCopyWith<$Res> {
  __$RoomSceneCopyWithImpl(this._self, this._then);

  final _RoomScene _self;
  final $Res Function(_RoomScene) _then;

/// Create a copy of RoomScene
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? name = null,Object? brightnessPercent = null,Object? color = null,Object? kelvin = null,Object? lights = null,}) {
  return _then(_RoomScene(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brightnessPercent: null == brightnessPercent ? _self.brightnessPercent : brightnessPercent // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as RgbColor,kelvin: null == kelvin ? _self.kelvin : kelvin // ignore: cast_nullable_to_non_nullable
as int,lights: null == lights ? _self._lights : lights // ignore: cast_nullable_to_non_nullable
as Map<String, SceneLight>,
  ));
}


}

/// @nodoc
mixin _$SceneLight {

 bool get on; int? get brightnessPercent; RgbColor? get color; int? get kelvin;
/// Create a copy of SceneLight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneLightCopyWith<SceneLight> get copyWith => _$SceneLightCopyWithImpl<SceneLight>(this as SceneLight, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SceneLight;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneLight&&(identical(other.on, _this.on) || other.on == _this.on)&&(identical(other.brightnessPercent, _this.brightnessPercent) || other.brightnessPercent == _this.brightnessPercent)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.kelvin, _this.kelvin) || other.kelvin == _this.kelvin));
}


@override
int get hashCode {
  final _this = this as SceneLight;
  return Object.hash(runtimeType,_this.on,_this.brightnessPercent,_this.color,_this.kelvin);
}

@override
String toString() {
  final _this = this as SceneLight;
  return 'SceneLight(on: ${_this.on}, brightnessPercent: ${_this.brightnessPercent}, color: ${_this.color}, kelvin: ${_this.kelvin})';
}


}

/// @nodoc
abstract mixin class $SceneLightCopyWith<$Res>  {
  factory $SceneLightCopyWith(SceneLight value, $Res Function(SceneLight) _then) = _$SceneLightCopyWithImpl;
@useResult
$Res call({
 bool on, int? brightnessPercent, RgbColor? color, int? kelvin
});




}
/// @nodoc
class _$SceneLightCopyWithImpl<$Res>
    implements $SceneLightCopyWith<$Res> {
  _$SceneLightCopyWithImpl(this._self, this._then);

  final SceneLight _self;
  final $Res Function(SceneLight) _then;

/// Create a copy of SceneLight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? on = null,Object? brightnessPercent = freezed,Object? color = freezed,Object? kelvin = freezed,}) {
  return _then(SceneLight(
on: null == on ? _self.on : on // ignore: cast_nullable_to_non_nullable
as bool,brightnessPercent: freezed == brightnessPercent ? _self.brightnessPercent : brightnessPercent // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as RgbColor?,kelvin: freezed == kelvin ? _self.kelvin : kelvin // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SceneLight].
extension SceneLightPatterns on SceneLight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneLight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneLight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneLight value)  $default,){
final _that = this;
switch (_that) {
case _SceneLight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneLight value)?  $default,){
final _that = this;
switch (_that) {
case _SceneLight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool on,  int? brightnessPercent,  RgbColor? color,  int? kelvin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneLight() when $default != null:
return $default(_that.on,_that.brightnessPercent,_that.color,_that.kelvin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool on,  int? brightnessPercent,  RgbColor? color,  int? kelvin)  $default,) {final _that = this;
switch (_that) {
case _SceneLight():
return $default(_that.on,_that.brightnessPercent,_that.color,_that.kelvin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool on,  int? brightnessPercent,  RgbColor? color,  int? kelvin)?  $default,) {final _that = this;
switch (_that) {
case _SceneLight() when $default != null:
return $default(_that.on,_that.brightnessPercent,_that.color,_that.kelvin);case _:
  return null;

}
}

}

/// @nodoc


class _SceneLight implements SceneLight {
  const _SceneLight({required this.on, this.brightnessPercent, this.color, this.kelvin});
  

@override final  bool on;
@override final  int? brightnessPercent;
@override final  RgbColor? color;
@override final  int? kelvin;

/// Create a copy of SceneLight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneLightCopyWith<_SceneLight> get copyWith => __$SceneLightCopyWithImpl<_SceneLight>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneLight&&(identical(other.on, on) || other.on == on)&&(identical(other.brightnessPercent, brightnessPercent) || other.brightnessPercent == brightnessPercent)&&(identical(other.color, color) || other.color == color)&&(identical(other.kelvin, kelvin) || other.kelvin == kelvin));
}


@override
int get hashCode {
    return Object.hash(runtimeType,on,brightnessPercent,color,kelvin);
}

@override
String toString() {
    return 'SceneLight(on: $on, brightnessPercent: $brightnessPercent, color: $color, kelvin: $kelvin)';
}


}

/// @nodoc
abstract mixin class _$SceneLightCopyWith<$Res> implements $SceneLightCopyWith<$Res> {
  factory _$SceneLightCopyWith(_SceneLight value, $Res Function(_SceneLight) _then) = __$SceneLightCopyWithImpl;
@override @useResult
$Res call({
 bool on, int? brightnessPercent, RgbColor? color, int? kelvin
});




}
/// @nodoc
class __$SceneLightCopyWithImpl<$Res>
    implements _$SceneLightCopyWith<$Res> {
  __$SceneLightCopyWithImpl(this._self, this._then);

  final _SceneLight _self;
  final $Res Function(_SceneLight) _then;

/// Create a copy of SceneLight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? on = null,Object? brightnessPercent = freezed,Object? color = freezed,Object? kelvin = freezed,}) {
  return _then(_SceneLight(
on: null == on ? _self.on : on // ignore: cast_nullable_to_non_nullable
as bool,brightnessPercent: freezed == brightnessPercent ? _self.brightnessPercent : brightnessPercent // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as RgbColor?,kelvin: freezed == kelvin ? _self.kelvin : kelvin // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
