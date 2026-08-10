// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_script_page_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryScriptPageDto {

 List<StoryScriptDto> get records; int get current; int get size; int get total; int get pages;
/// Create a copy of StoryScriptPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryScriptPageDtoCopyWith<StoryScriptPageDto> get copyWith => _$StoryScriptPageDtoCopyWithImpl<StoryScriptPageDto>(this as StoryScriptPageDto, _$identity);

  /// Serializes this StoryScriptPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryScriptPageDto&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.current, current) || other.current == current)&&(identical(other.size, size) || other.size == size)&&(identical(other.total, total) || other.total == total)&&(identical(other.pages, pages) || other.pages == pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(records),current,size,total,pages);

@override
String toString() {
  return 'StoryScriptPageDto(records: $records, current: $current, size: $size, total: $total, pages: $pages)';
}


}

/// @nodoc
abstract mixin class $StoryScriptPageDtoCopyWith<$Res>  {
  factory $StoryScriptPageDtoCopyWith(StoryScriptPageDto value, $Res Function(StoryScriptPageDto) _then) = _$StoryScriptPageDtoCopyWithImpl;
@useResult
$Res call({
 List<StoryScriptDto> records, int current, int size, int total, int pages
});




}
/// @nodoc
class _$StoryScriptPageDtoCopyWithImpl<$Res>
    implements $StoryScriptPageDtoCopyWith<$Res> {
  _$StoryScriptPageDtoCopyWithImpl(this._self, this._then);

  final StoryScriptPageDto _self;
  final $Res Function(StoryScriptPageDto) _then;

/// Create a copy of StoryScriptPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? records = null,Object? current = null,Object? size = null,Object? total = null,Object? pages = null,}) {
  return _then(_self.copyWith(
records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<StoryScriptDto>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryScriptPageDto].
extension StoryScriptPageDtoPatterns on StoryScriptPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryScriptPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryScriptPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryScriptPageDto value)  $default,){
final _that = this;
switch (_that) {
case _StoryScriptPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryScriptPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoryScriptPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StoryScriptDto> records,  int current,  int size,  int total,  int pages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryScriptPageDto() when $default != null:
return $default(_that.records,_that.current,_that.size,_that.total,_that.pages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StoryScriptDto> records,  int current,  int size,  int total,  int pages)  $default,) {final _that = this;
switch (_that) {
case _StoryScriptPageDto():
return $default(_that.records,_that.current,_that.size,_that.total,_that.pages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StoryScriptDto> records,  int current,  int size,  int total,  int pages)?  $default,) {final _that = this;
switch (_that) {
case _StoryScriptPageDto() when $default != null:
return $default(_that.records,_that.current,_that.size,_that.total,_that.pages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoryScriptPageDto extends StoryScriptPageDto {
  const _StoryScriptPageDto({final  List<StoryScriptDto> records = const <StoryScriptDto>[], this.current = 1, this.size = 0, this.total = 0, this.pages = 0}): _records = records,super._();
  factory _StoryScriptPageDto.fromJson(Map<String, dynamic> json) => _$StoryScriptPageDtoFromJson(json);

 final  List<StoryScriptDto> _records;
@override@JsonKey() List<StoryScriptDto> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override@JsonKey() final  int current;
@override@JsonKey() final  int size;
@override@JsonKey() final  int total;
@override@JsonKey() final  int pages;

/// Create a copy of StoryScriptPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryScriptPageDtoCopyWith<_StoryScriptPageDto> get copyWith => __$StoryScriptPageDtoCopyWithImpl<_StoryScriptPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryScriptPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryScriptPageDto&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.current, current) || other.current == current)&&(identical(other.size, size) || other.size == size)&&(identical(other.total, total) || other.total == total)&&(identical(other.pages, pages) || other.pages == pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_records),current,size,total,pages);

@override
String toString() {
  return 'StoryScriptPageDto(records: $records, current: $current, size: $size, total: $total, pages: $pages)';
}


}

/// @nodoc
abstract mixin class _$StoryScriptPageDtoCopyWith<$Res> implements $StoryScriptPageDtoCopyWith<$Res> {
  factory _$StoryScriptPageDtoCopyWith(_StoryScriptPageDto value, $Res Function(_StoryScriptPageDto) _then) = __$StoryScriptPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<StoryScriptDto> records, int current, int size, int total, int pages
});




}
/// @nodoc
class __$StoryScriptPageDtoCopyWithImpl<$Res>
    implements _$StoryScriptPageDtoCopyWith<$Res> {
  __$StoryScriptPageDtoCopyWithImpl(this._self, this._then);

  final _StoryScriptPageDto _self;
  final $Res Function(_StoryScriptPageDto) _then;

/// Create a copy of StoryScriptPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? records = null,Object? current = null,Object? size = null,Object? total = null,Object? pages = null,}) {
  return _then(_StoryScriptPageDto(
records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<StoryScriptDto>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
