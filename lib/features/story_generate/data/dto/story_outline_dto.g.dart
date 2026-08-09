// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_outline_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryOutlineDto _$StoryOutlineDtoFromJson(Map<String, dynamic> json) =>
    _StoryOutlineDto(
      title: json['title'] as String?,
      logline: json['logline'] as String?,
      beats:
          (json['beats'] as List<dynamic>?)
              ?.map((e) => OutlineBeatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OutlineBeatDto>[],
      ending: json['ending'] as String?,
    );

Map<String, dynamic> _$StoryOutlineDtoToJson(_StoryOutlineDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'logline': instance.logline,
      'beats': instance.beats,
      'ending': instance.ending,
    };

_OutlineBeatDto _$OutlineBeatDtoFromJson(Map<String, dynamic> json) =>
    _OutlineBeatDto(
      order: (json['order'] as num?)?.toInt(),
      title: json['title'] as String?,
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$OutlineBeatDtoToJson(_OutlineBeatDto instance) =>
    <String, dynamic>{
      'order': instance.order,
      'title': instance.title,
      'summary': instance.summary,
    };
