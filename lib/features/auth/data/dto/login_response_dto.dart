import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/data/dto/user_dto.dart";
import "package:happy_os/features/auth/domain/index.dart";

part "login_response_dto.freezed.dart";
part "login_response_dto.g.dart";

/// `POST /auth/login` 响应体（信封解包后的 data）：令牌 + 用户。
@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const LoginResponseDto._();

  const factory LoginResponseDto({
    required String accessToken,
    required String refreshToken,
    required UserDto user,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  AuthSession toEntity() => AuthSession(
    user: user.toEntity(),
    tokens: AuthTokens(accessToken: accessToken, refreshToken: refreshToken),
  );
}
