// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generated_story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GeneratedStory {

 String get content; String? get title; String? get scriptId; String? get conversationId; String? get currentVersionMessageId;
/// Create a copy of GeneratedStory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedStoryCopyWith<GeneratedStory> get copyWith => _$GeneratedStoryCopyWithImpl<GeneratedStory>(this as GeneratedStory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedStory&&(identical(other.content, content) || other.content == content)&&(identical(other.title, title) || other.title == title)&&(identical(other.scriptId, scriptId) || other.scriptId == scriptId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.currentVersionMessageId, currentVersionMessageId) || other.currentVersionMessageId == currentVersionMessageId));
}


@override
int get hashCode => Object.hash(runtimeType,content,title,scriptId,conversationId,currentVersionMessageId);

@override
String toString() {
  return 'GeneratedStory(content: $content, title: $title, scriptId: $scriptId, conversationId: $conversationId, currentVersionMessageId: $currentVersionMessageId)';
}


}

/// @nodoc
abstract mixin class $GeneratedStoryCopyWith<$Res>  {
  factory $GeneratedStoryCopyWith(GeneratedStory value, $Res Function(GeneratedStory) _then) = _$GeneratedStoryCopyWithImpl;
@useResult
$Res call({
 String content, String? title, String? scriptId, String? conversationId, String? currentVersionMessageId
});




}
/// @nodoc
class _$GeneratedStoryCopyWithImpl<$Res>
    implements $GeneratedStoryCopyWith<$Res> {
  _$GeneratedStoryCopyWithImpl(this._self, this._then);

  final GeneratedStory _self;
  final $Res Function(GeneratedStory) _then;

/// Create a copy of GeneratedStory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? title = freezed,Object? scriptId = freezed,Object? conversationId = freezed,Object? currentVersionMessageId = freezed,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,scriptId: freezed == scriptId ? _self.scriptId : scriptId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,currentVersionMessageId: freezed == currentVersionMessageId ? _self.currentVersionMessageId : currentVersionMessageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratedStory].
extension GeneratedStoryPatterns on GeneratedStory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratedStory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratedStory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratedStory value)  $default,){
final _that = this;
switch (_that) {
case _GeneratedStory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratedStory value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratedStory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  String? title,  String? scriptId,  String? conversationId,  String? currentVersionMessageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratedStory() when $default != null:
return $default(_that.content,_that.title,_that.scriptId,_that.conversationId,_that.currentVersionMessageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  String? title,  String? scriptId,  String? conversationId,  String? currentVersionMessageId)  $default,) {final _that = this;
switch (_that) {
case _GeneratedStory():
return $default(_that.content,_that.title,_that.scriptId,_that.conversationId,_that.currentVersionMessageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  String? title,  String? scriptId,  String? conversationId,  String? currentVersionMessageId)?  $default,) {final _that = this;
switch (_that) {
case _GeneratedStory() when $default != null:
return $default(_that.content,_that.title,_that.scriptId,_that.conversationId,_that.currentVersionMessageId);case _:
  return null;

}
}

}

/// @nodoc


class _GeneratedStory extends GeneratedStory {
  const _GeneratedStory({required this.content, this.title, this.scriptId, this.conversationId, this.currentVersionMessageId}): super._();
  

@override final  String content;
@override final  String? title;
@override final  String? scriptId;
@override final  String? conversationId;
@override final  String? currentVersionMessageId;

/// Create a copy of GeneratedStory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratedStoryCopyWith<_GeneratedStory> get copyWith => __$GeneratedStoryCopyWithImpl<_GeneratedStory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratedStory&&(identical(other.content, content) || other.content == content)&&(identical(other.title, title) || other.title == title)&&(identical(other.scriptId, scriptId) || other.scriptId == scriptId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.currentVersionMessageId, currentVersionMessageId) || other.currentVersionMessageId == currentVersionMessageId));
}


@override
int get hashCode => Object.hash(runtimeType,content,title,scriptId,conversationId,currentVersionMessageId);

@override
String toString() {
  return 'GeneratedStory(content: $content, title: $title, scriptId: $scriptId, conversationId: $conversationId, currentVersionMessageId: $currentVersionMessageId)';
}


}

/// @nodoc
abstract mixin class _$GeneratedStoryCopyWith<$Res> implements $GeneratedStoryCopyWith<$Res> {
  factory _$GeneratedStoryCopyWith(_GeneratedStory value, $Res Function(_GeneratedStory) _then) = __$GeneratedStoryCopyWithImpl;
@override @useResult
$Res call({
 String content, String? title, String? scriptId, String? conversationId, String? currentVersionMessageId
});




}
/// @nodoc
class __$GeneratedStoryCopyWithImpl<$Res>
    implements _$GeneratedStoryCopyWith<$Res> {
  __$GeneratedStoryCopyWithImpl(this._self, this._then);

  final _GeneratedStory _self;
  final $Res Function(_GeneratedStory) _then;

/// Create a copy of GeneratedStory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? title = freezed,Object? scriptId = freezed,Object? conversationId = freezed,Object? currentVersionMessageId = freezed,}) {
  return _then(_GeneratedStory(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,scriptId: freezed == scriptId ? _self.scriptId : scriptId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,currentVersionMessageId: freezed == currentVersionMessageId ? _self.currentVersionMessageId : currentVersionMessageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
