// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generation_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenerationEntry {

 DateTime get createdAt;
/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationEntryCopyWith<GenerationEntry> get copyWith => _$GenerationEntryCopyWithImpl<GenerationEntry>(this as GenerationEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationEntry&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,createdAt);

@override
String toString() {
  return 'GenerationEntry(createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GenerationEntryCopyWith<$Res>  {
  factory $GenerationEntryCopyWith(GenerationEntry value, $Res Function(GenerationEntry) _then) = _$GenerationEntryCopyWithImpl;
@useResult
$Res call({
 DateTime createdAt
});




}
/// @nodoc
class _$GenerationEntryCopyWithImpl<$Res>
    implements $GenerationEntryCopyWith<$Res> {
  _$GenerationEntryCopyWithImpl(this._self, this._then);

  final GenerationEntry _self;
  final $Res Function(GenerationEntry) _then;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdAt = null,}) {
  return _then(_self.copyWith(
createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerationEntry].
extension GenerationEntryPatterns on GenerationEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GenerationWishEntry value)?  wish,TResult Function( GenerationClarificationEntry value)?  clarification,TResult Function( GenerationOutlineEntry value)?  outline,TResult Function( GenerationNovelEntry value)?  novel,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GenerationWishEntry() when wish != null:
return wish(_that);case GenerationClarificationEntry() when clarification != null:
return clarification(_that);case GenerationOutlineEntry() when outline != null:
return outline(_that);case GenerationNovelEntry() when novel != null:
return novel(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GenerationWishEntry value)  wish,required TResult Function( GenerationClarificationEntry value)  clarification,required TResult Function( GenerationOutlineEntry value)  outline,required TResult Function( GenerationNovelEntry value)  novel,}){
final _that = this;
switch (_that) {
case GenerationWishEntry():
return wish(_that);case GenerationClarificationEntry():
return clarification(_that);case GenerationOutlineEntry():
return outline(_that);case GenerationNovelEntry():
return novel(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GenerationWishEntry value)?  wish,TResult? Function( GenerationClarificationEntry value)?  clarification,TResult? Function( GenerationOutlineEntry value)?  outline,TResult? Function( GenerationNovelEntry value)?  novel,}){
final _that = this;
switch (_that) {
case GenerationWishEntry() when wish != null:
return wish(_that);case GenerationClarificationEntry() when clarification != null:
return clarification(_that);case GenerationOutlineEntry() when outline != null:
return outline(_that);case GenerationNovelEntry() when novel != null:
return novel(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text,  DateTime createdAt)?  wish,TResult Function( ClarificationCard card,  DateTime createdAt,  String? answer)?  clarification,TResult Function( StoryOutline outline,  DateTime createdAt,  OutlineResolution? resolution,  String? feedback)?  outline,TResult Function( String content,  DateTime createdAt,  bool isStreaming)?  novel,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GenerationWishEntry() when wish != null:
return wish(_that.text,_that.createdAt);case GenerationClarificationEntry() when clarification != null:
return clarification(_that.card,_that.createdAt,_that.answer);case GenerationOutlineEntry() when outline != null:
return outline(_that.outline,_that.createdAt,_that.resolution,_that.feedback);case GenerationNovelEntry() when novel != null:
return novel(_that.content,_that.createdAt,_that.isStreaming);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text,  DateTime createdAt)  wish,required TResult Function( ClarificationCard card,  DateTime createdAt,  String? answer)  clarification,required TResult Function( StoryOutline outline,  DateTime createdAt,  OutlineResolution? resolution,  String? feedback)  outline,required TResult Function( String content,  DateTime createdAt,  bool isStreaming)  novel,}) {final _that = this;
switch (_that) {
case GenerationWishEntry():
return wish(_that.text,_that.createdAt);case GenerationClarificationEntry():
return clarification(_that.card,_that.createdAt,_that.answer);case GenerationOutlineEntry():
return outline(_that.outline,_that.createdAt,_that.resolution,_that.feedback);case GenerationNovelEntry():
return novel(_that.content,_that.createdAt,_that.isStreaming);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text,  DateTime createdAt)?  wish,TResult? Function( ClarificationCard card,  DateTime createdAt,  String? answer)?  clarification,TResult? Function( StoryOutline outline,  DateTime createdAt,  OutlineResolution? resolution,  String? feedback)?  outline,TResult? Function( String content,  DateTime createdAt,  bool isStreaming)?  novel,}) {final _that = this;
switch (_that) {
case GenerationWishEntry() when wish != null:
return wish(_that.text,_that.createdAt);case GenerationClarificationEntry() when clarification != null:
return clarification(_that.card,_that.createdAt,_that.answer);case GenerationOutlineEntry() when outline != null:
return outline(_that.outline,_that.createdAt,_that.resolution,_that.feedback);case GenerationNovelEntry() when novel != null:
return novel(_that.content,_that.createdAt,_that.isStreaming);case _:
  return null;

}
}

}

/// @nodoc


class GenerationWishEntry implements GenerationEntry {
  const GenerationWishEntry({required this.text, required this.createdAt});
  

 final  String text;
@override final  DateTime createdAt;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationWishEntryCopyWith<GenerationWishEntry> get copyWith => _$GenerationWishEntryCopyWithImpl<GenerationWishEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationWishEntry&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,text,createdAt);

@override
String toString() {
  return 'GenerationEntry.wish(text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GenerationWishEntryCopyWith<$Res> implements $GenerationEntryCopyWith<$Res> {
  factory $GenerationWishEntryCopyWith(GenerationWishEntry value, $Res Function(GenerationWishEntry) _then) = _$GenerationWishEntryCopyWithImpl;
@override @useResult
$Res call({
 String text, DateTime createdAt
});




}
/// @nodoc
class _$GenerationWishEntryCopyWithImpl<$Res>
    implements $GenerationWishEntryCopyWith<$Res> {
  _$GenerationWishEntryCopyWithImpl(this._self, this._then);

  final GenerationWishEntry _self;
  final $Res Function(GenerationWishEntry) _then;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? createdAt = null,}) {
  return _then(GenerationWishEntry(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class GenerationClarificationEntry implements GenerationEntry {
  const GenerationClarificationEntry({required this.card, required this.createdAt, this.answer});
  

 final  ClarificationCard card;
@override final  DateTime createdAt;
 final  String? answer;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationClarificationEntryCopyWith<GenerationClarificationEntry> get copyWith => _$GenerationClarificationEntryCopyWithImpl<GenerationClarificationEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationClarificationEntry&&(identical(other.card, card) || other.card == card)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.answer, answer) || other.answer == answer));
}


@override
int get hashCode => Object.hash(runtimeType,card,createdAt,answer);

@override
String toString() {
  return 'GenerationEntry.clarification(card: $card, createdAt: $createdAt, answer: $answer)';
}


}

/// @nodoc
abstract mixin class $GenerationClarificationEntryCopyWith<$Res> implements $GenerationEntryCopyWith<$Res> {
  factory $GenerationClarificationEntryCopyWith(GenerationClarificationEntry value, $Res Function(GenerationClarificationEntry) _then) = _$GenerationClarificationEntryCopyWithImpl;
@override @useResult
$Res call({
 ClarificationCard card, DateTime createdAt, String? answer
});


$ClarificationCardCopyWith<$Res> get card;

}
/// @nodoc
class _$GenerationClarificationEntryCopyWithImpl<$Res>
    implements $GenerationClarificationEntryCopyWith<$Res> {
  _$GenerationClarificationEntryCopyWithImpl(this._self, this._then);

  final GenerationClarificationEntry _self;
  final $Res Function(GenerationClarificationEntry) _then;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? card = null,Object? createdAt = null,Object? answer = freezed,}) {
  return _then(GenerationClarificationEntry(
card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as ClarificationCard,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClarificationCardCopyWith<$Res> get card {
  
  return $ClarificationCardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}

/// @nodoc


class GenerationOutlineEntry implements GenerationEntry {
  const GenerationOutlineEntry({required this.outline, required this.createdAt, this.resolution, this.feedback});
  

 final  StoryOutline outline;
@override final  DateTime createdAt;
 final  OutlineResolution? resolution;
/// 用户填的修改意见（[resolution] 为 [OutlineResolution.modified] 时有值）。
/// 回放场景下为空：意见文本没有单独落库。
 final  String? feedback;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationOutlineEntryCopyWith<GenerationOutlineEntry> get copyWith => _$GenerationOutlineEntryCopyWithImpl<GenerationOutlineEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationOutlineEntry&&(identical(other.outline, outline) || other.outline == outline)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.resolution, resolution) || other.resolution == resolution)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}


@override
int get hashCode => Object.hash(runtimeType,outline,createdAt,resolution,feedback);

@override
String toString() {
  return 'GenerationEntry.outline(outline: $outline, createdAt: $createdAt, resolution: $resolution, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $GenerationOutlineEntryCopyWith<$Res> implements $GenerationEntryCopyWith<$Res> {
  factory $GenerationOutlineEntryCopyWith(GenerationOutlineEntry value, $Res Function(GenerationOutlineEntry) _then) = _$GenerationOutlineEntryCopyWithImpl;
@override @useResult
$Res call({
 StoryOutline outline, DateTime createdAt, OutlineResolution? resolution, String? feedback
});


$StoryOutlineCopyWith<$Res> get outline;

}
/// @nodoc
class _$GenerationOutlineEntryCopyWithImpl<$Res>
    implements $GenerationOutlineEntryCopyWith<$Res> {
  _$GenerationOutlineEntryCopyWithImpl(this._self, this._then);

  final GenerationOutlineEntry _self;
  final $Res Function(GenerationOutlineEntry) _then;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outline = null,Object? createdAt = null,Object? resolution = freezed,Object? feedback = freezed,}) {
  return _then(GenerationOutlineEntry(
outline: null == outline ? _self.outline : outline // ignore: cast_nullable_to_non_nullable
as StoryOutline,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as OutlineResolution?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryOutlineCopyWith<$Res> get outline {
  
  return $StoryOutlineCopyWith<$Res>(_self.outline, (value) {
    return _then(_self.copyWith(outline: value));
  });
}
}

/// @nodoc


class GenerationNovelEntry implements GenerationEntry {
  const GenerationNovelEntry({required this.content, required this.createdAt, this.isStreaming = true});
  

 final  String content;
@override final  DateTime createdAt;
@JsonKey() final  bool isStreaming;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationNovelEntryCopyWith<GenerationNovelEntry> get copyWith => _$GenerationNovelEntryCopyWithImpl<GenerationNovelEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationNovelEntry&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming));
}


@override
int get hashCode => Object.hash(runtimeType,content,createdAt,isStreaming);

@override
String toString() {
  return 'GenerationEntry.novel(content: $content, createdAt: $createdAt, isStreaming: $isStreaming)';
}


}

/// @nodoc
abstract mixin class $GenerationNovelEntryCopyWith<$Res> implements $GenerationEntryCopyWith<$Res> {
  factory $GenerationNovelEntryCopyWith(GenerationNovelEntry value, $Res Function(GenerationNovelEntry) _then) = _$GenerationNovelEntryCopyWithImpl;
@override @useResult
$Res call({
 String content, DateTime createdAt, bool isStreaming
});




}
/// @nodoc
class _$GenerationNovelEntryCopyWithImpl<$Res>
    implements $GenerationNovelEntryCopyWith<$Res> {
  _$GenerationNovelEntryCopyWithImpl(this._self, this._then);

  final GenerationNovelEntry _self;
  final $Res Function(GenerationNovelEntry) _then;

/// Create a copy of GenerationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? createdAt = null,Object? isStreaming = null,}) {
  return _then(GenerationNovelEntry(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
