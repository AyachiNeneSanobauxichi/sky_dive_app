import "package:freezed_annotation/freezed_annotation.dart";

part "login_request_dto.freezed.dart";
part "login_request_dto.g.dart";

/// `POST /auth/login` 请求体。[identifier] 可为用户名或邮箱。
@freezed
abstract class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({
    required String identifier,
    required String password,
  }) = _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);
}
