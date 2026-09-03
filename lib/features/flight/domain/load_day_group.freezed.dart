// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_day_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadDayGroup {

/// 这一组的日历日（零点）。
 DateTime get day; List<Load> get loads;
/// Create a copy of LoadDayGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadDayGroupCopyWith<LoadDayGroup> get copyWith => _$LoadDayGroupCopyWithImpl<LoadDayGroup>(this as LoadDayGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadDayGroup&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other.loads, loads));
}


@override
int get hashCode => Object.hash(runtimeType,day,const DeepCollectionEquality().hash(loads));

@override
String toString() {
  return 'LoadDayGroup(day: $day, loads: $loads)';
}


}

/// @nodoc
abstract mixin class $LoadDayGroupCopyWith<$Res>  {
  factory $LoadDayGroupCopyWith(LoadDayGroup value, $Res Function(LoadDayGroup) _then) = _$LoadDayGroupCopyWithImpl;
@useResult
$Res call({
 DateTime day, List<Load> loads
});




}
/// @nodoc
class _$LoadDayGroupCopyWithImpl<$Res>
    implements $LoadDayGroupCopyWith<$Res> {
  _$LoadDayGroupCopyWithImpl(this._self, this._then);

  final LoadDayGroup _self;
  final $Res Function(LoadDayGroup) _then;

/// Create a copy of LoadDayGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? loads = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,loads: null == loads ? _self.loads : loads // ignore: cast_nullable_to_non_nullable
as List<Load>,
  ));
}

}


/// Adds pattern-matching-related methods to [LoadDayGroup].
extension LoadDayGroupPatterns on LoadDayGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadDayGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadDayGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadDayGroup value)  $default,){
final _that = this;
switch (_that) {
case _LoadDayGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadDayGroup value)?  $default,){
final _that = this;
switch (_that) {
case _LoadDayGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  List<Load> loads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadDayGroup() when $default != null:
return $default(_that.day,_that.loads);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  List<Load> loads)  $default,) {final _that = this;
switch (_that) {
case _LoadDayGroup():
return $default(_that.day,_that.loads);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  List<Load> loads)?  $default,) {final _that = this;
switch (_that) {
case _LoadDayGroup() when $default != null:
return $default(_that.day,_that.loads);case _:
  return null;

}
}

}

/// @nodoc


class _LoadDayGroup implements LoadDayGroup {
  const _LoadDayGroup({required this.day, required final  List<Load> loads}): _loads = loads;
  

/// 这一组的日历日（零点）。
@override final  DateTime day;
 final  List<Load> _loads;
@override List<Load> get loads {
  if (_loads is EqualUnmodifiableListView) return _loads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loads);
}


/// Create a copy of LoadDayGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadDayGroupCopyWith<_LoadDayGroup> get copyWith => __$LoadDayGroupCopyWithImpl<_LoadDayGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadDayGroup&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other._loads, _loads));
}


@override
int get hashCode => Object.hash(runtimeType,day,const DeepCollectionEquality().hash(_loads));

@override
String toString() {
  return 'LoadDayGroup(day: $day, loads: $loads)';
}


}

/// @nodoc
abstract mixin class _$LoadDayGroupCopyWith<$Res> implements $LoadDayGroupCopyWith<$Res> {
  factory _$LoadDayGroupCopyWith(_LoadDayGroup value, $Res Function(_LoadDayGroup) _then) = __$LoadDayGroupCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, List<Load> loads
});




}
/// @nodoc
class __$LoadDayGroupCopyWithImpl<$Res>
    implements _$LoadDayGroupCopyWith<$Res> {
  __$LoadDayGroupCopyWithImpl(this._self, this._then);

  final _LoadDayGroup _self;
  final $Res Function(_LoadDayGroup) _then;

/// Create a copy of LoadDayGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? loads = null,}) {
  return _then(_LoadDayGroup(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,loads: null == loads ? _self._loads : loads // ignore: cast_nullable_to_non_nullable
as List<Load>,
  ));
}


}

// dart format on
