import "package:flutter_secure_storage/flutter_secure_storage.dart";

/// 敏感数据安全存储封装（iOS Keychain / Android Keystore 加密）。
///
/// 为什么单独封装：对外只暴露语义化方法，隐藏 key 常量与底层插件，避免 key 拼写漂移；
/// 登出时统一 `clear()` 清空。切勿用 SharedPreferences 明文存敏感数据（skill 10）。
///
/// v2 令牌策略：**accessToken 不落盘**（改由内存态 `AccessTokenStore` 持有），
/// 这里只持久化 [readRefreshToken] 用的刷新令牌（启动静默刷新用）与用户快照
/// （非敏感，用于刷新成功后恢复展示态——refresh 接口只回 accessToken，不回用户）。
class SecureStorage {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  // 存储 key 常量集中在此，业务不直接接触。
  static const String _kRefreshToken = "refresh_token";
  static const String _kUser = "auth_user";

  /// 读取刷新令牌；无持久会话时返回 null。
  Future<String?> readRefreshToken() => _storage.read(key: _kRefreshToken);

  /// 写入刷新令牌（登录成功后调用）。
  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _kRefreshToken, value: token);

  /// 读取持久化的用户快照（JSON 字符串）；无则返回 null。
  Future<String?> readUser() => _storage.read(key: _kUser);

  /// 写入用户快照（JSON 字符串）。
  Future<void> writeUser(String json) =>
      _storage.write(key: _kUser, value: json);

  /// 清空所有敏感项（登出 / 会话失效时调用）。
  Future<void> clear() => _storage.deleteAll();
}
