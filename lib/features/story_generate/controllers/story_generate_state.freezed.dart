// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_generate_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryGenerateState {

/// 时间线条目，按发生顺序。
 List<GenerationEntry> get timeline; GenerationPhase get phase;/// 后端下发的会话 id。推进会话必须带它。
 String? get sessionId;/// 首次心愿文本。每轮 followup 都要回传（后端靠它落库）。
 String? get originalQuery;/// `status` 事件的阶段标识，用于加载文案。
 String? get stage;/// 失败原因。与 [timeline] 并存，不清屏。
 Failure? get failure;/// 后端业务错误码（如 [GenerationErrorCode.dailyInProgress]）。
 String? get errorCode;/// 生成完成的结果。
 GeneratedStory? get result;
/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryGenerateStateCopyWith<StoryGenerateState> get copyWith => _$StoryGenerateStateCopyWithImpl<StoryGenerateState>(this as StoryGenerateState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGenerateState&&const DeepCollectionEquality().equals(other.timeline, timeline)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.originalQuery, originalQuery) || other.originalQuery == originalQuery)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(timeline),phase,sessionId,originalQuery,stage,failure,errorCode,result);

@override
String toString() {
  return 'StoryGenerateState(timeline: $timeline, phase: $phase, sessionId: $sessionId, originalQuery: $originalQuery, stage: $stage, failure: $failure, errorCode: $errorCode, result: $result)';
}


}

/// @nodoc
abstract mixin class $StoryGenerateStateCopyWith<$Res>  {
  factory $StoryGenerateStateCopyWith(StoryGenerateState value, $Res Function(StoryGenerateState) _then) = _$StoryGenerateStateCopyWithImpl;
@useResult
$Res call({
 List<GenerationEntry> timeline, GenerationPhase phase, String? sessionId, String? originalQuery, String? stage, Failure? failure, String? errorCode, GeneratedStory? result
});


$FailureCopyWith<$Res>? get failure;$GeneratedStoryCopyWith<$Res>? get result;

}
/// @nodoc
class _$StoryGenerateStateCopyWithImpl<$Res>
    implements $StoryGenerateStateCopyWith<$Res> {
  _$StoryGenerateStateCopyWithImpl(this._self, this._then);

  final StoryGenerateState _self;
  final $Res Function(StoryGenerateState) _then;

/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeline = null,Object? phase = null,Object? sessionId = freezed,Object? originalQuery = freezed,Object? stage = freezed,Object? failure = freezed,Object? errorCode = freezed,Object? result = freezed,}) {
  return _then(_self.copyWith(
timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<GenerationEntry>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GenerationPhase,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,originalQuery: freezed == originalQuery ? _self.originalQuery : originalQuery // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as GeneratedStory?,
  ));
}
/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneratedStoryCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $GeneratedStoryCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoryGenerateState].
extension StoryGenerateStatePatterns on StoryGenerateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryGenerateState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryGenerateState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryGenerateState value)  $default,){
final _that = this;
switch (_that) {
case _StoryGenerateState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryGenerateState value)?  $default,){
final _that = this;
switch (_that) {
case _StoryGenerateState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GenerationEntry> timeline,  GenerationPhase phase,  String? sessionId,  String? originalQuery,  String? stage,  Failure? failure,  String? errorCode,  GeneratedStory? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryGenerateState() when $default != null:
return $default(_that.timeline,_that.phase,_that.sessionId,_that.originalQuery,_that.stage,_that.failure,_that.errorCode,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GenerationEntry> timeline,  GenerationPhase phase,  String? sessionId,  String? originalQuery,  String? stage,  Failure? failure,  String? errorCode,  GeneratedStory? result)  $default,) {final _that = this;
switch (_that) {
case _StoryGenerateState():
return $default(_that.timeline,_that.phase,_that.sessionId,_that.originalQuery,_that.stage,_that.failure,_that.errorCode,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GenerationEntry> timeline,  GenerationPhase phase,  String? sessionId,  String? originalQuery,  String? stage,  Failure? failure,  String? errorCode,  GeneratedStory? result)?  $default,) {final _that = this;
switch (_that) {
case _StoryGenerateState() when $default != null:
return $default(_that.timeline,_that.phase,_that.sessionId,_that.originalQuery,_that.stage,_that.failure,_that.errorCode,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _StoryGenerateState extends StoryGenerateState {
  const _StoryGenerateState({final  List<GenerationEntry> timeline = const <GenerationEntry>[], this.phase = GenerationPhase.idle, this.sessionId, this.originalQuery, this.stage, this.failure, this.errorCode, this.result}): _timeline = timeline,super._();
  

/// 时间线条目，按发生顺序。
 final  List<GenerationEntry> _timeline;
/// 时间线条目，按发生顺序。
@override@JsonKey() List<GenerationEntry> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}

@override@JsonKey() final  GenerationPhase phase;
/// 后端下发的会话 id。推进会话必须带它。
@override final  String? sessionId;
/// 首次心愿文本。每轮 followup 都要回传（后端靠它落库）。
@override final  String? originalQuery;
/// `status` 事件的阶段标识，用于加载文案。
@override final  String? stage;
/// 失败原因。与 [timeline] 并存，不清屏。
@override final  Failure? failure;
/// 后端业务错误码（如 [GenerationErrorCode.dailyInProgress]）。
@override final  String? errorCode;
/// 生成完成的结果。
@override final  GeneratedStory? result;

/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryGenerateStateCopyWith<_StoryGenerateState> get copyWith => __$StoryGenerateStateCopyWithImpl<_StoryGenerateState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryGenerateState&&const DeepCollectionEquality().equals(other._timeline, _timeline)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.originalQuery, originalQuery) || other.originalQuery == originalQuery)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_timeline),phase,sessionId,originalQuery,stage,failure,errorCode,result);

@override
String toString() {
  return 'StoryGenerateState(timeline: $timeline, phase: $phase, sessionId: $sessionId, originalQuery: $originalQuery, stage: $stage, failure: $failure, errorCode: $errorCode, result: $result)';
}


}

/// @nodoc
abstract mixin class _$StoryGenerateStateCopyWith<$Res> implements $StoryGenerateStateCopyWith<$Res> {
  factory _$StoryGenerateStateCopyWith(_StoryGenerateState value, $Res Function(_StoryGenerateState) _then) = __$StoryGenerateStateCopyWithImpl;
@override @useResult
$Res call({
 List<GenerationEntry> timeline, GenerationPhase phase, String? sessionId, String? originalQuery, String? stage, Failure? failure, String? errorCode, GeneratedStory? result
});


@override $FailureCopyWith<$Res>? get failure;@override $GeneratedStoryCopyWith<$Res>? get result;

}
/// @nodoc
class __$StoryGenerateStateCopyWithImpl<$Res>
    implements _$StoryGenerateStateCopyWith<$Res> {
  __$StoryGenerateStateCopyWithImpl(this._self, this._then);

  final _StoryGenerateState _self;
  final $Res Function(_StoryGenerateState) _then;

/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeline = null,Object? phase = null,Object? sessionId = freezed,Object? originalQuery = freezed,Object? stage = freezed,Object? failure = freezed,Object? errorCode = freezed,Object? result = freezed,}) {
  return _then(_StoryGenerateState(
timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<GenerationEntry>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GenerationPhase,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,originalQuery: freezed == originalQuery ? _self.originalQuery : originalQuery // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as GeneratedStory?,
  ));
}

/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of StoryGenerateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneratedStoryCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $GeneratedStoryCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

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
