// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenerationEventDto _$GenerationEventDtoFromJson(Map<String, dynamic> json) =>
    _GenerationEventDto(
      type: json['type'] as String? ?? "",
      sessionId: json['session_id'] as String?,
      payload:
          json['payload'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$GenerationEventDtoToJson(_GenerationEventDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'session_id': instance.sessionId,
      'payload': instance.payload,
    };
