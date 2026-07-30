import "package:freezed_annotation/freezed_annotation.dart";

part "refresh_token_response_dto.freezed.dart";
part "refresh_token_response_dto.g.dart";

/// `POST /auth/refresh-token` 响应体（信封解包后的 data）：仅新的 accessToken。
@freezed
abstract class RefreshTokenResponseDto with _$RefreshTokenResponseDto {
  const factory RefreshTokenResponseDto({required String accessToken}) =
      _RefreshTokenResponseDto;

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseDtoFromJson(json);
}
