// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherLocation {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherLocation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WeatherLocation()';
}


}

/// @nodoc
class $WeatherLocationCopyWith<$Res>  {
$WeatherLocationCopyWith(WeatherLocation _, $Res Function(WeatherLocation) __);
}


/// Adds pattern-matching-related methods to [WeatherLocation].
extension WeatherLocationPatterns on WeatherLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeviceWeatherLocation value)?  device,TResult Function( PlaceWeatherLocation value)?  place,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeviceWeatherLocation() when device != null:
return device(_that);case PlaceWeatherLocation() when place != null:
return place(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeviceWeatherLocation value)  device,required TResult Function( PlaceWeatherLocation value)  place,}){
final _that = this;
switch (_that) {
case DeviceWeatherLocation():
return device(_that);case PlaceWeatherLocation():
return place(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeviceWeatherLocation value)?  device,TResult? Function( PlaceWeatherLocation value)?  place,}){
final _that = this;
switch (_that) {
case DeviceWeatherLocation() when device != null:
return device(_that);case PlaceWeatherLocation() when place != null:
return place(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  device,TResult Function( WeatherPlace place)?  place,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeviceWeatherLocation() when device != null:
return device();case PlaceWeatherLocation() when place != null:
return place(_that.place);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  device,required TResult Function( WeatherPlace place)  place,}) {final _that = this;
switch (_that) {
case DeviceWeatherLocation():
return device();case PlaceWeatherLocation():
return place(_that.place);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  device,TResult? Function( WeatherPlace place)?  place,}) {final _that = this;
switch (_that) {
case DeviceWeatherLocation() when device != null:
return device();case PlaceWeatherLocation() when place != null:
return place(_that.place);case _:
  return null;

}
}

}

/// @nodoc


class DeviceWeatherLocation implements WeatherLocation {
  const DeviceWeatherLocation();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceWeatherLocation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WeatherLocation.device()';
}


}




/// @nodoc


class PlaceWeatherLocation implements WeatherLocation {
  const PlaceWeatherLocation(this.place);
  

 final  WeatherPlace place;

/// Create a copy of WeatherLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceWeatherLocationCopyWith<PlaceWeatherLocation> get copyWith => _$PlaceWeatherLocationCopyWithImpl<PlaceWeatherLocation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceWeatherLocation&&(identical(other.place, place) || other.place == place));
}


@override
int get hashCode {
    return Object.hash(runtimeType,place);
}

@override
String toString() {
    return 'WeatherLocation.place(place: $place)';
}


}

/// @nodoc
abstract mixin class $PlaceWeatherLocationCopyWith<$Res> implements $WeatherLocationCopyWith<$Res> {
  factory $PlaceWeatherLocationCopyWith(PlaceWeatherLocation value, $Res Function(PlaceWeatherLocation) _then) = _$PlaceWeatherLocationCopyWithImpl;
@useResult
$Res call({
 WeatherPlace place
});


$WeatherPlaceCopyWith<$Res> get place;

}
/// @nodoc
class _$PlaceWeatherLocationCopyWithImpl<$Res>
    implements $PlaceWeatherLocationCopyWith<$Res> {
  _$PlaceWeatherLocationCopyWithImpl(this._self, this._then);

  final PlaceWeatherLocation _self;
  final $Res Function(PlaceWeatherLocation) _then;

/// Create a copy of WeatherLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? place = null,}) {
  return _then(PlaceWeatherLocation(
null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as WeatherPlace,
  ));
}

/// Create a copy of WeatherLocation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherPlaceCopyWith<$Res> get place {
  
  return $WeatherPlaceCopyWith<$Res>(_self.place, (value) {
    return _then(_self.copyWith(place: value));
  });
}
}

// dart format on
