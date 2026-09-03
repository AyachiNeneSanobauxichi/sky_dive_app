// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadParticipant {

 String get id; String get name; ParticipantRole get role;/// 一句话补充：顾客写跳伞类型 / 执照等级，摄影师写机位（如「手持 + 头盔」）。
/// 排班的人靠它一眼判断"这个人能不能上这条航线"。
 String? get detail;
/// Create a copy of LoadParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadParticipantCopyWith<LoadParticipant> get copyWith => _$LoadParticipantCopyWithImpl<LoadParticipant>(this as LoadParticipant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,role,detail);

@override
String toString() {
  return 'LoadParticipant(id: $id, name: $name, role: $role, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $LoadParticipantCopyWith<$Res>  {
  factory $LoadParticipantCopyWith(LoadParticipant value, $Res Function(LoadParticipant) _then) = _$LoadParticipantCopyWithImpl;
@useResult
$Res call({
 String id, String name, ParticipantRole role, String? detail
});




}
/// @nodoc
class _$LoadParticipantCopyWithImpl<$Res>
    implements $LoadParticipantCopyWith<$Res> {
  _$LoadParticipantCopyWithImpl(this._self, this._then);

  final LoadParticipant _self;
  final $Res Function(LoadParticipant) _then;

/// Create a copy of LoadParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? detail = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ParticipantRole,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoadParticipant].
extension LoadParticipantPatterns on LoadParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadParticipant value)  $default,){
final _that = this;
switch (_that) {
case _LoadParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _LoadParticipant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ParticipantRole role,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadParticipant() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ParticipantRole role,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _LoadParticipant():
return $default(_that.id,_that.name,_that.role,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ParticipantRole role,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _LoadParticipant() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _LoadParticipant extends LoadParticipant {
  const _LoadParticipant({required this.id, required this.name, required this.role, this.detail}): super._();
  

@override final  String id;
@override final  String name;
@override final  ParticipantRole role;
/// 一句话补充：顾客写跳伞类型 / 执照等级，摄影师写机位（如「手持 + 头盔」）。
/// 排班的人靠它一眼判断"这个人能不能上这条航线"。
@override final  String? detail;

/// Create a copy of LoadParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadParticipantCopyWith<_LoadParticipant> get copyWith => __$LoadParticipantCopyWithImpl<_LoadParticipant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,role,detail);

@override
String toString() {
  return 'LoadParticipant(id: $id, name: $name, role: $role, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$LoadParticipantCopyWith<$Res> implements $LoadParticipantCopyWith<$Res> {
  factory _$LoadParticipantCopyWith(_LoadParticipant value, $Res Function(_LoadParticipant) _then) = __$LoadParticipantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ParticipantRole role, String? detail
});




}
/// @nodoc
class __$LoadParticipantCopyWithImpl<$Res>
    implements _$LoadParticipantCopyWith<$Res> {
  __$LoadParticipantCopyWithImpl(this._self, this._then);

  final _LoadParticipant _self;
  final $Res Function(_LoadParticipant) _then;

/// Create a copy of LoadParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? detail = freezed,}) {
  return _then(_LoadParticipant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ParticipantRole,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
