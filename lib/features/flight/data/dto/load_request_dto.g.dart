// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoadRequestDto _$LoadRequestDtoFromJson(Map<String, dynamic> json) =>
    _LoadRequestDto(
      code: json['code'] as String,
      dropZoneId: json['dropZoneId'] as String,
      departureAt: json['departureAt'] as String,
      aircraft: json['aircraft'] as String,
      altitudeFt: (json['altitudeFt'] as num).toInt(),
      customerCapacity: (json['customerCapacity'] as num).toInt(),
      photographerCapacity: (json['photographerCapacity'] as num).toInt(),
    );

Map<String, dynamic> _$LoadRequestDtoToJson(_LoadRequestDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'dropZoneId': instance.dropZoneId,
      'departureAt': instance.departureAt,
      'aircraft': instance.aircraft,
      'altitudeFt': instance.altitudeFt,
      'customerCapacity': instance.customerCapacity,
      'photographerCapacity': instance.photographerCapacity,
    };
