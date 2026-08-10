// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationMessageDto {

 String get id;/// 正文 / 澄清卡 JSON / 大纲 JSON，随 [type] 而定。
 String? get content; String? get type; String? get sender;/// 会话内序号，回放按它升序。
@JsonKey(fromJson: _orderFromJson) int get messageOrder; String? get createTime;
/// Create a copy of ConversationMessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMessageDtoCopyWith<ConversationMessageDto> get copyWith => _$ConversationMessageDtoCopyWithImpl<ConversationMessageDto>(this as ConversationMessageDto, _$identity);

  /// Serializes this ConversationMessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.messageOrder, messageOrder) || other.messageOrder == messageOrder)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,type,sender,messageOrder,createTime);

@override
String toString() {
  return 'ConversationMessageDto(id: $id, content: $content, type: $type, sender: $sender, messageOrder: $messageOrder, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $ConversationMessageDtoCopyWith<$Res>  {
  factory $ConversationMessageDtoCopyWith(ConversationMessageDto value, $Res Function(ConversationMessageDto) _then) = _$ConversationMessageDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? content, String? type, String? sender,@JsonKey(fromJson: _orderFromJson) int messageOrder, String? createTime
});




}
/// @nodoc
class _$ConversationMessageDtoCopyWithImpl<$Res>
    implements $ConversationMessageDtoCopyWith<$Res> {
  _$ConversationMessageDtoCopyWithImpl(this._self, this._then);

  final ConversationMessageDto _self;
  final $Res Function(ConversationMessageDto) _then;

/// Create a copy of ConversationMessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = freezed,Object? type = freezed,Object? sender = freezed,Object? messageOrder = null,Object? createTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,messageOrder: null == messageOrder ? _self.messageOrder : messageOrder // ignore: cast_nullable_to_non_nullable
as int,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationMessageDto].
extension ConversationMessageDtoPatterns on ConversationMessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMessageDto value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? content,  String? type,  String? sender, @JsonKey(fromJson: _orderFromJson)  int messageOrder,  String? createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationMessageDto() when $default != null:
return $default(_that.id,_that.content,_that.type,_that.sender,_that.messageOrder,_that.createTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? content,  String? type,  String? sender, @JsonKey(fromJson: _orderFromJson)  int messageOrder,  String? createTime)  $default,) {final _that = this;
switch (_that) {
case _ConversationMessageDto():
return $default(_that.id,_that.content,_that.type,_that.sender,_that.messageOrder,_that.createTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? content,  String? type,  String? sender, @JsonKey(fromJson: _orderFromJson)  int messageOrder,  String? createTime)?  $default,) {final _that = this;
switch (_that) {
case _ConversationMessageDto() when $default != null:
return $default(_that.id,_that.content,_that.type,_that.sender,_that.messageOrder,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationMessageDto extends ConversationMessageDto {
  const _ConversationMessageDto({this.id = "", this.content, this.type, this.sender, @JsonKey(fromJson: _orderFromJson) this.messageOrder = 0, this.createTime}): super._();
  factory _ConversationMessageDto.fromJson(Map<String, dynamic> json) => _$ConversationMessageDtoFromJson(json);

@override@JsonKey() final  String id;
/// 正文 / 澄清卡 JSON / 大纲 JSON，随 [type] 而定。
@override final  String? content;
@override final  String? type;
@override final  String? sender;
/// 会话内序号，回放按它升序。
@override@JsonKey(fromJson: _orderFromJson) final  int messageOrder;
@override final  String? createTime;

/// Create a copy of ConversationMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMessageDtoCopyWith<_ConversationMessageDto> get copyWith => __$ConversationMessageDtoCopyWithImpl<_ConversationMessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationMessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.messageOrder, messageOrder) || other.messageOrder == messageOrder)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,type,sender,messageOrder,createTime);

@override
String toString() {
  return 'ConversationMessageDto(id: $id, content: $content, type: $type, sender: $sender, messageOrder: $messageOrder, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$ConversationMessageDtoCopyWith<$Res> implements $ConversationMessageDtoCopyWith<$Res> {
  factory _$ConversationMessageDtoCopyWith(_ConversationMessageDto value, $Res Function(_ConversationMessageDto) _then) = __$ConversationMessageDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? content, String? type, String? sender,@JsonKey(fromJson: _orderFromJson) int messageOrder, String? createTime
});




}
/// @nodoc
class __$ConversationMessageDtoCopyWithImpl<$Res>
    implements _$ConversationMessageDtoCopyWith<$Res> {
  __$ConversationMessageDtoCopyWithImpl(this._self, this._then);

  final _ConversationMessageDto _self;
  final $Res Function(_ConversationMessageDto) _then;

/// Create a copy of ConversationMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = freezed,Object? type = freezed,Object? sender = freezed,Object? messageOrder = null,Object? createTime = freezed,}) {
  return _then(_ConversationMessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String?,messageOrder: null == messageOrder ? _self.messageOrder : messageOrder // ignore: cast_nullable_to_non_nullable
as int,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
