// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_code_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SmsCodeState {

/// 请求进行中（按钮进入忙碌态，防止重复发送）。
 bool get isSending;/// 距离可再次发送的剩余秒数，0 表示无冷却。
 int get cooldownSeconds;
/// Create a copy of SmsCodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsCodeStateCopyWith<SmsCodeState> get copyWith => _$SmsCodeStateCopyWithImpl<SmsCodeState>(this as SmsCodeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsCodeState&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.cooldownSeconds, cooldownSeconds) || other.cooldownSeconds == cooldownSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,isSending,cooldownSeconds);

@override
String toString() {
  return 'SmsCodeState(isSending: $isSending, cooldownSeconds: $cooldownSeconds)';
}


}

/// @nodoc
abstract mixin class $SmsCodeStateCopyWith<$Res>  {
  factory $SmsCodeStateCopyWith(SmsCodeState value, $Res Function(SmsCodeState) _then) = _$SmsCodeStateCopyWithImpl;
@useResult
$Res call({
 bool isSending, int cooldownSeconds
});




}
/// @nodoc
class _$SmsCodeStateCopyWithImpl<$Res>
    implements $SmsCodeStateCopyWith<$Res> {
  _$SmsCodeStateCopyWithImpl(this._self, this._then);

  final SmsCodeState _self;
  final $Res Function(SmsCodeState) _then;

/// Create a copy of SmsCodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSending = null,Object? cooldownSeconds = null,}) {
  return _then(_self.copyWith(
isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,cooldownSeconds: null == cooldownSeconds ? _self.cooldownSeconds : cooldownSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SmsCodeState].
extension SmsCodeStatePatterns on SmsCodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmsCodeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmsCodeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmsCodeState value)  $default,){
final _that = this;
switch (_that) {
case _SmsCodeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmsCodeState value)?  $default,){
final _that = this;
switch (_that) {
case _SmsCodeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSending,  int cooldownSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmsCodeState() when $default != null:
return $default(_that.isSending,_that.cooldownSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSending,  int cooldownSeconds)  $default,) {final _that = this;
switch (_that) {
case _SmsCodeState():
return $default(_that.isSending,_that.cooldownSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSending,  int cooldownSeconds)?  $default,) {final _that = this;
switch (_that) {
case _SmsCodeState() when $default != null:
return $default(_that.isSending,_that.cooldownSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _SmsCodeState extends SmsCodeState {
  const _SmsCodeState({this.isSending = false, this.cooldownSeconds = 0}): super._();
  

/// 请求进行中（按钮进入忙碌态，防止重复发送）。
@override@JsonKey() final  bool isSending;
/// 距离可再次发送的剩余秒数，0 表示无冷却。
@override@JsonKey() final  int cooldownSeconds;

/// Create a copy of SmsCodeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmsCodeStateCopyWith<_SmsCodeState> get copyWith => __$SmsCodeStateCopyWithImpl<_SmsCodeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmsCodeState&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.cooldownSeconds, cooldownSeconds) || other.cooldownSeconds == cooldownSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,isSending,cooldownSeconds);

@override
String toString() {
  return 'SmsCodeState(isSending: $isSending, cooldownSeconds: $cooldownSeconds)';
}


}

/// @nodoc
abstract mixin class _$SmsCodeStateCopyWith<$Res> implements $SmsCodeStateCopyWith<$Res> {
  factory _$SmsCodeStateCopyWith(_SmsCodeState value, $Res Function(_SmsCodeState) _then) = __$SmsCodeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSending, int cooldownSeconds
});




}
/// @nodoc
class __$SmsCodeStateCopyWithImpl<$Res>
    implements _$SmsCodeStateCopyWith<$Res> {
  __$SmsCodeStateCopyWithImpl(this._self, this._then);

  final _SmsCodeState _self;
  final $Res Function(_SmsCodeState) _then;

/// Create a copy of SmsCodeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSending = null,Object? cooldownSeconds = null,}) {
  return _then(_SmsCodeState(
isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,cooldownSeconds: null == cooldownSeconds ? _self.cooldownSeconds : cooldownSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
