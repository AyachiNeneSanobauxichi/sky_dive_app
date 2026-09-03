// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoadDto {

 String get id; String get code; DropZoneDto get dropZone;/// ISO-8601 起飞时刻。
 String get departureAt; String get aircraft; int get altitudeFt; int get customerCapacity; int get photographerCapacity; List<LoadParticipantDto> get participants;
/// Create a copy of LoadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadDtoCopyWith<LoadDto> get copyWith => _$LoadDtoCopyWithImpl<LoadDto>(this as LoadDto, _$identity);

  /// Serializes this LoadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadDto&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity)&&const DeepCollectionEquality().equals(other.participants, participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,dropZone,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity,const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'LoadDto(id: $id, code: $code, dropZone: $dropZone, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $LoadDtoCopyWith<$Res>  {
  factory $LoadDtoCopyWith(LoadDto value, $Res Function(LoadDto) _then) = _$LoadDtoCopyWithImpl;
@useResult
$Res call({
 String id, String code, DropZoneDto dropZone, String departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity, List<LoadParticipantDto> participants
});


$DropZoneDtoCopyWith<$Res> get dropZone;

}
/// @nodoc
class _$LoadDtoCopyWithImpl<$Res>
    implements $LoadDtoCopyWith<$Res> {
  _$LoadDtoCopyWithImpl(this._self, this._then);

  final LoadDto _self;
  final $Res Function(LoadDto) _then;

/// Create a copy of LoadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? dropZone = null,Object? departureAt = null,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,Object? participants = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as DropZoneDto,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<LoadParticipantDto>,
  ));
}
/// Create a copy of LoadDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropZoneDtoCopyWith<$Res> get dropZone {
  
  return $DropZoneDtoCopyWith<$Res>(_self.dropZone, (value) {
    return _then(_self.copyWith(dropZone: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoadDto].
extension LoadDtoPatterns on LoadDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadDto value)  $default,){
final _that = this;
switch (_that) {
case _LoadDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadDto value)?  $default,){
final _that = this;
switch (_that) {
case _LoadDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  DropZoneDto dropZone,  String departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  List<LoadParticipantDto> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadDto() when $default != null:
return $default(_that.id,_that.code,_that.dropZone,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity,_that.participants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  DropZoneDto dropZone,  String departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  List<LoadParticipantDto> participants)  $default,) {final _that = this;
switch (_that) {
case _LoadDto():
return $default(_that.id,_that.code,_that.dropZone,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity,_that.participants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  DropZoneDto dropZone,  String departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  List<LoadParticipantDto> participants)?  $default,) {final _that = this;
switch (_that) {
case _LoadDto() when $default != null:
return $default(_that.id,_that.code,_that.dropZone,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity,_that.participants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoadDto extends LoadDto {
  const _LoadDto({required this.id, required this.code, required this.dropZone, required this.departureAt, required this.aircraft, required this.altitudeFt, required this.customerCapacity, required this.photographerCapacity, final  List<LoadParticipantDto> participants = const <LoadParticipantDto>[]}): _participants = participants,super._();
  factory _LoadDto.fromJson(Map<String, dynamic> json) => _$LoadDtoFromJson(json);

@override final  String id;
@override final  String code;
@override final  DropZoneDto dropZone;
/// ISO-8601 起飞时刻。
@override final  String departureAt;
@override final  String aircraft;
@override final  int altitudeFt;
@override final  int customerCapacity;
@override final  int photographerCapacity;
 final  List<LoadParticipantDto> _participants;
@override@JsonKey() List<LoadParticipantDto> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of LoadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadDtoCopyWith<_LoadDto> get copyWith => __$LoadDtoCopyWithImpl<_LoadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadDto&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity)&&const DeepCollectionEquality().equals(other._participants, _participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,dropZone,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity,const DeepCollectionEquality().hash(_participants));

@override
String toString() {
  return 'LoadDto(id: $id, code: $code, dropZone: $dropZone, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$LoadDtoCopyWith<$Res> implements $LoadDtoCopyWith<$Res> {
  factory _$LoadDtoCopyWith(_LoadDto value, $Res Function(_LoadDto) _then) = __$LoadDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, DropZoneDto dropZone, String departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity, List<LoadParticipantDto> participants
});


@override $DropZoneDtoCopyWith<$Res> get dropZone;

}
/// @nodoc
class __$LoadDtoCopyWithImpl<$Res>
    implements _$LoadDtoCopyWith<$Res> {
  __$LoadDtoCopyWithImpl(this._self, this._then);

  final _LoadDto _self;
  final $Res Function(_LoadDto) _then;

/// Create a copy of LoadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? dropZone = null,Object? departureAt = null,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,Object? participants = null,}) {
  return _then(_LoadDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as DropZoneDto,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<LoadParticipantDto>,
  ));
}

/// Create a copy of LoadDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropZoneDtoCopyWith<$Res> get dropZone {
  
  return $DropZoneDtoCopyWith<$Res>(_self.dropZone, (value) {
    return _then(_self.copyWith(dropZone: value));
  });
}
}

// dart format on
