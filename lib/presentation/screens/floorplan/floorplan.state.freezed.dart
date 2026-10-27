// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floorplan.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlanSelection {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanSelection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PlanSelection()';
}


}

/// @nodoc
class $PlanSelectionCopyWith<$Res>  {
$PlanSelectionCopyWith(PlanSelection _, $Res Function(PlanSelection) __);
}


/// Adds pattern-matching-related methods to [PlanSelection].
extension PlanSelectionPatterns on PlanSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoSelection value)?  none,TResult Function( RoomSelection value)?  room,TResult Function( DeviceSelection value)?  device,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoSelection() when none != null:
return none(_that);case RoomSelection() when room != null:
return room(_that);case DeviceSelection() when device != null:
return device(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoSelection value)  none,required TResult Function( RoomSelection value)  room,required TResult Function( DeviceSelection value)  device,}){
final _that = this;
switch (_that) {
case NoSelection():
return none(_that);case RoomSelection():
return room(_that);case DeviceSelection():
return device(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoSelection value)?  none,TResult? Function( RoomSelection value)?  room,TResult? Function( DeviceSelection value)?  device,}){
final _that = this;
switch (_that) {
case NoSelection() when none != null:
return none(_that);case RoomSelection() when room != null:
return room(_that);case DeviceSelection() when device != null:
return device(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  none,TResult Function( String roomId)?  room,TResult Function( String deviceId)?  device,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoSelection() when none != null:
return none();case RoomSelection() when room != null:
return room(_that.roomId);case DeviceSelection() when device != null:
return device(_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  none,required TResult Function( String roomId)  room,required TResult Function( String deviceId)  device,}) {final _that = this;
switch (_that) {
case NoSelection():
return none();case RoomSelection():
return room(_that.roomId);case DeviceSelection():
return device(_that.deviceId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  none,TResult? Function( String roomId)?  room,TResult? Function( String deviceId)?  device,}) {final _that = this;
switch (_that) {
case NoSelection() when none != null:
return none();case RoomSelection() when room != null:
return room(_that.roomId);case DeviceSelection() when device != null:
return device(_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc


class NoSelection implements PlanSelection {
  const NoSelection();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NoSelection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PlanSelection.none()';
}


}




/// @nodoc


class RoomSelection implements PlanSelection {
  const RoomSelection(this.roomId);
  

 final  String roomId;

/// Create a copy of PlanSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSelectionCopyWith<RoomSelection> get copyWith => _$RoomSelectionCopyWithImpl<RoomSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSelection&&(identical(other.roomId, roomId) || other.roomId == roomId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,roomId);
}

@override
String toString() {
    return 'PlanSelection.room(roomId: $roomId)';
}


}

/// @nodoc
abstract mixin class $RoomSelectionCopyWith<$Res> implements $PlanSelectionCopyWith<$Res> {
  factory $RoomSelectionCopyWith(RoomSelection value, $Res Function(RoomSelection) _then) = _$RoomSelectionCopyWithImpl;
@useResult
$Res call({
 String roomId
});




}
/// @nodoc
class _$RoomSelectionCopyWithImpl<$Res>
    implements $RoomSelectionCopyWith<$Res> {
  _$RoomSelectionCopyWithImpl(this._self, this._then);

  final RoomSelection _self;
  final $Res Function(RoomSelection) _then;

/// Create a copy of PlanSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roomId = null,}) {
  return _then(RoomSelection(
null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeviceSelection implements PlanSelection {
  const DeviceSelection(this.deviceId);
  

 final  String deviceId;

/// Create a copy of PlanSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSelectionCopyWith<DeviceSelection> get copyWith => _$DeviceSelectionCopyWithImpl<DeviceSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSelection&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId);
}

@override
String toString() {
    return 'PlanSelection.device(deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $DeviceSelectionCopyWith<$Res> implements $PlanSelectionCopyWith<$Res> {
  factory $DeviceSelectionCopyWith(DeviceSelection value, $Res Function(DeviceSelection) _then) = _$DeviceSelectionCopyWithImpl;
@useResult
$Res call({
 String deviceId
});




}
/// @nodoc
class _$DeviceSelectionCopyWithImpl<$Res>
    implements $DeviceSelectionCopyWith<$Res> {
  _$DeviceSelectionCopyWithImpl(this._self, this._then);

  final DeviceSelection _self;
  final $Res Function(DeviceSelection) _then;

/// Create a copy of PlanSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceId = null,}) {
  return _then(DeviceSelection(
null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PlanDrag {

 String get deviceId; DeviceKind get kind;/// Position under the finger in cm; `null` while a device from the tray is not over the plan yet.
 PlanPoint? get position;/// Device the dragged one would be grouped with when dropped now.
 String? get targetId;
/// Create a copy of PlanDrag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanDragCopyWith<PlanDrag> get copyWith => _$PlanDragCopyWithImpl<PlanDrag>(this as PlanDrag, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlanDrag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanDrag&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId));
}


@override
int get hashCode {
  final _this = this as PlanDrag;
  return Object.hash(runtimeType,_this.deviceId,_this.kind,_this.position,_this.targetId);
}

@override
String toString() {
  final _this = this as PlanDrag;
  return 'PlanDrag(deviceId: ${_this.deviceId}, kind: ${_this.kind}, position: ${_this.position}, targetId: ${_this.targetId})';
}


}

/// @nodoc
abstract mixin class $PlanDragCopyWith<$Res>  {
  factory $PlanDragCopyWith(PlanDrag value, $Res Function(PlanDrag) _then) = _$PlanDragCopyWithImpl;
@useResult
$Res call({
 String deviceId, DeviceKind kind, PlanPoint? position, String? targetId
});




}
/// @nodoc
class _$PlanDragCopyWithImpl<$Res>
    implements $PlanDragCopyWith<$Res> {
  _$PlanDragCopyWithImpl(this._self, this._then);

  final PlanDrag _self;
  final $Res Function(PlanDrag) _then;

/// Create a copy of PlanDrag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? kind = null,Object? position = freezed,Object? targetId = freezed,}) {
  return _then(PlanDrag(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanDrag].
extension PlanDragPatterns on PlanDrag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanDrag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanDrag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanDrag value)  $default,){
final _that = this;
switch (_that) {
case _PlanDrag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanDrag value)?  $default,){
final _that = this;
switch (_that) {
case _PlanDrag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  DeviceKind kind,  PlanPoint? position,  String? targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanDrag() when $default != null:
return $default(_that.deviceId,_that.kind,_that.position,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  DeviceKind kind,  PlanPoint? position,  String? targetId)  $default,) {final _that = this;
switch (_that) {
case _PlanDrag():
return $default(_that.deviceId,_that.kind,_that.position,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  DeviceKind kind,  PlanPoint? position,  String? targetId)?  $default,) {final _that = this;
switch (_that) {
case _PlanDrag() when $default != null:
return $default(_that.deviceId,_that.kind,_that.position,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc


class _PlanDrag implements PlanDrag {
  const _PlanDrag({required this.deviceId, required this.kind, this.position, this.targetId});
  

@override final  String deviceId;
@override final  DeviceKind kind;
/// Position under the finger in cm; `null` while a device from the tray is not over the plan yet.
@override final  PlanPoint? position;
/// Device the dragged one would be grouped with when dropped now.
@override final  String? targetId;

/// Create a copy of PlanDrag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanDragCopyWith<_PlanDrag> get copyWith => __$PlanDragCopyWithImpl<_PlanDrag>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanDrag&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,kind,position,targetId);
}

@override
String toString() {
    return 'PlanDrag(deviceId: $deviceId, kind: $kind, position: $position, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$PlanDragCopyWith<$Res> implements $PlanDragCopyWith<$Res> {
  factory _$PlanDragCopyWith(_PlanDrag value, $Res Function(_PlanDrag) _then) = __$PlanDragCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, DeviceKind kind, PlanPoint? position, String? targetId
});




}
/// @nodoc
class __$PlanDragCopyWithImpl<$Res>
    implements _$PlanDragCopyWith<$Res> {
  __$PlanDragCopyWithImpl(this._self, this._then);

  final _PlanDrag _self;
  final $Res Function(_PlanDrag) _then;

/// Create a copy of PlanDrag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? kind = null,Object? position = freezed,Object? targetId = freezed,}) {
  return _then(_PlanDrag(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DeviceKind,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as PlanPoint?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$FloorplanState {

 PlanSelection get selection; Set<PlanLayer> get layers; PlanDrag? get drag;/// Key of the group that is fanned out (`GroupingUtil.groupKey`).
 String? get openGroupKey;/// Positions of dropped devices until the stored placement arrives, so markers do not jump back.
 Map<String, PlanPoint> get pendingPositions;
/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorplanStateCopyWith<FloorplanState> get copyWith => _$FloorplanStateCopyWithImpl<FloorplanState>(this as FloorplanState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FloorplanState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorplanState&&(identical(other.selection, _this.selection) || other.selection == _this.selection)&&const DeepCollectionEquality().equals(other.layers, _this.layers)&&(identical(other.drag, _this.drag) || other.drag == _this.drag)&&(identical(other.openGroupKey, _this.openGroupKey) || other.openGroupKey == _this.openGroupKey)&&const DeepCollectionEquality().equals(other.pendingPositions, _this.pendingPositions));
}


@override
int get hashCode {
  final _this = this as FloorplanState;
  return Object.hash(runtimeType,_this.selection,const DeepCollectionEquality().hash(_this.layers),_this.drag,_this.openGroupKey,const DeepCollectionEquality().hash(_this.pendingPositions));
}

@override
String toString() {
  final _this = this as FloorplanState;
  return 'FloorplanState(selection: ${_this.selection}, layers: ${_this.layers}, drag: ${_this.drag}, openGroupKey: ${_this.openGroupKey}, pendingPositions: ${_this.pendingPositions})';
}


}

/// @nodoc
abstract mixin class $FloorplanStateCopyWith<$Res>  {
  factory $FloorplanStateCopyWith(FloorplanState value, $Res Function(FloorplanState) _then) = _$FloorplanStateCopyWithImpl;
@useResult
$Res call({
 PlanSelection selection, Set<PlanLayer> layers, PlanDrag? drag, String? openGroupKey, Map<String, PlanPoint> pendingPositions
});


$PlanSelectionCopyWith<$Res> get selection;$PlanDragCopyWith<$Res>? get drag;

}
/// @nodoc
class _$FloorplanStateCopyWithImpl<$Res>
    implements $FloorplanStateCopyWith<$Res> {
  _$FloorplanStateCopyWithImpl(this._self, this._then);

  final FloorplanState _self;
  final $Res Function(FloorplanState) _then;

/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selection = null,Object? layers = null,Object? drag = freezed,Object? openGroupKey = freezed,Object? pendingPositions = null,}) {
  return _then(FloorplanState(
selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as PlanSelection,layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as Set<PlanLayer>,drag: freezed == drag ? _self.drag : drag // ignore: cast_nullable_to_non_nullable
as PlanDrag?,openGroupKey: freezed == openGroupKey ? _self.openGroupKey : openGroupKey // ignore: cast_nullable_to_non_nullable
as String?,pendingPositions: null == pendingPositions ? _self.pendingPositions : pendingPositions // ignore: cast_nullable_to_non_nullable
as Map<String, PlanPoint>,
  ));
}
/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanSelectionCopyWith<$Res> get selection {
  
  return $PlanSelectionCopyWith<$Res>(_self.selection, (value) {
    return _then(_self.copyWith(selection: value));
  });
}/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanDragCopyWith<$Res>? get drag {
    if (_self.drag == null) {
    return null;
  }

  return $PlanDragCopyWith<$Res>(_self.drag!, (value) {
    return _then(_self.copyWith(drag: value));
  });
}
}


/// Adds pattern-matching-related methods to [FloorplanState].
extension FloorplanStatePatterns on FloorplanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloorplanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloorplanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloorplanState value)  $default,){
final _that = this;
switch (_that) {
case _FloorplanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloorplanState value)?  $default,){
final _that = this;
switch (_that) {
case _FloorplanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlanSelection selection,  Set<PlanLayer> layers,  PlanDrag? drag,  String? openGroupKey,  Map<String, PlanPoint> pendingPositions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorplanState() when $default != null:
return $default(_that.selection,_that.layers,_that.drag,_that.openGroupKey,_that.pendingPositions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlanSelection selection,  Set<PlanLayer> layers,  PlanDrag? drag,  String? openGroupKey,  Map<String, PlanPoint> pendingPositions)  $default,) {final _that = this;
switch (_that) {
case _FloorplanState():
return $default(_that.selection,_that.layers,_that.drag,_that.openGroupKey,_that.pendingPositions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlanSelection selection,  Set<PlanLayer> layers,  PlanDrag? drag,  String? openGroupKey,  Map<String, PlanPoint> pendingPositions)?  $default,) {final _that = this;
switch (_that) {
case _FloorplanState() when $default != null:
return $default(_that.selection,_that.layers,_that.drag,_that.openGroupKey,_that.pendingPositions);case _:
  return null;

}
}

}

/// @nodoc


class _FloorplanState implements FloorplanState {
  const _FloorplanState({this.selection = const PlanSelection.none(),  Set<PlanLayer> layers = const {PlanLayer.plants, PlanLayer.lights, PlanLayer.speakers, PlanLayer.glow}, this.drag, this.openGroupKey,  Map<String, PlanPoint> pendingPositions = const {}}): _layers = layers,_pendingPositions = pendingPositions;
  

@override@JsonKey() final  PlanSelection selection;
 final  Set<PlanLayer> _layers;
@override@JsonKey() Set<PlanLayer> get layers {
  if (_layers is EqualUnmodifiableSetView) return _layers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_layers);
}

@override final  PlanDrag? drag;
/// Key of the group that is fanned out (`GroupingUtil.groupKey`).
@override final  String? openGroupKey;
/// Positions of dropped devices until the stored placement arrives, so markers do not jump back.
 final  Map<String, PlanPoint> _pendingPositions;
/// Positions of dropped devices until the stored placement arrives, so markers do not jump back.
@override@JsonKey() Map<String, PlanPoint> get pendingPositions {
  if (_pendingPositions is EqualUnmodifiableMapView) return _pendingPositions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pendingPositions);
}


/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorplanStateCopyWith<_FloorplanState> get copyWith => __$FloorplanStateCopyWithImpl<_FloorplanState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorplanState&&(identical(other.selection, selection) || other.selection == selection)&&const DeepCollectionEquality().equals(other.layers, _layers)&&(identical(other.drag, drag) || other.drag == drag)&&(identical(other.openGroupKey, openGroupKey) || other.openGroupKey == openGroupKey)&&const DeepCollectionEquality().equals(other.pendingPositions, _pendingPositions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,selection,const DeepCollectionEquality().hash(_layers),drag,openGroupKey,const DeepCollectionEquality().hash(_pendingPositions));
}

@override
String toString() {
    return 'FloorplanState(selection: $selection, layers: $layers, drag: $drag, openGroupKey: $openGroupKey, pendingPositions: $pendingPositions)';
}


}

/// @nodoc
abstract mixin class _$FloorplanStateCopyWith<$Res> implements $FloorplanStateCopyWith<$Res> {
  factory _$FloorplanStateCopyWith(_FloorplanState value, $Res Function(_FloorplanState) _then) = __$FloorplanStateCopyWithImpl;
@override @useResult
$Res call({
 PlanSelection selection, Set<PlanLayer> layers, PlanDrag? drag, String? openGroupKey, Map<String, PlanPoint> pendingPositions
});


@override $PlanSelectionCopyWith<$Res> get selection;@override $PlanDragCopyWith<$Res>? get drag;

}
/// @nodoc
class __$FloorplanStateCopyWithImpl<$Res>
    implements _$FloorplanStateCopyWith<$Res> {
  __$FloorplanStateCopyWithImpl(this._self, this._then);

  final _FloorplanState _self;
  final $Res Function(_FloorplanState) _then;

/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selection = null,Object? layers = null,Object? drag = freezed,Object? openGroupKey = freezed,Object? pendingPositions = null,}) {
  return _then(_FloorplanState(
selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as PlanSelection,layers: null == layers ? _self._layers : layers // ignore: cast_nullable_to_non_nullable
as Set<PlanLayer>,drag: freezed == drag ? _self.drag : drag // ignore: cast_nullable_to_non_nullable
as PlanDrag?,openGroupKey: freezed == openGroupKey ? _self.openGroupKey : openGroupKey // ignore: cast_nullable_to_non_nullable
as String?,pendingPositions: null == pendingPositions ? _self._pendingPositions : pendingPositions // ignore: cast_nullable_to_non_nullable
as Map<String, PlanPoint>,
  ));
}

/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanSelectionCopyWith<$Res> get selection {
  
  return $PlanSelectionCopyWith<$Res>(_self.selection, (value) {
    return _then(_self.copyWith(selection: value));
  });
}/// Create a copy of FloorplanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanDragCopyWith<$Res>? get drag {
    if (_self.drag == null) {
    return null;
  }

  return $PlanDragCopyWith<$Res>(_self.drag!, (value) {
    return _then(_self.copyWith(drag: value));
  });
}
}

// dart format on
