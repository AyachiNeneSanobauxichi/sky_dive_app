// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_script_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryScriptDto _$StoryScriptDtoFromJson(Map<String, dynamic> json) =>
    _StoryScriptDto(
      id: json['id'] as String,
      title: json['title'] as String?,
      theme: json['theme'] as String?,
      style: json['style'] as String?,
      length: json['length'] as String?,
      plotIntro: json['plotIntro'] as String?,
      plotTurning: json['plotTurning'] as String?,
      plotClimax: json['plotClimax'] as String?,
      plotEnding: json['plotEnding'] as String?,
      conversationId: json['conversationId'] as String?,
      currentVersionMessageId: json['currentVersionMessageId'] as String?,
      plotJson: json['plotJson'] as Map<String, dynamic>?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$StoryScriptDtoToJson(_StoryScriptDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'theme': instance.theme,
      'style': instance.style,
      'length': instance.length,
      'plotIntro': instance.plotIntro,
      'plotTurning': instance.plotTurning,
      'plotClimax': instance.plotClimax,
      'plotEnding': instance.plotEnding,
      'conversationId': instance.conversationId,
      'currentVersionMessageId': instance.currentVersionMessageId,
      'plotJson': instance.plotJson,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };
