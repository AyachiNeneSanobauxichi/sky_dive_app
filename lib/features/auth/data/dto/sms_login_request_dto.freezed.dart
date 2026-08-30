// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_login_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmsLoginRequestDto {

 String get phone; String get smsCode;
/// Create a copy of SmsLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsLoginRequestDtoCopyWith<SmsLoginRequestDto> get copyWith => _$SmsLoginRequestDtoCopyWithImpl<SmsLoginRequestDto>(this as SmsLoginRequestDto, _$identity);

  /// Serializes this SmsLoginRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsLoginRequestDto&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.smsCode, smsCode) || other.smsCode == smsCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,smsCode);

@override
String toString() {
  return 'SmsLoginRequestDto(phone: $phone, smsCode: $smsCode)';
}


}

/// @nodoc
abstract mixin class $SmsLoginRequestDtoCopyWith<$Res>  {
  factory $SmsLoginRequestDtoCopyWith(SmsLoginRequestDto value, $Res Function(SmsLoginRequestDto) _then) = _$SmsLoginRequestDtoCopyWithImpl;
@useResult
$Res call({
 String phone, String smsCode
});




}
/// @nodoc
class _$SmsLoginRequestDtoCopyWithImpl<$Res>
    implements $SmsLoginRequestDtoCopyWith<$Res> {
  _$SmsLoginRequestDtoCopyWithImpl(this._self, this._then);

  final SmsLoginRequestDto _self;
  final $Res Function(SmsLoginRequestDto) _then;

/// Create a copy of SmsLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? smsCode = null,}) {
  return _then(_self.copyWith(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,smsCode: null == smsCode ? _self.smsCode : smsCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SmsLoginRequestDto].
extension SmsLoginRequestDtoPatterns on SmsLoginRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmsLoginRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmsLoginRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmsLoginRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SmsLoginRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmsLoginRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SmsLoginRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String smsCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmsLoginRequestDto() when $default != null:
return $default(_that.phone,_that.smsCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String smsCode)  $default,) {final _that = this;
switch (_that) {
case _SmsLoginRequestDto():
return $default(_that.phone,_that.smsCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String smsCode)?  $default,) {final _that = this;
switch (_that) {
case _SmsLoginRequestDto() when $default != null:
return $default(_that.phone,_that.smsCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmsLoginRequestDto implements SmsLoginRequestDto {
  const _SmsLoginRequestDto({required this.phone, required this.smsCode});
  factory _SmsLoginRequestDto.fromJson(Map<String, dynamic> json) => _$SmsLoginRequestDtoFromJson(json);

@override final  String phone;
@override final  String smsCode;

/// Create a copy of SmsLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmsLoginRequestDtoCopyWith<_SmsLoginRequestDto> get copyWith => __$SmsLoginRequestDtoCopyWithImpl<_SmsLoginRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmsLoginRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmsLoginRequestDto&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.smsCode, smsCode) || other.smsCode == smsCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,smsCode);

@override
String toString() {
  return 'SmsLoginRequestDto(phone: $phone, smsCode: $smsCode)';
}


}

/// @nodoc
abstract mixin class _$SmsLoginRequestDtoCopyWith<$Res> implements $SmsLoginRequestDtoCopyWith<$Res> {
  factory _$SmsLoginRequestDtoCopyWith(_SmsLoginRequestDto value, $Res Function(_SmsLoginRequestDto) _then) = __$SmsLoginRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String phone, String smsCode
});




}
/// @nodoc
class __$SmsLoginRequestDtoCopyWithImpl<$Res>
    implements _$SmsLoginRequestDtoCopyWith<$Res> {
  __$SmsLoginRequestDtoCopyWithImpl(this._self, this._then);

  final _SmsLoginRequestDto _self;
  final $Res Function(_SmsLoginRequestDto) _then;

/// Create a copy of SmsLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? smsCode = null,}) {
  return _then(_SmsLoginRequestDto(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,smsCode: null == smsCode ? _self.smsCode : smsCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
