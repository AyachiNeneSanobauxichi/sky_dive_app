import "package:happy_os/core/network/index.dart";

/// User 远程数据源：只发原始请求、拿信封解包后的 `data`（Map），**不做领域映射**。
///
/// 端点对齐 `agent/service/user/user.api.md` v2。
class UserRemoteDataSource {
  const UserRemoteDataSource(this._client);

  final DioClient _client;

  /// 当前登录用户的档案。走 `/me` 而不是按 id 取：身份由 `Authorization` 头决定，
  /// 客户端不该存在"换个 id 就能看别人档案"的入口。
  static const String _myProfile = "/user-profile/me";

  Future<Map<String, dynamic>> fetchMyProfile() =>
      _client.get<Map<String, dynamic>>(_myProfile);
}
