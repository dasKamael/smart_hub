// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'light_bridge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LightBridge {

/// IP address in the home network.
 String get host;/// The key the bridge handed out when its button was pressed; secret.
 String get appKey;/// The bridge's own name, e.g. as shown in its app.
 String? get name;
/// Create a copy of LightBridge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LightBridgeCopyWith<LightBridge> get copyWith => _$LightBridgeCopyWithImpl<LightBridge>(this as LightBridge, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LightBridge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LightBridge&&(identical(other.host, _this.host) || other.host == _this.host)&&(identical(other.appKey, _this.appKey) || other.appKey == _this.appKey)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as LightBridge;
  return Object.hash(runtimeType,_this.host,_this.appKey,_this.name);
}

@override
String toString() {
  final _this = this as LightBridge;
  return 'LightBridge(host: ${_this.host}, appKey: ${_this.appKey}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $LightBridgeCopyWith<$Res>  {
  factory $LightBridgeCopyWith(LightBridge value, $Res Function(LightBridge) _then) = _$LightBridgeCopyWithImpl;
@useResult
$Res call({
 String host, String appKey, String? name
});




}
/// @nodoc
class _$LightBridgeCopyWithImpl<$Res>
    implements $LightBridgeCopyWith<$Res> {
  _$LightBridgeCopyWithImpl(this._self, this._then);

  final LightBridge _self;
  final $Res Function(LightBridge) _then;

/// Create a copy of LightBridge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,Object? appKey = null,Object? name = freezed,}) {
  return _then(LightBridge(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,appKey: null == appKey ? _self.appKey : appKey // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LightBridge].
extension LightBridgePatterns on LightBridge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LightBridge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LightBridge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LightBridge value)  $default,){
final _that = this;
switch (_that) {
case _LightBridge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LightBridge value)?  $default,){
final _that = this;
switch (_that) {
case _LightBridge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String host,  String appKey,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LightBridge() when $default != null:
return $default(_that.host,_that.appKey,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String host,  String appKey,  String? name)  $default,) {final _that = this;
switch (_that) {
case _LightBridge():
return $default(_that.host,_that.appKey,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String host,  String appKey,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _LightBridge() when $default != null:
return $default(_that.host,_that.appKey,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _LightBridge implements LightBridge {
  const _LightBridge({required this.host, required this.appKey, this.name});
  

/// IP address in the home network.
@override final  String host;
/// The key the bridge handed out when its button was pressed; secret.
@override final  String appKey;
/// The bridge's own name, e.g. as shown in its app.
@override final  String? name;

/// Create a copy of LightBridge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LightBridgeCopyWith<_LightBridge> get copyWith => __$LightBridgeCopyWithImpl<_LightBridge>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LightBridge&&(identical(other.host, host) || other.host == host)&&(identical(other.appKey, appKey) || other.appKey == appKey)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,host,appKey,name);
}

@override
String toString() {
    return 'LightBridge(host: $host, appKey: $appKey, name: $name)';
}


}

/// @nodoc
abstract mixin class _$LightBridgeCopyWith<$Res> implements $LightBridgeCopyWith<$Res> {
  factory _$LightBridgeCopyWith(_LightBridge value, $Res Function(_LightBridge) _then) = __$LightBridgeCopyWithImpl;
@override @useResult
$Res call({
 String host, String appKey, String? name
});




}
/// @nodoc
class __$LightBridgeCopyWithImpl<$Res>
    implements _$LightBridgeCopyWith<$Res> {
  __$LightBridgeCopyWithImpl(this._self, this._then);

  final _LightBridge _self;
  final $Res Function(_LightBridge) _then;

/// Create a copy of LightBridge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,Object? appKey = null,Object? name = freezed,}) {
  return _then(_LightBridge(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,appKey: null == appKey ? _self.appKey : appKey // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
