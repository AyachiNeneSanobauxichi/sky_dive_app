// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspiration_prompt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InspirationPrompt {

 String get id; String get text;/// 情绪 / 题材标签（如 觉醒、职场）。契约有，但当前 UI 还没展示。
 String? get tag;/// 叙事分类（如 转折、成长）。契约有，但当前 UI 还没展示。
 String? get category;
/// Create a copy of InspirationPrompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspirationPromptCopyWith<InspirationPrompt> get copyWith => _$InspirationPromptCopyWithImpl<InspirationPrompt>(this as InspirationPrompt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspirationPrompt&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,tag,category);

@override
String toString() {
  return 'InspirationPrompt(id: $id, text: $text, tag: $tag, category: $category)';
}


}

/// @nodoc
abstract mixin class $InspirationPromptCopyWith<$Res>  {
  factory $InspirationPromptCopyWith(InspirationPrompt value, $Res Function(InspirationPrompt) _then) = _$InspirationPromptCopyWithImpl;
@useResult
$Res call({
 String id, String text, String? tag, String? category
});




}
/// @nodoc
class _$InspirationPromptCopyWithImpl<$Res>
    implements $InspirationPromptCopyWith<$Res> {
  _$InspirationPromptCopyWithImpl(this._self, this._then);

  final InspirationPrompt _self;
  final $Res Function(InspirationPrompt) _then;

/// Create a copy of InspirationPrompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? tag = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InspirationPrompt].
extension InspirationPromptPatterns on InspirationPrompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspirationPrompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspirationPrompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspirationPrompt value)  $default,){
final _that = this;
switch (_that) {
case _InspirationPrompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspirationPrompt value)?  $default,){
final _that = this;
switch (_that) {
case _InspirationPrompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  String? tag,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspirationPrompt() when $default != null:
return $default(_that.id,_that.text,_that.tag,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  String? tag,  String? category)  $default,) {final _that = this;
switch (_that) {
case _InspirationPrompt():
return $default(_that.id,_that.text,_that.tag,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  String? tag,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _InspirationPrompt() when $default != null:
return $default(_that.id,_that.text,_that.tag,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _InspirationPrompt implements InspirationPrompt {
  const _InspirationPrompt({required this.id, required this.text, this.tag, this.category});
  

@override final  String id;
@override final  String text;
/// 情绪 / 题材标签（如 觉醒、职场）。契约有，但当前 UI 还没展示。
@override final  String? tag;
/// 叙事分类（如 转折、成长）。契约有，但当前 UI 还没展示。
@override final  String? category;

/// Create a copy of InspirationPrompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspirationPromptCopyWith<_InspirationPrompt> get copyWith => __$InspirationPromptCopyWithImpl<_InspirationPrompt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspirationPrompt&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,id,text,tag,category);

@override
String toString() {
  return 'InspirationPrompt(id: $id, text: $text, tag: $tag, category: $category)';
}


}

/// @nodoc
abstract mixin class _$InspirationPromptCopyWith<$Res> implements $InspirationPromptCopyWith<$Res> {
  factory _$InspirationPromptCopyWith(_InspirationPrompt value, $Res Function(_InspirationPrompt) _then) = __$InspirationPromptCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, String? tag, String? category
});




}
/// @nodoc
class __$InspirationPromptCopyWithImpl<$Res>
    implements _$InspirationPromptCopyWith<$Res> {
  __$InspirationPromptCopyWithImpl(this._self, this._then);

  final _InspirationPrompt _self;
  final $Res Function(_InspirationPrompt) _then;

/// Create a copy of InspirationPrompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? tag = freezed,Object? category = freezed,}) {
  return _then(_InspirationPrompt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
