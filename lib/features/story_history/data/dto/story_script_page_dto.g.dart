// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_script_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryScriptPageDto _$StoryScriptPageDtoFromJson(Map<String, dynamic> json) =>
    _StoryScriptPageDto(
      records:
          (json['records'] as List<dynamic>?)
              ?.map((e) => StoryScriptDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StoryScriptDto>[],
      current: (json['current'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StoryScriptPageDtoToJson(_StoryScriptPageDto instance) =>
    <String, dynamic>{
      'records': instance.records,
      'current': instance.current,
      'size': instance.size,
      'total': instance.total,
      'pages': instance.pages,
    };
