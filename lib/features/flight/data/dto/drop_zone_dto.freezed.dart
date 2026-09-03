// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drop_zone_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DropZoneDto {

 String get id; String get name; String? get area;
/// Create a copy of DropZoneDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DropZoneDtoCopyWith<DropZoneDto> get copyWith => _$DropZoneDtoCopyWithImpl<DropZoneDto>(this as DropZoneDto, _$identity);

  /// Serializes this DropZoneDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DropZoneDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,area);

@override
String toString() {
  return 'DropZoneDto(id: $id, name: $name, area: $area)';
}


}

/// @nodoc
abstract mixin class $DropZoneDtoCopyWith<$Res>  {
  factory $DropZoneDtoCopyWith(DropZoneDto value, $Res Function(DropZoneDto) _then) = _$DropZoneDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? area
});




}
/// @nodoc
class _$DropZoneDtoCopyWithImpl<$Res>
    implements $DropZoneDtoCopyWith<$Res> {
  _$DropZoneDtoCopyWithImpl(this._self, this._then);

  final DropZoneDto _self;
  final $Res Function(DropZoneDto) _then;

/// Create a copy of DropZoneDto
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


/// Adds pattern-matching-related methods to [DropZoneDto].
extension DropZoneDtoPatterns on DropZoneDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DropZoneDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DropZoneDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DropZoneDto value)  $default,){
final _that = this;
switch (_that) {
case _DropZoneDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DropZoneDto value)?  $default,){
final _that = this;
switch (_that) {
case _DropZoneDto() when $default != null:
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
case _DropZoneDto() when $default != null:
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
case _DropZoneDto():
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
case _DropZoneDto() when $default != null:
return $default(_that.id,_that.name,_that.area);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DropZoneDto extends DropZoneDto {
  const _DropZoneDto({required this.id, required this.name, this.area}): super._();
  factory _DropZoneDto.fromJson(Map<String, dynamic> json) => _$DropZoneDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? area;

/// Create a copy of DropZoneDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DropZoneDtoCopyWith<_DropZoneDto> get copyWith => __$DropZoneDtoCopyWithImpl<_DropZoneDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DropZoneDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DropZoneDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,area);

@override
String toString() {
  return 'DropZoneDto(id: $id, name: $name, area: $area)';
}


}

/// @nodoc
abstract mixin class _$DropZoneDtoCopyWith<$Res> implements $DropZoneDtoCopyWith<$Res> {
  factory _$DropZoneDtoCopyWith(_DropZoneDto value, $Res Function(_DropZoneDto) _then) = __$DropZoneDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? area
});




}
/// @nodoc
class __$DropZoneDtoCopyWithImpl<$Res>
    implements _$DropZoneDtoCopyWith<$Res> {
  __$DropZoneDtoCopyWithImpl(this._self, this._then);

  final _DropZoneDto _self;
  final $Res Function(_DropZoneDto) _then;

/// Create a copy of DropZoneDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? area = freezed,}) {
  return _then(_DropZoneDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
