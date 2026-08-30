// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_window.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherWindow {

/// 跳伞点名称（如「藤岡スカイダイビングクラブ」）。
 String get dropZone; JumpStatus get status;/// 地面温度（摄氏）。
 int get temperatureC;/// 地面风速（m/s）。跳伞看风速不看风级，这是行业惯例。
 double get windSpeedMps;/// 数据的观测时刻。有值就**必须展示**——天气数据的价值随时间衰减得极快，
/// 一条不知道什么时候测的"可跳"没有任何意义。
///
/// 可空是因为解析失败时**宁可不显示**：伪造一个"刚刚"比没有时间更危险，
/// 客人会拿着一条两小时前的判断出门。
 DateTime? get observedAt;
/// Create a copy of WeatherWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherWindowCopyWith<WeatherWindow> get copyWith => _$WeatherWindowCopyWithImpl<WeatherWindow>(this as WeatherWindow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherWindow&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.status, status) || other.status == status)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.windSpeedMps, windSpeedMps) || other.windSpeedMps == windSpeedMps)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}


@override
int get hashCode => Object.hash(runtimeType,dropZone,status,temperatureC,windSpeedMps,observedAt);

@override
String toString() {
  return 'WeatherWindow(dropZone: $dropZone, status: $status, temperatureC: $temperatureC, windSpeedMps: $windSpeedMps, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class $WeatherWindowCopyWith<$Res>  {
  factory $WeatherWindowCopyWith(WeatherWindow value, $Res Function(WeatherWindow) _then) = _$WeatherWindowCopyWithImpl;
@useResult
$Res call({
 String dropZone, JumpStatus status, int temperatureC, double windSpeedMps, DateTime? observedAt
});




}
/// @nodoc
class _$WeatherWindowCopyWithImpl<$Res>
    implements $WeatherWindowCopyWith<$Res> {
  _$WeatherWindowCopyWithImpl(this._self, this._then);

  final WeatherWindow _self;
  final $Res Function(WeatherWindow) _then;

/// Create a copy of WeatherWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dropZone = null,Object? status = null,Object? temperatureC = null,Object? windSpeedMps = null,Object? observedAt = freezed,}) {
  return _then(_self.copyWith(
dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JumpStatus,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as int,windSpeedMps: null == windSpeedMps ? _self.windSpeedMps : windSpeedMps // ignore: cast_nullable_to_non_nullable
as double,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherWindow].
extension WeatherWindowPatterns on WeatherWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherWindow value)  $default,){
final _that = this;
switch (_that) {
case _WeatherWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherWindow value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dropZone,  JumpStatus status,  int temperatureC,  double windSpeedMps,  DateTime? observedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherWindow() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dropZone,  JumpStatus status,  int temperatureC,  double windSpeedMps,  DateTime? observedAt)  $default,) {final _that = this;
switch (_that) {
case _WeatherWindow():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dropZone,  JumpStatus status,  int temperatureC,  double windSpeedMps,  DateTime? observedAt)?  $default,) {final _that = this;
switch (_that) {
case _WeatherWindow() when $default != null:
return $default(_that.dropZone,_that.status,_that.temperatureC,_that.windSpeedMps,_that.observedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherWindow implements WeatherWindow {
  const _WeatherWindow({required this.dropZone, required this.status, required this.temperatureC, required this.windSpeedMps, this.observedAt});
  

/// 跳伞点名称（如「藤岡スカイダイビングクラブ」）。
@override final  String dropZone;
@override final  JumpStatus status;
/// 地面温度（摄氏）。
@override final  int temperatureC;
/// 地面风速（m/s）。跳伞看风速不看风级，这是行业惯例。
@override final  double windSpeedMps;
/// 数据的观测时刻。有值就**必须展示**——天气数据的价值随时间衰减得极快，
/// 一条不知道什么时候测的"可跳"没有任何意义。
///
/// 可空是因为解析失败时**宁可不显示**：伪造一个"刚刚"比没有时间更危险，
/// 客人会拿着一条两小时前的判断出门。
@override final  DateTime? observedAt;

/// Create a copy of WeatherWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherWindowCopyWith<_WeatherWindow> get copyWith => __$WeatherWindowCopyWithImpl<_WeatherWindow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherWindow&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.status, status) || other.status == status)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.windSpeedMps, windSpeedMps) || other.windSpeedMps == windSpeedMps)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}


@override
int get hashCode => Object.hash(runtimeType,dropZone,status,temperatureC,windSpeedMps,observedAt);

@override
String toString() {
  return 'WeatherWindow(dropZone: $dropZone, status: $status, temperatureC: $temperatureC, windSpeedMps: $windSpeedMps, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class _$WeatherWindowCopyWith<$Res> implements $WeatherWindowCopyWith<$Res> {
  factory _$WeatherWindowCopyWith(_WeatherWindow value, $Res Function(_WeatherWindow) _then) = __$WeatherWindowCopyWithImpl;
@override @useResult
$Res call({
 String dropZone, JumpStatus status, int temperatureC, double windSpeedMps, DateTime? observedAt
});




}
/// @nodoc
class __$WeatherWindowCopyWithImpl<$Res>
    implements _$WeatherWindowCopyWith<$Res> {
  __$WeatherWindowCopyWithImpl(this._self, this._then);

  final _WeatherWindow _self;
  final $Res Function(_WeatherWindow) _then;

/// Create a copy of WeatherWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dropZone = null,Object? status = null,Object? temperatureC = null,Object? windSpeedMps = null,Object? observedAt = freezed,}) {
  return _then(_WeatherWindow(
dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JumpStatus,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as int,windSpeedMps: null == windSpeedMps ? _self.windSpeedMps : windSpeedMps // ignore: cast_nullable_to_non_nullable
as double,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
