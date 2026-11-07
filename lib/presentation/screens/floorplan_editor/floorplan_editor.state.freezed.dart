// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floorplan_editor.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditorSelection {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorSelection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EditorSelection()';
}


}

/// @nodoc
class $EditorSelectionCopyWith<$Res>  {
$EditorSelectionCopyWith(EditorSelection _, $Res Function(EditorSelection) __);
}


/// Adds pattern-matching-related methods to [EditorSelection].
extension EditorSelectionPatterns on EditorSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditorRoomSelection value)?  room,TResult Function( EditorOpeningSelection value)?  opening,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that);case EditorOpeningSelection() when opening != null:
return opening(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditorRoomSelection value)  room,required TResult Function( EditorOpeningSelection value)  opening,}){
final _that = this;
switch (_that) {
case EditorRoomSelection():
return room(_that);case EditorOpeningSelection():
return opening(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditorRoomSelection value)?  room,TResult? Function( EditorOpeningSelection value)?  opening,}){
final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that);case EditorOpeningSelection() when opening != null:
return opening(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String roomId)?  room,TResult Function( String openingId)?  opening,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that.roomId);case EditorOpeningSelection() when opening != null:
return opening(_that.openingId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String roomId)  room,required TResult Function( String openingId)  opening,}) {final _that = this;
switch (_that) {
case EditorRoomSelection():
return room(_that.roomId);case EditorOpeningSelection():
return opening(_that.openingId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String roomId)?  room,TResult? Function( String openingId)?  opening,}) {final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that.roomId);case EditorOpeningSelection() when opening != null:
return opening(_that.openingId);case _:
  return null;

}
}

}

/// @nodoc


class EditorRoomSelection implements EditorSelection {
  const EditorRoomSelection(this.roomId);
  

 final  String roomId;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorRoomSelectionCopyWith<EditorRoomSelection> get copyWith => _$EditorRoomSelectionCopyWithImpl<EditorRoomSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorRoomSelection&&(identical(other.roomId, roomId) || other.roomId == roomId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,roomId);
}

@override
String toString() {
    return 'EditorSelection.room(roomId: $roomId)';
}


}

/// @nodoc
abstract mixin class $EditorRoomSelectionCopyWith<$Res> implements $EditorSelectionCopyWith<$Res> {
  factory $EditorRoomSelectionCopyWith(EditorRoomSelection value, $Res Function(EditorRoomSelection) _then) = _$EditorRoomSelectionCopyWithImpl;
@useResult
$Res call({
 String roomId
});




}
/// @nodoc
class _$EditorRoomSelectionCopyWithImpl<$Res>
    implements $EditorRoomSelectionCopyWith<$Res> {
  _$EditorRoomSelectionCopyWithImpl(this._self, this._then);

  final EditorRoomSelection _self;
  final $Res Function(EditorRoomSelection) _then;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roomId = null,}) {
  return _then(EditorRoomSelection(
null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EditorOpeningSelection implements EditorSelection {
  const EditorOpeningSelection(this.openingId);
  

 final  String openingId;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorOpeningSelectionCopyWith<EditorOpeningSelection> get copyWith => _$EditorOpeningSelectionCopyWithImpl<EditorOpeningSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorOpeningSelection&&(identical(other.openingId, openingId) || other.openingId == openingId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,openingId);
}

@override
String toString() {
    return 'EditorSelection.opening(openingId: $openingId)';
}


}

/// @nodoc
abstract mixin class $EditorOpeningSelectionCopyWith<$Res> implements $EditorSelectionCopyWith<$Res> {
  factory $EditorOpeningSelectionCopyWith(EditorOpeningSelection value, $Res Function(EditorOpeningSelection) _then) = _$EditorOpeningSelectionCopyWithImpl;
@useResult
$Res call({
 String openingId
});




}
/// @nodoc
class _$EditorOpeningSelectionCopyWithImpl<$Res>
    implements $EditorOpeningSelectionCopyWith<$Res> {
  _$EditorOpeningSelectionCopyWithImpl(this._self, this._then);

  final EditorOpeningSelection _self;
  final $Res Function(EditorOpeningSelection) _then;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? openingId = null,}) {
  return _then(EditorOpeningSelection(
null == openingId ? _self.openingId : openingId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$FloorplanEditorState {

 FloorPlan get plan; EditorTool get tool; EditorSelection? get selection;/// Corners of the room being drawn with [EditorTool.room].
 List<PlanPoint> get draft;/// Rectangle being dragged with [EditorTool.rectangle].
 List<PlanPoint>? get rectangle;/// Lines through corners the dragged point is aligned with.
 double? get guideX; double? get guideY;/// Earlier plans for undo (oldest first) and undone plans for redo (next first).
 List<FloorPlan> get past; List<FloorPlan> get future;
/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorplanEditorStateCopyWith<FloorplanEditorState> get copyWith => _$FloorplanEditorStateCopyWithImpl<FloorplanEditorState>(this as FloorplanEditorState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FloorplanEditorState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorplanEditorState&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.tool, _this.tool) || other.tool == _this.tool)&&(identical(other.selection, _this.selection) || other.selection == _this.selection)&&const DeepCollectionEquality().equals(other.draft, _this.draft)&&const DeepCollectionEquality().equals(other.rectangle, _this.rectangle)&&(identical(other.guideX, _this.guideX) || other.guideX == _this.guideX)&&(identical(other.guideY, _this.guideY) || other.guideY == _this.guideY)&&const DeepCollectionEquality().equals(other.past, _this.past)&&const DeepCollectionEquality().equals(other.future, _this.future));
}


@override
int get hashCode {
  final _this = this as FloorplanEditorState;
  return Object.hash(runtimeType,_this.plan,_this.tool,_this.selection,const DeepCollectionEquality().hash(_this.draft),const DeepCollectionEquality().hash(_this.rectangle),_this.guideX,_this.guideY,const DeepCollectionEquality().hash(_this.past),const DeepCollectionEquality().hash(_this.future));
}

@override
String toString() {
  final _this = this as FloorplanEditorState;
  return 'FloorplanEditorState(plan: ${_this.plan}, tool: ${_this.tool}, selection: ${_this.selection}, draft: ${_this.draft}, rectangle: ${_this.rectangle}, guideX: ${_this.guideX}, guideY: ${_this.guideY}, past: ${_this.past}, future: ${_this.future})';
}


}

/// @nodoc
abstract mixin class $FloorplanEditorStateCopyWith<$Res>  {
  factory $FloorplanEditorStateCopyWith(FloorplanEditorState value, $Res Function(FloorplanEditorState) _then) = _$FloorplanEditorStateCopyWithImpl;
@useResult
$Res call({
 FloorPlan plan, EditorTool tool, EditorSelection? selection, List<PlanPoint> draft, List<PlanPoint>? rectangle, double? guideX, double? guideY, List<FloorPlan> past, List<FloorPlan> future
});


$FloorPlanCopyWith<$Res> get plan;$EditorSelectionCopyWith<$Res>? get selection;

}
/// @nodoc
class _$FloorplanEditorStateCopyWithImpl<$Res>
    implements $FloorplanEditorStateCopyWith<$Res> {
  _$FloorplanEditorStateCopyWithImpl(this._self, this._then);

  final FloorplanEditorState _self;
  final $Res Function(FloorplanEditorState) _then;

/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plan = null,Object? tool = null,Object? selection = freezed,Object? draft = null,Object? rectangle = freezed,Object? guideX = freezed,Object? guideY = freezed,Object? past = null,Object? future = null,}) {
  return _then(FloorplanEditorState(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as FloorPlan,tool: null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as EditorTool,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as EditorSelection?,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,rectangle: freezed == rectangle ? _self.rectangle : rectangle // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>?,guideX: freezed == guideX ? _self.guideX : guideX // ignore: cast_nullable_to_non_nullable
as double?,guideY: freezed == guideY ? _self.guideY : guideY // ignore: cast_nullable_to_non_nullable
as double?,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<FloorPlan>,future: null == future ? _self.future : future // ignore: cast_nullable_to_non_nullable
as List<FloorPlan>,
  ));
}
/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloorPlanCopyWith<$Res> get plan {
  
  return $FloorPlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorSelectionCopyWith<$Res>? get selection {
    if (_self.selection == null) {
    return null;
  }

  return $EditorSelectionCopyWith<$Res>(_self.selection!, (value) {
    return _then(_self.copyWith(selection: value));
  });
}
}


/// Adds pattern-matching-related methods to [FloorplanEditorState].
extension FloorplanEditorStatePatterns on FloorplanEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloorplanEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloorplanEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloorplanEditorState value)  $default,){
final _that = this;
switch (_that) {
case _FloorplanEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloorplanEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _FloorplanEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FloorPlan plan,  EditorTool tool,  EditorSelection? selection,  List<PlanPoint> draft,  List<PlanPoint>? rectangle,  double? guideX,  double? guideY,  List<FloorPlan> past,  List<FloorPlan> future)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorplanEditorState() when $default != null:
return $default(_that.plan,_that.tool,_that.selection,_that.draft,_that.rectangle,_that.guideX,_that.guideY,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FloorPlan plan,  EditorTool tool,  EditorSelection? selection,  List<PlanPoint> draft,  List<PlanPoint>? rectangle,  double? guideX,  double? guideY,  List<FloorPlan> past,  List<FloorPlan> future)  $default,) {final _that = this;
switch (_that) {
case _FloorplanEditorState():
return $default(_that.plan,_that.tool,_that.selection,_that.draft,_that.rectangle,_that.guideX,_that.guideY,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FloorPlan plan,  EditorTool tool,  EditorSelection? selection,  List<PlanPoint> draft,  List<PlanPoint>? rectangle,  double? guideX,  double? guideY,  List<FloorPlan> past,  List<FloorPlan> future)?  $default,) {final _that = this;
switch (_that) {
case _FloorplanEditorState() when $default != null:
return $default(_that.plan,_that.tool,_that.selection,_that.draft,_that.rectangle,_that.guideX,_that.guideY,_that.past,_that.future);case _:
  return null;

}
}

}

/// @nodoc


class _FloorplanEditorState extends FloorplanEditorState {
  const _FloorplanEditorState({required this.plan, this.tool = EditorTool.select, this.selection,  List<PlanPoint> draft = const [],  List<PlanPoint>? rectangle, this.guideX, this.guideY,  List<FloorPlan> past = const [],  List<FloorPlan> future = const []}): _draft = draft,_rectangle = rectangle,_past = past,_future = future,super._();
  

@override final  FloorPlan plan;
@override@JsonKey() final  EditorTool tool;
@override final  EditorSelection? selection;
/// Corners of the room being drawn with [EditorTool.room].
 final  List<PlanPoint> _draft;
/// Corners of the room being drawn with [EditorTool.room].
@override@JsonKey() List<PlanPoint> get draft {
  if (_draft is EqualUnmodifiableListView) return _draft;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_draft);
}

/// Rectangle being dragged with [EditorTool.rectangle].
 final  List<PlanPoint>? _rectangle;
/// Rectangle being dragged with [EditorTool.rectangle].
@override List<PlanPoint>? get rectangle {
  final value = _rectangle;
  if (value == null) return null;
  if (_rectangle is EqualUnmodifiableListView) return _rectangle;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Lines through corners the dragged point is aligned with.
@override final  double? guideX;
@override final  double? guideY;
/// Earlier plans for undo (oldest first) and undone plans for redo (next first).
 final  List<FloorPlan> _past;
/// Earlier plans for undo (oldest first) and undone plans for redo (next first).
@override@JsonKey() List<FloorPlan> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

 final  List<FloorPlan> _future;
@override@JsonKey() List<FloorPlan> get future {
  if (_future is EqualUnmodifiableListView) return _future;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_future);
}


/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorplanEditorStateCopyWith<_FloorplanEditorState> get copyWith => __$FloorplanEditorStateCopyWithImpl<_FloorplanEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorplanEditorState&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.tool, tool) || other.tool == tool)&&(identical(other.selection, selection) || other.selection == selection)&&const DeepCollectionEquality().equals(other.draft, _draft)&&const DeepCollectionEquality().equals(other.rectangle, _rectangle)&&(identical(other.guideX, guideX) || other.guideX == guideX)&&(identical(other.guideY, guideY) || other.guideY == guideY)&&const DeepCollectionEquality().equals(other.past, _past)&&const DeepCollectionEquality().equals(other.future, _future));
}


@override
int get hashCode {
    return Object.hash(runtimeType,plan,tool,selection,const DeepCollectionEquality().hash(_draft),const DeepCollectionEquality().hash(_rectangle),guideX,guideY,const DeepCollectionEquality().hash(_past),const DeepCollectionEquality().hash(_future));
}

@override
String toString() {
    return 'FloorplanEditorState(plan: $plan, tool: $tool, selection: $selection, draft: $draft, rectangle: $rectangle, guideX: $guideX, guideY: $guideY, past: $past, future: $future)';
}


}

/// @nodoc
abstract mixin class _$FloorplanEditorStateCopyWith<$Res> implements $FloorplanEditorStateCopyWith<$Res> {
  factory _$FloorplanEditorStateCopyWith(_FloorplanEditorState value, $Res Function(_FloorplanEditorState) _then) = __$FloorplanEditorStateCopyWithImpl;
@override @useResult
$Res call({
 FloorPlan plan, EditorTool tool, EditorSelection? selection, List<PlanPoint> draft, List<PlanPoint>? rectangle, double? guideX, double? guideY, List<FloorPlan> past, List<FloorPlan> future
});


@override $FloorPlanCopyWith<$Res> get plan;@override $EditorSelectionCopyWith<$Res>? get selection;

}
/// @nodoc
class __$FloorplanEditorStateCopyWithImpl<$Res>
    implements _$FloorplanEditorStateCopyWith<$Res> {
  __$FloorplanEditorStateCopyWithImpl(this._self, this._then);

  final _FloorplanEditorState _self;
  final $Res Function(_FloorplanEditorState) _then;

/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? tool = null,Object? selection = freezed,Object? draft = null,Object? rectangle = freezed,Object? guideX = freezed,Object? guideY = freezed,Object? past = null,Object? future = null,}) {
  return _then(_FloorplanEditorState(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as FloorPlan,tool: null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as EditorTool,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as EditorSelection?,draft: null == draft ? _self._draft : draft // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,rectangle: freezed == rectangle ? _self._rectangle : rectangle // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>?,guideX: freezed == guideX ? _self.guideX : guideX // ignore: cast_nullable_to_non_nullable
as double?,guideY: freezed == guideY ? _self.guideY : guideY // ignore: cast_nullable_to_non_nullable
as double?,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<FloorPlan>,future: null == future ? _self._future : future // ignore: cast_nullable_to_non_nullable
as List<FloorPlan>,
  ));
}

/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloorPlanCopyWith<$Res> get plan {
  
  return $FloorPlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EditorSelectionCopyWith<$Res>? get selection {
    if (_self.selection == null) {
    return null;
  }

  return $EditorSelectionCopyWith<$Res>(_self.selection!, (value) {
    return _then(_self.copyWith(selection: value));
  });
}
}

// dart format on
