// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_window_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherWindowDto _$WeatherWindowDtoFromJson(Map<String, dynamic> json) =>
    _WeatherWindowDto(
      dropZone: json['dropZone'] as String,
      status: json['status'] as String,
      temperatureC: (json['temperatureC'] as num).toInt(),
      windSpeedMps: (json['windSpeedMps'] as num).toDouble(),
      observedAt: json['observedAt'] as String?,
    );

Map<String, dynamic> _$WeatherWindowDtoToJson(_WeatherWindowDto instance) =>
    <String, dynamic>{
      'dropZone': instance.dropZone,
      'status': instance.status,
      'temperatureC': instance.temperatureC,
      'windSpeedMps': instance.windSpeedMps,
      'observedAt': instance.observedAt,
    };
