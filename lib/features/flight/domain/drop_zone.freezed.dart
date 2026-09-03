// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drop_zone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DropZone {

 String get id; String get name;/// 所在都道府県（如「群馬県」）。缺失时 UI 只展示名称。
 String? get area;
/// Create a copy of DropZone
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DropZoneCopyWith<DropZone> get copyWith => _$DropZoneCopyWithImpl<DropZone>(this as DropZone, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DropZone&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,area);

@override
String toString() {
  return 'DropZone(id: $id, name: $name, area: $area)';
}


}

/// @nodoc
abstract mixin class $DropZoneCopyWith<$Res>  {
  factory $DropZoneCopyWith(DropZone value, $Res Function(DropZone) _then) = _$DropZoneCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? area
});




}
/// @nodoc
class _$DropZoneCopyWithImpl<$Res>
    implements $DropZoneCopyWith<$Res> {
  _$DropZoneCopyWithImpl(this._self, this._then);

  final DropZone _self;
  final $Res Function(DropZone) _then;

/// Create a copy of DropZone
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? area = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DropZone].
extension DropZonePatterns on DropZone {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DropZone value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DropZone() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DropZone value)  $default,){
final _that = this;
switch (_that) {
case _DropZone():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DropZone value)?  $default,){
final _that = this;
switch (_that) {
case _DropZone() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? area)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DropZone() when $default != null:
return $default(_that.id,_that.name,_that.area);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? area)  $default,) {final _that = this;
switch (_that) {
case _DropZone():
return $default(_that.id,_that.name,_that.area);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? area)?  $default,) {final _that = this;
switch (_that) {
case _DropZone() when $default != null:
return $default(_that.id,_that.name,_that.area);case _:
  return null;

}
}

}

/// @nodoc


class _DropZone extends DropZone {
  const _DropZone({required this.id, required this.name, this.area}): super._();
  

@override final  String id;
@override final  String name;
/// 所在都道府県（如「群馬県」）。缺失时 UI 只展示名称。
@override final  String? area;

/// Create a copy of DropZone
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DropZoneCopyWith<_DropZone> get copyWith => __$DropZoneCopyWithImpl<_DropZone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DropZone&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,area);

@override
String toString() {
  return 'DropZone(id: $id, name: $name, area: $area)';
}


}

/// @nodoc
abstract mixin class _$DropZoneCopyWith<$Res> implements $DropZoneCopyWith<$Res> {
  factory _$DropZoneCopyWith(_DropZone value, $Res Function(_DropZone) _then) = __$DropZoneCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? area
});




}
/// @nodoc
class __$DropZoneCopyWithImpl<$Res>
    implements _$DropZoneCopyWith<$Res> {
  __$DropZoneCopyWithImpl(this._self, this._then);

  final _DropZone _self;
  final $Res Function(_DropZone) _then;

/// Create a copy of DropZone
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? area = freezed,}) {
  return _then(_DropZone(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
