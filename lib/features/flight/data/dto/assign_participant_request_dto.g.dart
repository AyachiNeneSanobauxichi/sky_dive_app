// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_participant_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssignParticipantRequestDto _$AssignParticipantRequestDtoFromJson(
  Map<String, dynamic> json,
) => _AssignParticipantRequestDto(
  participantId: json['participantId'] as String,
  role: json['role'] as String,
  name: json['name'] as String?,
  detail: json['detail'] as String?,
);

Map<String, dynamic> _$AssignParticipantRequestDtoToJson(
  _AssignParticipantRequestDto instance,
) => <String, dynamic>{
  'participantId': instance.participantId,
  'role': instance.role,
  'name': instance.name,
  'detail': instance.detail,
};
