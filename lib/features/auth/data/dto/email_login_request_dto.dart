import "package:freezed_annotation/freezed_annotation.dart";

part "email_login_request_dto.freezed.dart";
part "email_login_request_dto.g.dart";

/// `POST /auth/login/email` 请求体：邮箱 + 密码。
@freezed
abstract class EmailLoginRequestDto with _$EmailLoginRequestDto {
  const factory EmailLoginRequestDto({
    required String email,
    required String password,
  }) = _EmailLoginRequestDto;

  factory EmailLoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$EmailLoginRequestDtoFromJson(json);
}
