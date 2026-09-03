// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'load_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadQuery {

 String get keyword; LoadSort get sort;
/// Create a copy of LoadQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadQueryCopyWith<LoadQuery> get copyWith => _$LoadQueryCopyWithImpl<LoadQuery>(this as LoadQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadQuery&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,sort);

@override
String toString() {
  return 'LoadQuery(keyword: $keyword, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $LoadQueryCopyWith<$Res>  {
  factory $LoadQueryCopyWith(LoadQuery value, $Res Function(LoadQuery) _then) = _$LoadQueryCopyWithImpl;
@useResult
$Res call({
 String keyword, LoadSort sort
});




}
/// @nodoc
class _$LoadQueryCopyWithImpl<$Res>
    implements $LoadQueryCopyWith<$Res> {
  _$LoadQueryCopyWithImpl(this._self, this._then);

  final LoadQuery _self;
  final $Res Function(LoadQuery) _then;

/// Create a copy of LoadQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyword = null,Object? sort = null,}) {
  return _then(_self.copyWith(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as LoadSort,
  ));
}

}


/// Adds pattern-matching-related methods to [LoadQuery].
extension LoadQueryPatterns on LoadQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoadQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoadQuery value)  $default,){
final _that = this;
switch (_that) {
case _LoadQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoadQuery value)?  $default,){
final _that = this;
switch (_that) {
case _LoadQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyword,  LoadSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadQuery() when $default != null:
return $default(_that.keyword,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyword,  LoadSort sort)  $default,) {final _that = this;
switch (_that) {
case _LoadQuery():
return $default(_that.keyword,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyword,  LoadSort sort)?  $default,) {final _that = this;
switch (_that) {
case _LoadQuery() when $default != null:
return $default(_that.keyword,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _LoadQuery extends LoadQuery {
  const _LoadQuery({this.keyword = "", this.sort = LoadSort.departureAsc}): super._();
  

@override@JsonKey() final  String keyword;
@override@JsonKey() final  LoadSort sort;

/// Create a copy of LoadQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadQueryCopyWith<_LoadQuery> get copyWith => __$LoadQueryCopyWithImpl<_LoadQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadQuery&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,sort);

@override
String toString() {
  return 'LoadQuery(keyword: $keyword, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$LoadQueryCopyWith<$Res> implements $LoadQueryCopyWith<$Res> {
  factory _$LoadQueryCopyWith(_LoadQuery value, $Res Function(_LoadQuery) _then) = __$LoadQueryCopyWithImpl;
@override @useResult
$Res call({
 String keyword, LoadSort sort
});




}
/// @nodoc
class __$LoadQueryCopyWithImpl<$Res>
    implements _$LoadQueryCopyWith<$Res> {
  __$LoadQueryCopyWithImpl(this._self, this._then);

  final _LoadQuery _self;
  final $Res Function(_LoadQuery) _then;

/// Create a copy of LoadQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyword = null,Object? sort = null,}) {
  return _then(_LoadQuery(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as LoadSort,
  ));
}


}

// dart format on
