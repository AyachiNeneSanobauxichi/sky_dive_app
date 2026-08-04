// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspiration_prompt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspirationPromptDto {

 String get text;/// 情绪 / 题材标签（如 觉醒、职场）。
 String? get tag;/// 叙事分类（如 转折、成长）。
 String? get category;
/// Create a copy of InspirationPromptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspirationPromptDtoCopyWith<InspirationPromptDto> get copyWith => _$InspirationPromptDtoCopyWithImpl<InspirationPromptDto>(this as InspirationPromptDto, _$identity);

  /// Serializes this InspirationPromptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspirationPromptDto&&(identical(other.text, text) || other.text == text)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,tag,category);

@override
String toString() {
  return 'InspirationPromptDto(text: $text, tag: $tag, category: $category)';
}


}

/// @nodoc
abstract mixin class $InspirationPromptDtoCopyWith<$Res>  {
  factory $InspirationPromptDtoCopyWith(InspirationPromptDto value, $Res Function(InspirationPromptDto) _then) = _$InspirationPromptDtoCopyWithImpl;
@useResult
$Res call({
 String text, String? tag, String? category
});




}
/// @nodoc
class _$InspirationPromptDtoCopyWithImpl<$Res>
    implements $InspirationPromptDtoCopyWith<$Res> {
  _$InspirationPromptDtoCopyWithImpl(this._self, this._then);

  final InspirationPromptDto _self;
  final $Res Function(InspirationPromptDto) _then;

/// Create a copy of InspirationPromptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? tag = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InspirationPromptDto].
extension InspirationPromptDtoPatterns on InspirationPromptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspirationPromptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspirationPromptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspirationPromptDto value)  $default,){
final _that = this;
switch (_that) {
case _InspirationPromptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspirationPromptDto value)?  $default,){
final _that = this;
switch (_that) {
case _InspirationPromptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String? tag,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspirationPromptDto() when $default != null:
return $default(_that.text,_that.tag,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String? tag,  String? category)  $default,) {final _that = this;
switch (_that) {
case _InspirationPromptDto():
return $default(_that.text,_that.tag,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String? tag,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _InspirationPromptDto() when $default != null:
return $default(_that.text,_that.tag,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspirationPromptDto extends InspirationPromptDto {
  const _InspirationPromptDto({this.text = "", this.tag, this.category}): super._();
  factory _InspirationPromptDto.fromJson(Map<String, dynamic> json) => _$InspirationPromptDtoFromJson(json);

@override@JsonKey() final  String text;
/// 情绪 / 题材标签（如 觉醒、职场）。
@override final  String? tag;
/// 叙事分类（如 转折、成长）。
@override final  String? category;

/// Create a copy of InspirationPromptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspirationPromptDtoCopyWith<_InspirationPromptDto> get copyWith => __$InspirationPromptDtoCopyWithImpl<_InspirationPromptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspirationPromptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspirationPromptDto&&(identical(other.text, text) || other.text == text)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,tag,category);

@override
String toString() {
  return 'InspirationPromptDto(text: $text, tag: $tag, category: $category)';
}


}

/// @nodoc
abstract mixin class _$InspirationPromptDtoCopyWith<$Res> implements $InspirationPromptDtoCopyWith<$Res> {
  factory _$InspirationPromptDtoCopyWith(_InspirationPromptDto value, $Res Function(_InspirationPromptDto) _then) = __$InspirationPromptDtoCopyWithImpl;
@override @useResult
$Res call({
 String text, String? tag, String? category
});




}
/// @nodoc
class __$InspirationPromptDtoCopyWithImpl<$Res>
    implements _$InspirationPromptDtoCopyWith<$Res> {
  __$InspirationPromptDtoCopyWithImpl(this._self, this._then);

  final _InspirationPromptDto _self;
  final $Res Function(_InspirationPromptDto) _then;

/// Create a copy of InspirationPromptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? tag = freezed,Object? category = freezed,}) {
  return _then(_InspirationPromptDto(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
