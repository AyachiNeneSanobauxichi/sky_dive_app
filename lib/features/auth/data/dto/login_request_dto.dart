import "package:freezed_annotation/freezed_annotation.dart";

part "login_request_dto.freezed.dart";
part "login_request_dto.g.dart";

/// `POST /auth/login` 请求体：手机号 + 短信验证码。
@freezed
abstract class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({
    required String phone,
    required String smsCode,
  }) = _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);
}
