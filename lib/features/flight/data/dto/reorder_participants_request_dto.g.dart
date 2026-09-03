// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_participants_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReorderParticipantsRequestDto _$ReorderParticipantsRequestDtoFromJson(
  Map<String, dynamic> json,
) => _ReorderParticipantsRequestDto(
  participantIds: (json['participantIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  role: json['role'] as String,
);

Map<String, dynamic> _$ReorderParticipantsRequestDtoToJson(
  _ReorderParticipantsRequestDto instance,
) => <String, dynamic>{
  'participantIds': instance.participantIds,
  'role': instance.role,
};
