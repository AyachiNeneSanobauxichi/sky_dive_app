import "package:happy_os/core/network/index.dart";
import "package:happy_os/features/auth/data/dto/index.dart";

/// Auth 远程数据源：只发原始请求、拿信封解包后的 `data`（Map），**不做领域映射**。
///
/// DTO→Entity 映射与「技术异常 → 领域 Failure」的转换都在 [AuthRepository] 完成
/// （skill 05 / 08）。这里保持纯粹：一个方法对应一个端点。
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final DioClient _client;

  static const String _register = "/auth/register";
  static const String _login = "/auth/login";
  static const String _refreshToken = "/auth/refresh-token";
  static const String _logout = "/auth/logout";

  Future<Map<String, dynamic>> register(RegisterRequestDto body) =>
      _client.post<Map<String, dynamic>>(_register, data: body.toJson());

  Future<Map<String, dynamic>> login(LoginRequestDto body) =>
      _client.post<Map<String, dynamic>>(_login, data: body.toJson());

  Future<Map<String, dynamic>> refreshToken(RefreshTokenRequestDto body) =>
      _client.post<Map<String, dynamic>>(_refreshToken, data: body.toJson());

  /// 登出（需鉴权头，由 AuthInterceptor 注入）。响应 `data` 为 null，无需返回值。
  Future<void> logout() async {
    await _client.post<dynamic>(_logout);
  }
}
