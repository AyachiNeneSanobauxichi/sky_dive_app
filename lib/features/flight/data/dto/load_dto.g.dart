// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoadDto _$LoadDtoFromJson(Map<String, dynamic> json) => _LoadDto(
  id: json['id'] as String,
  code: json['code'] as String,
  dropZone: DropZoneDto.fromJson(json['dropZone'] as Map<String, dynamic>),
  departureAt: json['departureAt'] as String,
  aircraft: json['aircraft'] as String,
  altitudeFt: (json['altitudeFt'] as num).toInt(),
  customerCapacity: (json['customerCapacity'] as num).toInt(),
  photographerCapacity: (json['photographerCapacity'] as num).toInt(),
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => LoadParticipantDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LoadParticipantDto>[],
);

Map<String, dynamic> _$LoadDtoToJson(_LoadDto instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'dropZone': instance.dropZone,
  'departureAt': instance.departureAt,
  'aircraft': instance.aircraft,
  'altitudeFt': instance.altitudeFt,
  'customerCapacity': instance.customerCapacity,
  'photographerCapacity': instance.photographerCapacity,
  'participants': instance.participants,
};
