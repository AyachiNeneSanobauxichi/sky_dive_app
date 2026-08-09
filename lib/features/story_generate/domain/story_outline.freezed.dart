// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_outline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryOutline {

 String? get title;/// 一句话梗概。
 String? get logline;/// 分幕节拍。
 List<OutlineBeat> get beats; String? get ending;
/// Create a copy of StoryOutline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryOutlineCopyWith<StoryOutline> get copyWith => _$StoryOutlineCopyWithImpl<StoryOutline>(this as StoryOutline, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryOutline&&(identical(other.title, title) || other.title == title)&&(identical(other.logline, logline) || other.logline == logline)&&const DeepCollectionEquality().equals(other.beats, beats)&&(identical(other.ending, ending) || other.ending == ending));
}


@override
int get hashCode => Object.hash(runtimeType,title,logline,const DeepCollectionEquality().hash(beats),ending);

@override
String toString() {
  return 'StoryOutline(title: $title, logline: $logline, beats: $beats, ending: $ending)';
}


}

/// @nodoc
abstract mixin class $StoryOutlineCopyWith<$Res>  {
  factory $StoryOutlineCopyWith(StoryOutline value, $Res Function(StoryOutline) _then) = _$StoryOutlineCopyWithImpl;
@useResult
$Res call({
 String? title, String? logline, List<OutlineBeat> beats, String? ending
});




}
/// @nodoc
class _$StoryOutlineCopyWithImpl<$Res>
    implements $StoryOutlineCopyWith<$Res> {
  _$StoryOutlineCopyWithImpl(this._self, this._then);

  final StoryOutline _self;
  final $Res Function(StoryOutline) _then;

/// Create a copy of StoryOutline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? logline = freezed,Object? beats = null,Object? ending = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,logline: freezed == logline ? _self.logline : logline // ignore: cast_nullable_to_non_nullable
as String?,beats: null == beats ? _self.beats : beats // ignore: cast_nullable_to_non_nullable
as List<OutlineBeat>,ending: freezed == ending ? _self.ending : ending // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryOutline].
extension StoryOutlinePatterns on StoryOutline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryOutline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryOutline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryOutline value)  $default,){
final _that = this;
switch (_that) {
case _StoryOutline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryOutline value)?  $default,){
final _that = this;
switch (_that) {
case _StoryOutline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? logline,  List<OutlineBeat> beats,  String? ending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryOutline() when $default != null:
return $default(_that.title,_that.logline,_that.beats,_that.ending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? logline,  List<OutlineBeat> beats,  String? ending)  $default,) {final _that = this;
switch (_that) {
case _StoryOutline():
return $default(_that.title,_that.logline,_that.beats,_that.ending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? logline,  List<OutlineBeat> beats,  String? ending)?  $default,) {final _that = this;
switch (_that) {
case _StoryOutline() when $default != null:
return $default(_that.title,_that.logline,_that.beats,_that.ending);case _:
  return null;

}
}

}

/// @nodoc


class _StoryOutline extends StoryOutline {
  const _StoryOutline({this.title, this.logline, final  List<OutlineBeat> beats = const <OutlineBeat>[], this.ending}): _beats = beats,super._();
  

@override final  String? title;
/// 一句话梗概。
@override final  String? logline;
/// 分幕节拍。
 final  List<OutlineBeat> _beats;
/// 分幕节拍。
@override@JsonKey() List<OutlineBeat> get beats {
  if (_beats is EqualUnmodifiableListView) return _beats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_beats);
}

@override final  String? ending;

/// Create a copy of StoryOutline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryOutlineCopyWith<_StoryOutline> get copyWith => __$StoryOutlineCopyWithImpl<_StoryOutline>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryOutline&&(identical(other.title, title) || other.title == title)&&(identical(other.logline, logline) || other.logline == logline)&&const DeepCollectionEquality().equals(other._beats, _beats)&&(identical(other.ending, ending) || other.ending == ending));
}


@override
int get hashCode => Object.hash(runtimeType,title,logline,const DeepCollectionEquality().hash(_beats),ending);

@override
String toString() {
  return 'StoryOutline(title: $title, logline: $logline, beats: $beats, ending: $ending)';
}


}

/// @nodoc
abstract mixin class _$StoryOutlineCopyWith<$Res> implements $StoryOutlineCopyWith<$Res> {
  factory _$StoryOutlineCopyWith(_StoryOutline value, $Res Function(_StoryOutline) _then) = __$StoryOutlineCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? logline, List<OutlineBeat> beats, String? ending
});




}
/// @nodoc
class __$StoryOutlineCopyWithImpl<$Res>
    implements _$StoryOutlineCopyWith<$Res> {
  __$StoryOutlineCopyWithImpl(this._self, this._then);

  final _StoryOutline _self;
  final $Res Function(_StoryOutline) _then;

/// Create a copy of StoryOutline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? logline = freezed,Object? beats = null,Object? ending = freezed,}) {
  return _then(_StoryOutline(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,logline: freezed == logline ? _self.logline : logline // ignore: cast_nullable_to_non_nullable
as String?,beats: null == beats ? _self._beats : beats // ignore: cast_nullable_to_non_nullable
as List<OutlineBeat>,ending: freezed == ending ? _self.ending : ending // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$OutlineBeat {

/// 序号。上游可能不给，UI 用下标兜底。
 int? get order; String? get title; String? get summary;
/// Create a copy of OutlineBeat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutlineBeatCopyWith<OutlineBeat> get copyWith => _$OutlineBeatCopyWithImpl<OutlineBeat>(this as OutlineBeat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutlineBeat&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,order,title,summary);

@override
String toString() {
  return 'OutlineBeat(order: $order, title: $title, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $OutlineBeatCopyWith<$Res>  {
  factory $OutlineBeatCopyWith(OutlineBeat value, $Res Function(OutlineBeat) _then) = _$OutlineBeatCopyWithImpl;
@useResult
$Res call({
 int? order, String? title, String? summary
});




}
/// @nodoc
class _$OutlineBeatCopyWithImpl<$Res>
    implements $OutlineBeatCopyWith<$Res> {
  _$OutlineBeatCopyWithImpl(this._self, this._then);

  final OutlineBeat _self;
  final $Res Function(OutlineBeat) _then;

/// Create a copy of OutlineBeat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = freezed,Object? title = freezed,Object? summary = freezed,}) {
  return _then(_self.copyWith(
order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OutlineBeat].
extension OutlineBeatPatterns on OutlineBeat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutlineBeat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutlineBeat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutlineBeat value)  $default,){
final _that = this;
switch (_that) {
case _OutlineBeat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutlineBeat value)?  $default,){
final _that = this;
switch (_that) {
case _OutlineBeat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? order,  String? title,  String? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutlineBeat() when $default != null:
return $default(_that.order,_that.title,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? order,  String? title,  String? summary)  $default,) {final _that = this;
switch (_that) {
case _OutlineBeat():
return $default(_that.order,_that.title,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? order,  String? title,  String? summary)?  $default,) {final _that = this;
switch (_that) {
case _OutlineBeat() when $default != null:
return $default(_that.order,_that.title,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _OutlineBeat implements OutlineBeat {
  const _OutlineBeat({this.order, this.title, this.summary});
  

/// 序号。上游可能不给，UI 用下标兜底。
@override final  int? order;
@override final  String? title;
@override final  String? summary;

/// Create a copy of OutlineBeat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutlineBeatCopyWith<_OutlineBeat> get copyWith => __$OutlineBeatCopyWithImpl<_OutlineBeat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutlineBeat&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,order,title,summary);

@override
String toString() {
  return 'OutlineBeat(order: $order, title: $title, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$OutlineBeatCopyWith<$Res> implements $OutlineBeatCopyWith<$Res> {
  factory _$OutlineBeatCopyWith(_OutlineBeat value, $Res Function(_OutlineBeat) _then) = __$OutlineBeatCopyWithImpl;
@override @useResult
$Res call({
 int? order, String? title, String? summary
});




}
/// @nodoc
class __$OutlineBeatCopyWithImpl<$Res>
    implements _$OutlineBeatCopyWith<$Res> {
  __$OutlineBeatCopyWithImpl(this._self, this._then);

  final _OutlineBeat _self;
  final $Res Function(_OutlineBeat) _then;

/// Create a copy of OutlineBeat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = freezed,Object? title = freezed,Object? summary = freezed,}) {
  return _then(_OutlineBeat(
order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
