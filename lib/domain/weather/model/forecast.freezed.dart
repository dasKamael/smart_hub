// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forecast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Forecast {

 WeatherPlace get place; WeatherNow get now;/// From the current hour on.
 List<WeatherHour> get hours;/// From today on.
 List<WeatherDay> get days; DateTime get fetchedAt;
/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastCopyWith<Forecast> get copyWith => _$ForecastCopyWithImpl<Forecast>(this as Forecast, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Forecast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Forecast&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.now, _this.now) || other.now == _this.now)&&const DeepCollectionEquality().equals(other.hours, _this.hours)&&const DeepCollectionEquality().equals(other.days, _this.days)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt));
}


@override
int get hashCode {
  final _this = this as Forecast;
  return Object.hash(runtimeType,_this.place,_this.now,const DeepCollectionEquality().hash(_this.hours),const DeepCollectionEquality().hash(_this.days),_this.fetchedAt);
}

@override
String toString() {
  final _this = this as Forecast;
  return 'Forecast(place: ${_this.place}, now: ${_this.now}, hours: ${_this.hours}, days: ${_this.days}, fetchedAt: ${_this.fetchedAt})';
}


}

/// @nodoc
abstract mixin class $ForecastCopyWith<$Res>  {
  factory $ForecastCopyWith(Forecast value, $Res Function(Forecast) _then) = _$ForecastCopyWithImpl;
@useResult
$Res call({
 WeatherPlace place, WeatherNow now, List<WeatherHour> hours, List<WeatherDay> days, DateTime fetchedAt
});


$WeatherPlaceCopyWith<$Res> get place;$WeatherNowCopyWith<$Res> get now;

}
/// @nodoc
class _$ForecastCopyWithImpl<$Res>
    implements $ForecastCopyWith<$Res> {
  _$ForecastCopyWithImpl(this._self, this._then);

  final Forecast _self;
  final $Res Function(Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? place = null,Object? now = null,Object? hours = null,Object? days = null,Object? fetchedAt = null,}) {
  return _then(Forecast(
place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as WeatherPlace,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as WeatherNow,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as List<WeatherHour>,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<WeatherDay>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherPlaceCopyWith<$Res> get place {
  
  return $WeatherPlaceCopyWith<$Res>(_self.place, (value) {
    return _then(_self.copyWith(place: value));
  });
}/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherNowCopyWith<$Res> get now {
  
  return $WeatherNowCopyWith<$Res>(_self.now, (value) {
    return _then(_self.copyWith(now: value));
  });
}
}


/// Adds pattern-matching-related methods to [Forecast].
extension ForecastPatterns on Forecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Forecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Forecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Forecast value)  $default,){
final _that = this;
switch (_that) {
case _Forecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Forecast value)?  $default,){
final _that = this;
switch (_that) {
case _Forecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeatherPlace place,  WeatherNow now,  List<WeatherHour> hours,  List<WeatherDay> days,  DateTime fetchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.place,_that.now,_that.hours,_that.days,_that.fetchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeatherPlace place,  WeatherNow now,  List<WeatherHour> hours,  List<WeatherDay> days,  DateTime fetchedAt)  $default,) {final _that = this;
switch (_that) {
case _Forecast():
return $default(_that.place,_that.now,_that.hours,_that.days,_that.fetchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeatherPlace place,  WeatherNow now,  List<WeatherHour> hours,  List<WeatherDay> days,  DateTime fetchedAt)?  $default,) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.place,_that.now,_that.hours,_that.days,_that.fetchedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Forecast implements Forecast {
  const _Forecast({required this.place, required this.now, required  List<WeatherHour> hours, required  List<WeatherDay> days, required this.fetchedAt}): _hours = hours,_days = days;
  

@override final  WeatherPlace place;
@override final  WeatherNow now;
/// From the current hour on.
 final  List<WeatherHour> _hours;
/// From the current hour on.
@override List<WeatherHour> get hours {
  if (_hours is EqualUnmodifiableListView) return _hours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hours);
}

/// From today on.
 final  List<WeatherDay> _days;
/// From today on.
@override List<WeatherDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  DateTime fetchedAt;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastCopyWith<_Forecast> get copyWith => __$ForecastCopyWithImpl<_Forecast>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Forecast&&(identical(other.place, place) || other.place == place)&&(identical(other.now, now) || other.now == now)&&const DeepCollectionEquality().equals(other.hours, _hours)&&const DeepCollectionEquality().equals(other.days, _days)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,place,now,const DeepCollectionEquality().hash(_hours),const DeepCollectionEquality().hash(_days),fetchedAt);
}

@override
String toString() {
    return 'Forecast(place: $place, now: $now, hours: $hours, days: $days, fetchedAt: $fetchedAt)';
}


}

/// @nodoc
abstract mixin class _$ForecastCopyWith<$Res> implements $ForecastCopyWith<$Res> {
  factory _$ForecastCopyWith(_Forecast value, $Res Function(_Forecast) _then) = __$ForecastCopyWithImpl;
@override @useResult
$Res call({
 WeatherPlace place, WeatherNow now, List<WeatherHour> hours, List<WeatherDay> days, DateTime fetchedAt
});


@override $WeatherPlaceCopyWith<$Res> get place;@override $WeatherNowCopyWith<$Res> get now;

}
/// @nodoc
class __$ForecastCopyWithImpl<$Res>
    implements _$ForecastCopyWith<$Res> {
  __$ForecastCopyWithImpl(this._self, this._then);

  final _Forecast _self;
  final $Res Function(_Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? place = null,Object? now = null,Object? hours = null,Object? days = null,Object? fetchedAt = null,}) {
  return _then(_Forecast(
place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as WeatherPlace,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as WeatherNow,hours: null == hours ? _self._hours : hours // ignore: cast_nullable_to_non_nullable
as List<WeatherHour>,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<WeatherDay>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherPlaceCopyWith<$Res> get place {
  
  return $WeatherPlaceCopyWith<$Res>(_self.place, (value) {
    return _then(_self.copyWith(place: value));
  });
}/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherNowCopyWith<$Res> get now {
  
  return $WeatherNowCopyWith<$Res>(_self.now, (value) {
    return _then(_self.copyWith(now: value));
  });
}
}

/// @nodoc
mixin _$WeatherNow {

 double get temperature; double get apparentTemperature; WeatherCondition get condition; bool get isDay;/// Percent.
 int get humidity; double get dewPoint;/// km/h.
 double get windSpeed; double get windGusts;/// Degrees the wind comes from, 0 = north.
 int get windDirection; double get uvIndex;
/// Create a copy of WeatherNow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherNowCopyWith<WeatherNow> get copyWith => _$WeatherNowCopyWithImpl<WeatherNow>(this as WeatherNow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeatherNow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherNow&&(identical(other.temperature, _this.temperature) || other.temperature == _this.temperature)&&(identical(other.apparentTemperature, _this.apparentTemperature) || other.apparentTemperature == _this.apparentTemperature)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.isDay, _this.isDay) || other.isDay == _this.isDay)&&(identical(other.humidity, _this.humidity) || other.humidity == _this.humidity)&&(identical(other.dewPoint, _this.dewPoint) || other.dewPoint == _this.dewPoint)&&(identical(other.windSpeed, _this.windSpeed) || other.windSpeed == _this.windSpeed)&&(identical(other.windGusts, _this.windGusts) || other.windGusts == _this.windGusts)&&(identical(other.windDirection, _this.windDirection) || other.windDirection == _this.windDirection)&&(identical(other.uvIndex, _this.uvIndex) || other.uvIndex == _this.uvIndex));
}


@override
int get hashCode {
  final _this = this as WeatherNow;
  return Object.hash(runtimeType,_this.temperature,_this.apparentTemperature,_this.condition,_this.isDay,_this.humidity,_this.dewPoint,_this.windSpeed,_this.windGusts,_this.windDirection,_this.uvIndex);
}

@override
String toString() {
  final _this = this as WeatherNow;
  return 'WeatherNow(temperature: ${_this.temperature}, apparentTemperature: ${_this.apparentTemperature}, condition: ${_this.condition}, isDay: ${_this.isDay}, humidity: ${_this.humidity}, dewPoint: ${_this.dewPoint}, windSpeed: ${_this.windSpeed}, windGusts: ${_this.windGusts}, windDirection: ${_this.windDirection}, uvIndex: ${_this.uvIndex})';
}


}

/// @nodoc
abstract mixin class $WeatherNowCopyWith<$Res>  {
  factory $WeatherNowCopyWith(WeatherNow value, $Res Function(WeatherNow) _then) = _$WeatherNowCopyWithImpl;
@useResult
$Res call({
 double temperature, double apparentTemperature, WeatherCondition condition, bool isDay, int humidity, double dewPoint, double windSpeed, double windGusts, int windDirection, double uvIndex
});




}
/// @nodoc
class _$WeatherNowCopyWithImpl<$Res>
    implements $WeatherNowCopyWith<$Res> {
  _$WeatherNowCopyWithImpl(this._self, this._then);

  final WeatherNow _self;
  final $Res Function(WeatherNow) _then;

/// Create a copy of WeatherNow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperature = null,Object? apparentTemperature = null,Object? condition = null,Object? isDay = null,Object? humidity = null,Object? dewPoint = null,Object? windSpeed = null,Object? windGusts = null,Object? windDirection = null,Object? uvIndex = null,}) {
  return _then(WeatherNow(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,apparentTemperature: null == apparentTemperature ? _self.apparentTemperature : apparentTemperature // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,dewPoint: null == dewPoint ? _self.dewPoint : dewPoint // ignore: cast_nullable_to_non_nullable
as double,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,windGusts: null == windGusts ? _self.windGusts : windGusts // ignore: cast_nullable_to_non_nullable
as double,windDirection: null == windDirection ? _self.windDirection : windDirection // ignore: cast_nullable_to_non_nullable
as int,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherNow].
extension WeatherNowPatterns on WeatherNow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherNow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherNow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherNow value)  $default,){
final _that = this;
switch (_that) {
case _WeatherNow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherNow value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherNow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temperature,  double apparentTemperature,  WeatherCondition condition,  bool isDay,  int humidity,  double dewPoint,  double windSpeed,  double windGusts,  int windDirection,  double uvIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherNow() when $default != null:
return $default(_that.temperature,_that.apparentTemperature,_that.condition,_that.isDay,_that.humidity,_that.dewPoint,_that.windSpeed,_that.windGusts,_that.windDirection,_that.uvIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temperature,  double apparentTemperature,  WeatherCondition condition,  bool isDay,  int humidity,  double dewPoint,  double windSpeed,  double windGusts,  int windDirection,  double uvIndex)  $default,) {final _that = this;
switch (_that) {
case _WeatherNow():
return $default(_that.temperature,_that.apparentTemperature,_that.condition,_that.isDay,_that.humidity,_that.dewPoint,_that.windSpeed,_that.windGusts,_that.windDirection,_that.uvIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temperature,  double apparentTemperature,  WeatherCondition condition,  bool isDay,  int humidity,  double dewPoint,  double windSpeed,  double windGusts,  int windDirection,  double uvIndex)?  $default,) {final _that = this;
switch (_that) {
case _WeatherNow() when $default != null:
return $default(_that.temperature,_that.apparentTemperature,_that.condition,_that.isDay,_that.humidity,_that.dewPoint,_that.windSpeed,_that.windGusts,_that.windDirection,_that.uvIndex);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherNow implements WeatherNow {
  const _WeatherNow({required this.temperature, required this.apparentTemperature, required this.condition, required this.isDay, required this.humidity, required this.dewPoint, required this.windSpeed, required this.windGusts, required this.windDirection, required this.uvIndex});
  

@override final  double temperature;
@override final  double apparentTemperature;
@override final  WeatherCondition condition;
@override final  bool isDay;
/// Percent.
@override final  int humidity;
@override final  double dewPoint;
/// km/h.
@override final  double windSpeed;
@override final  double windGusts;
/// Degrees the wind comes from, 0 = north.
@override final  int windDirection;
@override final  double uvIndex;

/// Create a copy of WeatherNow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherNowCopyWith<_WeatherNow> get copyWith => __$WeatherNowCopyWithImpl<_WeatherNow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherNow&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.apparentTemperature, apparentTemperature) || other.apparentTemperature == apparentTemperature)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.dewPoint, dewPoint) || other.dewPoint == dewPoint)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.windGusts, windGusts) || other.windGusts == windGusts)&&(identical(other.windDirection, windDirection) || other.windDirection == windDirection)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,temperature,apparentTemperature,condition,isDay,humidity,dewPoint,windSpeed,windGusts,windDirection,uvIndex);
}

@override
String toString() {
    return 'WeatherNow(temperature: $temperature, apparentTemperature: $apparentTemperature, condition: $condition, isDay: $isDay, humidity: $humidity, dewPoint: $dewPoint, windSpeed: $windSpeed, windGusts: $windGusts, windDirection: $windDirection, uvIndex: $uvIndex)';
}


}

/// @nodoc
abstract mixin class _$WeatherNowCopyWith<$Res> implements $WeatherNowCopyWith<$Res> {
  factory _$WeatherNowCopyWith(_WeatherNow value, $Res Function(_WeatherNow) _then) = __$WeatherNowCopyWithImpl;
@override @useResult
$Res call({
 double temperature, double apparentTemperature, WeatherCondition condition, bool isDay, int humidity, double dewPoint, double windSpeed, double windGusts, int windDirection, double uvIndex
});




}
/// @nodoc
class __$WeatherNowCopyWithImpl<$Res>
    implements _$WeatherNowCopyWith<$Res> {
  __$WeatherNowCopyWithImpl(this._self, this._then);

  final _WeatherNow _self;
  final $Res Function(_WeatherNow) _then;

/// Create a copy of WeatherNow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperature = null,Object? apparentTemperature = null,Object? condition = null,Object? isDay = null,Object? humidity = null,Object? dewPoint = null,Object? windSpeed = null,Object? windGusts = null,Object? windDirection = null,Object? uvIndex = null,}) {
  return _then(_WeatherNow(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,apparentTemperature: null == apparentTemperature ? _self.apparentTemperature : apparentTemperature // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,dewPoint: null == dewPoint ? _self.dewPoint : dewPoint // ignore: cast_nullable_to_non_nullable
as double,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,windGusts: null == windGusts ? _self.windGusts : windGusts // ignore: cast_nullable_to_non_nullable
as double,windDirection: null == windDirection ? _self.windDirection : windDirection // ignore: cast_nullable_to_non_nullable
as int,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$WeatherHour {

 DateTime get time; double get temperature; WeatherCondition get condition; bool get isDay;/// Percent.
 int get precipitationProbability;/// mm.
 double get precipitation;/// km/h.
 double get windGusts;
/// Create a copy of WeatherHour
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherHourCopyWith<WeatherHour> get copyWith => _$WeatherHourCopyWithImpl<WeatherHour>(this as WeatherHour, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeatherHour;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherHour&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.temperature, _this.temperature) || other.temperature == _this.temperature)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.isDay, _this.isDay) || other.isDay == _this.isDay)&&(identical(other.precipitationProbability, _this.precipitationProbability) || other.precipitationProbability == _this.precipitationProbability)&&(identical(other.precipitation, _this.precipitation) || other.precipitation == _this.precipitation)&&(identical(other.windGusts, _this.windGusts) || other.windGusts == _this.windGusts));
}


@override
int get hashCode {
  final _this = this as WeatherHour;
  return Object.hash(runtimeType,_this.time,_this.temperature,_this.condition,_this.isDay,_this.precipitationProbability,_this.precipitation,_this.windGusts);
}

@override
String toString() {
  final _this = this as WeatherHour;
  return 'WeatherHour(time: ${_this.time}, temperature: ${_this.temperature}, condition: ${_this.condition}, isDay: ${_this.isDay}, precipitationProbability: ${_this.precipitationProbability}, precipitation: ${_this.precipitation}, windGusts: ${_this.windGusts})';
}


}

/// @nodoc
abstract mixin class $WeatherHourCopyWith<$Res>  {
  factory $WeatherHourCopyWith(WeatherHour value, $Res Function(WeatherHour) _then) = _$WeatherHourCopyWithImpl;
@useResult
$Res call({
 DateTime time, double temperature, WeatherCondition condition, bool isDay, int precipitationProbability, double precipitation, double windGusts
});




}
/// @nodoc
class _$WeatherHourCopyWithImpl<$Res>
    implements $WeatherHourCopyWith<$Res> {
  _$WeatherHourCopyWithImpl(this._self, this._then);

  final WeatherHour _self;
  final $Res Function(WeatherHour) _then;

/// Create a copy of WeatherHour
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature = null,Object? condition = null,Object? isDay = null,Object? precipitationProbability = null,Object? precipitation = null,Object? windGusts = null,}) {
  return _then(WeatherHour(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,windGusts: null == windGusts ? _self.windGusts : windGusts // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherHour].
extension WeatherHourPatterns on WeatherHour {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherHour value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherHour() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherHour value)  $default,){
final _that = this;
switch (_that) {
case _WeatherHour():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherHour value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherHour() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double temperature,  WeatherCondition condition,  bool isDay,  int precipitationProbability,  double precipitation,  double windGusts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherHour() when $default != null:
return $default(_that.time,_that.temperature,_that.condition,_that.isDay,_that.precipitationProbability,_that.precipitation,_that.windGusts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double temperature,  WeatherCondition condition,  bool isDay,  int precipitationProbability,  double precipitation,  double windGusts)  $default,) {final _that = this;
switch (_that) {
case _WeatherHour():
return $default(_that.time,_that.temperature,_that.condition,_that.isDay,_that.precipitationProbability,_that.precipitation,_that.windGusts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double temperature,  WeatherCondition condition,  bool isDay,  int precipitationProbability,  double precipitation,  double windGusts)?  $default,) {final _that = this;
switch (_that) {
case _WeatherHour() when $default != null:
return $default(_that.time,_that.temperature,_that.condition,_that.isDay,_that.precipitationProbability,_that.precipitation,_that.windGusts);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherHour implements WeatherHour {
  const _WeatherHour({required this.time, required this.temperature, required this.condition, required this.isDay, required this.precipitationProbability, required this.precipitation, required this.windGusts});
  

@override final  DateTime time;
@override final  double temperature;
@override final  WeatherCondition condition;
@override final  bool isDay;
/// Percent.
@override final  int precipitationProbability;
/// mm.
@override final  double precipitation;
/// km/h.
@override final  double windGusts;

/// Create a copy of WeatherHour
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherHourCopyWith<_WeatherHour> get copyWith => __$WeatherHourCopyWithImpl<_WeatherHour>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherHour&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.isDay, isDay) || other.isDay == isDay)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.precipitation, precipitation) || other.precipitation == precipitation)&&(identical(other.windGusts, windGusts) || other.windGusts == windGusts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,time,temperature,condition,isDay,precipitationProbability,precipitation,windGusts);
}

@override
String toString() {
    return 'WeatherHour(time: $time, temperature: $temperature, condition: $condition, isDay: $isDay, precipitationProbability: $precipitationProbability, precipitation: $precipitation, windGusts: $windGusts)';
}


}

/// @nodoc
abstract mixin class _$WeatherHourCopyWith<$Res> implements $WeatherHourCopyWith<$Res> {
  factory _$WeatherHourCopyWith(_WeatherHour value, $Res Function(_WeatherHour) _then) = __$WeatherHourCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double temperature, WeatherCondition condition, bool isDay, int precipitationProbability, double precipitation, double windGusts
});




}
/// @nodoc
class __$WeatherHourCopyWithImpl<$Res>
    implements _$WeatherHourCopyWith<$Res> {
  __$WeatherHourCopyWithImpl(this._self, this._then);

  final _WeatherHour _self;
  final $Res Function(_WeatherHour) _then;

/// Create a copy of WeatherHour
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature = null,Object? condition = null,Object? isDay = null,Object? precipitationProbability = null,Object? precipitation = null,Object? windGusts = null,}) {
  return _then(_WeatherHour(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,precipitation: null == precipitation ? _self.precipitation : precipitation // ignore: cast_nullable_to_non_nullable
as double,windGusts: null == windGusts ? _self.windGusts : windGusts // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$WeatherDay {

 DateTime get date; WeatherCondition get condition; double get maxTemperature; double get minTemperature;/// Percent.
 int get precipitationProbability;/// mm.
 double get precipitationSum; DateTime get sunrise; DateTime get sunset; double get uvIndexMax;
/// Create a copy of WeatherDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherDayCopyWith<WeatherDay> get copyWith => _$WeatherDayCopyWithImpl<WeatherDay>(this as WeatherDay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeatherDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherDay&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.maxTemperature, _this.maxTemperature) || other.maxTemperature == _this.maxTemperature)&&(identical(other.minTemperature, _this.minTemperature) || other.minTemperature == _this.minTemperature)&&(identical(other.precipitationProbability, _this.precipitationProbability) || other.precipitationProbability == _this.precipitationProbability)&&(identical(other.precipitationSum, _this.precipitationSum) || other.precipitationSum == _this.precipitationSum)&&(identical(other.sunrise, _this.sunrise) || other.sunrise == _this.sunrise)&&(identical(other.sunset, _this.sunset) || other.sunset == _this.sunset)&&(identical(other.uvIndexMax, _this.uvIndexMax) || other.uvIndexMax == _this.uvIndexMax));
}


@override
int get hashCode {
  final _this = this as WeatherDay;
  return Object.hash(runtimeType,_this.date,_this.condition,_this.maxTemperature,_this.minTemperature,_this.precipitationProbability,_this.precipitationSum,_this.sunrise,_this.sunset,_this.uvIndexMax);
}

@override
String toString() {
  final _this = this as WeatherDay;
  return 'WeatherDay(date: ${_this.date}, condition: ${_this.condition}, maxTemperature: ${_this.maxTemperature}, minTemperature: ${_this.minTemperature}, precipitationProbability: ${_this.precipitationProbability}, precipitationSum: ${_this.precipitationSum}, sunrise: ${_this.sunrise}, sunset: ${_this.sunset}, uvIndexMax: ${_this.uvIndexMax})';
}


}

/// @nodoc
abstract mixin class $WeatherDayCopyWith<$Res>  {
  factory $WeatherDayCopyWith(WeatherDay value, $Res Function(WeatherDay) _then) = _$WeatherDayCopyWithImpl;
@useResult
$Res call({
 DateTime date, WeatherCondition condition, double maxTemperature, double minTemperature, int precipitationProbability, double precipitationSum, DateTime sunrise, DateTime sunset, double uvIndexMax
});




}
/// @nodoc
class _$WeatherDayCopyWithImpl<$Res>
    implements $WeatherDayCopyWith<$Res> {
  _$WeatherDayCopyWithImpl(this._self, this._then);

  final WeatherDay _self;
  final $Res Function(WeatherDay) _then;

/// Create a copy of WeatherDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? condition = null,Object? maxTemperature = null,Object? minTemperature = null,Object? precipitationProbability = null,Object? precipitationSum = null,Object? sunrise = null,Object? sunset = null,Object? uvIndexMax = null,}) {
  return _then(WeatherDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,maxTemperature: null == maxTemperature ? _self.maxTemperature : maxTemperature // ignore: cast_nullable_to_non_nullable
as double,minTemperature: null == minTemperature ? _self.minTemperature : minTemperature // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,precipitationSum: null == precipitationSum ? _self.precipitationSum : precipitationSum // ignore: cast_nullable_to_non_nullable
as double,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,uvIndexMax: null == uvIndexMax ? _self.uvIndexMax : uvIndexMax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherDay].
extension WeatherDayPatterns on WeatherDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherDay value)  $default,){
final _that = this;
switch (_that) {
case _WeatherDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherDay value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  WeatherCondition condition,  double maxTemperature,  double minTemperature,  int precipitationProbability,  double precipitationSum,  DateTime sunrise,  DateTime sunset,  double uvIndexMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherDay() when $default != null:
return $default(_that.date,_that.condition,_that.maxTemperature,_that.minTemperature,_that.precipitationProbability,_that.precipitationSum,_that.sunrise,_that.sunset,_that.uvIndexMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  WeatherCondition condition,  double maxTemperature,  double minTemperature,  int precipitationProbability,  double precipitationSum,  DateTime sunrise,  DateTime sunset,  double uvIndexMax)  $default,) {final _that = this;
switch (_that) {
case _WeatherDay():
return $default(_that.date,_that.condition,_that.maxTemperature,_that.minTemperature,_that.precipitationProbability,_that.precipitationSum,_that.sunrise,_that.sunset,_that.uvIndexMax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  WeatherCondition condition,  double maxTemperature,  double minTemperature,  int precipitationProbability,  double precipitationSum,  DateTime sunrise,  DateTime sunset,  double uvIndexMax)?  $default,) {final _that = this;
switch (_that) {
case _WeatherDay() when $default != null:
return $default(_that.date,_that.condition,_that.maxTemperature,_that.minTemperature,_that.precipitationProbability,_that.precipitationSum,_that.sunrise,_that.sunset,_that.uvIndexMax);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherDay implements WeatherDay {
  const _WeatherDay({required this.date, required this.condition, required this.maxTemperature, required this.minTemperature, required this.precipitationProbability, required this.precipitationSum, required this.sunrise, required this.sunset, required this.uvIndexMax});
  

@override final  DateTime date;
@override final  WeatherCondition condition;
@override final  double maxTemperature;
@override final  double minTemperature;
/// Percent.
@override final  int precipitationProbability;
/// mm.
@override final  double precipitationSum;
@override final  DateTime sunrise;
@override final  DateTime sunset;
@override final  double uvIndexMax;

/// Create a copy of WeatherDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherDayCopyWith<_WeatherDay> get copyWith => __$WeatherDayCopyWithImpl<_WeatherDay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherDay&&(identical(other.date, date) || other.date == date)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.maxTemperature, maxTemperature) || other.maxTemperature == maxTemperature)&&(identical(other.minTemperature, minTemperature) || other.minTemperature == minTemperature)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.precipitationSum, precipitationSum) || other.precipitationSum == precipitationSum)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset)&&(identical(other.uvIndexMax, uvIndexMax) || other.uvIndexMax == uvIndexMax));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,condition,maxTemperature,minTemperature,precipitationProbability,precipitationSum,sunrise,sunset,uvIndexMax);
}

@override
String toString() {
    return 'WeatherDay(date: $date, condition: $condition, maxTemperature: $maxTemperature, minTemperature: $minTemperature, precipitationProbability: $precipitationProbability, precipitationSum: $precipitationSum, sunrise: $sunrise, sunset: $sunset, uvIndexMax: $uvIndexMax)';
}


}

/// @nodoc
abstract mixin class _$WeatherDayCopyWith<$Res> implements $WeatherDayCopyWith<$Res> {
  factory _$WeatherDayCopyWith(_WeatherDay value, $Res Function(_WeatherDay) _then) = __$WeatherDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, WeatherCondition condition, double maxTemperature, double minTemperature, int precipitationProbability, double precipitationSum, DateTime sunrise, DateTime sunset, double uvIndexMax
});




}
/// @nodoc
class __$WeatherDayCopyWithImpl<$Res>
    implements _$WeatherDayCopyWith<$Res> {
  __$WeatherDayCopyWithImpl(this._self, this._then);

  final _WeatherDay _self;
  final $Res Function(_WeatherDay) _then;

/// Create a copy of WeatherDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? condition = null,Object? maxTemperature = null,Object? minTemperature = null,Object? precipitationProbability = null,Object? precipitationSum = null,Object? sunrise = null,Object? sunset = null,Object? uvIndexMax = null,}) {
  return _then(_WeatherDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,maxTemperature: null == maxTemperature ? _self.maxTemperature : maxTemperature // ignore: cast_nullable_to_non_nullable
as double,minTemperature: null == minTemperature ? _self.minTemperature : minTemperature // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,precipitationSum: null == precipitationSum ? _self.precipitationSum : precipitationSum // ignore: cast_nullable_to_non_nullable
as double,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,uvIndexMax: null == uvIndexMax ? _self.uvIndexMax : uvIndexMax // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
