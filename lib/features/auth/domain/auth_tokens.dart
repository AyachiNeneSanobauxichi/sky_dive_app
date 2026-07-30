import "package:freezed_annotation/freezed_annotation.dart";

part "auth_tokens.freezed.dart";

/// 鉴权令牌对。登录返回 access + refresh；刷新接口只回新的 access
/// （不再下发 refresh），故 [refreshToken] 可空。
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    String? refreshToken,
  }) = _AuthTokens;
}
