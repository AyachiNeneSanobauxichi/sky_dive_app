// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_sms_code_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendSmsCodeResponseDto {

 int get resendAfterSeconds;
/// Create a copy of SendSmsCodeResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendSmsCodeResponseDtoCopyWith<SendSmsCodeResponseDto> get copyWith => _$SendSmsCodeResponseDtoCopyWithImpl<SendSmsCodeResponseDto>(this as SendSmsCodeResponseDto, _$identity);

  /// Serializes this SendSmsCodeResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendSmsCodeResponseDto&&(identical(other.resendAfterSeconds, resendAfterSeconds) || other.resendAfterSeconds == resendAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resendAfterSeconds);

@override
String toString() {
  return 'SendSmsCodeResponseDto(resendAfterSeconds: $resendAfterSeconds)';
}


}

/// @nodoc
abstract mixin class $SendSmsCodeResponseDtoCopyWith<$Res>  {
  factory $SendSmsCodeResponseDtoCopyWith(SendSmsCodeResponseDto value, $Res Function(SendSmsCodeResponseDto) _then) = _$SendSmsCodeResponseDtoCopyWithImpl;
@useResult
$Res call({
 int resendAfterSeconds
});




}
/// @nodoc
class _$SendSmsCodeResponseDtoCopyWithImpl<$Res>
    implements $SendSmsCodeResponseDtoCopyWith<$Res> {
  _$SendSmsCodeResponseDtoCopyWithImpl(this._self, this._then);

  final SendSmsCodeResponseDto _self;
  final $Res Function(SendSmsCodeResponseDto) _then;

/// Create a copy of SendSmsCodeResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resendAfterSeconds = null,}) {
  return _then(_self.copyWith(
resendAfterSeconds: null == resendAfterSeconds ? _self.resendAfterSeconds : resendAfterSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SendSmsCodeResponseDto].
extension SendSmsCodeResponseDtoPatterns on SendSmsCodeResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendSmsCodeResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendSmsCodeResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendSmsCodeResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SendSmsCodeResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendSmsCodeResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SendSmsCodeResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int resendAfterSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendSmsCodeResponseDto() when $default != null:
return $default(_that.resendAfterSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int resendAfterSeconds)  $default,) {final _that = this;
switch (_that) {
case _SendSmsCodeResponseDto():
return $default(_that.resendAfterSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int resendAfterSeconds)?  $default,) {final _that = this;
switch (_that) {
case _SendSmsCodeResponseDto() when $default != null:
return $default(_that.resendAfterSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendSmsCodeResponseDto implements SendSmsCodeResponseDto {
  const _SendSmsCodeResponseDto({required this.resendAfterSeconds});
  factory _SendSmsCodeResponseDto.fromJson(Map<String, dynamic> json) => _$SendSmsCodeResponseDtoFromJson(json);

@override final  int resendAfterSeconds;

/// Create a copy of SendSmsCodeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendSmsCodeResponseDtoCopyWith<_SendSmsCodeResponseDto> get copyWith => __$SendSmsCodeResponseDtoCopyWithImpl<_SendSmsCodeResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendSmsCodeResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendSmsCodeResponseDto&&(identical(other.resendAfterSeconds, resendAfterSeconds) || other.resendAfterSeconds == resendAfterSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resendAfterSeconds);

@override
String toString() {
  return 'SendSmsCodeResponseDto(resendAfterSeconds: $resendAfterSeconds)';
}


}

/// @nodoc
abstract mixin class _$SendSmsCodeResponseDtoCopyWith<$Res> implements $SendSmsCodeResponseDtoCopyWith<$Res> {
  factory _$SendSmsCodeResponseDtoCopyWith(_SendSmsCodeResponseDto value, $Res Function(_SendSmsCodeResponseDto) _then) = __$SendSmsCodeResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int resendAfterSeconds
});




}
/// @nodoc
class __$SendSmsCodeResponseDtoCopyWithImpl<$Res>
    implements _$SendSmsCodeResponseDtoCopyWith<$Res> {
  __$SendSmsCodeResponseDtoCopyWithImpl(this._self, this._then);

  final _SendSmsCodeResponseDto _self;
  final $Res Function(_SendSmsCodeResponseDto) _then;

/// Create a copy of SendSmsCodeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resendAfterSeconds = null,}) {
  return _then(_SendSmsCodeResponseDto(
resendAfterSeconds: null == resendAfterSeconds ? _self.resendAfterSeconds : resendAfterSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
