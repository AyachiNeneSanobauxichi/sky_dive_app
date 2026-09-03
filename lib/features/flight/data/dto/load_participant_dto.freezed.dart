// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_participant_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoadParticipantDto {

 String get id; String get name;/// 角色原始值（`customer` / `photographer`）。
 String get role; String? get detail;
/// Create a copy of LoadParticipantDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadParticipantDtoCopyWith<LoadParticipantDto> get copyWith => _$LoadParticipantDtoCopyWithImpl<LoadParticipantDto>(this as LoadParticipantDto, _$identity);

  /// Serializes this LoadParticipantDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadParticipantDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,detail);

@override
String toString() {
  return 'LoadParticipantDto(id: $id, name: $name, role: $role, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $LoadParticipantDtoCopyWith<$Res>  {
  factory $LoadParticipantDtoCopyWith(LoadParticipantDto value, $Res Function(LoadParticipantDto) _then) = _$LoadParticipantDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String role, String? detail
});




}
/// @nodoc
class _$LoadParticipantDtoCopyWithImpl<$Res>
    implements $LoadParticipantDtoCopyWith<$Res> {
  _$LoadParticipantDtoCopyWithImpl(this._self, this._then);

  final LoadParticipantDto _self;
  final $Res Function(LoadParticipantDto) _then;

/// Create a copy of LoadParticipantDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? detail = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoadParticipantDto].
extension LoadParticipantDtoPatterns on LoadParticipantDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadParticipantDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadParticipantDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadParticipantDto value)  $default,){
final _that = this;
switch (_that) {
case _LoadParticipantDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadParticipantDto value)?  $default,){
final _that = this;
switch (_that) {
case _LoadParticipantDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadParticipantDto() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _LoadParticipantDto():
return $default(_that.id,_that.name,_that.role,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String role,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _LoadParticipantDto() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoadParticipantDto extends LoadParticipantDto {
  const _LoadParticipantDto({required this.id, required this.name, required this.role, this.detail}): super._();
  factory _LoadParticipantDto.fromJson(Map<String, dynamic> json) => _$LoadParticipantDtoFromJson(json);

@override final  String id;
@override final  String name;
/// 角色原始值（`customer` / `photographer`）。
@override final  String role;
@override final  String? detail;

/// Create a copy of LoadParticipantDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadParticipantDtoCopyWith<_LoadParticipantDto> get copyWith => __$LoadParticipantDtoCopyWithImpl<_LoadParticipantDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoadParticipantDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadParticipantDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,detail);

@override
String toString() {
  return 'LoadParticipantDto(id: $id, name: $name, role: $role, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$LoadParticipantDtoCopyWith<$Res> implements $LoadParticipantDtoCopyWith<$Res> {
  factory _$LoadParticipantDtoCopyWith(_LoadParticipantDto value, $Res Function(_LoadParticipantDto) _then) = __$LoadParticipantDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String role, String? detail
});




}
/// @nodoc
class __$LoadParticipantDtoCopyWithImpl<$Res>
    implements _$LoadParticipantDtoCopyWith<$Res> {
  __$LoadParticipantDtoCopyWithImpl(this._self, this._then);

  final _LoadParticipantDto _self;
  final $Res Function(_LoadParticipantDto) _then;

/// Create a copy of LoadParticipantDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? detail = freezed,}) {
  return _then(_LoadParticipantDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
