import "package:freezed_annotation/freezed_annotation.dart";

part "register_request_dto.freezed.dart";
part "register_request_dto.g.dart";

/// `POST /auth/register` 请求体。
@freezed
abstract class RegisterRequestDto with _$RegisterRequestDto {
  const factory RegisterRequestDto({
    required String username,
    required String email,
    required String password,
  }) = _RegisterRequestDto;

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);
}
