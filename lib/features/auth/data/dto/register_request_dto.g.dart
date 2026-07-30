// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterRequestDto _$RegisterRequestDtoFromJson(Map<String, dynamic> json) =>
    _RegisterRequestDto(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterRequestDtoToJson(_RegisterRequestDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };
