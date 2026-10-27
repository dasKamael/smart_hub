// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SetupState {

 String get address; String get token; bool get isConnecting;/// The running connection attempt is the demo, so its button shows the progress.
 bool get isStartingDemo; SetupError? get error;
/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupStateCopyWith<SetupState> get copyWith => _$SetupStateCopyWithImpl<SetupState>(this as SetupState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SetupState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupState&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.isConnecting, _this.isConnecting) || other.isConnecting == _this.isConnecting)&&(identical(other.isStartingDemo, _this.isStartingDemo) || other.isStartingDemo == _this.isStartingDemo)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as SetupState;
  return Object.hash(runtimeType,_this.address,_this.token,_this.isConnecting,_this.isStartingDemo,_this.error);
}

@override
String toString() {
  final _this = this as SetupState;
  return 'SetupState(address: ${_this.address}, token: ${_this.token}, isConnecting: ${_this.isConnecting}, isStartingDemo: ${_this.isStartingDemo}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $SetupStateCopyWith<$Res>  {
  factory $SetupStateCopyWith(SetupState value, $Res Function(SetupState) _then) = _$SetupStateCopyWithImpl;
@useResult
$Res call({
 String address, String token, bool isConnecting, bool isStartingDemo, SetupError? error
});




}
/// @nodoc
class _$SetupStateCopyWithImpl<$Res>
    implements $SetupStateCopyWith<$Res> {
  _$SetupStateCopyWithImpl(this._self, this._then);

  final SetupState _self;
  final $Res Function(SetupState) _then;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? token = null,Object? isConnecting = null,Object? isStartingDemo = null,Object? error = freezed,}) {
  return _then(SetupState(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,isStartingDemo: null == isStartingDemo ? _self.isStartingDemo : isStartingDemo // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as SetupError?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetupState].
extension SetupStatePatterns on SetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetupState value)  $default,){
final _that = this;
switch (_that) {
case _SetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetupState value)?  $default,){
final _that = this;
switch (_that) {
case _SetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String address,  String token,  bool isConnecting,  bool isStartingDemo,  SetupError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetupState() when $default != null:
return $default(_that.address,_that.token,_that.isConnecting,_that.isStartingDemo,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String address,  String token,  bool isConnecting,  bool isStartingDemo,  SetupError? error)  $default,) {final _that = this;
switch (_that) {
case _SetupState():
return $default(_that.address,_that.token,_that.isConnecting,_that.isStartingDemo,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String address,  String token,  bool isConnecting,  bool isStartingDemo,  SetupError? error)?  $default,) {final _that = this;
switch (_that) {
case _SetupState() when $default != null:
return $default(_that.address,_that.token,_that.isConnecting,_that.isStartingDemo,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SetupState implements SetupState {
  const _SetupState({this.address = '', this.token = '', this.isConnecting = false, this.isStartingDemo = false, this.error});
  

@override@JsonKey() final  String address;
@override@JsonKey() final  String token;
@override@JsonKey() final  bool isConnecting;
/// The running connection attempt is the demo, so its button shows the progress.
@override@JsonKey() final  bool isStartingDemo;
@override final  SetupError? error;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetupStateCopyWith<_SetupState> get copyWith => __$SetupStateCopyWithImpl<_SetupState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetupState&&(identical(other.address, address) || other.address == address)&&(identical(other.token, token) || other.token == token)&&(identical(other.isConnecting, isConnecting) || other.isConnecting == isConnecting)&&(identical(other.isStartingDemo, isStartingDemo) || other.isStartingDemo == isStartingDemo)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,address,token,isConnecting,isStartingDemo,error);
}

@override
String toString() {
    return 'SetupState(address: $address, token: $token, isConnecting: $isConnecting, isStartingDemo: $isStartingDemo, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SetupStateCopyWith<$Res> implements $SetupStateCopyWith<$Res> {
  factory _$SetupStateCopyWith(_SetupState value, $Res Function(_SetupState) _then) = __$SetupStateCopyWithImpl;
@override @useResult
$Res call({
 String address, String token, bool isConnecting, bool isStartingDemo, SetupError? error
});




}
/// @nodoc
class __$SetupStateCopyWithImpl<$Res>
    implements _$SetupStateCopyWith<$Res> {
  __$SetupStateCopyWithImpl(this._self, this._then);

  final _SetupState _self;
  final $Res Function(_SetupState) _then;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? token = null,Object? isConnecting = null,Object? isStartingDemo = null,Object? error = freezed,}) {
  return _then(_SetupState(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,isStartingDemo: null == isStartingDemo ? _self.isStartingDemo : isStartingDemo // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as SetupError?,
  ));
}


}

// dart format on
