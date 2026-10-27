// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectionConfig {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionConfig);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ConnectionConfig()';
}


}

/// @nodoc
class $ConnectionConfigCopyWith<$Res>  {
$ConnectionConfigCopyWith(ConnectionConfig _, $Res Function(ConnectionConfig) __);
}


/// Adds pattern-matching-related methods to [ConnectionConfig].
extension ConnectionConfigPatterns on ConnectionConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeAssistantConnectionConfig value)?  homeAssistant,TResult Function( DemoConnectionConfig value)?  demo,TResult Function( StandaloneConnectionConfig value)?  standalone,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeAssistantConnectionConfig() when homeAssistant != null:
return homeAssistant(_that);case DemoConnectionConfig() when demo != null:
return demo(_that);case StandaloneConnectionConfig() when standalone != null:
return standalone(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeAssistantConnectionConfig value)  homeAssistant,required TResult Function( DemoConnectionConfig value)  demo,required TResult Function( StandaloneConnectionConfig value)  standalone,}){
final _that = this;
switch (_that) {
case HomeAssistantConnectionConfig():
return homeAssistant(_that);case DemoConnectionConfig():
return demo(_that);case StandaloneConnectionConfig():
return standalone(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeAssistantConnectionConfig value)?  homeAssistant,TResult? Function( DemoConnectionConfig value)?  demo,TResult? Function( StandaloneConnectionConfig value)?  standalone,}){
final _that = this;
switch (_that) {
case HomeAssistantConnectionConfig() when homeAssistant != null:
return homeAssistant(_that);case DemoConnectionConfig() when demo != null:
return demo(_that);case StandaloneConnectionConfig() when standalone != null:
return standalone(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Uri baseUrl,  String token)?  homeAssistant,TResult Function()?  demo,TResult Function()?  standalone,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeAssistantConnectionConfig() when homeAssistant != null:
return homeAssistant(_that.baseUrl,_that.token);case DemoConnectionConfig() when demo != null:
return demo();case StandaloneConnectionConfig() when standalone != null:
return standalone();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Uri baseUrl,  String token)  homeAssistant,required TResult Function()  demo,required TResult Function()  standalone,}) {final _that = this;
switch (_that) {
case HomeAssistantConnectionConfig():
return homeAssistant(_that.baseUrl,_that.token);case DemoConnectionConfig():
return demo();case StandaloneConnectionConfig():
return standalone();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Uri baseUrl,  String token)?  homeAssistant,TResult? Function()?  demo,TResult? Function()?  standalone,}) {final _that = this;
switch (_that) {
case HomeAssistantConnectionConfig() when homeAssistant != null:
return homeAssistant(_that.baseUrl,_that.token);case DemoConnectionConfig() when demo != null:
return demo();case StandaloneConnectionConfig() when standalone != null:
return standalone();case _:
  return null;

}
}

}

/// @nodoc


class HomeAssistantConnectionConfig implements ConnectionConfig {
  const HomeAssistantConnectionConfig({required this.baseUrl, required this.token});
  

 final  Uri baseUrl;
 final  String token;

/// Create a copy of ConnectionConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeAssistantConnectionConfigCopyWith<HomeAssistantConnectionConfig> get copyWith => _$HomeAssistantConnectionConfigCopyWithImpl<HomeAssistantConnectionConfig>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeAssistantConnectionConfig&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode {
    return Object.hash(runtimeType,baseUrl,token);
}

@override
String toString() {
    return 'ConnectionConfig.homeAssistant(baseUrl: $baseUrl, token: $token)';
}


}

/// @nodoc
abstract mixin class $HomeAssistantConnectionConfigCopyWith<$Res> implements $ConnectionConfigCopyWith<$Res> {
  factory $HomeAssistantConnectionConfigCopyWith(HomeAssistantConnectionConfig value, $Res Function(HomeAssistantConnectionConfig) _then) = _$HomeAssistantConnectionConfigCopyWithImpl;
@useResult
$Res call({
 Uri baseUrl, String token
});




}
/// @nodoc
class _$HomeAssistantConnectionConfigCopyWithImpl<$Res>
    implements $HomeAssistantConnectionConfigCopyWith<$Res> {
  _$HomeAssistantConnectionConfigCopyWithImpl(this._self, this._then);

  final HomeAssistantConnectionConfig _self;
  final $Res Function(HomeAssistantConnectionConfig) _then;

/// Create a copy of ConnectionConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? baseUrl = null,Object? token = null,}) {
  return _then(HomeAssistantConnectionConfig(
baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as Uri,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DemoConnectionConfig implements ConnectionConfig {
  const DemoConnectionConfig();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DemoConnectionConfig);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ConnectionConfig.demo()';
}


}




/// @nodoc


class StandaloneConnectionConfig implements ConnectionConfig {
  const StandaloneConnectionConfig();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StandaloneConnectionConfig);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ConnectionConfig.standalone()';
}


}




// dart format on
