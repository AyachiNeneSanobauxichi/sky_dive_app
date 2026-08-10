// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_script.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryScript {

 String get id;/// 标题。后端可能没给（早期数据），UI 用主题或兜底文案顶上。
 String get title;/// 列表里露出的一小段（约 90 字，已去 Markdown 符号）。
 String get summary;/// 创建时间，列表按它倒序。
 DateTime get createdAt;/// 用户当初那句心愿。它比标题更能唤起"这篇是写什么的"。
 String? get theme;/// 全文（Markdown）。列表不需要，阅读页要。
 String? get content;/// 关联会话 id。日后"接着改这一篇"要靠它回到生成会话。
 String? get conversationId;/// 是否已收藏。
///
/// **不来自列表接口**——契约里 `EpicScriptResponse` 没有这个字段，是仓库另外
/// 探一次收藏列表再套上来的（见 `story-history.api.md` 的契约缺口）。
 bool get isFavorited;
/// Create a copy of StoryScript
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryScriptCopyWith<StoryScript> get copyWith => _$StoryScriptCopyWithImpl<StoryScript>(this as StoryScript, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryScript&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.content, content) || other.content == content)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,summary,createdAt,theme,content,conversationId,isFavorited);

@override
String toString() {
  return 'StoryScript(id: $id, title: $title, summary: $summary, createdAt: $createdAt, theme: $theme, content: $content, conversationId: $conversationId, isFavorited: $isFavorited)';
}


}

/// @nodoc
abstract mixin class $StoryScriptCopyWith<$Res>  {
  factory $StoryScriptCopyWith(StoryScript value, $Res Function(StoryScript) _then) = _$StoryScriptCopyWithImpl;
@useResult
$Res call({
 String id, String title, String summary, DateTime createdAt, String? theme, String? content, String? conversationId, bool isFavorited
});




}
/// @nodoc
class _$StoryScriptCopyWithImpl<$Res>
    implements $StoryScriptCopyWith<$Res> {
  _$StoryScriptCopyWithImpl(this._self, this._then);

  final StoryScript _self;
  final $Res Function(StoryScript) _then;

/// Create a copy of StoryScript
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? createdAt = null,Object? theme = freezed,Object? content = freezed,Object? conversationId = freezed,Object? isFavorited = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,isFavorited: null == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryScript].
extension StoryScriptPatterns on StoryScript {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryScript value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryScript() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryScript value)  $default,){
final _that = this;
switch (_that) {
case _StoryScript():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryScript value)?  $default,){
final _that = this;
switch (_that) {
case _StoryScript() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  DateTime createdAt,  String? theme,  String? content,  String? conversationId,  bool isFavorited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryScript() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.createdAt,_that.theme,_that.content,_that.conversationId,_that.isFavorited);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  DateTime createdAt,  String? theme,  String? content,  String? conversationId,  bool isFavorited)  $default,) {final _that = this;
switch (_that) {
case _StoryScript():
return $default(_that.id,_that.title,_that.summary,_that.createdAt,_that.theme,_that.content,_that.conversationId,_that.isFavorited);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String summary,  DateTime createdAt,  String? theme,  String? content,  String? conversationId,  bool isFavorited)?  $default,) {final _that = this;
switch (_that) {
case _StoryScript() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.createdAt,_that.theme,_that.content,_that.conversationId,_that.isFavorited);case _:
  return null;

}
}

}

/// @nodoc


class _StoryScript implements StoryScript {
  const _StoryScript({required this.id, required this.title, required this.summary, required this.createdAt, this.theme, this.content, this.conversationId, this.isFavorited = false});
  

@override final  String id;
/// 标题。后端可能没给（早期数据），UI 用主题或兜底文案顶上。
@override final  String title;
/// 列表里露出的一小段（约 90 字，已去 Markdown 符号）。
@override final  String summary;
/// 创建时间，列表按它倒序。
@override final  DateTime createdAt;
/// 用户当初那句心愿。它比标题更能唤起"这篇是写什么的"。
@override final  String? theme;
/// 全文（Markdown）。列表不需要，阅读页要。
@override final  String? content;
/// 关联会话 id。日后"接着改这一篇"要靠它回到生成会话。
@override final  String? conversationId;
/// 是否已收藏。
///
/// **不来自列表接口**——契约里 `EpicScriptResponse` 没有这个字段，是仓库另外
/// 探一次收藏列表再套上来的（见 `story-history.api.md` 的契约缺口）。
@override@JsonKey() final  bool isFavorited;

/// Create a copy of StoryScript
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryScriptCopyWith<_StoryScript> get copyWith => __$StoryScriptCopyWithImpl<_StoryScript>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryScript&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.content, content) || other.content == content)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,summary,createdAt,theme,content,conversationId,isFavorited);

@override
String toString() {
  return 'StoryScript(id: $id, title: $title, summary: $summary, createdAt: $createdAt, theme: $theme, content: $content, conversationId: $conversationId, isFavorited: $isFavorited)';
}


}

/// @nodoc
abstract mixin class _$StoryScriptCopyWith<$Res> implements $StoryScriptCopyWith<$Res> {
  factory _$StoryScriptCopyWith(_StoryScript value, $Res Function(_StoryScript) _then) = __$StoryScriptCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String summary, DateTime createdAt, String? theme, String? content, String? conversationId, bool isFavorited
});




}
/// @nodoc
class __$StoryScriptCopyWithImpl<$Res>
    implements _$StoryScriptCopyWith<$Res> {
  __$StoryScriptCopyWithImpl(this._self, this._then);

  final _StoryScript _self;
  final $Res Function(_StoryScript) _then;

/// Create a copy of StoryScript
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? createdAt = null,Object? theme = freezed,Object? content = freezed,Object? conversationId = freezed,Object? isFavorited = null,}) {
  return _then(_StoryScript(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,isFavorited: null == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$StoryScriptPage {

 List<StoryScript> get scripts;/// 已经加载到第几页（从 1 开始，0 表示一页都还没有）。
 int get current;/// 后端给的总条数。用来判断"还有没有下一页"，比信 `pages` 字段稳
/// ——`pages` 在某些实现里会因为最后一页不满而算错。
 int get total;
/// Create a copy of StoryScriptPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryScriptPageCopyWith<StoryScriptPage> get copyWith => _$StoryScriptPageCopyWithImpl<StoryScriptPage>(this as StoryScriptPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryScriptPage&&const DeepCollectionEquality().equals(other.scripts, scripts)&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(scripts),current,total);

@override
String toString() {
  return 'StoryScriptPage(scripts: $scripts, current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class $StoryScriptPageCopyWith<$Res>  {
  factory $StoryScriptPageCopyWith(StoryScriptPage value, $Res Function(StoryScriptPage) _then) = _$StoryScriptPageCopyWithImpl;
@useResult
$Res call({
 List<StoryScript> scripts, int current, int total
});




}
/// @nodoc
class _$StoryScriptPageCopyWithImpl<$Res>
    implements $StoryScriptPageCopyWith<$Res> {
  _$StoryScriptPageCopyWithImpl(this._self, this._then);

  final StoryScriptPage _self;
  final $Res Function(StoryScriptPage) _then;

/// Create a copy of StoryScriptPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scripts = null,Object? current = null,Object? total = null,}) {
  return _then(_self.copyWith(
scripts: null == scripts ? _self.scripts : scripts // ignore: cast_nullable_to_non_nullable
as List<StoryScript>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryScriptPage].
extension StoryScriptPagePatterns on StoryScriptPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryScriptPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryScriptPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryScriptPage value)  $default,){
final _that = this;
switch (_that) {
case _StoryScriptPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryScriptPage value)?  $default,){
final _that = this;
switch (_that) {
case _StoryScriptPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StoryScript> scripts,  int current,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryScriptPage() when $default != null:
return $default(_that.scripts,_that.current,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StoryScript> scripts,  int current,  int total)  $default,) {final _that = this;
switch (_that) {
case _StoryScriptPage():
return $default(_that.scripts,_that.current,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StoryScript> scripts,  int current,  int total)?  $default,) {final _that = this;
switch (_that) {
case _StoryScriptPage() when $default != null:
return $default(_that.scripts,_that.current,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _StoryScriptPage extends StoryScriptPage {
  const _StoryScriptPage({final  List<StoryScript> scripts = const <StoryScript>[], this.current = 0, this.total = 0}): _scripts = scripts,super._();
  

 final  List<StoryScript> _scripts;
@override@JsonKey() List<StoryScript> get scripts {
  if (_scripts is EqualUnmodifiableListView) return _scripts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scripts);
}

/// 已经加载到第几页（从 1 开始，0 表示一页都还没有）。
@override@JsonKey() final  int current;
/// 后端给的总条数。用来判断"还有没有下一页"，比信 `pages` 字段稳
/// ——`pages` 在某些实现里会因为最后一页不满而算错。
@override@JsonKey() final  int total;

/// Create a copy of StoryScriptPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryScriptPageCopyWith<_StoryScriptPage> get copyWith => __$StoryScriptPageCopyWithImpl<_StoryScriptPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryScriptPage&&const DeepCollectionEquality().equals(other._scripts, _scripts)&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_scripts),current,total);

@override
String toString() {
  return 'StoryScriptPage(scripts: $scripts, current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$StoryScriptPageCopyWith<$Res> implements $StoryScriptPageCopyWith<$Res> {
  factory _$StoryScriptPageCopyWith(_StoryScriptPage value, $Res Function(_StoryScriptPage) _then) = __$StoryScriptPageCopyWithImpl;
@override @useResult
$Res call({
 List<StoryScript> scripts, int current, int total
});




}
/// @nodoc
class __$StoryScriptPageCopyWithImpl<$Res>
    implements _$StoryScriptPageCopyWith<$Res> {
  __$StoryScriptPageCopyWithImpl(this._self, this._then);

  final _StoryScriptPage _self;
  final $Res Function(_StoryScriptPage) _then;

/// Create a copy of StoryScriptPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scripts = null,Object? current = null,Object? total = null,}) {
  return _then(_StoryScriptPage(
scripts: null == scripts ? _self._scripts : scripts // ignore: cast_nullable_to_non_nullable
as List<StoryScript>,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
