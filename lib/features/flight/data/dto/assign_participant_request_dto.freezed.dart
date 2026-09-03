// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assign_participant_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssignParticipantRequestDto {

 String get participantId; String get role;/// 此人不在运营侧候选池里时才下发（客人自助预约即属此类）。
/// 后端能按 id 查到用户时以后端数据为准，这里只是兜底。
 String? get name; String? get detail;
/// Create a copy of AssignParticipantRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignParticipantRequestDtoCopyWith<AssignParticipantRequestDto> get copyWith => _$AssignParticipantRequestDtoCopyWithImpl<AssignParticipantRequestDto>(this as AssignParticipantRequestDto, _$identity);

  /// Serializes this AssignParticipantRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignParticipantRequestDto&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,role,name,detail);

@override
String toString() {
  return 'AssignParticipantRequestDto(participantId: $participantId, role: $role, name: $name, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $AssignParticipantRequestDtoCopyWith<$Res>  {
  factory $AssignParticipantRequestDtoCopyWith(AssignParticipantRequestDto value, $Res Function(AssignParticipantRequestDto) _then) = _$AssignParticipantRequestDtoCopyWithImpl;
@useResult
$Res call({
 String participantId, String role, String? name, String? detail
});




}
/// @nodoc
class _$AssignParticipantRequestDtoCopyWithImpl<$Res>
    implements $AssignParticipantRequestDtoCopyWith<$Res> {
  _$AssignParticipantRequestDtoCopyWithImpl(this._self, this._then);

  final AssignParticipantRequestDto _self;
  final $Res Function(AssignParticipantRequestDto) _then;

/// Create a copy of AssignParticipantRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participantId = null,Object? role = null,Object? name = freezed,Object? detail = freezed,}) {
  return _then(_self.copyWith(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignParticipantRequestDto].
extension AssignParticipantRequestDtoPatterns on AssignParticipantRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignParticipantRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignParticipantRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignParticipantRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _AssignParticipantRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignParticipantRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _AssignParticipantRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String participantId,  String role,  String? name,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignParticipantRequestDto() when $default != null:
return $default(_that.participantId,_that.role,_that.name,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String participantId,  String role,  String? name,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _AssignParticipantRequestDto():
return $default(_that.participantId,_that.role,_that.name,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String participantId,  String role,  String? name,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _AssignParticipantRequestDto() when $default != null:
return $default(_that.participantId,_that.role,_that.name,_that.detail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignParticipantRequestDto extends AssignParticipantRequestDto {
  const _AssignParticipantRequestDto({required this.participantId, required this.role, this.name, this.detail}): super._();
  factory _AssignParticipantRequestDto.fromJson(Map<String, dynamic> json) => _$AssignParticipantRequestDtoFromJson(json);

@override final  String participantId;
@override final  String role;
/// 此人不在运营侧候选池里时才下发（客人自助预约即属此类）。
/// 后端能按 id 查到用户时以后端数据为准，这里只是兜底。
@override final  String? name;
@override final  String? detail;

/// Create a copy of AssignParticipantRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignParticipantRequestDtoCopyWith<_AssignParticipantRequestDto> get copyWith => __$AssignParticipantRequestDtoCopyWithImpl<_AssignParticipantRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignParticipantRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignParticipantRequestDto&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.detail, detail) || other.detail == detail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,participantId,role,name,detail);

@override
String toString() {
  return 'AssignParticipantRequestDto(participantId: $participantId, role: $role, name: $name, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$AssignParticipantRequestDtoCopyWith<$Res> implements $AssignParticipantRequestDtoCopyWith<$Res> {
  factory _$AssignParticipantRequestDtoCopyWith(_AssignParticipantRequestDto value, $Res Function(_AssignParticipantRequestDto) _then) = __$AssignParticipantRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String participantId, String role, String? name, String? detail
});




}
/// @nodoc
class __$AssignParticipantRequestDtoCopyWithImpl<$Res>
    implements _$AssignParticipantRequestDtoCopyWith<$Res> {
  __$AssignParticipantRequestDtoCopyWithImpl(this._self, this._then);

  final _AssignParticipantRequestDto _self;
  final $Res Function(_AssignParticipantRequestDto) _then;

/// Create a copy of AssignParticipantRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantId = null,Object? role = null,Object? name = freezed,Object? detail = freezed,}) {
  return _then(_AssignParticipantRequestDto(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
