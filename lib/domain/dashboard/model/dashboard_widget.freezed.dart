// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_widget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardWidget {

 String get id; DashboardWidgetKind get kind; DashboardWidgetSize get size;/// What the widget shows, in this order – e.g. room ids for the lights widget. Empty: chosen automatically.
 List<String> get selection;
/// Create a copy of DashboardWidget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardWidgetCopyWith<DashboardWidget> get copyWith => _$DashboardWidgetCopyWithImpl<DashboardWidget>(this as DashboardWidget, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardWidget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardWidget&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.size, _this.size) || other.size == _this.size)&&const DeepCollectionEquality().equals(other.selection, _this.selection));
}


@override
int get hashCode {
  final _this = this as DashboardWidget;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.size,const DeepCollectionEquality().hash(_this.selection));
}

@override
String toString() {
  final _this = this as DashboardWidget;
  return 'DashboardWidget(id: ${_this.id}, kind: ${_this.kind}, size: ${_this.size}, selection: ${_this.selection})';
}


}

/// @nodoc
abstract mixin class $DashboardWidgetCopyWith<$Res>  {
  factory $DashboardWidgetCopyWith(DashboardWidget value, $Res Function(DashboardWidget) _then) = _$DashboardWidgetCopyWithImpl;
@useResult
$Res call({
 String id, DashboardWidgetKind kind, DashboardWidgetSize size, List<String> selection
});




}
/// @nodoc
class _$DashboardWidgetCopyWithImpl<$Res>
    implements $DashboardWidgetCopyWith<$Res> {
  _$DashboardWidgetCopyWithImpl(this._self, this._then);

  final DashboardWidget _self;
  final $Res Function(DashboardWidget) _then;

/// Create a copy of DashboardWidget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? size = null,Object? selection = null,}) {
  return _then(DashboardWidget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DashboardWidgetKind,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as DashboardWidgetSize,selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardWidget].
extension DashboardWidgetPatterns on DashboardWidget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardWidget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardWidget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardWidget value)  $default,){
final _that = this;
switch (_that) {
case _DashboardWidget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardWidget value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardWidget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DashboardWidgetKind kind,  DashboardWidgetSize size,  List<String> selection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardWidget() when $default != null:
return $default(_that.id,_that.kind,_that.size,_that.selection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DashboardWidgetKind kind,  DashboardWidgetSize size,  List<String> selection)  $default,) {final _that = this;
switch (_that) {
case _DashboardWidget():
return $default(_that.id,_that.kind,_that.size,_that.selection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DashboardWidgetKind kind,  DashboardWidgetSize size,  List<String> selection)?  $default,) {final _that = this;
switch (_that) {
case _DashboardWidget() when $default != null:
return $default(_that.id,_that.kind,_that.size,_that.selection);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardWidget implements DashboardWidget {
  const _DashboardWidget({required this.id, required this.kind, required this.size,  List<String> selection = const <String>[]}): _selection = selection;
  

@override final  String id;
@override final  DashboardWidgetKind kind;
@override final  DashboardWidgetSize size;
/// What the widget shows, in this order – e.g. room ids for the lights widget. Empty: chosen automatically.
 final  List<String> _selection;
/// What the widget shows, in this order – e.g. room ids for the lights widget. Empty: chosen automatically.
@override@JsonKey() List<String> get selection {
  if (_selection is EqualUnmodifiableListView) return _selection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selection);
}


/// Create a copy of DashboardWidget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardWidgetCopyWith<_DashboardWidget> get copyWith => __$DashboardWidgetCopyWithImpl<_DashboardWidget>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardWidget&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other.selection, _selection));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,size,const DeepCollectionEquality().hash(_selection));
}

@override
String toString() {
    return 'DashboardWidget(id: $id, kind: $kind, size: $size, selection: $selection)';
}


}

/// @nodoc
abstract mixin class _$DashboardWidgetCopyWith<$Res> implements $DashboardWidgetCopyWith<$Res> {
  factory _$DashboardWidgetCopyWith(_DashboardWidget value, $Res Function(_DashboardWidget) _then) = __$DashboardWidgetCopyWithImpl;
@override @useResult
$Res call({
 String id, DashboardWidgetKind kind, DashboardWidgetSize size, List<String> selection
});




}
/// @nodoc
class __$DashboardWidgetCopyWithImpl<$Res>
    implements _$DashboardWidgetCopyWith<$Res> {
  __$DashboardWidgetCopyWithImpl(this._self, this._then);

  final _DashboardWidget _self;
  final $Res Function(_DashboardWidget) _then;

/// Create a copy of DashboardWidget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? size = null,Object? selection = null,}) {
  return _then(_DashboardWidget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DashboardWidgetKind,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as DashboardWidgetSize,selection: null == selection ? _self._selection : selection // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
