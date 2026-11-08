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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditorRoomSelection value)?  room,TResult Function( EditorWallSelection value)?  wall,TResult Function( EditorOpeningSelection value)?  opening,TResult Function( EditorFurnitureSelection value)?  furniture,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that);case EditorWallSelection() when wall != null:
return wall(_that);case EditorOpeningSelection() when opening != null:
return opening(_that);case EditorFurnitureSelection() when furniture != null:
return furniture(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditorRoomSelection value)  room,required TResult Function( EditorWallSelection value)  wall,required TResult Function( EditorOpeningSelection value)  opening,required TResult Function( EditorFurnitureSelection value)  furniture,}){
final _that = this;
switch (_that) {
case EditorRoomSelection():
return room(_that);case EditorWallSelection():
return wall(_that);case EditorOpeningSelection():
return opening(_that);case EditorFurnitureSelection():
return furniture(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditorRoomSelection value)?  room,TResult? Function( EditorWallSelection value)?  wall,TResult? Function( EditorOpeningSelection value)?  opening,TResult? Function( EditorFurnitureSelection value)?  furniture,}){
final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that);case EditorWallSelection() when wall != null:
return wall(_that);case EditorOpeningSelection() when opening != null:
return opening(_that);case EditorFurnitureSelection() when furniture != null:
return furniture(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String roomId)?  room,TResult Function( String wallId)?  wall,TResult Function( String openingId)?  opening,TResult Function( String furnitureId)?  furniture,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that.roomId);case EditorWallSelection() when wall != null:
return wall(_that.wallId);case EditorOpeningSelection() when opening != null:
return opening(_that.openingId);case EditorFurnitureSelection() when furniture != null:
return furniture(_that.furnitureId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String roomId)  room,required TResult Function( String wallId)  wall,required TResult Function( String openingId)  opening,required TResult Function( String furnitureId)  furniture,}) {final _that = this;
switch (_that) {
case EditorRoomSelection():
return room(_that.roomId);case EditorWallSelection():
return wall(_that.wallId);case EditorOpeningSelection():
return opening(_that.openingId);case EditorFurnitureSelection():
return furniture(_that.furnitureId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String roomId)?  room,TResult? Function( String wallId)?  wall,TResult? Function( String openingId)?  opening,TResult? Function( String furnitureId)?  furniture,}) {final _that = this;
switch (_that) {
case EditorRoomSelection() when room != null:
return room(_that.roomId);case EditorWallSelection() when wall != null:
return wall(_that.wallId);case EditorOpeningSelection() when opening != null:
return opening(_that.openingId);case EditorFurnitureSelection() when furniture != null:
return furniture(_that.furnitureId);case _:
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


class EditorWallSelection implements EditorSelection {
  const EditorWallSelection(this.wallId);
  

 final  String wallId;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorWallSelectionCopyWith<EditorWallSelection> get copyWith => _$EditorWallSelectionCopyWithImpl<EditorWallSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorWallSelection&&(identical(other.wallId, wallId) || other.wallId == wallId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,wallId);
}

@override
String toString() {
    return 'EditorSelection.wall(wallId: $wallId)';
}


}

/// @nodoc
abstract mixin class $EditorWallSelectionCopyWith<$Res> implements $EditorSelectionCopyWith<$Res> {
  factory $EditorWallSelectionCopyWith(EditorWallSelection value, $Res Function(EditorWallSelection) _then) = _$EditorWallSelectionCopyWithImpl;
@useResult
$Res call({
 String wallId
});




}
/// @nodoc
class _$EditorWallSelectionCopyWithImpl<$Res>
    implements $EditorWallSelectionCopyWith<$Res> {
  _$EditorWallSelectionCopyWithImpl(this._self, this._then);

  final EditorWallSelection _self;
  final $Res Function(EditorWallSelection) _then;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? wallId = null,}) {
  return _then(EditorWallSelection(
null == wallId ? _self.wallId : wallId // ignore: cast_nullable_to_non_nullable
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


class EditorFurnitureSelection implements EditorSelection {
  const EditorFurnitureSelection(this.furnitureId);
  

 final  String furnitureId;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorFurnitureSelectionCopyWith<EditorFurnitureSelection> get copyWith => _$EditorFurnitureSelectionCopyWithImpl<EditorFurnitureSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorFurnitureSelection&&(identical(other.furnitureId, furnitureId) || other.furnitureId == furnitureId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,furnitureId);
}

@override
String toString() {
    return 'EditorSelection.furniture(furnitureId: $furnitureId)';
}


}

/// @nodoc
abstract mixin class $EditorFurnitureSelectionCopyWith<$Res> implements $EditorSelectionCopyWith<$Res> {
  factory $EditorFurnitureSelectionCopyWith(EditorFurnitureSelection value, $Res Function(EditorFurnitureSelection) _then) = _$EditorFurnitureSelectionCopyWithImpl;
@useResult
$Res call({
 String furnitureId
});




}
/// @nodoc
class _$EditorFurnitureSelectionCopyWithImpl<$Res>
    implements $EditorFurnitureSelectionCopyWith<$Res> {
  _$EditorFurnitureSelectionCopyWithImpl(this._self, this._then);

  final EditorFurnitureSelection _self;
  final $Res Function(EditorFurnitureSelection) _then;

/// Create a copy of EditorSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? furnitureId = null,}) {
  return _then(EditorFurnitureSelection(
null == furnitureId ? _self.furnitureId : furnitureId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$FloorplanEditorState {

 HomeLayout get layout; EditorTool get tool;/// What the furniture tool puts down.
 FurnitureKind get furnitureKind; EditorSelection? get selection;/// Corners of the walls being drawn with [EditorTool.wall]; the last one is where the next wall starts.
 List<PlanPoint> get chain;/// Rectangle being dragged with [EditorTool.room], two opposite corners.
 List<PlanPoint>? get rectangle;/// Opening being dragged along a wall, from where the finger went down to where it is.
 List<PlanPoint>? get openingDraft;/// Lines through junctions the dragged point is aligned with.
 double? get guideX; double? get guideY;/// Shows the apartment in 3D instead of the plan to edit.
 bool get preview;/// Earlier layouts for undo (oldest first) and undone layouts for redo (next first).
 List<HomeLayout> get past; List<HomeLayout> get future;
/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorplanEditorStateCopyWith<FloorplanEditorState> get copyWith => _$FloorplanEditorStateCopyWithImpl<FloorplanEditorState>(this as FloorplanEditorState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FloorplanEditorState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorplanEditorState&&(identical(other.layout, _this.layout) || other.layout == _this.layout)&&(identical(other.tool, _this.tool) || other.tool == _this.tool)&&(identical(other.furnitureKind, _this.furnitureKind) || other.furnitureKind == _this.furnitureKind)&&(identical(other.selection, _this.selection) || other.selection == _this.selection)&&const DeepCollectionEquality().equals(other.chain, _this.chain)&&const DeepCollectionEquality().equals(other.rectangle, _this.rectangle)&&const DeepCollectionEquality().equals(other.openingDraft, _this.openingDraft)&&(identical(other.guideX, _this.guideX) || other.guideX == _this.guideX)&&(identical(other.guideY, _this.guideY) || other.guideY == _this.guideY)&&(identical(other.preview, _this.preview) || other.preview == _this.preview)&&const DeepCollectionEquality().equals(other.past, _this.past)&&const DeepCollectionEquality().equals(other.future, _this.future));
}


@override
int get hashCode {
  final _this = this as FloorplanEditorState;
  return Object.hash(runtimeType,_this.layout,_this.tool,_this.furnitureKind,_this.selection,const DeepCollectionEquality().hash(_this.chain),const DeepCollectionEquality().hash(_this.rectangle),const DeepCollectionEquality().hash(_this.openingDraft),_this.guideX,_this.guideY,_this.preview,const DeepCollectionEquality().hash(_this.past),const DeepCollectionEquality().hash(_this.future));
}

@override
String toString() {
  final _this = this as FloorplanEditorState;
  return 'FloorplanEditorState(layout: ${_this.layout}, tool: ${_this.tool}, furnitureKind: ${_this.furnitureKind}, selection: ${_this.selection}, chain: ${_this.chain}, rectangle: ${_this.rectangle}, openingDraft: ${_this.openingDraft}, guideX: ${_this.guideX}, guideY: ${_this.guideY}, preview: ${_this.preview}, past: ${_this.past}, future: ${_this.future})';
}


}

/// @nodoc
abstract mixin class $FloorplanEditorStateCopyWith<$Res>  {
  factory $FloorplanEditorStateCopyWith(FloorplanEditorState value, $Res Function(FloorplanEditorState) _then) = _$FloorplanEditorStateCopyWithImpl;
@useResult
$Res call({
 HomeLayout layout, EditorTool tool, FurnitureKind furnitureKind, EditorSelection? selection, List<PlanPoint> chain, List<PlanPoint>? rectangle, List<PlanPoint>? openingDraft, double? guideX, double? guideY, bool preview, List<HomeLayout> past, List<HomeLayout> future
});


$HomeLayoutCopyWith<$Res> get layout;$EditorSelectionCopyWith<$Res>? get selection;

}
/// @nodoc
class _$FloorplanEditorStateCopyWithImpl<$Res>
    implements $FloorplanEditorStateCopyWith<$Res> {
  _$FloorplanEditorStateCopyWithImpl(this._self, this._then);

  final FloorplanEditorState _self;
  final $Res Function(FloorplanEditorState) _then;

/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? layout = null,Object? tool = null,Object? furnitureKind = null,Object? selection = freezed,Object? chain = null,Object? rectangle = freezed,Object? openingDraft = freezed,Object? guideX = freezed,Object? guideY = freezed,Object? preview = null,Object? past = null,Object? future = null,}) {
  return _then(FloorplanEditorState(
layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as HomeLayout,tool: null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as EditorTool,furnitureKind: null == furnitureKind ? _self.furnitureKind : furnitureKind // ignore: cast_nullable_to_non_nullable
as FurnitureKind,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as EditorSelection?,chain: null == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,rectangle: freezed == rectangle ? _self.rectangle : rectangle // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>?,openingDraft: freezed == openingDraft ? _self.openingDraft : openingDraft // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>?,guideX: freezed == guideX ? _self.guideX : guideX // ignore: cast_nullable_to_non_nullable
as double?,guideY: freezed == guideY ? _self.guideY : guideY // ignore: cast_nullable_to_non_nullable
as double?,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as bool,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<HomeLayout>,future: null == future ? _self.future : future // ignore: cast_nullable_to_non_nullable
as List<HomeLayout>,
  ));
}
/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeLayoutCopyWith<$Res> get layout {
  
  return $HomeLayoutCopyWith<$Res>(_self.layout, (value) {
    return _then(_self.copyWith(layout: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HomeLayout layout,  EditorTool tool,  FurnitureKind furnitureKind,  EditorSelection? selection,  List<PlanPoint> chain,  List<PlanPoint>? rectangle,  List<PlanPoint>? openingDraft,  double? guideX,  double? guideY,  bool preview,  List<HomeLayout> past,  List<HomeLayout> future)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorplanEditorState() when $default != null:
return $default(_that.layout,_that.tool,_that.furnitureKind,_that.selection,_that.chain,_that.rectangle,_that.openingDraft,_that.guideX,_that.guideY,_that.preview,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HomeLayout layout,  EditorTool tool,  FurnitureKind furnitureKind,  EditorSelection? selection,  List<PlanPoint> chain,  List<PlanPoint>? rectangle,  List<PlanPoint>? openingDraft,  double? guideX,  double? guideY,  bool preview,  List<HomeLayout> past,  List<HomeLayout> future)  $default,) {final _that = this;
switch (_that) {
case _FloorplanEditorState():
return $default(_that.layout,_that.tool,_that.furnitureKind,_that.selection,_that.chain,_that.rectangle,_that.openingDraft,_that.guideX,_that.guideY,_that.preview,_that.past,_that.future);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HomeLayout layout,  EditorTool tool,  FurnitureKind furnitureKind,  EditorSelection? selection,  List<PlanPoint> chain,  List<PlanPoint>? rectangle,  List<PlanPoint>? openingDraft,  double? guideX,  double? guideY,  bool preview,  List<HomeLayout> past,  List<HomeLayout> future)?  $default,) {final _that = this;
switch (_that) {
case _FloorplanEditorState() when $default != null:
return $default(_that.layout,_that.tool,_that.furnitureKind,_that.selection,_that.chain,_that.rectangle,_that.openingDraft,_that.guideX,_that.guideY,_that.preview,_that.past,_that.future);case _:
  return null;

}
}

}

/// @nodoc


class _FloorplanEditorState extends FloorplanEditorState {
  const _FloorplanEditorState({required this.layout, this.tool = EditorTool.select, this.furnitureKind = FurnitureKind.bed, this.selection,  List<PlanPoint> chain = const [],  List<PlanPoint>? rectangle,  List<PlanPoint>? openingDraft, this.guideX, this.guideY, this.preview = false,  List<HomeLayout> past = const [],  List<HomeLayout> future = const []}): _chain = chain,_rectangle = rectangle,_openingDraft = openingDraft,_past = past,_future = future,super._();
  

@override final  HomeLayout layout;
@override@JsonKey() final  EditorTool tool;
/// What the furniture tool puts down.
@override@JsonKey() final  FurnitureKind furnitureKind;
@override final  EditorSelection? selection;
/// Corners of the walls being drawn with [EditorTool.wall]; the last one is where the next wall starts.
 final  List<PlanPoint> _chain;
/// Corners of the walls being drawn with [EditorTool.wall]; the last one is where the next wall starts.
@override@JsonKey() List<PlanPoint> get chain {
  if (_chain is EqualUnmodifiableListView) return _chain;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chain);
}

/// Rectangle being dragged with [EditorTool.room], two opposite corners.
 final  List<PlanPoint>? _rectangle;
/// Rectangle being dragged with [EditorTool.room], two opposite corners.
@override List<PlanPoint>? get rectangle {
  final value = _rectangle;
  if (value == null) return null;
  if (_rectangle is EqualUnmodifiableListView) return _rectangle;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Opening being dragged along a wall, from where the finger went down to where it is.
 final  List<PlanPoint>? _openingDraft;
/// Opening being dragged along a wall, from where the finger went down to where it is.
@override List<PlanPoint>? get openingDraft {
  final value = _openingDraft;
  if (value == null) return null;
  if (_openingDraft is EqualUnmodifiableListView) return _openingDraft;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Lines through junctions the dragged point is aligned with.
@override final  double? guideX;
@override final  double? guideY;
/// Shows the apartment in 3D instead of the plan to edit.
@override@JsonKey() final  bool preview;
/// Earlier layouts for undo (oldest first) and undone layouts for redo (next first).
 final  List<HomeLayout> _past;
/// Earlier layouts for undo (oldest first) and undone layouts for redo (next first).
@override@JsonKey() List<HomeLayout> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

 final  List<HomeLayout> _future;
@override@JsonKey() List<HomeLayout> get future {
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorplanEditorState&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.tool, tool) || other.tool == tool)&&(identical(other.furnitureKind, furnitureKind) || other.furnitureKind == furnitureKind)&&(identical(other.selection, selection) || other.selection == selection)&&const DeepCollectionEquality().equals(other.chain, _chain)&&const DeepCollectionEquality().equals(other.rectangle, _rectangle)&&const DeepCollectionEquality().equals(other.openingDraft, _openingDraft)&&(identical(other.guideX, guideX) || other.guideX == guideX)&&(identical(other.guideY, guideY) || other.guideY == guideY)&&(identical(other.preview, preview) || other.preview == preview)&&const DeepCollectionEquality().equals(other.past, _past)&&const DeepCollectionEquality().equals(other.future, _future));
}


@override
int get hashCode {
    return Object.hash(runtimeType,layout,tool,furnitureKind,selection,const DeepCollectionEquality().hash(_chain),const DeepCollectionEquality().hash(_rectangle),const DeepCollectionEquality().hash(_openingDraft),guideX,guideY,preview,const DeepCollectionEquality().hash(_past),const DeepCollectionEquality().hash(_future));
}

@override
String toString() {
    return 'FloorplanEditorState(layout: $layout, tool: $tool, furnitureKind: $furnitureKind, selection: $selection, chain: $chain, rectangle: $rectangle, openingDraft: $openingDraft, guideX: $guideX, guideY: $guideY, preview: $preview, past: $past, future: $future)';
}


}

/// @nodoc
abstract mixin class _$FloorplanEditorStateCopyWith<$Res> implements $FloorplanEditorStateCopyWith<$Res> {
  factory _$FloorplanEditorStateCopyWith(_FloorplanEditorState value, $Res Function(_FloorplanEditorState) _then) = __$FloorplanEditorStateCopyWithImpl;
@override @useResult
$Res call({
 HomeLayout layout, EditorTool tool, FurnitureKind furnitureKind, EditorSelection? selection, List<PlanPoint> chain, List<PlanPoint>? rectangle, List<PlanPoint>? openingDraft, double? guideX, double? guideY, bool preview, List<HomeLayout> past, List<HomeLayout> future
});


@override $HomeLayoutCopyWith<$Res> get layout;@override $EditorSelectionCopyWith<$Res>? get selection;

}
/// @nodoc
class __$FloorplanEditorStateCopyWithImpl<$Res>
    implements _$FloorplanEditorStateCopyWith<$Res> {
  __$FloorplanEditorStateCopyWithImpl(this._self, this._then);

  final _FloorplanEditorState _self;
  final $Res Function(_FloorplanEditorState) _then;

/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? layout = null,Object? tool = null,Object? furnitureKind = null,Object? selection = freezed,Object? chain = null,Object? rectangle = freezed,Object? openingDraft = freezed,Object? guideX = freezed,Object? guideY = freezed,Object? preview = null,Object? past = null,Object? future = null,}) {
  return _then(_FloorplanEditorState(
layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as HomeLayout,tool: null == tool ? _self.tool : tool // ignore: cast_nullable_to_non_nullable
as EditorTool,furnitureKind: null == furnitureKind ? _self.furnitureKind : furnitureKind // ignore: cast_nullable_to_non_nullable
as FurnitureKind,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as EditorSelection?,chain: null == chain ? _self._chain : chain // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>,rectangle: freezed == rectangle ? _self._rectangle : rectangle // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>?,openingDraft: freezed == openingDraft ? _self._openingDraft : openingDraft // ignore: cast_nullable_to_non_nullable
as List<PlanPoint>?,guideX: freezed == guideX ? _self.guideX : guideX // ignore: cast_nullable_to_non_nullable
as double?,guideY: freezed == guideY ? _self.guideY : guideY // ignore: cast_nullable_to_non_nullable
as double?,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as bool,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<HomeLayout>,future: null == future ? _self._future : future // ignore: cast_nullable_to_non_nullable
as List<HomeLayout>,
  ));
}

/// Create a copy of FloorplanEditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeLayoutCopyWith<$Res> get layout {
  
  return $HomeLayoutCopyWith<$Res>(_self.layout, (value) {
    return _then(_self.copyWith(layout: value));
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
