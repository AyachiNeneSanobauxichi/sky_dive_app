// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_sms_code_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendSmsCodeRequestDto {

 String get phone;
/// Create a copy of SendSmsCodeRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendSmsCodeRequestDtoCopyWith<SendSmsCodeRequestDto> get copyWith => _$SendSmsCodeRequestDtoCopyWithImpl<SendSmsCodeRequestDto>(this as SendSmsCodeRequestDto, _$identity);

  /// Serializes this SendSmsCodeRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendSmsCodeRequestDto&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'SendSmsCodeRequestDto(phone: $phone)';
}


}

/// @nodoc
abstract mixin class $SendSmsCodeRequestDtoCopyWith<$Res>  {
  factory $SendSmsCodeRequestDtoCopyWith(SendSmsCodeRequestDto value, $Res Function(SendSmsCodeRequestDto) _then) = _$SendSmsCodeRequestDtoCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class _$SendSmsCodeRequestDtoCopyWithImpl<$Res>
    implements $SendSmsCodeRequestDtoCopyWith<$Res> {
  _$SendSmsCodeRequestDtoCopyWithImpl(this._self, this._then);

  final SendSmsCodeRequestDto _self;
  final $Res Function(SendSmsCodeRequestDto) _then;

/// Create a copy of SendSmsCodeRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,}) {
  return _then(_self.copyWith(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SendSmsCodeRequestDto].
extension SendSmsCodeRequestDtoPatterns on SendSmsCodeRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendSmsCodeRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendSmsCodeRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendSmsCodeRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SendSmsCodeRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendSmsCodeRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SendSmsCodeRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendSmsCodeRequestDto() when $default != null:
return $default(_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone)  $default,) {final _that = this;
switch (_that) {
case _SendSmsCodeRequestDto():
return $default(_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone)?  $default,) {final _that = this;
switch (_that) {
case _SendSmsCodeRequestDto() when $default != null:
return $default(_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendSmsCodeRequestDto implements SendSmsCodeRequestDto {
  const _SendSmsCodeRequestDto({required this.phone});
  factory _SendSmsCodeRequestDto.fromJson(Map<String, dynamic> json) => _$SendSmsCodeRequestDtoFromJson(json);

@override final  String phone;

/// Create a copy of SendSmsCodeRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendSmsCodeRequestDtoCopyWith<_SendSmsCodeRequestDto> get copyWith => __$SendSmsCodeRequestDtoCopyWithImpl<_SendSmsCodeRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendSmsCodeRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendSmsCodeRequestDto&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'SendSmsCodeRequestDto(phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$SendSmsCodeRequestDtoCopyWith<$Res> implements $SendSmsCodeRequestDtoCopyWith<$Res> {
  factory _$SendSmsCodeRequestDtoCopyWith(_SendSmsCodeRequestDto value, $Res Function(_SendSmsCodeRequestDto) _then) = __$SendSmsCodeRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String phone
});




}
/// @nodoc
class __$SendSmsCodeRequestDtoCopyWithImpl<$Res>
    implements _$SendSmsCodeRequestDtoCopyWith<$Res> {
  __$SendSmsCodeRequestDtoCopyWithImpl(this._self, this._then);

  final _SendSmsCodeRequestDto _self;
  final $Res Function(_SendSmsCodeRequestDto) _then;

/// Create a copy of SendSmsCodeRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(_SendSmsCodeRequestDto(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
