// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generation_event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenerationEventDto {

 String get type;/// 注意是 snake_case，且与 `type` **同级**、不在 payload 内。
@JsonKey(name: "session_id") String? get sessionId; Map<String, dynamic> get payload;/// 服务端事件时间（RFC3339，纳秒精度，如 `2026-08-10T13:12:58.675533211Z`）。
///
/// 刻意存**原始字符串**而不是让 json_serializable 直接反序列化成 `DateTime`：
/// 后者遇到一个格式不对的时间戳会抛 `FormatException`，而仓库层正是靠捕获
/// 这个异常来跳过脏帧的——于是一个坏时间戳会让一整帧好事件被丢掉。
/// 解析交给 [occurredAt]，失败就只是没有时间，事件本身照样送到。
 String? get timestamp;
/// Create a copy of GenerationEventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationEventDtoCopyWith<GenerationEventDto> get copyWith => _$GenerationEventDtoCopyWithImpl<GenerationEventDto>(this as GenerationEventDto, _$identity);

  /// Serializes this GenerationEventDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationEventDto&&(identical(other.type, type) || other.type == type)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,sessionId,const DeepCollectionEquality().hash(payload),timestamp);

@override
String toString() {
  return 'GenerationEventDto(type: $type, sessionId: $sessionId, payload: $payload, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GenerationEventDtoCopyWith<$Res>  {
  factory $GenerationEventDtoCopyWith(GenerationEventDto value, $Res Function(GenerationEventDto) _then) = _$GenerationEventDtoCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: "session_id") String? sessionId, Map<String, dynamic> payload, String? timestamp
});




}
/// @nodoc
class _$GenerationEventDtoCopyWithImpl<$Res>
    implements $GenerationEventDtoCopyWith<$Res> {
  _$GenerationEventDtoCopyWithImpl(this._self, this._then);

  final GenerationEventDto _self;
  final $Res Function(GenerationEventDto) _then;

/// Create a copy of GenerationEventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? sessionId = freezed,Object? payload = null,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerationEventDto].
extension GenerationEventDtoPatterns on GenerationEventDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerationEventDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerationEventDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerationEventDto value)  $default,){
final _that = this;
switch (_that) {
case _GenerationEventDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerationEventDto value)?  $default,){
final _that = this;
switch (_that) {
case _GenerationEventDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @JsonKey(name: "session_id")  String? sessionId,  Map<String, dynamic> payload,  String? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerationEventDto() when $default != null:
return $default(_that.type,_that.sessionId,_that.payload,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @JsonKey(name: "session_id")  String? sessionId,  Map<String, dynamic> payload,  String? timestamp)  $default,) {final _that = this;
switch (_that) {
case _GenerationEventDto():
return $default(_that.type,_that.sessionId,_that.payload,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @JsonKey(name: "session_id")  String? sessionId,  Map<String, dynamic> payload,  String? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _GenerationEventDto() when $default != null:
return $default(_that.type,_that.sessionId,_that.payload,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenerationEventDto extends GenerationEventDto {
  const _GenerationEventDto({this.type = "", @JsonKey(name: "session_id") this.sessionId, final  Map<String, dynamic> payload = const <String, dynamic>{}, this.timestamp}): _payload = payload,super._();
  factory _GenerationEventDto.fromJson(Map<String, dynamic> json) => _$GenerationEventDtoFromJson(json);

@override@JsonKey() final  String type;
/// 注意是 snake_case，且与 `type` **同级**、不在 payload 内。
@override@JsonKey(name: "session_id") final  String? sessionId;
 final  Map<String, dynamic> _payload;
@override@JsonKey() Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

/// 服务端事件时间（RFC3339，纳秒精度，如 `2026-08-10T13:12:58.675533211Z`）。
///
/// 刻意存**原始字符串**而不是让 json_serializable 直接反序列化成 `DateTime`：
/// 后者遇到一个格式不对的时间戳会抛 `FormatException`，而仓库层正是靠捕获
/// 这个异常来跳过脏帧的——于是一个坏时间戳会让一整帧好事件被丢掉。
/// 解析交给 [occurredAt]，失败就只是没有时间，事件本身照样送到。
@override final  String? timestamp;

/// Create a copy of GenerationEventDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerationEventDtoCopyWith<_GenerationEventDto> get copyWith => __$GenerationEventDtoCopyWithImpl<_GenerationEventDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenerationEventDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerationEventDto&&(identical(other.type, type) || other.type == type)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,sessionId,const DeepCollectionEquality().hash(_payload),timestamp);

@override
String toString() {
  return 'GenerationEventDto(type: $type, sessionId: $sessionId, payload: $payload, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$GenerationEventDtoCopyWith<$Res> implements $GenerationEventDtoCopyWith<$Res> {
  factory _$GenerationEventDtoCopyWith(_GenerationEventDto value, $Res Function(_GenerationEventDto) _then) = __$GenerationEventDtoCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: "session_id") String? sessionId, Map<String, dynamic> payload, String? timestamp
});




}
/// @nodoc
class __$GenerationEventDtoCopyWithImpl<$Res>
    implements _$GenerationEventDtoCopyWith<$Res> {
  __$GenerationEventDtoCopyWithImpl(this._self, this._then);

  final _GenerationEventDto _self;
  final $Res Function(_GenerationEventDto) _then;

/// Create a copy of GenerationEventDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? sessionId = freezed,Object? payload = null,Object? timestamp = freezed,}) {
  return _then(_GenerationEventDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
