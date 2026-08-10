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

// dart format on
