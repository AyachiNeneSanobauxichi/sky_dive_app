// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_script_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryScriptDto {

 String get id; String? get title; String? get theme; String? get style; String? get length;/// 四段式剧情。[plotJson] 里没有全文时靠它们拼。
 String? get plotIntro; String? get plotTurning; String? get plotClimax; String? get plotEnding; String? get conversationId; String? get currentVersionMessageId;/// 扩展 JSON。全文藏在 `fullContent` 里（客户端约定，不是强约束）。
 Map<String, dynamic>? get plotJson; String? get createTime; String? get updateTime;
/// Create a copy of StoryScriptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryScriptDtoCopyWith<StoryScriptDto> get copyWith => _$StoryScriptDtoCopyWithImpl<StoryScriptDto>(this as StoryScriptDto, _$identity);

  /// Serializes this StoryScriptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryScriptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.style, style) || other.style == style)&&(identical(other.length, length) || other.length == length)&&(identical(other.plotIntro, plotIntro) || other.plotIntro == plotIntro)&&(identical(other.plotTurning, plotTurning) || other.plotTurning == plotTurning)&&(identical(other.plotClimax, plotClimax) || other.plotClimax == plotClimax)&&(identical(other.plotEnding, plotEnding) || other.plotEnding == plotEnding)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.currentVersionMessageId, currentVersionMessageId) || other.currentVersionMessageId == currentVersionMessageId)&&const DeepCollectionEquality().equals(other.plotJson, plotJson)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,theme,style,length,plotIntro,plotTurning,plotClimax,plotEnding,conversationId,currentVersionMessageId,const DeepCollectionEquality().hash(plotJson),createTime,updateTime);

@override
String toString() {
  return 'StoryScriptDto(id: $id, title: $title, theme: $theme, style: $style, length: $length, plotIntro: $plotIntro, plotTurning: $plotTurning, plotClimax: $plotClimax, plotEnding: $plotEnding, conversationId: $conversationId, currentVersionMessageId: $currentVersionMessageId, plotJson: $plotJson, createTime: $createTime, updateTime: $updateTime)';
}


}

/// @nodoc
abstract mixin class $StoryScriptDtoCopyWith<$Res>  {
  factory $StoryScriptDtoCopyWith(StoryScriptDto value, $Res Function(StoryScriptDto) _then) = _$StoryScriptDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? title, String? theme, String? style, String? length, String? plotIntro, String? plotTurning, String? plotClimax, String? plotEnding, String? conversationId, String? currentVersionMessageId, Map<String, dynamic>? plotJson, String? createTime, String? updateTime
});




}
/// @nodoc
class _$StoryScriptDtoCopyWithImpl<$Res>
    implements $StoryScriptDtoCopyWith<$Res> {
  _$StoryScriptDtoCopyWithImpl(this._self, this._then);

  final StoryScriptDto _self;
  final $Res Function(StoryScriptDto) _then;

/// Create a copy of StoryScriptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? theme = freezed,Object? style = freezed,Object? length = freezed,Object? plotIntro = freezed,Object? plotTurning = freezed,Object? plotClimax = freezed,Object? plotEnding = freezed,Object? conversationId = freezed,Object? currentVersionMessageId = freezed,Object? plotJson = freezed,Object? createTime = freezed,Object? updateTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,style: freezed == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as String?,plotIntro: freezed == plotIntro ? _self.plotIntro : plotIntro // ignore: cast_nullable_to_non_nullable
as String?,plotTurning: freezed == plotTurning ? _self.plotTurning : plotTurning // ignore: cast_nullable_to_non_nullable
as String?,plotClimax: freezed == plotClimax ? _self.plotClimax : plotClimax // ignore: cast_nullable_to_non_nullable
as String?,plotEnding: freezed == plotEnding ? _self.plotEnding : plotEnding // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,currentVersionMessageId: freezed == currentVersionMessageId ? _self.currentVersionMessageId : currentVersionMessageId // ignore: cast_nullable_to_non_nullable
as String?,plotJson: freezed == plotJson ? _self.plotJson : plotJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryScriptDto].
extension StoryScriptDtoPatterns on StoryScriptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryScriptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryScriptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryScriptDto value)  $default,){
final _that = this;
switch (_that) {
case _StoryScriptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryScriptDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoryScriptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? title,  String? theme,  String? style,  String? length,  String? plotIntro,  String? plotTurning,  String? plotClimax,  String? plotEnding,  String? conversationId,  String? currentVersionMessageId,  Map<String, dynamic>? plotJson,  String? createTime,  String? updateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryScriptDto() when $default != null:
return $default(_that.id,_that.title,_that.theme,_that.style,_that.length,_that.plotIntro,_that.plotTurning,_that.plotClimax,_that.plotEnding,_that.conversationId,_that.currentVersionMessageId,_that.plotJson,_that.createTime,_that.updateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? title,  String? theme,  String? style,  String? length,  String? plotIntro,  String? plotTurning,  String? plotClimax,  String? plotEnding,  String? conversationId,  String? currentVersionMessageId,  Map<String, dynamic>? plotJson,  String? createTime,  String? updateTime)  $default,) {final _that = this;
switch (_that) {
case _StoryScriptDto():
return $default(_that.id,_that.title,_that.theme,_that.style,_that.length,_that.plotIntro,_that.plotTurning,_that.plotClimax,_that.plotEnding,_that.conversationId,_that.currentVersionMessageId,_that.plotJson,_that.createTime,_that.updateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? title,  String? theme,  String? style,  String? length,  String? plotIntro,  String? plotTurning,  String? plotClimax,  String? plotEnding,  String? conversationId,  String? currentVersionMessageId,  Map<String, dynamic>? plotJson,  String? createTime,  String? updateTime)?  $default,) {final _that = this;
switch (_that) {
case _StoryScriptDto() when $default != null:
return $default(_that.id,_that.title,_that.theme,_that.style,_that.length,_that.plotIntro,_that.plotTurning,_that.plotClimax,_that.plotEnding,_that.conversationId,_that.currentVersionMessageId,_that.plotJson,_that.createTime,_that.updateTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoryScriptDto extends StoryScriptDto {
  const _StoryScriptDto({required this.id, this.title, this.theme, this.style, this.length, this.plotIntro, this.plotTurning, this.plotClimax, this.plotEnding, this.conversationId, this.currentVersionMessageId, final  Map<String, dynamic>? plotJson, this.createTime, this.updateTime}): _plotJson = plotJson,super._();
  factory _StoryScriptDto.fromJson(Map<String, dynamic> json) => _$StoryScriptDtoFromJson(json);

@override final  String id;
@override final  String? title;
@override final  String? theme;
@override final  String? style;
@override final  String? length;
/// 四段式剧情。[plotJson] 里没有全文时靠它们拼。
@override final  String? plotIntro;
@override final  String? plotTurning;
@override final  String? plotClimax;
@override final  String? plotEnding;
@override final  String? conversationId;
@override final  String? currentVersionMessageId;
/// 扩展 JSON。全文藏在 `fullContent` 里（客户端约定，不是强约束）。
 final  Map<String, dynamic>? _plotJson;
/// 扩展 JSON。全文藏在 `fullContent` 里（客户端约定，不是强约束）。
@override Map<String, dynamic>? get plotJson {
  final value = _plotJson;
  if (value == null) return null;
  if (_plotJson is EqualUnmodifiableMapView) return _plotJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? createTime;
@override final  String? updateTime;

/// Create a copy of StoryScriptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryScriptDtoCopyWith<_StoryScriptDto> get copyWith => __$StoryScriptDtoCopyWithImpl<_StoryScriptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryScriptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryScriptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.style, style) || other.style == style)&&(identical(other.length, length) || other.length == length)&&(identical(other.plotIntro, plotIntro) || other.plotIntro == plotIntro)&&(identical(other.plotTurning, plotTurning) || other.plotTurning == plotTurning)&&(identical(other.plotClimax, plotClimax) || other.plotClimax == plotClimax)&&(identical(other.plotEnding, plotEnding) || other.plotEnding == plotEnding)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.currentVersionMessageId, currentVersionMessageId) || other.currentVersionMessageId == currentVersionMessageId)&&const DeepCollectionEquality().equals(other._plotJson, _plotJson)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,theme,style,length,plotIntro,plotTurning,plotClimax,plotEnding,conversationId,currentVersionMessageId,const DeepCollectionEquality().hash(_plotJson),createTime,updateTime);

@override
String toString() {
  return 'StoryScriptDto(id: $id, title: $title, theme: $theme, style: $style, length: $length, plotIntro: $plotIntro, plotTurning: $plotTurning, plotClimax: $plotClimax, plotEnding: $plotEnding, conversationId: $conversationId, currentVersionMessageId: $currentVersionMessageId, plotJson: $plotJson, createTime: $createTime, updateTime: $updateTime)';
}


}

/// @nodoc
abstract mixin class _$StoryScriptDtoCopyWith<$Res> implements $StoryScriptDtoCopyWith<$Res> {
  factory _$StoryScriptDtoCopyWith(_StoryScriptDto value, $Res Function(_StoryScriptDto) _then) = __$StoryScriptDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? title, String? theme, String? style, String? length, String? plotIntro, String? plotTurning, String? plotClimax, String? plotEnding, String? conversationId, String? currentVersionMessageId, Map<String, dynamic>? plotJson, String? createTime, String? updateTime
});




}
/// @nodoc
class __$StoryScriptDtoCopyWithImpl<$Res>
    implements _$StoryScriptDtoCopyWith<$Res> {
  __$StoryScriptDtoCopyWithImpl(this._self, this._then);

  final _StoryScriptDto _self;
  final $Res Function(_StoryScriptDto) _then;

/// Create a copy of StoryScriptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? theme = freezed,Object? style = freezed,Object? length = freezed,Object? plotIntro = freezed,Object? plotTurning = freezed,Object? plotClimax = freezed,Object? plotEnding = freezed,Object? conversationId = freezed,Object? currentVersionMessageId = freezed,Object? plotJson = freezed,Object? createTime = freezed,Object? updateTime = freezed,}) {
  return _then(_StoryScriptDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,style: freezed == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as String?,plotIntro: freezed == plotIntro ? _self.plotIntro : plotIntro // ignore: cast_nullable_to_non_nullable
as String?,plotTurning: freezed == plotTurning ? _self.plotTurning : plotTurning // ignore: cast_nullable_to_non_nullable
as String?,plotClimax: freezed == plotClimax ? _self.plotClimax : plotClimax // ignore: cast_nullable_to_non_nullable
as String?,plotEnding: freezed == plotEnding ? _self.plotEnding : plotEnding // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,currentVersionMessageId: freezed == currentVersionMessageId ? _self.currentVersionMessageId : currentVersionMessageId // ignore: cast_nullable_to_non_nullable
as String?,plotJson: freezed == plotJson ? _self._plotJson : plotJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
