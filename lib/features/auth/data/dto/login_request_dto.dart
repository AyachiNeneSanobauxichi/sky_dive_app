import "package:freezed_annotation/freezed_annotation.dart";

part "login_request_dto.freezed.dart";
part "login_request_dto.g.dart";

/// 手机号验证码登录请求体。
///
// TODO(auth): 字段名按 mock 假设为 `phone` / `code`，auth.api.md 补齐契约后校对。
@freezed
abstract class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({required String phone, required String code}) =
      _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);
}
