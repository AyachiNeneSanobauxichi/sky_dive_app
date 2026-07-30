/// 内存态 accessToken 持有者（v2）。
///
/// 为什么只放内存：accessToken 生命周期短、敏感度高，v2 约定**不落盘**——
/// 冷启动后为空，靠持久化的 refreshToken 静默换回（见 AuthController.build）。
/// AuthInterceptor 从这里同步读取 token 注入鉴权头；登录/刷新时写入，登出/失效时清空。
class AccessTokenStore {
  String? _token;

  /// 当前内存中的 accessToken；未登录 / 冷启动未恢复时为 null。
  String? get token => _token;

  bool get hasToken => _token != null && _token!.isNotEmpty;

  void set(String token) => _token = token;

  void clear() => _token = null;
}
