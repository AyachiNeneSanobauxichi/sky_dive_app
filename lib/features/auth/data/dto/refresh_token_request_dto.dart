import "package:freezed_annotation/freezed_annotation.dart";

part "refresh_token_request_dto.freezed.dart";
part "refresh_token_request_dto.g.dart";

/// `POST /auth/refresh-token` 请求体。
/// app 端直接在 body 里传 refreshToken（不走 cookie）。
///
// TODO(auth): auth.api.md v1 只定义了 sms-code 与 login，**刷新接口的契约仍未确认**
//   （路径 / 字段名 / 是否重发 refreshToken）。冷启动静默刷新依赖它，需后端确认后校对。
@freezed
abstract class RefreshTokenRequestDto with _$RefreshTokenRequestDto {
  const factory RefreshTokenRequestDto({required String refreshToken}) =
      _RefreshTokenRequestDto;

  factory RefreshTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestDtoFromJson(json);
}
