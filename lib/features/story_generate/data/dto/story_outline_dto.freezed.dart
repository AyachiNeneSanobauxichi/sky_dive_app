// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_outline_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryOutlineDto {

 String? get title; String? get logline; List<OutlineBeatDto> get beats; String? get ending;
/// Create a copy of StoryOutlineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryOutlineDtoCopyWith<StoryOutlineDto> get copyWith => _$StoryOutlineDtoCopyWithImpl<StoryOutlineDto>(this as StoryOutlineDto, _$identity);

  /// Serializes this StoryOutlineDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryOutlineDto&&(identical(other.title, title) || other.title == title)&&(identical(other.logline, logline) || other.logline == logline)&&const DeepCollectionEquality().equals(other.beats, beats)&&(identical(other.ending, ending) || other.ending == ending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,logline,const DeepCollectionEquality().hash(beats),ending);

@override
String toString() {
  return 'StoryOutlineDto(title: $title, logline: $logline, beats: $beats, ending: $ending)';
}


}

/// @nodoc
abstract mixin class $StoryOutlineDtoCopyWith<$Res>  {
  factory $StoryOutlineDtoCopyWith(StoryOutlineDto value, $Res Function(StoryOutlineDto) _then) = _$StoryOutlineDtoCopyWithImpl;
@useResult
$Res call({
 String? title, String? logline, List<OutlineBeatDto> beats, String? ending
});




}
/// @nodoc
class _$StoryOutlineDtoCopyWithImpl<$Res>
    implements $StoryOutlineDtoCopyWith<$Res> {
  _$StoryOutlineDtoCopyWithImpl(this._self, this._then);

  final StoryOutlineDto _self;
  final $Res Function(StoryOutlineDto) _then;

/// Create a copy of StoryOutlineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? logline = freezed,Object? beats = null,Object? ending = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,logline: freezed == logline ? _self.logline : logline // ignore: cast_nullable_to_non_nullable
as String?,beats: null == beats ? _self.beats : beats // ignore: cast_nullable_to_non_nullable
as List<OutlineBeatDto>,ending: freezed == ending ? _self.ending : ending // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryOutlineDto].
extension StoryOutlineDtoPatterns on StoryOutlineDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryOutlineDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryOutlineDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryOutlineDto value)  $default,){
final _that = this;
switch (_that) {
case _StoryOutlineDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryOutlineDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoryOutlineDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? logline,  List<OutlineBeatDto> beats,  String? ending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryOutlineDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? logline,  List<OutlineBeatDto> beats,  String? ending)  $default,) {final _that = this;
switch (_that) {
case _StoryOutlineDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? logline,  List<OutlineBeatDto> beats,  String? ending)?  $default,) {final _that = this;
switch (_that) {
case _StoryOutlineDto() when $default != null:
return $default(_that.title,_that.logline,_that.beats,_that.ending);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoryOutlineDto extends StoryOutlineDto {
  const _StoryOutlineDto({this.title, this.logline, final  List<OutlineBeatDto> beats = const <OutlineBeatDto>[], this.ending}): _beats = beats,super._();
  factory _StoryOutlineDto.fromJson(Map<String, dynamic> json) => _$StoryOutlineDtoFromJson(json);

@override final  String? title;
@override final  String? logline;
 final  List<OutlineBeatDto> _beats;
@override@JsonKey() List<OutlineBeatDto> get beats {
  if (_beats is EqualUnmodifiableListView) return _beats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_beats);
}

@override final  String? ending;

/// Create a copy of StoryOutlineDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryOutlineDtoCopyWith<_StoryOutlineDto> get copyWith => __$StoryOutlineDtoCopyWithImpl<_StoryOutlineDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryOutlineDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryOutlineDto&&(identical(other.title, title) || other.title == title)&&(identical(other.logline, logline) || other.logline == logline)&&const DeepCollectionEquality().equals(other._beats, _beats)&&(identical(other.ending, ending) || other.ending == ending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,logline,const DeepCollectionEquality().hash(_beats),ending);

@override
String toString() {
  return 'StoryOutlineDto(title: $title, logline: $logline, beats: $beats, ending: $ending)';
}


}

/// @nodoc
abstract mixin class _$StoryOutlineDtoCopyWith<$Res> implements $StoryOutlineDtoCopyWith<$Res> {
  factory _$StoryOutlineDtoCopyWith(_StoryOutlineDto value, $Res Function(_StoryOutlineDto) _then) = __$StoryOutlineDtoCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? logline, List<OutlineBeatDto> beats, String? ending
});




}
/// @nodoc
class __$StoryOutlineDtoCopyWithImpl<$Res>
    implements _$StoryOutlineDtoCopyWith<$Res> {
  __$StoryOutlineDtoCopyWithImpl(this._self, this._then);

  final _StoryOutlineDto _self;
  final $Res Function(_StoryOutlineDto) _then;

/// Create a copy of StoryOutlineDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? logline = freezed,Object? beats = null,Object? ending = freezed,}) {
  return _then(_StoryOutlineDto(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,logline: freezed == logline ? _self.logline : logline // ignore: cast_nullable_to_non_nullable
as String?,beats: null == beats ? _self._beats : beats // ignore: cast_nullable_to_non_nullable
as List<OutlineBeatDto>,ending: freezed == ending ? _self.ending : ending // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OutlineBeatDto {

 int? get order; String? get title; String? get summary;
/// Create a copy of OutlineBeatDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutlineBeatDtoCopyWith<OutlineBeatDto> get copyWith => _$OutlineBeatDtoCopyWithImpl<OutlineBeatDto>(this as OutlineBeatDto, _$identity);

  /// Serializes this OutlineBeatDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutlineBeatDto&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,title,summary);

@override
String toString() {
  return 'OutlineBeatDto(order: $order, title: $title, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $OutlineBeatDtoCopyWith<$Res>  {
  factory $OutlineBeatDtoCopyWith(OutlineBeatDto value, $Res Function(OutlineBeatDto) _then) = _$OutlineBeatDtoCopyWithImpl;
@useResult
$Res call({
 int? order, String? title, String? summary
});




}
/// @nodoc
class _$OutlineBeatDtoCopyWithImpl<$Res>
    implements $OutlineBeatDtoCopyWith<$Res> {
  _$OutlineBeatDtoCopyWithImpl(this._self, this._then);

  final OutlineBeatDto _self;
  final $Res Function(OutlineBeatDto) _then;

/// Create a copy of OutlineBeatDto
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


/// Adds pattern-matching-related methods to [OutlineBeatDto].
extension OutlineBeatDtoPatterns on OutlineBeatDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutlineBeatDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutlineBeatDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutlineBeatDto value)  $default,){
final _that = this;
switch (_that) {
case _OutlineBeatDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutlineBeatDto value)?  $default,){
final _that = this;
switch (_that) {
case _OutlineBeatDto() when $default != null:
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
case _OutlineBeatDto() when $default != null:
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
case _OutlineBeatDto():
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
case _OutlineBeatDto() when $default != null:
return $default(_that.order,_that.title,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OutlineBeatDto extends OutlineBeatDto {
  const _OutlineBeatDto({this.order, this.title, this.summary}): super._();
  factory _OutlineBeatDto.fromJson(Map<String, dynamic> json) => _$OutlineBeatDtoFromJson(json);

@override final  int? order;
@override final  String? title;
@override final  String? summary;

/// Create a copy of OutlineBeatDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutlineBeatDtoCopyWith<_OutlineBeatDto> get copyWith => __$OutlineBeatDtoCopyWithImpl<_OutlineBeatDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutlineBeatDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutlineBeatDto&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,title,summary);

@override
String toString() {
  return 'OutlineBeatDto(order: $order, title: $title, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$OutlineBeatDtoCopyWith<$Res> implements $OutlineBeatDtoCopyWith<$Res> {
  factory _$OutlineBeatDtoCopyWith(_OutlineBeatDto value, $Res Function(_OutlineBeatDto) _then) = __$OutlineBeatDtoCopyWithImpl;
@override @useResult
$Res call({
 int? order, String? title, String? summary
});




}
/// @nodoc
class __$OutlineBeatDtoCopyWithImpl<$Res>
    implements _$OutlineBeatDtoCopyWith<$Res> {
  __$OutlineBeatDtoCopyWithImpl(this._self, this._then);

  final _OutlineBeatDto _self;
  final $Res Function(_OutlineBeatDto) _then;

/// Create a copy of OutlineBeatDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = freezed,Object? title = freezed,Object? summary = freezed,}) {
  return _then(_OutlineBeatDto(
order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
