// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_generation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryGenerationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGenerationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryGenerationState()';
}


}

/// @nodoc
class $StoryGenerationStateCopyWith<$Res>  {
$StoryGenerationStateCopyWith(StoryGenerationState _, $Res Function(StoryGenerationState) __);
}


/// Adds pattern-matching-related methods to [StoryGenerationState].
extension StoryGenerationStatePatterns on StoryGenerationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StoryIdle value)?  idle,TResult Function( StoryThinking value)?  thinking,TResult Function( StoryStreaming value)?  streaming,TResult Function( StoryCompleted value)?  completed,TResult Function( StoryFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StoryIdle() when idle != null:
return idle(_that);case StoryThinking() when thinking != null:
return thinking(_that);case StoryStreaming() when streaming != null:
return streaming(_that);case StoryCompleted() when completed != null:
return completed(_that);case StoryFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StoryIdle value)  idle,required TResult Function( StoryThinking value)  thinking,required TResult Function( StoryStreaming value)  streaming,required TResult Function( StoryCompleted value)  completed,required TResult Function( StoryFailed value)  failed,}){
final _that = this;
switch (_that) {
case StoryIdle():
return idle(_that);case StoryThinking():
return thinking(_that);case StoryStreaming():
return streaming(_that);case StoryCompleted():
return completed(_that);case StoryFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StoryIdle value)?  idle,TResult? Function( StoryThinking value)?  thinking,TResult? Function( StoryStreaming value)?  streaming,TResult? Function( StoryCompleted value)?  completed,TResult? Function( StoryFailed value)?  failed,}){
final _that = this;
switch (_that) {
case StoryIdle() when idle != null:
return idle(_that);case StoryThinking() when thinking != null:
return thinking(_that);case StoryStreaming() when streaming != null:
return streaming(_that);case StoryCompleted() when completed != null:
return completed(_that);case StoryFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  thinking,TResult Function( String text)?  streaming,TResult Function( String text,  bool stoppedByUser)?  completed,TResult Function( String text,  Failure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StoryIdle() when idle != null:
return idle();case StoryThinking() when thinking != null:
return thinking();case StoryStreaming() when streaming != null:
return streaming(_that.text);case StoryCompleted() when completed != null:
return completed(_that.text,_that.stoppedByUser);case StoryFailed() when failed != null:
return failed(_that.text,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  thinking,required TResult Function( String text)  streaming,required TResult Function( String text,  bool stoppedByUser)  completed,required TResult Function( String text,  Failure failure)  failed,}) {final _that = this;
switch (_that) {
case StoryIdle():
return idle();case StoryThinking():
return thinking();case StoryStreaming():
return streaming(_that.text);case StoryCompleted():
return completed(_that.text,_that.stoppedByUser);case StoryFailed():
return failed(_that.text,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  thinking,TResult? Function( String text)?  streaming,TResult? Function( String text,  bool stoppedByUser)?  completed,TResult? Function( String text,  Failure failure)?  failed,}) {final _that = this;
switch (_that) {
case StoryIdle() when idle != null:
return idle();case StoryThinking() when thinking != null:
return thinking();case StoryStreaming() when streaming != null:
return streaming(_that.text);case StoryCompleted() when completed != null:
return completed(_that.text,_that.stoppedByUser);case StoryFailed() when failed != null:
return failed(_that.text,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class StoryIdle implements StoryGenerationState {
  const StoryIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryGenerationState.idle()';
}


}




/// @nodoc


class StoryThinking implements StoryGenerationState {
  const StoryThinking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryThinking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoryGenerationState.thinking()';
}


}




/// @nodoc


class StoryStreaming implements StoryGenerationState {
  const StoryStreaming({required this.text});
  

 final  String text;

/// Create a copy of StoryGenerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryStreamingCopyWith<StoryStreaming> get copyWith => _$StoryStreamingCopyWithImpl<StoryStreaming>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryStreaming&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'StoryGenerationState.streaming(text: $text)';
}


}

/// @nodoc
abstract mixin class $StoryStreamingCopyWith<$Res> implements $StoryGenerationStateCopyWith<$Res> {
  factory $StoryStreamingCopyWith(StoryStreaming value, $Res Function(StoryStreaming) _then) = _$StoryStreamingCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$StoryStreamingCopyWithImpl<$Res>
    implements $StoryStreamingCopyWith<$Res> {
  _$StoryStreamingCopyWithImpl(this._self, this._then);

  final StoryStreaming _self;
  final $Res Function(StoryStreaming) _then;

/// Create a copy of StoryGenerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(StoryStreaming(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class StoryCompleted implements StoryGenerationState {
  const StoryCompleted({required this.text, this.stoppedByUser = false});
  

 final  String text;
@JsonKey() final  bool stoppedByUser;

/// Create a copy of StoryGenerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCompletedCopyWith<StoryCompleted> get copyWith => _$StoryCompletedCopyWithImpl<StoryCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryCompleted&&(identical(other.text, text) || other.text == text)&&(identical(other.stoppedByUser, stoppedByUser) || other.stoppedByUser == stoppedByUser));
}


@override
int get hashCode => Object.hash(runtimeType,text,stoppedByUser);

@override
String toString() {
  return 'StoryGenerationState.completed(text: $text, stoppedByUser: $stoppedByUser)';
}


}

/// @nodoc
abstract mixin class $StoryCompletedCopyWith<$Res> implements $StoryGenerationStateCopyWith<$Res> {
  factory $StoryCompletedCopyWith(StoryCompleted value, $Res Function(StoryCompleted) _then) = _$StoryCompletedCopyWithImpl;
@useResult
$Res call({
 String text, bool stoppedByUser
});




}
/// @nodoc
class _$StoryCompletedCopyWithImpl<$Res>
    implements $StoryCompletedCopyWith<$Res> {
  _$StoryCompletedCopyWithImpl(this._self, this._then);

  final StoryCompleted _self;
  final $Res Function(StoryCompleted) _then;

/// Create a copy of StoryGenerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,Object? stoppedByUser = null,}) {
  return _then(StoryCompleted(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,stoppedByUser: null == stoppedByUser ? _self.stoppedByUser : stoppedByUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class StoryFailed implements StoryGenerationState {
  const StoryFailed({required this.text, required this.failure});
  

 final  String text;
 final  Failure failure;

/// Create a copy of StoryGenerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryFailedCopyWith<StoryFailed> get copyWith => _$StoryFailedCopyWithImpl<StoryFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryFailed&&(identical(other.text, text) || other.text == text)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,text,failure);

@override
String toString() {
  return 'StoryGenerationState.failed(text: $text, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $StoryFailedCopyWith<$Res> implements $StoryGenerationStateCopyWith<$Res> {
  factory $StoryFailedCopyWith(StoryFailed value, $Res Function(StoryFailed) _then) = _$StoryFailedCopyWithImpl;
@useResult
$Res call({
 String text, Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$StoryFailedCopyWithImpl<$Res>
    implements $StoryFailedCopyWith<$Res> {
  _$StoryFailedCopyWithImpl(this._self, this._then);

  final StoryFailed _self;
  final $Res Function(StoryFailed) _then;

/// Create a copy of StoryGenerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,Object? failure = null,}) {
  return _then(StoryFailed(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of StoryGenerationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
