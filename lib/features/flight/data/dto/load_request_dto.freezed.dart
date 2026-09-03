// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoadRequestDto {

 String get code; String get dropZoneId;/// ISO-8601 起飞时刻。
 String get departureAt; String get aircraft; int get altitudeFt; int get customerCapacity; int get photographerCapacity;
/// Create a copy of LoadRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadRequestDtoCopyWith<LoadRequestDto> get copyWith => _$LoadRequestDtoCopyWithImpl<LoadRequestDto>(this as LoadRequestDto, _$identity);

  /// Serializes this LoadRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadRequestDto&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZoneId, dropZoneId) || other.dropZoneId == dropZoneId)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,dropZoneId,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity);

@override
String toString() {
  return 'LoadRequestDto(code: $code, dropZoneId: $dropZoneId, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity)';
}


}

/// @nodoc
abstract mixin class $LoadRequestDtoCopyWith<$Res>  {
  factory $LoadRequestDtoCopyWith(LoadRequestDto value, $Res Function(LoadRequestDto) _then) = _$LoadRequestDtoCopyWithImpl;
@useResult
$Res call({
 String code, String dropZoneId, String departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity
});




}
/// @nodoc
class _$LoadRequestDtoCopyWithImpl<$Res>
    implements $LoadRequestDtoCopyWith<$Res> {
  _$LoadRequestDtoCopyWithImpl(this._self, this._then);

  final LoadRequestDto _self;
  final $Res Function(LoadRequestDto) _then;

/// Create a copy of LoadRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? dropZoneId = null,Object? departureAt = null,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZoneId: null == dropZoneId ? _self.dropZoneId : dropZoneId // ignore: cast_nullable_to_non_nullable
as String,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LoadRequestDto].
extension LoadRequestDtoPatterns on LoadRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _LoadRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _LoadRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String dropZoneId,  String departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadRequestDto() when $default != null:
return $default(_that.code,_that.dropZoneId,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String dropZoneId,  String departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity)  $default,) {final _that = this;
switch (_that) {
case _LoadRequestDto():
return $default(_that.code,_that.dropZoneId,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String dropZoneId,  String departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity)?  $default,) {final _that = this;
switch (_that) {
case _LoadRequestDto() when $default != null:
return $default(_that.code,_that.dropZoneId,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoadRequestDto extends LoadRequestDto {
  const _LoadRequestDto({required this.code, required this.dropZoneId, required this.departureAt, required this.aircraft, required this.altitudeFt, required this.customerCapacity, required this.photographerCapacity}): super._();
  factory _LoadRequestDto.fromJson(Map<String, dynamic> json) => _$LoadRequestDtoFromJson(json);

@override final  String code;
@override final  String dropZoneId;
/// ISO-8601 起飞时刻。
@override final  String departureAt;
@override final  String aircraft;
@override final  int altitudeFt;
@override final  int customerCapacity;
@override final  int photographerCapacity;

/// Create a copy of LoadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadRequestDtoCopyWith<_LoadRequestDto> get copyWith => __$LoadRequestDtoCopyWithImpl<_LoadRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoadRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadRequestDto&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZoneId, dropZoneId) || other.dropZoneId == dropZoneId)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,dropZoneId,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity);

@override
String toString() {
  return 'LoadRequestDto(code: $code, dropZoneId: $dropZoneId, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity)';
}


}

/// @nodoc
abstract mixin class _$LoadRequestDtoCopyWith<$Res> implements $LoadRequestDtoCopyWith<$Res> {
  factory _$LoadRequestDtoCopyWith(_LoadRequestDto value, $Res Function(_LoadRequestDto) _then) = __$LoadRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String code, String dropZoneId, String departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity
});




}
/// @nodoc
class __$LoadRequestDtoCopyWithImpl<$Res>
    implements _$LoadRequestDtoCopyWith<$Res> {
  __$LoadRequestDtoCopyWithImpl(this._self, this._then);

  final _LoadRequestDto _self;
  final $Res Function(_LoadRequestDto) _then;

/// Create a copy of LoadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? dropZoneId = null,Object? departureAt = null,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,}) {
  return _then(_LoadRequestDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZoneId: null == dropZoneId ? _self.dropZoneId : dropZoneId // ignore: cast_nullable_to_non_nullable
as String,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
