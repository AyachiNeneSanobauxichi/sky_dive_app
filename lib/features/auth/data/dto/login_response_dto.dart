import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/data/dto/user_dto.dart";
import "package:happy_os/features/auth/domain/index.dart";

part "login_response_dto.freezed.dart";
part "login_response_dto.g.dart";

/// `POST /auth/login` 响应体（信封解包后的 data）：令牌 + 用户 + 登录时刻。
///
/// 令牌与 `userInfo` 是必填：三者缺任何一个都无法建立可用会话，与其带着半个会话
/// 进 app 再到处判空，不如在解析这一步就失败。
@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const LoginResponseDto._();

  const factory LoginResponseDto({
    required String accessToken,
    required String refreshToken,

    /// accessToken 有效期（秒）。
    @Default(0) int expiresIn,
    required UserDto userInfo,
    String? loginTime,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  AuthSession toEntity() => AuthSession(
    user: userInfo.toEntity(),
    tokens: AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      // 0 表示后端没给，别伪造一个"立即过期"的有效期出来。
      expiresIn: expiresIn > 0 ? Duration(seconds: expiresIn) : null,
    ),
    loginTime: UserDto.parseServerTime(loginTime),
  );
}
