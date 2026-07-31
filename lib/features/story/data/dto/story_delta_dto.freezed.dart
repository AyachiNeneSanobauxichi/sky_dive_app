// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_delta_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryDeltaDto {

/// 本帧的文本增量。心跳帧可能为空串。
 String get delta;
/// Create a copy of StoryDeltaDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryDeltaDtoCopyWith<StoryDeltaDto> get copyWith => _$StoryDeltaDtoCopyWithImpl<StoryDeltaDto>(this as StoryDeltaDto, _$identity);

  /// Serializes this StoryDeltaDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryDeltaDto&&(identical(other.delta, delta) || other.delta == delta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,delta);

@override
String toString() {
  return 'StoryDeltaDto(delta: $delta)';
}


}

/// @nodoc
abstract mixin class $StoryDeltaDtoCopyWith<$Res>  {
  factory $StoryDeltaDtoCopyWith(StoryDeltaDto value, $Res Function(StoryDeltaDto) _then) = _$StoryDeltaDtoCopyWithImpl;
@useResult
$Res call({
 String delta
});




}
/// @nodoc
class _$StoryDeltaDtoCopyWithImpl<$Res>
    implements $StoryDeltaDtoCopyWith<$Res> {
  _$StoryDeltaDtoCopyWithImpl(this._self, this._then);

  final StoryDeltaDto _self;
  final $Res Function(StoryDeltaDto) _then;

/// Create a copy of StoryDeltaDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? delta = null,}) {
  return _then(_self.copyWith(
delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryDeltaDto].
extension StoryDeltaDtoPatterns on StoryDeltaDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryDeltaDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryDeltaDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryDeltaDto value)  $default,){
final _that = this;
switch (_that) {
case _StoryDeltaDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryDeltaDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoryDeltaDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String delta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryDeltaDto() when $default != null:
return $default(_that.delta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String delta)  $default,) {final _that = this;
switch (_that) {
case _StoryDeltaDto():
return $default(_that.delta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String delta)?  $default,) {final _that = this;
switch (_that) {
case _StoryDeltaDto() when $default != null:
return $default(_that.delta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoryDeltaDto implements StoryDeltaDto {
  const _StoryDeltaDto({this.delta = ""});
  factory _StoryDeltaDto.fromJson(Map<String, dynamic> json) => _$StoryDeltaDtoFromJson(json);

/// 本帧的文本增量。心跳帧可能为空串。
@override@JsonKey() final  String delta;

/// Create a copy of StoryDeltaDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryDeltaDtoCopyWith<_StoryDeltaDto> get copyWith => __$StoryDeltaDtoCopyWithImpl<_StoryDeltaDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryDeltaDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryDeltaDto&&(identical(other.delta, delta) || other.delta == delta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,delta);

@override
String toString() {
  return 'StoryDeltaDto(delta: $delta)';
}


}

/// @nodoc
abstract mixin class _$StoryDeltaDtoCopyWith<$Res> implements $StoryDeltaDtoCopyWith<$Res> {
  factory _$StoryDeltaDtoCopyWith(_StoryDeltaDto value, $Res Function(_StoryDeltaDto) _then) = __$StoryDeltaDtoCopyWithImpl;
@override @useResult
$Res call({
 String delta
});




}
/// @nodoc
class __$StoryDeltaDtoCopyWithImpl<$Res>
    implements _$StoryDeltaDtoCopyWith<$Res> {
  __$StoryDeltaDtoCopyWithImpl(this._self, this._then);

  final _StoryDeltaDto _self;
  final $Res Function(_StoryDeltaDto) _then;

/// Create a copy of StoryDeltaDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? delta = null,}) {
  return _then(_StoryDeltaDto(
delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
