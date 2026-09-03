// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Load {

 String get id;/// 航线代号 / 呼号（如 `L-204`）。排班板上叫它、对讲机里也叫它。
 String get code;/// 跳伞地点。
 DropZone get dropZone;/// 计划起飞时刻（本地时区）。
 DateTime get departureAt;/// 机型（如 `Cessna 208B`）。
 String get aircraft;/// 出舱高度（英尺）。行业统一用英尺。
 int get altitudeFt;/// 顾客名额上限。
 int get customerCapacity;/// 摄影师名额上限。
 int get photographerCapacity;/// 已分配的名单（顾客 + 摄影师混在一起，按 [ParticipantRole] 区分）。
 List<LoadParticipant> get participants;
/// Create a copy of Load
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadCopyWith<Load> get copyWith => _$LoadCopyWithImpl<Load>(this as Load, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Load&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity)&&const DeepCollectionEquality().equals(other.participants, participants));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,dropZone,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity,const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'Load(id: $id, code: $code, dropZone: $dropZone, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $LoadCopyWith<$Res>  {
  factory $LoadCopyWith(Load value, $Res Function(Load) _then) = _$LoadCopyWithImpl;
@useResult
$Res call({
 String id, String code, DropZone dropZone, DateTime departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity, List<LoadParticipant> participants
});


$DropZoneCopyWith<$Res> get dropZone;

}
/// @nodoc
class _$LoadCopyWithImpl<$Res>
    implements $LoadCopyWith<$Res> {
  _$LoadCopyWithImpl(this._self, this._then);

  final Load _self;
  final $Res Function(Load) _then;

/// Create a copy of Load
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? dropZone = null,Object? departureAt = null,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,Object? participants = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as DropZone,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<LoadParticipant>,
  ));
}
/// Create a copy of Load
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropZoneCopyWith<$Res> get dropZone {
  
  return $DropZoneCopyWith<$Res>(_self.dropZone, (value) {
    return _then(_self.copyWith(dropZone: value));
  });
}
}


/// Adds pattern-matching-related methods to [Load].
extension LoadPatterns on Load {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Load value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Load value)  $default,){
final _that = this;
switch (_that) {
case _Load():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Load value)?  $default,){
final _that = this;
switch (_that) {
case _Load() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  DropZone dropZone,  DateTime departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  List<LoadParticipant> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  DropZone dropZone,  DateTime departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  List<LoadParticipant> participants)  $default,) {final _that = this;
switch (_that) {
case _Load():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  DropZone dropZone,  DateTime departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  List<LoadParticipant> participants)?  $default,) {final _that = this;
switch (_that) {
case _Load() when $default != null:
return $default(_that.id,_that.code,_that.dropZone,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity,_that.participants);case _:
  return null;

}
}

}

/// @nodoc


class _Load extends Load {
  const _Load({required this.id, required this.code, required this.dropZone, required this.departureAt, required this.aircraft, required this.altitudeFt, required this.customerCapacity, required this.photographerCapacity, final  List<LoadParticipant> participants = const <LoadParticipant>[]}): _participants = participants,super._();
  

@override final  String id;
/// 航线代号 / 呼号（如 `L-204`）。排班板上叫它、对讲机里也叫它。
@override final  String code;
/// 跳伞地点。
@override final  DropZone dropZone;
/// 计划起飞时刻（本地时区）。
@override final  DateTime departureAt;
/// 机型（如 `Cessna 208B`）。
@override final  String aircraft;
/// 出舱高度（英尺）。行业统一用英尺。
@override final  int altitudeFt;
/// 顾客名额上限。
@override final  int customerCapacity;
/// 摄影师名额上限。
@override final  int photographerCapacity;
/// 已分配的名单（顾客 + 摄影师混在一起，按 [ParticipantRole] 区分）。
 final  List<LoadParticipant> _participants;
/// 已分配的名单（顾客 + 摄影师混在一起，按 [ParticipantRole] 区分）。
@override@JsonKey() List<LoadParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of Load
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadCopyWith<_Load> get copyWith => __$LoadCopyWithImpl<_Load>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity)&&const DeepCollectionEquality().equals(other._participants, _participants));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,dropZone,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity,const DeepCollectionEquality().hash(_participants));

@override
String toString() {
  return 'Load(id: $id, code: $code, dropZone: $dropZone, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$LoadCopyWith<$Res> implements $LoadCopyWith<$Res> {
  factory _$LoadCopyWith(_Load value, $Res Function(_Load) _then) = __$LoadCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, DropZone dropZone, DateTime departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity, List<LoadParticipant> participants
});


@override $DropZoneCopyWith<$Res> get dropZone;

}
/// @nodoc
class __$LoadCopyWithImpl<$Res>
    implements _$LoadCopyWith<$Res> {
  __$LoadCopyWithImpl(this._self, this._then);

  final _Load _self;
  final $Res Function(_Load) _then;

/// Create a copy of Load
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? dropZone = null,Object? departureAt = null,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,Object? participants = null,}) {
  return _then(_Load(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZone: null == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as DropZone,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<LoadParticipant>,
  ));
}

/// Create a copy of Load
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropZoneCopyWith<$Res> get dropZone {
  
  return $DropZoneCopyWith<$Res>(_self.dropZone, (value) {
    return _then(_self.copyWith(dropZone: value));
  });
}
}

// dart format on
