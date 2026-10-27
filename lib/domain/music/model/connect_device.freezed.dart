// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connect_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectDevice {

 String get id; String get name; ConnectDeviceType get type; bool get isActive;/// Spotify does not allow remote control of this device.
 bool get isRestricted; int? get volumePercent; bool get supportsVolume;
/// Create a copy of ConnectDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectDeviceCopyWith<ConnectDevice> get copyWith => _$ConnectDeviceCopyWithImpl<ConnectDevice>(this as ConnectDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConnectDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectDevice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isRestricted, _this.isRestricted) || other.isRestricted == _this.isRestricted)&&(identical(other.volumePercent, _this.volumePercent) || other.volumePercent == _this.volumePercent)&&(identical(other.supportsVolume, _this.supportsVolume) || other.supportsVolume == _this.supportsVolume));
}


@override
int get hashCode {
  final _this = this as ConnectDevice;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.isActive,_this.isRestricted,_this.volumePercent,_this.supportsVolume);
}

@override
String toString() {
  final _this = this as ConnectDevice;
  return 'ConnectDevice(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, isActive: ${_this.isActive}, isRestricted: ${_this.isRestricted}, volumePercent: ${_this.volumePercent}, supportsVolume: ${_this.supportsVolume})';
}


}

/// @nodoc
abstract mixin class $ConnectDeviceCopyWith<$Res>  {
  factory $ConnectDeviceCopyWith(ConnectDevice value, $Res Function(ConnectDevice) _then) = _$ConnectDeviceCopyWithImpl;
@useResult
$Res call({
 String id, String name, ConnectDeviceType type, bool isActive, bool isRestricted, int? volumePercent, bool supportsVolume
});




}
/// @nodoc
class _$ConnectDeviceCopyWithImpl<$Res>
    implements $ConnectDeviceCopyWith<$Res> {
  _$ConnectDeviceCopyWithImpl(this._self, this._then);

  final ConnectDevice _self;
  final $Res Function(ConnectDevice) _then;

/// Create a copy of ConnectDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isActive = null,Object? isRestricted = null,Object? volumePercent = freezed,Object? supportsVolume = null,}) {
  return _then(ConnectDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConnectDeviceType,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isRestricted: null == isRestricted ? _self.isRestricted : isRestricted // ignore: cast_nullable_to_non_nullable
as bool,volumePercent: freezed == volumePercent ? _self.volumePercent : volumePercent // ignore: cast_nullable_to_non_nullable
as int?,supportsVolume: null == supportsVolume ? _self.supportsVolume : supportsVolume // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectDevice].
extension ConnectDevicePatterns on ConnectDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectDevice value)  $default,){
final _that = this;
switch (_that) {
case _ConnectDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectDevice value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ConnectDeviceType type,  bool isActive,  bool isRestricted,  int? volumePercent,  bool supportsVolume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectDevice() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isActive,_that.isRestricted,_that.volumePercent,_that.supportsVolume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ConnectDeviceType type,  bool isActive,  bool isRestricted,  int? volumePercent,  bool supportsVolume)  $default,) {final _that = this;
switch (_that) {
case _ConnectDevice():
return $default(_that.id,_that.name,_that.type,_that.isActive,_that.isRestricted,_that.volumePercent,_that.supportsVolume);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ConnectDeviceType type,  bool isActive,  bool isRestricted,  int? volumePercent,  bool supportsVolume)?  $default,) {final _that = this;
switch (_that) {
case _ConnectDevice() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isActive,_that.isRestricted,_that.volumePercent,_that.supportsVolume);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectDevice implements ConnectDevice {
  const _ConnectDevice({required this.id, required this.name, required this.type, this.isActive = false, this.isRestricted = false, this.volumePercent, this.supportsVolume = false});
  

@override final  String id;
@override final  String name;
@override final  ConnectDeviceType type;
@override@JsonKey() final  bool isActive;
/// Spotify does not allow remote control of this device.
@override@JsonKey() final  bool isRestricted;
@override final  int? volumePercent;
@override@JsonKey() final  bool supportsVolume;

/// Create a copy of ConnectDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectDeviceCopyWith<_ConnectDevice> get copyWith => __$ConnectDeviceCopyWithImpl<_ConnectDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isRestricted, isRestricted) || other.isRestricted == isRestricted)&&(identical(other.volumePercent, volumePercent) || other.volumePercent == volumePercent)&&(identical(other.supportsVolume, supportsVolume) || other.supportsVolume == supportsVolume));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,isActive,isRestricted,volumePercent,supportsVolume);
}

@override
String toString() {
    return 'ConnectDevice(id: $id, name: $name, type: $type, isActive: $isActive, isRestricted: $isRestricted, volumePercent: $volumePercent, supportsVolume: $supportsVolume)';
}


}

/// @nodoc
abstract mixin class _$ConnectDeviceCopyWith<$Res> implements $ConnectDeviceCopyWith<$Res> {
  factory _$ConnectDeviceCopyWith(_ConnectDevice value, $Res Function(_ConnectDevice) _then) = __$ConnectDeviceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ConnectDeviceType type, bool isActive, bool isRestricted, int? volumePercent, bool supportsVolume
});




}
/// @nodoc
class __$ConnectDeviceCopyWithImpl<$Res>
    implements _$ConnectDeviceCopyWith<$Res> {
  __$ConnectDeviceCopyWithImpl(this._self, this._then);

  final _ConnectDevice _self;
  final $Res Function(_ConnectDevice) _then;

/// Create a copy of ConnectDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isActive = null,Object? isRestricted = null,Object? volumePercent = freezed,Object? supportsVolume = null,}) {
  return _then(_ConnectDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConnectDeviceType,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isRestricted: null == isRestricted ? _self.isRestricted : isRestricted // ignore: cast_nullable_to_non_nullable
as bool,volumePercent: freezed == volumePercent ? _self.volumePercent : volumePercent // ignore: cast_nullable_to_non_nullable
as int?,supportsVolume: null == supportsVolume ? _self.supportsVolume : supportsVolume // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
