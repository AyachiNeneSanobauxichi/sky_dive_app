// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_window_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherWindowDto {

 String get dropZone; String get status; int get temperatureC; double get windSpeedMps; String? get observedAt;
/// Create a copy of WeatherWindowDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherWindowDtoCopyWith<WeatherWindowDto> get copyWith => _$WeatherWindowDtoCopyWithImpl<WeatherWindowDto>(this as WeatherWindowDto, _$identity);

  /// Serializes this WeatherWindowDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherWindowDto&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.status, status) || other.status == status)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.windSpeedMps, windSpeedMps) || other.windSpeedMps == windSpeedMps)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dropZone,status,temperatureC,windSpeedMps,observedAt);

@override
String toString() {
  return 'WeatherWindowDto(dropZone: $dropZone, status: $status, temperatureC: $temperatureC, windSpeedMps: $windSpeedMps, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class $WeatherWindowDtoCopyWith<$Res>  {
  factory $WeatherWindowDtoCopyWith(WeatherWindowDto value, $Res Function(WeatherWindowDto) _then) = _$WeatherWindowDtoCopyWithImpl;
@useResult
$Res call({
 String dropZone, String status, int temperatureC, double windSpeedMps, String? observedAt
});




}
/// @nodoc
class _$WeatherWindowDtoCopyWithImpl<$Res>
    implements $WeatherWindowDtoCopyWith<$Res> {
  _$WeatherWindowDtoCopyWithImpl(this._self, this._then);

  final WeatherWindowDto _self;
  final $Res Function(WeatherWindowDto) _then;

/// Create a copy of WeatherWindowDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dropZone = null,Object? status = null,Object? temperatureC = null,Object? windSpeedMps = null,Object? observedAt = freezed,}) {
  return _then(_self.copyWith(
dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as int,windSpeedMps: null == windSpeedMps ? _self.windSpeedMps : windSpeedMps // ignore: cast_nullable_to_non_nullable
as double,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherWindowDto].
extension WeatherWindowDtoPatterns on WeatherWindowDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherWindowDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherWindowDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherWindowDto value)  $default,){
final _that = this;
switch (_that) {
case _WeatherWindowDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherWindowDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherWindowDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dropZone,  String status,  int temperatureC,  double windSpeedMps,  String? observedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherWindowDto() when $default != null:
return $default(_that.dropZone,_that.status,_that.temperatureC,_that.windSpeedMps,_that.observedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dropZone,  String status,  int temperatureC,  double windSpeedMps,  String? observedAt)  $default,) {final _that = this;
switch (_that) {
case _WeatherWindowDto():
return $default(_that.dropZone,_that.status,_that.temperatureC,_that.windSpeedMps,_that.observedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dropZone,  String status,  int temperatureC,  double windSpeedMps,  String? observedAt)?  $default,) {final _that = this;
switch (_that) {
case _WeatherWindowDto() when $default != null:
return $default(_that.dropZone,_that.status,_that.temperatureC,_that.windSpeedMps,_that.observedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherWindowDto extends WeatherWindowDto {
  const _WeatherWindowDto({required this.dropZone, required this.status, required this.temperatureC, required this.windSpeedMps, this.observedAt}): super._();
  factory _WeatherWindowDto.fromJson(Map<String, dynamic> json) => _$WeatherWindowDtoFromJson(json);

@override final  String dropZone;
@override final  String status;
@override final  int temperatureC;
@override final  double windSpeedMps;
@override final  String? observedAt;

/// Create a copy of WeatherWindowDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherWindowDtoCopyWith<_WeatherWindowDto> get copyWith => __$WeatherWindowDtoCopyWithImpl<_WeatherWindowDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherWindowDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherWindowDto&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.status, status) || other.status == status)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.windSpeedMps, windSpeedMps) || other.windSpeedMps == windSpeedMps)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dropZone,status,temperatureC,windSpeedMps,observedAt);

@override
String toString() {
  return 'WeatherWindowDto(dropZone: $dropZone, status: $status, temperatureC: $temperatureC, windSpeedMps: $windSpeedMps, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class _$WeatherWindowDtoCopyWith<$Res> implements $WeatherWindowDtoCopyWith<$Res> {
  factory _$WeatherWindowDtoCopyWith(_WeatherWindowDto value, $Res Function(_WeatherWindowDto) _then) = __$WeatherWindowDtoCopyWithImpl;
@override @useResult
$Res call({
 String dropZone, String status, int temperatureC, double windSpeedMps, String? observedAt
});




}
/// @nodoc
class __$WeatherWindowDtoCopyWithImpl<$Res>
    implements _$WeatherWindowDtoCopyWith<$Res> {
  __$WeatherWindowDtoCopyWithImpl(this._self, this._then);

  final _WeatherWindowDto _self;
  final $Res Function(_WeatherWindowDto) _then;

/// Create a copy of WeatherWindowDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dropZone = null,Object? status = null,Object? temperatureC = null,Object? windSpeedMps = null,Object? observedAt = freezed,}) {
  return _then(_WeatherWindowDto(
dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as int,windSpeedMps: null == windSpeedMps ? _self.windSpeedMps : windSpeedMps // ignore: cast_nullable_to_non_nullable
as double,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
