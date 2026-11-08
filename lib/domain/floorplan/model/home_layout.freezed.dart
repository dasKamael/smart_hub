// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeLayout {

 List<LayoutNode> get nodes; List<LayoutWall> get walls; List<LayoutOpening> get openings; List<LayoutRoom> get rooms; List<Furniture> get furniture;
/// Create a copy of HomeLayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeLayoutCopyWith<HomeLayout> get copyWith => _$HomeLayoutCopyWithImpl<HomeLayout>(this as HomeLayout, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeLayout;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLayout&&const DeepCollectionEquality().equals(other.nodes, _this.nodes)&&const DeepCollectionEquality().equals(other.walls, _this.walls)&&const DeepCollectionEquality().equals(other.openings, _this.openings)&&const DeepCollectionEquality().equals(other.rooms, _this.rooms)&&const DeepCollectionEquality().equals(other.furniture, _this.furniture));
}


@override
int get hashCode {
  final _this = this as HomeLayout;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.nodes),const DeepCollectionEquality().hash(_this.walls),const DeepCollectionEquality().hash(_this.openings),const DeepCollectionEquality().hash(_this.rooms),const DeepCollectionEquality().hash(_this.furniture));
}

@override
String toString() {
  final _this = this as HomeLayout;
  return 'HomeLayout(nodes: ${_this.nodes}, walls: ${_this.walls}, openings: ${_this.openings}, rooms: ${_this.rooms}, furniture: ${_this.furniture})';
}


}

/// @nodoc
abstract mixin class $HomeLayoutCopyWith<$Res>  {
  factory $HomeLayoutCopyWith(HomeLayout value, $Res Function(HomeLayout) _then) = _$HomeLayoutCopyWithImpl;
@useResult
$Res call({
 List<LayoutNode> nodes, List<LayoutWall> walls, List<LayoutOpening> openings, List<LayoutRoom> rooms, List<Furniture> furniture
});




}
/// @nodoc
class _$HomeLayoutCopyWithImpl<$Res>
    implements $HomeLayoutCopyWith<$Res> {
  _$HomeLayoutCopyWithImpl(this._self, this._then);

  final HomeLayout _self;
  final $Res Function(HomeLayout) _then;

/// Create a copy of HomeLayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodes = null,Object? walls = null,Object? openings = null,Object? rooms = null,Object? furniture = null,}) {
  return _then(HomeLayout(
nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<LayoutNode>,walls: null == walls ? _self.walls : walls // ignore: cast_nullable_to_non_nullable
as List<LayoutWall>,openings: null == openings ? _self.openings : openings // ignore: cast_nullable_to_non_nullable
as List<LayoutOpening>,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<LayoutRoom>,furniture: null == furniture ? _self.furniture : furniture // ignore: cast_nullable_to_non_nullable
as List<Furniture>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeLayout].
extension HomeLayoutPatterns on HomeLayout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeLayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeLayout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeLayout value)  $default,){
final _that = this;
switch (_that) {
case _HomeLayout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeLayout value)?  $default,){
final _that = this;
switch (_that) {
case _HomeLayout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LayoutNode> nodes,  List<LayoutWall> walls,  List<LayoutOpening> openings,  List<LayoutRoom> rooms,  List<Furniture> furniture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeLayout() when $default != null:
return $default(_that.nodes,_that.walls,_that.openings,_that.rooms,_that.furniture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LayoutNode> nodes,  List<LayoutWall> walls,  List<LayoutOpening> openings,  List<LayoutRoom> rooms,  List<Furniture> furniture)  $default,) {final _that = this;
switch (_that) {
case _HomeLayout():
return $default(_that.nodes,_that.walls,_that.openings,_that.rooms,_that.furniture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LayoutNode> nodes,  List<LayoutWall> walls,  List<LayoutOpening> openings,  List<LayoutRoom> rooms,  List<Furniture> furniture)?  $default,) {final _that = this;
switch (_that) {
case _HomeLayout() when $default != null:
return $default(_that.nodes,_that.walls,_that.openings,_that.rooms,_that.furniture);case _:
  return null;

}
}

}

/// @nodoc


class _HomeLayout implements HomeLayout {
  const _HomeLayout({ List<LayoutNode> nodes = const [],  List<LayoutWall> walls = const [],  List<LayoutOpening> openings = const [],  List<LayoutRoom> rooms = const [],  List<Furniture> furniture = const []}): _nodes = nodes,_walls = walls,_openings = openings,_rooms = rooms,_furniture = furniture;
  

 final  List<LayoutNode> _nodes;
@override@JsonKey() List<LayoutNode> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}

 final  List<LayoutWall> _walls;
@override@JsonKey() List<LayoutWall> get walls {
  if (_walls is EqualUnmodifiableListView) return _walls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_walls);
}

 final  List<LayoutOpening> _openings;
@override@JsonKey() List<LayoutOpening> get openings {
  if (_openings is EqualUnmodifiableListView) return _openings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openings);
}

 final  List<LayoutRoom> _rooms;
@override@JsonKey() List<LayoutRoom> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}

 final  List<Furniture> _furniture;
@override@JsonKey() List<Furniture> get furniture {
  if (_furniture is EqualUnmodifiableListView) return _furniture;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_furniture);
}


/// Create a copy of HomeLayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeLayoutCopyWith<_HomeLayout> get copyWith => __$HomeLayoutCopyWithImpl<_HomeLayout>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeLayout&&const DeepCollectionEquality().equals(other.nodes, _nodes)&&const DeepCollectionEquality().equals(other.walls, _walls)&&const DeepCollectionEquality().equals(other.openings, _openings)&&const DeepCollectionEquality().equals(other.rooms, _rooms)&&const DeepCollectionEquality().equals(other.furniture, _furniture));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_nodes),const DeepCollectionEquality().hash(_walls),const DeepCollectionEquality().hash(_openings),const DeepCollectionEquality().hash(_rooms),const DeepCollectionEquality().hash(_furniture));
}

@override
String toString() {
    return 'HomeLayout(nodes: $nodes, walls: $walls, openings: $openings, rooms: $rooms, furniture: $furniture)';
}


}

/// @nodoc
abstract mixin class _$HomeLayoutCopyWith<$Res> implements $HomeLayoutCopyWith<$Res> {
  factory _$HomeLayoutCopyWith(_HomeLayout value, $Res Function(_HomeLayout) _then) = __$HomeLayoutCopyWithImpl;
@override @useResult
$Res call({
 List<LayoutNode> nodes, List<LayoutWall> walls, List<LayoutOpening> openings, List<LayoutRoom> rooms, List<Furniture> furniture
});




}
/// @nodoc
class __$HomeLayoutCopyWithImpl<$Res>
    implements _$HomeLayoutCopyWith<$Res> {
  __$HomeLayoutCopyWithImpl(this._self, this._then);

  final _HomeLayout _self;
  final $Res Function(_HomeLayout) _then;

/// Create a copy of HomeLayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodes = null,Object? walls = null,Object? openings = null,Object? rooms = null,Object? furniture = null,}) {
  return _then(_HomeLayout(
nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<LayoutNode>,walls: null == walls ? _self._walls : walls // ignore: cast_nullable_to_non_nullable
as List<LayoutWall>,openings: null == openings ? _self._openings : openings // ignore: cast_nullable_to_non_nullable
as List<LayoutOpening>,rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<LayoutRoom>,furniture: null == furniture ? _self._furniture : furniture // ignore: cast_nullable_to_non_nullable
as List<Furniture>,
  ));
}


}

/// @nodoc
mixin _$LayoutNode {

 String get id; PlanPoint get position;
/// Create a copy of LayoutNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutNodeCopyWith<LayoutNode> get copyWith => _$LayoutNodeCopyWithImpl<LayoutNode>(this as LayoutNode, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LayoutNode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutNode&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.position, _this.position) || other.position == _this.position));
}


@override
int get hashCode {
  final _this = this as LayoutNode;
  return Object.hash(runtimeType,_this.id,_this.position);
}

@override
String toString() {
  final _this = this as LayoutNode;
  return 'LayoutNode(id: ${_this.id}, position: ${_this.position})';
}


}

/// @nodoc
abstract mixin class $LayoutNodeCopyWith<$Res>  {
  factory $LayoutNodeCopyWith(LayoutNode value, $Res Function(LayoutNode) _then) = _$LayoutNodeCopyWithImpl;
@useResult
$Res call({
 String id, PlanPoint position
});




}
/// @nodoc
class _$LayoutNodeCopyWithImpl<$Res>
    implements $LayoutNodeCopyWith<$Res> {
  _$LayoutNodeCopyWithImpl(this._self, this._then);

  final LayoutNode _self;
  final $Res Function(LayoutNode) _then;

/// Create a copy of LayoutNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? position = null,}) {
  return _then(LayoutNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutNode].
extension LayoutNodePatterns on LayoutNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutNode value)  $default,){
final _that = this;
switch (_that) {
case _LayoutNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutNode value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PlanPoint position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayoutNode() when $default != null:
return $default(_that.id,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PlanPoint position)  $default,) {final _that = this;
switch (_that) {
case _LayoutNode():
return $default(_that.id,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PlanPoint position)?  $default,) {final _that = this;
switch (_that) {
case _LayoutNode() when $default != null:
return $default(_that.id,_that.position);case _:
  return null;

}
}

}

/// @nodoc


class _LayoutNode implements LayoutNode {
  const _LayoutNode({required this.id, required this.position});
  

@override final  String id;
@override final  PlanPoint position;

/// Create a copy of LayoutNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutNodeCopyWith<_LayoutNode> get copyWith => __$LayoutNodeCopyWithImpl<_LayoutNode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutNode&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,position);
}

@override
String toString() {
    return 'LayoutNode(id: $id, position: $position)';
}


}

/// @nodoc
abstract mixin class _$LayoutNodeCopyWith<$Res> implements $LayoutNodeCopyWith<$Res> {
  factory _$LayoutNodeCopyWith(_LayoutNode value, $Res Function(_LayoutNode) _then) = __$LayoutNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, PlanPoint position
});




}
/// @nodoc
class __$LayoutNodeCopyWithImpl<$Res>
    implements _$LayoutNodeCopyWith<$Res> {
  __$LayoutNodeCopyWithImpl(this._self, this._then);

  final _LayoutNode _self;
  final $Res Function(_LayoutNode) _then;

/// Create a copy of LayoutNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,}) {
  return _then(_LayoutNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}


}

/// @nodoc
mixin _$LayoutWall {

 String get id; String get from; String get to; double get thickness;
/// Create a copy of LayoutWall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutWallCopyWith<LayoutWall> get copyWith => _$LayoutWallCopyWithImpl<LayoutWall>(this as LayoutWall, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LayoutWall;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutWall&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.thickness, _this.thickness) || other.thickness == _this.thickness));
}


@override
int get hashCode {
  final _this = this as LayoutWall;
  return Object.hash(runtimeType,_this.id,_this.from,_this.to,_this.thickness);
}

@override
String toString() {
  final _this = this as LayoutWall;
  return 'LayoutWall(id: ${_this.id}, from: ${_this.from}, to: ${_this.to}, thickness: ${_this.thickness})';
}


}

/// @nodoc
abstract mixin class $LayoutWallCopyWith<$Res>  {
  factory $LayoutWallCopyWith(LayoutWall value, $Res Function(LayoutWall) _then) = _$LayoutWallCopyWithImpl;
@useResult
$Res call({
 String id, String from, String to, double thickness
});




}
/// @nodoc
class _$LayoutWallCopyWithImpl<$Res>
    implements $LayoutWallCopyWith<$Res> {
  _$LayoutWallCopyWithImpl(this._self, this._then);

  final LayoutWall _self;
  final $Res Function(LayoutWall) _then;

/// Create a copy of LayoutWall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? from = null,Object? to = null,Object? thickness = null,}) {
  return _then(LayoutWall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,thickness: null == thickness ? _self.thickness : thickness // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutWall].
extension LayoutWallPatterns on LayoutWall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutWall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutWall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutWall value)  $default,){
final _that = this;
switch (_that) {
case _LayoutWall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutWall value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutWall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String from,  String to,  double thickness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayoutWall() when $default != null:
return $default(_that.id,_that.from,_that.to,_that.thickness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String from,  String to,  double thickness)  $default,) {final _that = this;
switch (_that) {
case _LayoutWall():
return $default(_that.id,_that.from,_that.to,_that.thickness);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String from,  String to,  double thickness)?  $default,) {final _that = this;
switch (_that) {
case _LayoutWall() when $default != null:
return $default(_that.id,_that.from,_that.to,_that.thickness);case _:
  return null;

}
}

}

/// @nodoc


class _LayoutWall extends LayoutWall {
  const _LayoutWall({required this.id, required this.from, required this.to, this.thickness = LayoutWall.innerThickness}): super._();
  

@override final  String id;
@override final  String from;
@override final  String to;
@override@JsonKey() final  double thickness;

/// Create a copy of LayoutWall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutWallCopyWith<_LayoutWall> get copyWith => __$LayoutWallCopyWithImpl<_LayoutWall>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutWall&&(identical(other.id, id) || other.id == id)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.thickness, thickness) || other.thickness == thickness));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,from,to,thickness);
}

@override
String toString() {
    return 'LayoutWall(id: $id, from: $from, to: $to, thickness: $thickness)';
}


}

/// @nodoc
abstract mixin class _$LayoutWallCopyWith<$Res> implements $LayoutWallCopyWith<$Res> {
  factory _$LayoutWallCopyWith(_LayoutWall value, $Res Function(_LayoutWall) _then) = __$LayoutWallCopyWithImpl;
@override @useResult
$Res call({
 String id, String from, String to, double thickness
});




}
/// @nodoc
class __$LayoutWallCopyWithImpl<$Res>
    implements _$LayoutWallCopyWith<$Res> {
  __$LayoutWallCopyWithImpl(this._self, this._then);

  final _LayoutWall _self;
  final $Res Function(_LayoutWall) _then;

/// Create a copy of LayoutWall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? from = null,Object? to = null,Object? thickness = null,}) {
  return _then(_LayoutWall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,thickness: null == thickness ? _self.thickness : thickness // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$LayoutOpening {

 String get id; String get wallId; DoorType get type; double get offset; double get width;/// Door swing, 0–3: which side the hinge is on and to which side of the wall the door opens.
 int get swing;
/// Create a copy of LayoutOpening
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutOpeningCopyWith<LayoutOpening> get copyWith => _$LayoutOpeningCopyWithImpl<LayoutOpening>(this as LayoutOpening, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LayoutOpening;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutOpening&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.wallId, _this.wallId) || other.wallId == _this.wallId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.offset, _this.offset) || other.offset == _this.offset)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.swing, _this.swing) || other.swing == _this.swing));
}


@override
int get hashCode {
  final _this = this as LayoutOpening;
  return Object.hash(runtimeType,_this.id,_this.wallId,_this.type,_this.offset,_this.width,_this.swing);
}

@override
String toString() {
  final _this = this as LayoutOpening;
  return 'LayoutOpening(id: ${_this.id}, wallId: ${_this.wallId}, type: ${_this.type}, offset: ${_this.offset}, width: ${_this.width}, swing: ${_this.swing})';
}


}

/// @nodoc
abstract mixin class $LayoutOpeningCopyWith<$Res>  {
  factory $LayoutOpeningCopyWith(LayoutOpening value, $Res Function(LayoutOpening) _then) = _$LayoutOpeningCopyWithImpl;
@useResult
$Res call({
 String id, String wallId, DoorType type, double offset, double width, int swing
});




}
/// @nodoc
class _$LayoutOpeningCopyWithImpl<$Res>
    implements $LayoutOpeningCopyWith<$Res> {
  _$LayoutOpeningCopyWithImpl(this._self, this._then);

  final LayoutOpening _self;
  final $Res Function(LayoutOpening) _then;

/// Create a copy of LayoutOpening
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? wallId = null,Object? type = null,Object? offset = null,Object? width = null,Object? swing = null,}) {
  return _then(LayoutOpening(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wallId: null == wallId ? _self.wallId : wallId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DoorType,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,swing: null == swing ? _self.swing : swing // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutOpening].
extension LayoutOpeningPatterns on LayoutOpening {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutOpening value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutOpening() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutOpening value)  $default,){
final _that = this;
switch (_that) {
case _LayoutOpening():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutOpening value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutOpening() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String wallId,  DoorType type,  double offset,  double width,  int swing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayoutOpening() when $default != null:
return $default(_that.id,_that.wallId,_that.type,_that.offset,_that.width,_that.swing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String wallId,  DoorType type,  double offset,  double width,  int swing)  $default,) {final _that = this;
switch (_that) {
case _LayoutOpening():
return $default(_that.id,_that.wallId,_that.type,_that.offset,_that.width,_that.swing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String wallId,  DoorType type,  double offset,  double width,  int swing)?  $default,) {final _that = this;
switch (_that) {
case _LayoutOpening() when $default != null:
return $default(_that.id,_that.wallId,_that.type,_that.offset,_that.width,_that.swing);case _:
  return null;

}
}

}

/// @nodoc


class _LayoutOpening implements LayoutOpening {
  const _LayoutOpening({required this.id, required this.wallId, required this.type, required this.offset, required this.width, this.swing = 0});
  

@override final  String id;
@override final  String wallId;
@override final  DoorType type;
@override final  double offset;
@override final  double width;
/// Door swing, 0–3: which side the hinge is on and to which side of the wall the door opens.
@override@JsonKey() final  int swing;

/// Create a copy of LayoutOpening
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutOpeningCopyWith<_LayoutOpening> get copyWith => __$LayoutOpeningCopyWithImpl<_LayoutOpening>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutOpening&&(identical(other.id, id) || other.id == id)&&(identical(other.wallId, wallId) || other.wallId == wallId)&&(identical(other.type, type) || other.type == type)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.width, width) || other.width == width)&&(identical(other.swing, swing) || other.swing == swing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,wallId,type,offset,width,swing);
}

@override
String toString() {
    return 'LayoutOpening(id: $id, wallId: $wallId, type: $type, offset: $offset, width: $width, swing: $swing)';
}


}

/// @nodoc
abstract mixin class _$LayoutOpeningCopyWith<$Res> implements $LayoutOpeningCopyWith<$Res> {
  factory _$LayoutOpeningCopyWith(_LayoutOpening value, $Res Function(_LayoutOpening) _then) = __$LayoutOpeningCopyWithImpl;
@override @useResult
$Res call({
 String id, String wallId, DoorType type, double offset, double width, int swing
});




}
/// @nodoc
class __$LayoutOpeningCopyWithImpl<$Res>
    implements _$LayoutOpeningCopyWith<$Res> {
  __$LayoutOpeningCopyWithImpl(this._self, this._then);

  final _LayoutOpening _self;
  final $Res Function(_LayoutOpening) _then;

/// Create a copy of LayoutOpening
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wallId = null,Object? type = null,Object? offset = null,Object? width = null,Object? swing = null,}) {
  return _then(_LayoutOpening(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,wallId: null == wallId ? _self.wallId : wallId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DoorType,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,swing: null == swing ? _self.swing : swing // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LayoutRoom {

 String get id; String get name; RoomType get type; PlanPoint get anchor;
/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutRoomCopyWith<LayoutRoom> get copyWith => _$LayoutRoomCopyWithImpl<LayoutRoom>(this as LayoutRoom, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LayoutRoom;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutRoom&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.anchor, _this.anchor) || other.anchor == _this.anchor));
}


@override
int get hashCode {
  final _this = this as LayoutRoom;
  return Object.hash(runtimeType,_this.id,_this.name,_this.type,_this.anchor);
}

@override
String toString() {
  final _this = this as LayoutRoom;
  return 'LayoutRoom(id: ${_this.id}, name: ${_this.name}, type: ${_this.type}, anchor: ${_this.anchor})';
}


}

/// @nodoc
abstract mixin class $LayoutRoomCopyWith<$Res>  {
  factory $LayoutRoomCopyWith(LayoutRoom value, $Res Function(LayoutRoom) _then) = _$LayoutRoomCopyWithImpl;
@useResult
$Res call({
 String id, String name, RoomType type, PlanPoint anchor
});




}
/// @nodoc
class _$LayoutRoomCopyWithImpl<$Res>
    implements $LayoutRoomCopyWith<$Res> {
  _$LayoutRoomCopyWithImpl(this._self, this._then);

  final LayoutRoom _self;
  final $Res Function(LayoutRoom) _then;

/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? anchor = null,}) {
  return _then(LayoutRoom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoomType,anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutRoom].
extension LayoutRoomPatterns on LayoutRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutRoom value)  $default,){
final _that = this;
switch (_that) {
case _LayoutRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutRoom value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  RoomType type,  PlanPoint anchor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.anchor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  RoomType type,  PlanPoint anchor)  $default,) {final _that = this;
switch (_that) {
case _LayoutRoom():
return $default(_that.id,_that.name,_that.type,_that.anchor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  RoomType type,  PlanPoint anchor)?  $default,) {final _that = this;
switch (_that) {
case _LayoutRoom() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.anchor);case _:
  return null;

}
}

}

/// @nodoc


class _LayoutRoom implements LayoutRoom {
  const _LayoutRoom({required this.id, required this.name, this.type = RoomType.other, required this.anchor});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  RoomType type;
@override final  PlanPoint anchor;

/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutRoomCopyWith<_LayoutRoom> get copyWith => __$LayoutRoomCopyWithImpl<_LayoutRoom>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutRoom&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.anchor, anchor) || other.anchor == anchor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,type,anchor);
}

@override
String toString() {
    return 'LayoutRoom(id: $id, name: $name, type: $type, anchor: $anchor)';
}


}

/// @nodoc
abstract mixin class _$LayoutRoomCopyWith<$Res> implements $LayoutRoomCopyWith<$Res> {
  factory _$LayoutRoomCopyWith(_LayoutRoom value, $Res Function(_LayoutRoom) _then) = __$LayoutRoomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, RoomType type, PlanPoint anchor
});




}
/// @nodoc
class __$LayoutRoomCopyWithImpl<$Res>
    implements _$LayoutRoomCopyWith<$Res> {
  __$LayoutRoomCopyWithImpl(this._self, this._then);

  final _LayoutRoom _self;
  final $Res Function(_LayoutRoom) _then;

/// Create a copy of LayoutRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? anchor = null,}) {
  return _then(_LayoutRoom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoomType,anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as PlanPoint,
  ));
}


}

/// @nodoc
mixin _$Furniture {

 String get id; FurnitureKind get kind; PlanPoint get position; double get rotation; double get width; double get depth;
/// Create a copy of Furniture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FurnitureCopyWith<Furniture> get copyWith => _$FurnitureCopyWithImpl<Furniture>(this as Furniture, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Furniture;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Furniture&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.rotation, _this.rotation) || other.rotation == _this.rotation)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.depth, _this.depth) || other.depth == _this.depth));
}


@override
int get hashCode {
  final _this = this as Furniture;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.position,_this.rotation,_this.width,_this.depth);
}

@override
String toString() {
  final _this = this as Furniture;
  return 'Furniture(id: ${_this.id}, kind: ${_this.kind}, position: ${_this.position}, rotation: ${_this.rotation}, width: ${_this.width}, depth: ${_this.depth})';
}


}

/// @nodoc
abstract mixin class $FurnitureCopyWith<$Res>  {
  factory $FurnitureCopyWith(Furniture value, $Res Function(Furniture) _then) = _$FurnitureCopyWithImpl;
@useResult
$Res call({
 String id, FurnitureKind kind, PlanPoint position, double rotation, double width, double depth
});




}
/// @nodoc
class _$FurnitureCopyWithImpl<$Res>
    implements $FurnitureCopyWith<$Res> {
  _$FurnitureCopyWithImpl(this._self, this._then);

  final Furniture _self;
  final $Res Function(Furniture) _then;

/// Create a copy of Furniture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? position = null,Object? rotation = null,Object? width = null,Object? depth = null,}) {
  return _then(Furniture(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FurnitureKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Furniture].
extension FurniturePatterns on Furniture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Furniture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Furniture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Furniture value)  $default,){
final _that = this;
switch (_that) {
case _Furniture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Furniture value)?  $default,){
final _that = this;
switch (_that) {
case _Furniture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FurnitureKind kind,  PlanPoint position,  double rotation,  double width,  double depth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Furniture() when $default != null:
return $default(_that.id,_that.kind,_that.position,_that.rotation,_that.width,_that.depth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FurnitureKind kind,  PlanPoint position,  double rotation,  double width,  double depth)  $default,) {final _that = this;
switch (_that) {
case _Furniture():
return $default(_that.id,_that.kind,_that.position,_that.rotation,_that.width,_that.depth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FurnitureKind kind,  PlanPoint position,  double rotation,  double width,  double depth)?  $default,) {final _that = this;
switch (_that) {
case _Furniture() when $default != null:
return $default(_that.id,_that.kind,_that.position,_that.rotation,_that.width,_that.depth);case _:
  return null;

}
}

}

/// @nodoc


class _Furniture implements Furniture {
  const _Furniture({required this.id, required this.kind, required this.position, this.rotation = 0, required this.width, required this.depth});
  

@override final  String id;
@override final  FurnitureKind kind;
@override final  PlanPoint position;
@override@JsonKey() final  double rotation;
@override final  double width;
@override final  double depth;

/// Create a copy of Furniture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FurnitureCopyWith<_Furniture> get copyWith => __$FurnitureCopyWithImpl<_Furniture>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Furniture&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.width, width) || other.width == width)&&(identical(other.depth, depth) || other.depth == depth));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,position,rotation,width,depth);
}

@override
String toString() {
    return 'Furniture(id: $id, kind: $kind, position: $position, rotation: $rotation, width: $width, depth: $depth)';
}


}

/// @nodoc
abstract mixin class _$FurnitureCopyWith<$Res> implements $FurnitureCopyWith<$Res> {
  factory _$FurnitureCopyWith(_Furniture value, $Res Function(_Furniture) _then) = __$FurnitureCopyWithImpl;
@override @useResult
$Res call({
 String id, FurnitureKind kind, PlanPoint position, double rotation, double width, double depth
});




}
/// @nodoc
class __$FurnitureCopyWithImpl<$Res>
    implements _$FurnitureCopyWith<$Res> {
  __$FurnitureCopyWithImpl(this._self, this._then);

  final _Furniture _self;
  final $Res Function(_Furniture) _then;

/// Create a copy of Furniture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? position = null,Object? rotation = null,Object? width = null,Object? depth = null,}) {
  return _then(_Furniture(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FurnitureKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
