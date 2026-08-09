// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generation_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenerationEvent {

 String get sessionId;
/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationEventCopyWith<GenerationEvent> get copyWith => _$GenerationEventCopyWithImpl<GenerationEvent>(this as GenerationEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'GenerationEvent(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $GenerationEventCopyWith<$Res>  {
  factory $GenerationEventCopyWith(GenerationEvent value, $Res Function(GenerationEvent) _then) = _$GenerationEventCopyWithImpl;
@useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class _$GenerationEventCopyWithImpl<$Res>
    implements $GenerationEventCopyWith<$Res> {
  _$GenerationEventCopyWithImpl(this._self, this._then);

  final GenerationEvent _self;
  final $Res Function(GenerationEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerationEvent].
extension GenerationEventPatterns on GenerationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GenerationStatusEvent value)?  status,TResult Function( GenerationClarificationEvent value)?  clarification,TResult Function( GenerationOutlineEvent value)?  outline,TResult Function( GenerationNovelStartEvent value)?  novelStart,TResult Function( GenerationDeltaEvent value)?  delta,TResult Function( GenerationDoneEvent value)?  done,TResult Function( GenerationFailedEvent value)?  failed,TResult Function( GenerationUnknownEvent value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GenerationStatusEvent() when status != null:
return status(_that);case GenerationClarificationEvent() when clarification != null:
return clarification(_that);case GenerationOutlineEvent() when outline != null:
return outline(_that);case GenerationNovelStartEvent() when novelStart != null:
return novelStart(_that);case GenerationDeltaEvent() when delta != null:
return delta(_that);case GenerationDoneEvent() when done != null:
return done(_that);case GenerationFailedEvent() when failed != null:
return failed(_that);case GenerationUnknownEvent() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GenerationStatusEvent value)  status,required TResult Function( GenerationClarificationEvent value)  clarification,required TResult Function( GenerationOutlineEvent value)  outline,required TResult Function( GenerationNovelStartEvent value)  novelStart,required TResult Function( GenerationDeltaEvent value)  delta,required TResult Function( GenerationDoneEvent value)  done,required TResult Function( GenerationFailedEvent value)  failed,required TResult Function( GenerationUnknownEvent value)  unknown,}){
final _that = this;
switch (_that) {
case GenerationStatusEvent():
return status(_that);case GenerationClarificationEvent():
return clarification(_that);case GenerationOutlineEvent():
return outline(_that);case GenerationNovelStartEvent():
return novelStart(_that);case GenerationDeltaEvent():
return delta(_that);case GenerationDoneEvent():
return done(_that);case GenerationFailedEvent():
return failed(_that);case GenerationUnknownEvent():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GenerationStatusEvent value)?  status,TResult? Function( GenerationClarificationEvent value)?  clarification,TResult? Function( GenerationOutlineEvent value)?  outline,TResult? Function( GenerationNovelStartEvent value)?  novelStart,TResult? Function( GenerationDeltaEvent value)?  delta,TResult? Function( GenerationDoneEvent value)?  done,TResult? Function( GenerationFailedEvent value)?  failed,TResult? Function( GenerationUnknownEvent value)?  unknown,}){
final _that = this;
switch (_that) {
case GenerationStatusEvent() when status != null:
return status(_that);case GenerationClarificationEvent() when clarification != null:
return clarification(_that);case GenerationOutlineEvent() when outline != null:
return outline(_that);case GenerationNovelStartEvent() when novelStart != null:
return novelStart(_that);case GenerationDeltaEvent() when delta != null:
return delta(_that);case GenerationDoneEvent() when done != null:
return done(_that);case GenerationFailedEvent() when failed != null:
return failed(_that);case GenerationUnknownEvent() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String sessionId,  String? stage)?  status,TResult Function( String sessionId,  ClarificationCard card)?  clarification,TResult Function( String sessionId,  StoryOutline outline)?  outline,TResult Function( String sessionId)?  novelStart,TResult Function( String sessionId,  String text)?  delta,TResult Function( String sessionId,  String? fullText,  String? title,  String? scriptId,  String? conversationId,  String? currentVersionMessageId)?  done,TResult Function( String sessionId,  String? code,  String? message)?  failed,TResult Function( String sessionId,  String type)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GenerationStatusEvent() when status != null:
return status(_that.sessionId,_that.stage);case GenerationClarificationEvent() when clarification != null:
return clarification(_that.sessionId,_that.card);case GenerationOutlineEvent() when outline != null:
return outline(_that.sessionId,_that.outline);case GenerationNovelStartEvent() when novelStart != null:
return novelStart(_that.sessionId);case GenerationDeltaEvent() when delta != null:
return delta(_that.sessionId,_that.text);case GenerationDoneEvent() when done != null:
return done(_that.sessionId,_that.fullText,_that.title,_that.scriptId,_that.conversationId,_that.currentVersionMessageId);case GenerationFailedEvent() when failed != null:
return failed(_that.sessionId,_that.code,_that.message);case GenerationUnknownEvent() when unknown != null:
return unknown(_that.sessionId,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String sessionId,  String? stage)  status,required TResult Function( String sessionId,  ClarificationCard card)  clarification,required TResult Function( String sessionId,  StoryOutline outline)  outline,required TResult Function( String sessionId)  novelStart,required TResult Function( String sessionId,  String text)  delta,required TResult Function( String sessionId,  String? fullText,  String? title,  String? scriptId,  String? conversationId,  String? currentVersionMessageId)  done,required TResult Function( String sessionId,  String? code,  String? message)  failed,required TResult Function( String sessionId,  String type)  unknown,}) {final _that = this;
switch (_that) {
case GenerationStatusEvent():
return status(_that.sessionId,_that.stage);case GenerationClarificationEvent():
return clarification(_that.sessionId,_that.card);case GenerationOutlineEvent():
return outline(_that.sessionId,_that.outline);case GenerationNovelStartEvent():
return novelStart(_that.sessionId);case GenerationDeltaEvent():
return delta(_that.sessionId,_that.text);case GenerationDoneEvent():
return done(_that.sessionId,_that.fullText,_that.title,_that.scriptId,_that.conversationId,_that.currentVersionMessageId);case GenerationFailedEvent():
return failed(_that.sessionId,_that.code,_that.message);case GenerationUnknownEvent():
return unknown(_that.sessionId,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String sessionId,  String? stage)?  status,TResult? Function( String sessionId,  ClarificationCard card)?  clarification,TResult? Function( String sessionId,  StoryOutline outline)?  outline,TResult? Function( String sessionId)?  novelStart,TResult? Function( String sessionId,  String text)?  delta,TResult? Function( String sessionId,  String? fullText,  String? title,  String? scriptId,  String? conversationId,  String? currentVersionMessageId)?  done,TResult? Function( String sessionId,  String? code,  String? message)?  failed,TResult? Function( String sessionId,  String type)?  unknown,}) {final _that = this;
switch (_that) {
case GenerationStatusEvent() when status != null:
return status(_that.sessionId,_that.stage);case GenerationClarificationEvent() when clarification != null:
return clarification(_that.sessionId,_that.card);case GenerationOutlineEvent() when outline != null:
return outline(_that.sessionId,_that.outline);case GenerationNovelStartEvent() when novelStart != null:
return novelStart(_that.sessionId);case GenerationDeltaEvent() when delta != null:
return delta(_that.sessionId,_that.text);case GenerationDoneEvent() when done != null:
return done(_that.sessionId,_that.fullText,_that.title,_that.scriptId,_that.conversationId,_that.currentVersionMessageId);case GenerationFailedEvent() when failed != null:
return failed(_that.sessionId,_that.code,_that.message);case GenerationUnknownEvent() when unknown != null:
return unknown(_that.sessionId,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class GenerationStatusEvent implements GenerationEvent {
  const GenerationStatusEvent({required this.sessionId, this.stage});
  

@override final  String sessionId;
/// 阶段标识（如 `processing`）。契约没有枚举值清单，按字符串透传。
 final  String? stage;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationStatusEventCopyWith<GenerationStatusEvent> get copyWith => _$GenerationStatusEventCopyWithImpl<GenerationStatusEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationStatusEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.stage, stage) || other.stage == stage));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,stage);

@override
String toString() {
  return 'GenerationEvent.status(sessionId: $sessionId, stage: $stage)';
}


}

/// @nodoc
abstract mixin class $GenerationStatusEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationStatusEventCopyWith(GenerationStatusEvent value, $Res Function(GenerationStatusEvent) _then) = _$GenerationStatusEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String? stage
});




}
/// @nodoc
class _$GenerationStatusEventCopyWithImpl<$Res>
    implements $GenerationStatusEventCopyWith<$Res> {
  _$GenerationStatusEventCopyWithImpl(this._self, this._then);

  final GenerationStatusEvent _self;
  final $Res Function(GenerationStatusEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? stage = freezed,}) {
  return _then(GenerationStatusEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class GenerationClarificationEvent implements GenerationEvent {
  const GenerationClarificationEvent({required this.sessionId, required this.card});
  

@override final  String sessionId;
 final  ClarificationCard card;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationClarificationEventCopyWith<GenerationClarificationEvent> get copyWith => _$GenerationClarificationEventCopyWithImpl<GenerationClarificationEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationClarificationEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.card, card) || other.card == card));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,card);

@override
String toString() {
  return 'GenerationEvent.clarification(sessionId: $sessionId, card: $card)';
}


}

/// @nodoc
abstract mixin class $GenerationClarificationEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationClarificationEventCopyWith(GenerationClarificationEvent value, $Res Function(GenerationClarificationEvent) _then) = _$GenerationClarificationEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, ClarificationCard card
});


$ClarificationCardCopyWith<$Res> get card;

}
/// @nodoc
class _$GenerationClarificationEventCopyWithImpl<$Res>
    implements $GenerationClarificationEventCopyWith<$Res> {
  _$GenerationClarificationEventCopyWithImpl(this._self, this._then);

  final GenerationClarificationEvent _self;
  final $Res Function(GenerationClarificationEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? card = null,}) {
  return _then(GenerationClarificationEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as ClarificationCard,
  ));
}

/// Create a copy of GenerationEvent
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


class GenerationOutlineEvent implements GenerationEvent {
  const GenerationOutlineEvent({required this.sessionId, required this.outline});
  

@override final  String sessionId;
 final  StoryOutline outline;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationOutlineEventCopyWith<GenerationOutlineEvent> get copyWith => _$GenerationOutlineEventCopyWithImpl<GenerationOutlineEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationOutlineEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.outline, outline) || other.outline == outline));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,outline);

@override
String toString() {
  return 'GenerationEvent.outline(sessionId: $sessionId, outline: $outline)';
}


}

/// @nodoc
abstract mixin class $GenerationOutlineEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationOutlineEventCopyWith(GenerationOutlineEvent value, $Res Function(GenerationOutlineEvent) _then) = _$GenerationOutlineEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, StoryOutline outline
});


$StoryOutlineCopyWith<$Res> get outline;

}
/// @nodoc
class _$GenerationOutlineEventCopyWithImpl<$Res>
    implements $GenerationOutlineEventCopyWith<$Res> {
  _$GenerationOutlineEventCopyWithImpl(this._self, this._then);

  final GenerationOutlineEvent _self;
  final $Res Function(GenerationOutlineEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? outline = null,}) {
  return _then(GenerationOutlineEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,outline: null == outline ? _self.outline : outline // ignore: cast_nullable_to_non_nullable
as StoryOutline,
  ));
}

/// Create a copy of GenerationEvent
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


class GenerationNovelStartEvent implements GenerationEvent {
  const GenerationNovelStartEvent({required this.sessionId});
  

@override final  String sessionId;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationNovelStartEventCopyWith<GenerationNovelStartEvent> get copyWith => _$GenerationNovelStartEventCopyWithImpl<GenerationNovelStartEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationNovelStartEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'GenerationEvent.novelStart(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $GenerationNovelStartEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationNovelStartEventCopyWith(GenerationNovelStartEvent value, $Res Function(GenerationNovelStartEvent) _then) = _$GenerationNovelStartEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class _$GenerationNovelStartEventCopyWithImpl<$Res>
    implements $GenerationNovelStartEventCopyWith<$Res> {
  _$GenerationNovelStartEventCopyWithImpl(this._self, this._then);

  final GenerationNovelStartEvent _self;
  final $Res Function(GenerationNovelStartEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,}) {
  return _then(GenerationNovelStartEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GenerationDeltaEvent implements GenerationEvent {
  const GenerationDeltaEvent({required this.sessionId, required this.text});
  

@override final  String sessionId;
 final  String text;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationDeltaEventCopyWith<GenerationDeltaEvent> get copyWith => _$GenerationDeltaEventCopyWithImpl<GenerationDeltaEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationDeltaEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,text);

@override
String toString() {
  return 'GenerationEvent.delta(sessionId: $sessionId, text: $text)';
}


}

/// @nodoc
abstract mixin class $GenerationDeltaEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationDeltaEventCopyWith(GenerationDeltaEvent value, $Res Function(GenerationDeltaEvent) _then) = _$GenerationDeltaEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String text
});




}
/// @nodoc
class _$GenerationDeltaEventCopyWithImpl<$Res>
    implements $GenerationDeltaEventCopyWith<$Res> {
  _$GenerationDeltaEventCopyWithImpl(this._self, this._then);

  final GenerationDeltaEvent _self;
  final $Res Function(GenerationDeltaEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? text = null,}) {
  return _then(GenerationDeltaEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GenerationDoneEvent implements GenerationEvent {
  const GenerationDoneEvent({required this.sessionId, this.fullText, this.title, this.scriptId, this.conversationId, this.currentVersionMessageId});
  

@override final  String sessionId;
/// 全文。上游可能不带，此时由 controller 用累加的增量兜底。
 final  String? fullText;
 final  String? title;
/// 落库后的剧本 id。有它才谈得上「读全文」。
 final  String? scriptId;
 final  String? conversationId;
 final  String? currentVersionMessageId;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationDoneEventCopyWith<GenerationDoneEvent> get copyWith => _$GenerationDoneEventCopyWithImpl<GenerationDoneEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationDoneEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.fullText, fullText) || other.fullText == fullText)&&(identical(other.title, title) || other.title == title)&&(identical(other.scriptId, scriptId) || other.scriptId == scriptId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.currentVersionMessageId, currentVersionMessageId) || other.currentVersionMessageId == currentVersionMessageId));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,fullText,title,scriptId,conversationId,currentVersionMessageId);

@override
String toString() {
  return 'GenerationEvent.done(sessionId: $sessionId, fullText: $fullText, title: $title, scriptId: $scriptId, conversationId: $conversationId, currentVersionMessageId: $currentVersionMessageId)';
}


}

/// @nodoc
abstract mixin class $GenerationDoneEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationDoneEventCopyWith(GenerationDoneEvent value, $Res Function(GenerationDoneEvent) _then) = _$GenerationDoneEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String? fullText, String? title, String? scriptId, String? conversationId, String? currentVersionMessageId
});




}
/// @nodoc
class _$GenerationDoneEventCopyWithImpl<$Res>
    implements $GenerationDoneEventCopyWith<$Res> {
  _$GenerationDoneEventCopyWithImpl(this._self, this._then);

  final GenerationDoneEvent _self;
  final $Res Function(GenerationDoneEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? fullText = freezed,Object? title = freezed,Object? scriptId = freezed,Object? conversationId = freezed,Object? currentVersionMessageId = freezed,}) {
  return _then(GenerationDoneEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,fullText: freezed == fullText ? _self.fullText : fullText // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,scriptId: freezed == scriptId ? _self.scriptId : scriptId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,currentVersionMessageId: freezed == currentVersionMessageId ? _self.currentVersionMessageId : currentVersionMessageId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class GenerationFailedEvent implements GenerationEvent {
  const GenerationFailedEvent({required this.sessionId, this.code, this.message});
  

@override final  String sessionId;
 final  String? code;
 final  String? message;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationFailedEventCopyWith<GenerationFailedEvent> get copyWith => _$GenerationFailedEventCopyWithImpl<GenerationFailedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationFailedEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,code,message);

@override
String toString() {
  return 'GenerationEvent.failed(sessionId: $sessionId, code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $GenerationFailedEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationFailedEventCopyWith(GenerationFailedEvent value, $Res Function(GenerationFailedEvent) _then) = _$GenerationFailedEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String? code, String? message
});




}
/// @nodoc
class _$GenerationFailedEventCopyWithImpl<$Res>
    implements $GenerationFailedEventCopyWith<$Res> {
  _$GenerationFailedEventCopyWithImpl(this._self, this._then);

  final GenerationFailedEvent _self;
  final $Res Function(GenerationFailedEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? code = freezed,Object? message = freezed,}) {
  return _then(GenerationFailedEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class GenerationUnknownEvent implements GenerationEvent {
  const GenerationUnknownEvent({required this.sessionId, required this.type});
  

@override final  String sessionId;
 final  String type;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationUnknownEventCopyWith<GenerationUnknownEvent> get copyWith => _$GenerationUnknownEventCopyWithImpl<GenerationUnknownEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationUnknownEvent&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,type);

@override
String toString() {
  return 'GenerationEvent.unknown(sessionId: $sessionId, type: $type)';
}


}

/// @nodoc
abstract mixin class $GenerationUnknownEventCopyWith<$Res> implements $GenerationEventCopyWith<$Res> {
  factory $GenerationUnknownEventCopyWith(GenerationUnknownEvent value, $Res Function(GenerationUnknownEvent) _then) = _$GenerationUnknownEventCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String type
});




}
/// @nodoc
class _$GenerationUnknownEventCopyWithImpl<$Res>
    implements $GenerationUnknownEventCopyWith<$Res> {
  _$GenerationUnknownEventCopyWithImpl(this._self, this._then);

  final GenerationUnknownEvent _self;
  final $Res Function(GenerationUnknownEvent) _then;

/// Create a copy of GenerationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? type = null,}) {
  return _then(GenerationUnknownEvent(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
