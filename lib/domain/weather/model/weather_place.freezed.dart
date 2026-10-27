// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherPlace {

 double get latitude; double get longitude; String get name;/// State or country, to tell places with the same name apart.
 String? get region;
/// Create a copy of WeatherPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherPlaceCopyWith<WeatherPlace> get copyWith => _$WeatherPlaceCopyWithImpl<WeatherPlace>(this as WeatherPlace, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeatherPlace;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherPlace&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.region, _this.region) || other.region == _this.region));
}


@override
int get hashCode {
  final _this = this as WeatherPlace;
  return Object.hash(runtimeType,_this.latitude,_this.longitude,_this.name,_this.region);
}

@override
String toString() {
  final _this = this as WeatherPlace;
  return 'WeatherPlace(latitude: ${_this.latitude}, longitude: ${_this.longitude}, name: ${_this.name}, region: ${_this.region})';
}


}

/// @nodoc
abstract mixin class $WeatherPlaceCopyWith<$Res>  {
  factory $WeatherPlaceCopyWith(WeatherPlace value, $Res Function(WeatherPlace) _then) = _$WeatherPlaceCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, String name, String? region
});




}
/// @nodoc
class _$WeatherPlaceCopyWithImpl<$Res>
    implements $WeatherPlaceCopyWith<$Res> {
  _$WeatherPlaceCopyWithImpl(this._self, this._then);

  final WeatherPlace _self;
  final $Res Function(WeatherPlace) _then;

/// Create a copy of WeatherPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? name = null,Object? region = freezed,}) {
  return _then(WeatherPlace(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherPlace].
extension WeatherPlacePatterns on WeatherPlace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherPlace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherPlace value)  $default,){
final _that = this;
switch (_that) {
case _WeatherPlace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherPlace value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherPlace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String name,  String? region)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherPlace() when $default != null:
return $default(_that.latitude,_that.longitude,_that.name,_that.region);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String name,  String? region)  $default,) {final _that = this;
switch (_that) {
case _WeatherPlace():
return $default(_that.latitude,_that.longitude,_that.name,_that.region);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  String name,  String? region)?  $default,) {final _that = this;
switch (_that) {
case _WeatherPlace() when $default != null:
return $default(_that.latitude,_that.longitude,_that.name,_that.region);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherPlace implements WeatherPlace {
  const _WeatherPlace({required this.latitude, required this.longitude, required this.name, this.region});
  

@override final  double latitude;
@override final  double longitude;
@override final  String name;
/// State or country, to tell places with the same name apart.
@override final  String? region;

/// Create a copy of WeatherPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherPlaceCopyWith<_WeatherPlace> get copyWith => __$WeatherPlaceCopyWithImpl<_WeatherPlace>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherPlace&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.name, name) || other.name == name)&&(identical(other.region, region) || other.region == region));
}


@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,name,region);
}

@override
String toString() {
    return 'WeatherPlace(latitude: $latitude, longitude: $longitude, name: $name, region: $region)';
}


}

/// @nodoc
abstract mixin class _$WeatherPlaceCopyWith<$Res> implements $WeatherPlaceCopyWith<$Res> {
  factory _$WeatherPlaceCopyWith(_WeatherPlace value, $Res Function(_WeatherPlace) _then) = __$WeatherPlaceCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, String name, String? region
});




}
/// @nodoc
class __$WeatherPlaceCopyWithImpl<$Res>
    implements _$WeatherPlaceCopyWith<$Res> {
  __$WeatherPlaceCopyWithImpl(this._self, this._then);

  final _WeatherPlace _self;
  final $Res Function(_WeatherPlace) _then;

/// Create a copy of WeatherPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? name = null,Object? region = freezed,}) {
  return _then(_WeatherPlace(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
