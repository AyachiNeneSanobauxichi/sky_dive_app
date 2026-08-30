import "package:sky_dive/features/auth/data/dto/index.dart";

/// Auth 数据源契约。
///
/// 抽出这一层**只为了 mock**：后端未就绪期间 `AuthMockDataSource` 顶上，
/// 上线后换回 `AuthRemoteDataSource`，Repository 与其上的一切代码不动。
///
/// 返回值统一是**信封解包后的 `data`**（`Map<String, dynamic>`），
/// 不做领域映射——DTO→Entity 与「技术异常 → 领域 Failure」都在 Repository 完成。
/// 让 mock 也返回原始 JSON 形状（而不是直接造 Entity）是刻意的：
/// 这样 DTO 的反序列化路径在 mock 期间就被真实跑过一遍，
/// 接真后端时不会突然冒出一堆字段名对不上的问题。
abstract interface class AuthDataSource {
  /// 发送登录 / 注册用短信验证码。
  Future<Map<String, dynamic>> sendSmsCode(SendSmsCodeRequestDto params);

  /// 邮箱 + 密码登录。
  Future<Map<String, dynamic>> loginWithEmail(EmailLoginRequestDto body);

  /// 手机号 + 验证码登录（未注册手机号由服务端直接建号）。
  Future<Map<String, dynamic>> loginWithSms(SmsLoginRequestDto body);

  /// 邮箱注册。
  Future<Map<String, dynamic>> register(RegisterRequestDto body);

  /// 用 refreshToken 换新的 accessToken。
  Future<Map<String, dynamic>> refreshToken(RefreshTokenRequestDto body);

  /// 吊销当前会话。
  Future<void> logout();
}
