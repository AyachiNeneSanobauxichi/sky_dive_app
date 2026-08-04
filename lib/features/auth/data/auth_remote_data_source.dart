import "package:happy_os/core/network/index.dart";
import "package:happy_os/features/auth/data/dto/index.dart";

/// Auth 远程数据源：只发原始请求、拿信封解包后的 `data`（Map），**不做领域映射**。
///
/// DTO→Entity 映射与「技术异常 → 领域 Failure」的转换都在 `AuthRepository` 完成
/// （skill 05 / 08）。这里保持纯粹：一个方法对应一个端点。
///
/// 端点对齐 `agent/service/auth/auth.api.md` v1。
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final DioClient _client;

  static const String _sendSmsCode = "/auth/sms-code";
  static const String _login = "/auth/login";

  // TODO(auth): 下面两个端点 auth.api.md v1 未定义，路径按常见命名假设；
  //   后端确认后校对（刷新路径还与 core 的 AuthInterceptor 硬编码值联动）。
  static const String _refreshToken = "/auth/refresh-token";
  static const String _logout = "/auth/logout";

  /// 发送验证码（v1 是 **GET + query**，不是 POST body）。
  Future<Map<String, dynamic>> sendSmsCode(SendSmsCodeRequestDto params) =>
      _client.get<Map<String, dynamic>>(_sendSmsCode, query: params.toJson());

  Future<Map<String, dynamic>> login(LoginRequestDto body) =>
      _client.post<Map<String, dynamic>>(_login, data: body.toJson());

  Future<Map<String, dynamic>> refreshToken(RefreshTokenRequestDto body) =>
      _client.post<Map<String, dynamic>>(_refreshToken, data: body.toJson());

  /// 登出（需鉴权头，由 AuthInterceptor 注入）。响应 `data` 为 null，无需返回值。
  Future<void> logout() async {
    await _client.post<dynamic>(_logout);
  }
}
