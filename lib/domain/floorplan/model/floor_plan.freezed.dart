// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floor_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FloorPlan {

 List<Room> get rooms; List<Wall> get walls; List<Door> get doors;
/// Create a copy of FloorPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorPlanCopyWith<FloorPlan> get copyWith => _$FloorPlanCopyWithImpl<FloorPlan>(this as FloorPlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FloorPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorPlan&&const DeepCollectionEquality().equals(other.rooms, _this.rooms)&&const DeepCollectionEquality().equals(other.walls, _this.walls)&&const DeepCollectionEquality().equals(other.doors, _this.doors));
}


@override
int get hashCode {
  final _this = this as FloorPlan;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.rooms),const DeepCollectionEquality().hash(_this.walls),const DeepCollectionEquality().hash(_this.doors));
}

@override
String toString() {
  final _this = this as FloorPlan;
  return 'FloorPlan(rooms: ${_this.rooms}, walls: ${_this.walls}, doors: ${_this.doors})';
}


}

/// @nodoc
abstract mixin class $FloorPlanCopyWith<$Res>  {
  factory $FloorPlanCopyWith(FloorPlan value, $Res Function(FloorPlan) _then) = _$FloorPlanCopyWithImpl;
@useResult
$Res call({
 List<Room> rooms, List<Wall> walls, List<Door> doors
});




}
/// @nodoc
class _$FloorPlanCopyWithImpl<$Res>
    implements $FloorPlanCopyWith<$Res> {
  _$FloorPlanCopyWithImpl(this._self, this._then);

  final FloorPlan _self;
  final $Res Function(FloorPlan) _then;

/// Create a copy of FloorPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rooms = null,Object? walls = null,Object? doors = null,}) {
  return _then(FloorPlan(
rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<Room>,walls: null == walls ? _self.walls : walls // ignore: cast_nullable_to_non_nullable
as List<Wall>,doors: null == doors ? _self.doors : doors // ignore: cast_nullable_to_non_nullable
as List<Door>,
  ));
}

}


/// Adds pattern-matching-related methods to [FloorPlan].
extension FloorPlanPatterns on FloorPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloorPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloorPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloorPlan value)  $default,){
final _that = this;
switch (_that) {
case _FloorPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloorPlan value)?  $default,){
final _that = this;
switch (_that) {
case _FloorPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Room> rooms,  List<Wall> walls,  List<Door> doors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorPlan() when $default != null:
return $default(_that.rooms,_that.walls,_that.doors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Room> rooms,  List<Wall> walls,  List<Door> doors)  $default,) {final _that = this;
switch (_that) {
case _FloorPlan():
return $default(_that.rooms,_that.walls,_that.doors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Room> rooms,  List<Wall> walls,  List<Door> doors)?  $default,) {final _that = this;
switch (_that) {
case _FloorPlan() when $default != null:
return $default(_that.rooms,_that.walls,_that.doors);case _:
  return null;

}
}

}

/// @nodoc


class _FloorPlan implements FloorPlan {
  const _FloorPlan({required  List<Room> rooms,  List<Wall> walls = const [],  List<Door> doors = const []}): _rooms = rooms,_walls = walls,_doors = doors;
  

 final  List<Room> _rooms;
@override List<Room> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}

 final  List<Wall> _walls;
@override@JsonKey() List<Wall> get walls {
  if (_walls is EqualUnmodifiableListView) return _walls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_walls);
}

 final  List<Door> _doors;
@override@JsonKey() List<Door> get doors {
  if (_doors is EqualUnmodifiableListView) return _doors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_doors);
}


/// Create a copy of FloorPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorPlanCopyWith<_FloorPlan> get copyWith => __$FloorPlanCopyWithImpl<_FloorPlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorPlan&&const DeepCollectionEquality().equals(other.rooms, _rooms)&&const DeepCollectionEquality().equals(other.walls, _walls)&&const DeepCollectionEquality().equals(other.doors, _doors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_rooms),const DeepCollectionEquality().hash(_walls),const DeepCollectionEquality().hash(_doors));
}

@override
String toString() {
    return 'FloorPlan(rooms: $rooms, walls: $walls, doors: $doors)';
}


}

/// @nodoc
abstract mixin class _$FloorPlanCopyWith<$Res> implements $FloorPlanCopyWith<$Res> {
  factory _$FloorPlanCopyWith(_FloorPlan value, $Res Function(_FloorPlan) _then) = __$FloorPlanCopyWithImpl;
@override @useResult
$Res call({
 List<Room> rooms, List<Wall> walls, List<Door> doors
});




}
/// @nodoc
class __$FloorPlanCopyWithImpl<$Res>
    implements _$FloorPlanCopyWith<$Res> {
  __$FloorPlanCopyWithImpl(this._self, this._then);

  final _FloorPlan _self;
  final $Res Function(_FloorPlan) _then;

/// Create a copy of FloorPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rooms = null,Object? walls = null,Object? doors = null,}) {
  return _then(_FloorPlan(
rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<Room>,walls: null == walls ? _self._walls : walls // ignore: cast_nullable_to_non_nullable
as List<Wall>,doors: null == doors ? _self._doors : doors // ignore: cast_nullable_to_non_nullable
as List<Door>,
  ));
}


}

/// @nodoc
mixin _$Room {

 String get id; String get name; List<PlanPoint> get polygon;
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCopyWith<Room> get copyWith => _$RoomCopyWithImpl<Room>(this as Room, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Room;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Room&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.polygon, _this.polygon));
}


@override
int get hashCode {
  final _this = this as Room;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.polygon));
}

@override
String toString() {
  final _this = this as Room;
  return 'Room(id: ${_this.id}, name: ${_this.name}, polygon: ${_this.polygon})';
}


}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res>  {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) = _$RoomCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<PlanPoint> polygon
});




}
/// @nodoc
class _$RoomCopyWithImpl<$Res>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? polygon = null,}) {
  return _then(Room(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,polygon: null == polygon ? _self.polygon : polygon // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [Room].
extension RoomPatterns on Room {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Room value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Room value)  $default,){
final _that = this;
switch (_that) {
case _Room():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Room value)?  $default,){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<PlanPoint> polygon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.name,_that.polygon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<PlanPoint> polygon)  $default,) {final _that = this;
switch (_that) {
case _Room():
return $default(_that.id,_that.name,_that.polygon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<PlanPoint> polygon)?  $default,) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.name,_that.polygon);case _:
  return null;

}
}

}

/// @nodoc


class _Room implements Room {
  const _Room({required this.id, required this.name, required  List<PlanPoint> polygon}): _polygon = polygon;
  

@override final  String id;
@override final  String name;
 final  List<PlanPoint> _polygon;
@override List<PlanPoint> get polygon {
  if (_polygon is EqualUnmodifiableListView) return _polygon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polygon);
}


/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCopyWith<_Room> get copyWith => __$RoomCopyWithImpl<_Room>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Room&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.polygon, _polygon));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_polygon));
}

@override
String toString() {
    return 'Room(id: $id, name: $name, polygon: $polygon)';
}


}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) = __$RoomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<PlanPoint> polygon
});




}
/// @nodoc
class __$RoomCopyWithImpl<$Res>
    implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? polygon = null,}) {
  return _then(_Room(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,polygon: null == polygon ? _self._polygon : polygon // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,
  ));
}


}

/// @nodoc
mixin _$Wall {

 String get id; List<PlanPoint> get polygon;
/// Create a copy of Wall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WallCopyWith<Wall> get copyWith => _$WallCopyWithImpl<Wall>(this as Wall, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Wall;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wall&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.polygon, _this.polygon));
}


@override
int get hashCode {
  final _this = this as Wall;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.polygon));
}

@override
String toString() {
  final _this = this as Wall;
  return 'Wall(id: ${_this.id}, polygon: ${_this.polygon})';
}


}

/// @nodoc
abstract mixin class $WallCopyWith<$Res>  {
  factory $WallCopyWith(Wall value, $Res Function(Wall) _then) = _$WallCopyWithImpl;
@useResult
$Res call({
 String id, List<PlanPoint> polygon
});




}
/// @nodoc
class _$WallCopyWithImpl<$Res>
    implements $WallCopyWith<$Res> {
  _$WallCopyWithImpl(this._self, this._then);

  final Wall _self;
  final $Res Function(Wall) _then;

/// Create a copy of Wall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? polygon = null,}) {
  return _then(Wall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,polygon: null == polygon ? _self.polygon : polygon // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [Wall].
extension WallPatterns on Wall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wall value)  $default,){
final _that = this;
switch (_that) {
case _Wall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wall value)?  $default,){
final _that = this;
switch (_that) {
case _Wall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<PlanPoint> polygon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wall() when $default != null:
return $default(_that.id,_that.polygon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<PlanPoint> polygon)  $default,) {final _that = this;
switch (_that) {
case _Wall():
return $default(_that.id,_that.polygon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<PlanPoint> polygon)?  $default,) {final _that = this;
switch (_that) {
case _Wall() when $default != null:
return $default(_that.id,_that.polygon);case _:
  return null;

}
}

}

/// @nodoc


class _Wall implements Wall {
  const _Wall({required this.id, required  List<PlanPoint> polygon}): _polygon = polygon;
  

@override final  String id;
 final  List<PlanPoint> _polygon;
@override List<PlanPoint> get polygon {
  if (_polygon is EqualUnmodifiableListView) return _polygon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polygon);
}


/// Create a copy of Wall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WallCopyWith<_Wall> get copyWith => __$WallCopyWithImpl<_Wall>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wall&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.polygon, _polygon));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_polygon));
}

@override
String toString() {
    return 'Wall(id: $id, polygon: $polygon)';
}


}

/// @nodoc
abstract mixin class _$WallCopyWith<$Res> implements $WallCopyWith<$Res> {
  factory _$WallCopyWith(_Wall value, $Res Function(_Wall) _then) = __$WallCopyWithImpl;
@override @useResult
$Res call({
 String id, List<PlanPoint> polygon
});




}
/// @nodoc
class __$WallCopyWithImpl<$Res>
    implements _$WallCopyWith<$Res> {
  __$WallCopyWithImpl(this._self, this._then);

  final _Wall _self;
  final $Res Function(_Wall) _then;

/// Create a copy of Wall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? polygon = null,}) {
  return _then(_Wall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,polygon: null == polygon ? _self._polygon : polygon // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,
  ));
}


}

/// @nodoc
mixin _$Door {

 String get id; DoorType get type; PlanPoint get a; PlanPoint get b;
/// Create a copy of Door
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoorCopyWith<Door> get copyWith => _$DoorCopyWithImpl<Door>(this as Door, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Door;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Door&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.a, _this.a) || other.a == _this.a)&&(identical(other.b, _this.b) || other.b == _this.b));
}


@override
int get hashCode {
  final _this = this as Door;
  return Object.hash(runtimeType,_this.id,_this.type,_this.a,_this.b);
}

@override
String toString() {
  final _this = this as Door;
  return 'Door(id: ${_this.id}, type: ${_this.type}, a: ${_this.a}, b: ${_this.b})';
}


}

/// @nodoc
abstract mixin class $DoorCopyWith<$Res>  {
  factory $DoorCopyWith(Door value, $Res Function(Door) _then) = _$DoorCopyWithImpl;
@useResult
$Res call({
 String id, DoorType type, PlanPoint a, PlanPoint b
});




}
/// @nodoc
class _$DoorCopyWithImpl<$Res>
    implements $DoorCopyWith<$Res> {
  _$DoorCopyWithImpl(this._self, this._then);

  final Door _self;
  final $Res Function(Door) _then;

/// Create a copy of Door
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? a = null,Object? b = null,}) {
  return _then(Door(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DoorType,a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as PlanPoint,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}

}


/// Adds pattern-matching-related methods to [Door].
extension DoorPatterns on Door {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Door value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Door() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Door value)  $default,){
final _that = this;
switch (_that) {
case _Door():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Door value)?  $default,){
final _that = this;
switch (_that) {
case _Door() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DoorType type,  PlanPoint a,  PlanPoint b)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Door() when $default != null:
return $default(_that.id,_that.type,_that.a,_that.b);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DoorType type,  PlanPoint a,  PlanPoint b)  $default,) {final _that = this;
switch (_that) {
case _Door():
return $default(_that.id,_that.type,_that.a,_that.b);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DoorType type,  PlanPoint a,  PlanPoint b)?  $default,) {final _that = this;
switch (_that) {
case _Door() when $default != null:
return $default(_that.id,_that.type,_that.a,_that.b);case _:
  return null;

}
}

}

/// @nodoc


class _Door implements Door {
  const _Door({required this.id, required this.type, required this.a, required this.b});
  

@override final  String id;
@override final  DoorType type;
@override final  PlanPoint a;
@override final  PlanPoint b;

/// Create a copy of Door
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoorCopyWith<_Door> get copyWith => __$DoorCopyWithImpl<_Door>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Door&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.a, a) || other.a == a)&&(identical(other.b, b) || other.b == b));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,a,b);
}

@override
String toString() {
    return 'Door(id: $id, type: $type, a: $a, b: $b)';
}


}

/// @nodoc
abstract mixin class _$DoorCopyWith<$Res> implements $DoorCopyWith<$Res> {
  factory _$DoorCopyWith(_Door value, $Res Function(_Door) _then) = __$DoorCopyWithImpl;
@override @useResult
$Res call({
 String id, DoorType type, PlanPoint a, PlanPoint b
});




}
/// @nodoc
class __$DoorCopyWithImpl<$Res>
    implements _$DoorCopyWith<$Res> {
  __$DoorCopyWithImpl(this._self, this._then);

  final _Door _self;
  final $Res Function(_Door) _then;

/// Create a copy of Door
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? a = null,Object? b = null,}) {
  return _then(_Door(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DoorType,a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as PlanPoint,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}


}

// dart format on
