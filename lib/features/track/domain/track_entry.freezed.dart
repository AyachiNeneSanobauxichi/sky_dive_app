// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackEntry {

 String get id;/// 事件本身，一句话说清发生了什么。
 String get event;/// 发生时间。时间线按它倒序。
 DateTime get happenedAt;/// 当时的感受。
 String get feeling;/// 后来怎么了。为空表示"还没有结果"。
 String? get outcome; TrackTag get tag;
/// Create a copy of TrackEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackEntryCopyWith<TrackEntry> get copyWith => _$TrackEntryCopyWithImpl<TrackEntry>(this as TrackEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event)&&(identical(other.happenedAt, happenedAt) || other.happenedAt == happenedAt)&&(identical(other.feeling, feeling) || other.feeling == feeling)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.tag, tag) || other.tag == tag));
}


@override
int get hashCode => Object.hash(runtimeType,id,event,happenedAt,feeling,outcome,tag);

@override
String toString() {
  return 'TrackEntry(id: $id, event: $event, happenedAt: $happenedAt, feeling: $feeling, outcome: $outcome, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $TrackEntryCopyWith<$Res>  {
  factory $TrackEntryCopyWith(TrackEntry value, $Res Function(TrackEntry) _then) = _$TrackEntryCopyWithImpl;
@useResult
$Res call({
 String id, String event, DateTime happenedAt, String feeling, String? outcome, TrackTag tag
});




}
/// @nodoc
class _$TrackEntryCopyWithImpl<$Res>
    implements $TrackEntryCopyWith<$Res> {
  _$TrackEntryCopyWithImpl(this._self, this._then);

  final TrackEntry _self;
  final $Res Function(TrackEntry) _then;

/// Create a copy of TrackEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? event = null,Object? happenedAt = null,Object? feeling = null,Object? outcome = freezed,Object? tag = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,happenedAt: null == happenedAt ? _self.happenedAt : happenedAt // ignore: cast_nullable_to_non_nullable
as DateTime,feeling: null == feeling ? _self.feeling : feeling // ignore: cast_nullable_to_non_nullable
as String,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as TrackTag,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackEntry].
extension TrackEntryPatterns on TrackEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackEntry value)  $default,){
final _that = this;
switch (_that) {
case _TrackEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TrackEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String event,  DateTime happenedAt,  String feeling,  String? outcome,  TrackTag tag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackEntry() when $default != null:
return $default(_that.id,_that.event,_that.happenedAt,_that.feeling,_that.outcome,_that.tag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String event,  DateTime happenedAt,  String feeling,  String? outcome,  TrackTag tag)  $default,) {final _that = this;
switch (_that) {
case _TrackEntry():
return $default(_that.id,_that.event,_that.happenedAt,_that.feeling,_that.outcome,_that.tag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String event,  DateTime happenedAt,  String feeling,  String? outcome,  TrackTag tag)?  $default,) {final _that = this;
switch (_that) {
case _TrackEntry() when $default != null:
return $default(_that.id,_that.event,_that.happenedAt,_that.feeling,_that.outcome,_that.tag);case _:
  return null;

}
}

}

/// @nodoc


class _TrackEntry implements TrackEntry {
  const _TrackEntry({required this.id, required this.event, required this.happenedAt, required this.feeling, this.outcome, required this.tag});
  

@override final  String id;
/// 事件本身，一句话说清发生了什么。
@override final  String event;
/// 发生时间。时间线按它倒序。
@override final  DateTime happenedAt;
/// 当时的感受。
@override final  String feeling;
/// 后来怎么了。为空表示"还没有结果"。
@override final  String? outcome;
@override final  TrackTag tag;

/// Create a copy of TrackEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackEntryCopyWith<_TrackEntry> get copyWith => __$TrackEntryCopyWithImpl<_TrackEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event)&&(identical(other.happenedAt, happenedAt) || other.happenedAt == happenedAt)&&(identical(other.feeling, feeling) || other.feeling == feeling)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.tag, tag) || other.tag == tag));
}


@override
int get hashCode => Object.hash(runtimeType,id,event,happenedAt,feeling,outcome,tag);

@override
String toString() {
  return 'TrackEntry(id: $id, event: $event, happenedAt: $happenedAt, feeling: $feeling, outcome: $outcome, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$TrackEntryCopyWith<$Res> implements $TrackEntryCopyWith<$Res> {
  factory _$TrackEntryCopyWith(_TrackEntry value, $Res Function(_TrackEntry) _then) = __$TrackEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String event, DateTime happenedAt, String feeling, String? outcome, TrackTag tag
});




}
/// @nodoc
class __$TrackEntryCopyWithImpl<$Res>
    implements _$TrackEntryCopyWith<$Res> {
  __$TrackEntryCopyWithImpl(this._self, this._then);

  final _TrackEntry _self;
  final $Res Function(_TrackEntry) _then;

/// Create a copy of TrackEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? event = null,Object? happenedAt = null,Object? feeling = null,Object? outcome = freezed,Object? tag = null,}) {
  return _then(_TrackEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,happenedAt: null == happenedAt ? _self.happenedAt : happenedAt // ignore: cast_nullable_to_non_nullable
as DateTime,feeling: null == feeling ? _self.feeling : feeling // ignore: cast_nullable_to_non_nullable
as String,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as TrackTag,
  ));
}


}

// dart format on
