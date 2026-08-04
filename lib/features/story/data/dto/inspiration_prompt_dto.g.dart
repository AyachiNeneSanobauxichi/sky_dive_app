// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspiration_prompt_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspirationPromptDto _$InspirationPromptDtoFromJson(
  Map<String, dynamic> json,
) => _InspirationPromptDto(
  text: json['text'] as String? ?? "",
  tag: json['tag'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$InspirationPromptDtoToJson(
  _InspirationPromptDto instance,
) => <String, dynamic>{
  'text': instance.text,
  'tag': instance.tag,
  'category': instance.category,
};
