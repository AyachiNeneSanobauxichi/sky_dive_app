import "package:sky_dive/core/network/index.dart";
import "package:sky_dive/features/auth/data/auth_data_source.dart";
import "package:sky_dive/features/auth/data/dto/index.dart";

/// Auth 远程数据源：只发原始请求、拿信封解包后的 `data`，**不做领域映射**。
///
/// 端点对齐 `agent/service/auth/auth.api.md` v1。
///
/// ⚠️ 后端尚未就绪，当前 provider 装配的是 `AuthMockDataSource`（见
/// `controllers/auth_controller.dart` 的 `authDataSource` provider）。
/// 本类保留完整实现，接真后端时只需把那个 provider 换回来。
class AuthRemoteDataSource implements AuthDataSource {
  const AuthRemoteDataSource(this._client);

  final DioClient _client;

  static const String _smsCode = "/auth/sms-code";
  static const String _loginEmail = "/auth/login/email";
  static const String _loginSms = "/auth/login/sms";
  static const String _register = "/auth/register";
  static const String _logout = "/auth/logout";

  // TODO(auth): 刷新端点的路径还与 core 的 AuthInterceptor 里的硬编码值联动，
  //   后端定稿后两处要一起改。
  static const String _refreshToken = "/auth/refresh-token";

  /// 发送验证码（GET + query，不是 POST body）。
  @override
  Future<Map<String, dynamic>> sendSmsCode(SendSmsCodeRequestDto params) =>
      _client.get<Map<String, dynamic>>(_smsCode, query: params.toJson());

  @override
  Future<Map<String, dynamic>> loginWithEmail(EmailLoginRequestDto body) =>
      _client.post<Map<String, dynamic>>(_loginEmail, data: body.toJson());

  @override
  Future<Map<String, dynamic>> loginWithSms(SmsLoginRequestDto body) =>
      _client.post<Map<String, dynamic>>(_loginSms, data: body.toJson());

  @override
  Future<Map<String, dynamic>> register(RegisterRequestDto body) =>
      _client.post<Map<String, dynamic>>(_register, data: body.toJson());

  @override
  Future<Map<String, dynamic>> refreshToken(RefreshTokenRequestDto body) =>
      _client.post<Map<String, dynamic>>(_refreshToken, data: body.toJson());

  /// 登出。需鉴权头——服务端要凭 accessToken 才知道吊销谁的会话，由
  /// AuthInterceptor 在发送时注入。无请求体，响应 `data` 为 null，故不取返回值。
  @override
  Future<void> logout() async {
    await _client.post<dynamic>(_logout);
  }
}
