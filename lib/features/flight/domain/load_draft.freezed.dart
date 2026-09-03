// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadDraft {

 String? get id; String get code; DropZone? get dropZone; DateTime? get departureAt; String get aircraft; int get altitudeFt; int get customerCapacity; int get photographerCapacity;/// 编辑态下各角色**已分配**的人数。不是表单字段，只用来卡上限下界：
/// 已经排了 6 个客人的航线，上限不能被改成 4——那 2 个人无处安放。
 int get assignedCustomers; int get assignedPhotographers;
/// Create a copy of LoadDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadDraftCopyWith<LoadDraft> get copyWith => _$LoadDraftCopyWithImpl<LoadDraft>(this as LoadDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity)&&(identical(other.assignedCustomers, assignedCustomers) || other.assignedCustomers == assignedCustomers)&&(identical(other.assignedPhotographers, assignedPhotographers) || other.assignedPhotographers == assignedPhotographers));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,dropZone,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity,assignedCustomers,assignedPhotographers);

@override
String toString() {
  return 'LoadDraft(id: $id, code: $code, dropZone: $dropZone, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity, assignedCustomers: $assignedCustomers, assignedPhotographers: $assignedPhotographers)';
}


}

/// @nodoc
abstract mixin class $LoadDraftCopyWith<$Res>  {
  factory $LoadDraftCopyWith(LoadDraft value, $Res Function(LoadDraft) _then) = _$LoadDraftCopyWithImpl;
@useResult
$Res call({
 String? id, String code, DropZone? dropZone, DateTime? departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity, int assignedCustomers, int assignedPhotographers
});


$DropZoneCopyWith<$Res>? get dropZone;

}
/// @nodoc
class _$LoadDraftCopyWithImpl<$Res>
    implements $LoadDraftCopyWith<$Res> {
  _$LoadDraftCopyWithImpl(this._self, this._then);

  final LoadDraft _self;
  final $Res Function(LoadDraft) _then;

/// Create a copy of LoadDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? code = null,Object? dropZone = freezed,Object? departureAt = freezed,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,Object? assignedCustomers = null,Object? assignedPhotographers = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZone: freezed == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as DropZone?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime?,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,assignedCustomers: null == assignedCustomers ? _self.assignedCustomers : assignedCustomers // ignore: cast_nullable_to_non_nullable
as int,assignedPhotographers: null == assignedPhotographers ? _self.assignedPhotographers : assignedPhotographers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of LoadDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropZoneCopyWith<$Res>? get dropZone {
    if (_self.dropZone == null) {
    return null;
  }

  return $DropZoneCopyWith<$Res>(_self.dropZone!, (value) {
    return _then(_self.copyWith(dropZone: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoadDraft].
extension LoadDraftPatterns on LoadDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadDraft value)  $default,){
final _that = this;
switch (_that) {
case _LoadDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadDraft value)?  $default,){
final _that = this;
switch (_that) {
case _LoadDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String code,  DropZone? dropZone,  DateTime? departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  int assignedCustomers,  int assignedPhotographers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadDraft() when $default != null:
return $default(_that.id,_that.code,_that.dropZone,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity,_that.assignedCustomers,_that.assignedPhotographers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String code,  DropZone? dropZone,  DateTime? departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  int assignedCustomers,  int assignedPhotographers)  $default,) {final _that = this;
switch (_that) {
case _LoadDraft():
return $default(_that.id,_that.code,_that.dropZone,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity,_that.assignedCustomers,_that.assignedPhotographers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String code,  DropZone? dropZone,  DateTime? departureAt,  String aircraft,  int altitudeFt,  int customerCapacity,  int photographerCapacity,  int assignedCustomers,  int assignedPhotographers)?  $default,) {final _that = this;
switch (_that) {
case _LoadDraft() when $default != null:
return $default(_that.id,_that.code,_that.dropZone,_that.departureAt,_that.aircraft,_that.altitudeFt,_that.customerCapacity,_that.photographerCapacity,_that.assignedCustomers,_that.assignedPhotographers);case _:
  return null;

}
}

}

/// @nodoc


class _LoadDraft extends LoadDraft {
  const _LoadDraft({this.id, this.code = "", this.dropZone, this.departureAt, this.aircraft = "", this.altitudeFt = LoadRules.defaultAltitudeFt, this.customerCapacity = LoadRules.defaultCustomerCapacity, this.photographerCapacity = LoadRules.defaultPhotographerCapacity, this.assignedCustomers = 0, this.assignedPhotographers = 0}): super._();
  

@override final  String? id;
@override@JsonKey() final  String code;
@override final  DropZone? dropZone;
@override final  DateTime? departureAt;
@override@JsonKey() final  String aircraft;
@override@JsonKey() final  int altitudeFt;
@override@JsonKey() final  int customerCapacity;
@override@JsonKey() final  int photographerCapacity;
/// 编辑态下各角色**已分配**的人数。不是表单字段，只用来卡上限下界：
/// 已经排了 6 个客人的航线，上限不能被改成 4——那 2 个人无处安放。
@override@JsonKey() final  int assignedCustomers;
@override@JsonKey() final  int assignedPhotographers;

/// Create a copy of LoadDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadDraftCopyWith<_LoadDraft> get copyWith => __$LoadDraftCopyWithImpl<_LoadDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.dropZone, dropZone) || other.dropZone == dropZone)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.aircraft, aircraft) || other.aircraft == aircraft)&&(identical(other.altitudeFt, altitudeFt) || other.altitudeFt == altitudeFt)&&(identical(other.customerCapacity, customerCapacity) || other.customerCapacity == customerCapacity)&&(identical(other.photographerCapacity, photographerCapacity) || other.photographerCapacity == photographerCapacity)&&(identical(other.assignedCustomers, assignedCustomers) || other.assignedCustomers == assignedCustomers)&&(identical(other.assignedPhotographers, assignedPhotographers) || other.assignedPhotographers == assignedPhotographers));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,dropZone,departureAt,aircraft,altitudeFt,customerCapacity,photographerCapacity,assignedCustomers,assignedPhotographers);

@override
String toString() {
  return 'LoadDraft(id: $id, code: $code, dropZone: $dropZone, departureAt: $departureAt, aircraft: $aircraft, altitudeFt: $altitudeFt, customerCapacity: $customerCapacity, photographerCapacity: $photographerCapacity, assignedCustomers: $assignedCustomers, assignedPhotographers: $assignedPhotographers)';
}


}

/// @nodoc
abstract mixin class _$LoadDraftCopyWith<$Res> implements $LoadDraftCopyWith<$Res> {
  factory _$LoadDraftCopyWith(_LoadDraft value, $Res Function(_LoadDraft) _then) = __$LoadDraftCopyWithImpl;
@override @useResult
$Res call({
 String? id, String code, DropZone? dropZone, DateTime? departureAt, String aircraft, int altitudeFt, int customerCapacity, int photographerCapacity, int assignedCustomers, int assignedPhotographers
});


@override $DropZoneCopyWith<$Res>? get dropZone;

}
/// @nodoc
class __$LoadDraftCopyWithImpl<$Res>
    implements _$LoadDraftCopyWith<$Res> {
  __$LoadDraftCopyWithImpl(this._self, this._then);

  final _LoadDraft _self;
  final $Res Function(_LoadDraft) _then;

/// Create a copy of LoadDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? code = null,Object? dropZone = freezed,Object? departureAt = freezed,Object? aircraft = null,Object? altitudeFt = null,Object? customerCapacity = null,Object? photographerCapacity = null,Object? assignedCustomers = null,Object? assignedPhotographers = null,}) {
  return _then(_LoadDraft(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,dropZone: freezed == dropZone ? _self.dropZone : dropZone // ignore: cast_nullable_to_non_nullable
as DropZone?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime?,aircraft: null == aircraft ? _self.aircraft : aircraft // ignore: cast_nullable_to_non_nullable
as String,altitudeFt: null == altitudeFt ? _self.altitudeFt : altitudeFt // ignore: cast_nullable_to_non_nullable
as int,customerCapacity: null == customerCapacity ? _self.customerCapacity : customerCapacity // ignore: cast_nullable_to_non_nullable
as int,photographerCapacity: null == photographerCapacity ? _self.photographerCapacity : photographerCapacity // ignore: cast_nullable_to_non_nullable
as int,assignedCustomers: null == assignedCustomers ? _self.assignedCustomers : assignedCustomers // ignore: cast_nullable_to_non_nullable
as int,assignedPhotographers: null == assignedPhotographers ? _self.assignedPhotographers : assignedPhotographers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of LoadDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DropZoneCopyWith<$Res>? get dropZone {
    if (_self.dropZone == null) {
    return null;
  }

  return $DropZoneCopyWith<$Res>(_self.dropZone!, (value) {
    return _then(_self.copyWith(dropZone: value));
  });
}
}

// dart format on
