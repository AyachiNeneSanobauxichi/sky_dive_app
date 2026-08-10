// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationMessageDto _$ConversationMessageDtoFromJson(
  Map<String, dynamic> json,
) => _ConversationMessageDto(
  id: json['id'] as String? ?? "",
  content: json['content'] as String?,
  type: json['type'] as String?,
  sender: json['sender'] as String?,
  messageOrder: json['messageOrder'] == null
      ? 0
      : _orderFromJson(json['messageOrder']),
  createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$ConversationMessageDtoToJson(
  _ConversationMessageDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'type': instance.type,
  'sender': instance.sender,
  'messageOrder': instance.messageOrder,
  'createTime': instance.createTime,
};
