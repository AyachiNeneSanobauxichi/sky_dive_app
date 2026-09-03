// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reorder_participants_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReorderParticipantsRequestDto {

 List<String> get participantIds;/// 这次重排的是哪个角色（`customer` / `photographer`）。
 String get role;
/// Create a copy of ReorderParticipantsRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderParticipantsRequestDtoCopyWith<ReorderParticipantsRequestDto> get copyWith => _$ReorderParticipantsRequestDtoCopyWithImpl<ReorderParticipantsRequestDto>(this as ReorderParticipantsRequestDto, _$identity);

  /// Serializes this ReorderParticipantsRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderParticipantsRequestDto&&const DeepCollectionEquality().equals(other.participantIds, participantIds)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(participantIds),role);

@override
String toString() {
  return 'ReorderParticipantsRequestDto(participantIds: $participantIds, role: $role)';
}


}

/// @nodoc
abstract mixin class $ReorderParticipantsRequestDtoCopyWith<$Res>  {
  factory $ReorderParticipantsRequestDtoCopyWith(ReorderParticipantsRequestDto value, $Res Function(ReorderParticipantsRequestDto) _then) = _$ReorderParticipantsRequestDtoCopyWithImpl;
@useResult
$Res call({
 List<String> participantIds, String role
});




}
/// @nodoc
class _$ReorderParticipantsRequestDtoCopyWithImpl<$Res>
    implements $ReorderParticipantsRequestDtoCopyWith<$Res> {
  _$ReorderParticipantsRequestDtoCopyWithImpl(this._self, this._then);

  final ReorderParticipantsRequestDto _self;
  final $Res Function(ReorderParticipantsRequestDto) _then;

/// Create a copy of ReorderParticipantsRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participantIds = null,Object? role = null,}) {
  return _then(_self.copyWith(
participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderParticipantsRequestDto].
extension ReorderParticipantsRequestDtoPatterns on ReorderParticipantsRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderParticipantsRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderParticipantsRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderParticipantsRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _ReorderParticipantsRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderParticipantsRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderParticipantsRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> participantIds,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderParticipantsRequestDto() when $default != null:
return $default(_that.participantIds,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> participantIds,  String role)  $default,) {final _that = this;
switch (_that) {
case _ReorderParticipantsRequestDto():
return $default(_that.participantIds,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> participantIds,  String role)?  $default,) {final _that = this;
switch (_that) {
case _ReorderParticipantsRequestDto() when $default != null:
return $default(_that.participantIds,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderParticipantsRequestDto extends ReorderParticipantsRequestDto {
  const _ReorderParticipantsRequestDto({required final  List<String> participantIds, required this.role}): _participantIds = participantIds,super._();
  factory _ReorderParticipantsRequestDto.fromJson(Map<String, dynamic> json) => _$ReorderParticipantsRequestDtoFromJson(json);

 final  List<String> _participantIds;
@override List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

/// 这次重排的是哪个角色（`customer` / `photographer`）。
@override final  String role;

/// Create a copy of ReorderParticipantsRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderParticipantsRequestDtoCopyWith<_ReorderParticipantsRequestDto> get copyWith => __$ReorderParticipantsRequestDtoCopyWithImpl<_ReorderParticipantsRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderParticipantsRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderParticipantsRequestDto&&const DeepCollectionEquality().equals(other._participantIds, _participantIds)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_participantIds),role);

@override
String toString() {
  return 'ReorderParticipantsRequestDto(participantIds: $participantIds, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ReorderParticipantsRequestDtoCopyWith<$Res> implements $ReorderParticipantsRequestDtoCopyWith<$Res> {
  factory _$ReorderParticipantsRequestDtoCopyWith(_ReorderParticipantsRequestDto value, $Res Function(_ReorderParticipantsRequestDto) _then) = __$ReorderParticipantsRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 List<String> participantIds, String role
});




}
/// @nodoc
class __$ReorderParticipantsRequestDtoCopyWithImpl<$Res>
    implements _$ReorderParticipantsRequestDtoCopyWith<$Res> {
  __$ReorderParticipantsRequestDtoCopyWithImpl(this._self, this._then);

  final _ReorderParticipantsRequestDto _self;
  final $Res Function(_ReorderParticipantsRequestDto) _then;

/// Create a copy of ReorderParticipantsRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantIds = null,Object? role = null,}) {
  return _then(_ReorderParticipantsRequestDto(
participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
