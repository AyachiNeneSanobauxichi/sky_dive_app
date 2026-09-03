// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_participant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoadParticipantDto _$LoadParticipantDtoFromJson(Map<String, dynamic> json) =>
    _LoadParticipantDto(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      detail: json['detail'] as String?,
    );

Map<String, dynamic> _$LoadParticipantDtoToJson(_LoadParticipantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'detail': instance.detail,
    };
