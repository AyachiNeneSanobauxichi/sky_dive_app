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

  // 应用偏好（非敏感，只是**没必要为两个字符串再引一个存储库**）。
  static const String _kThemeMode = "app_theme_mode";
  static const String _kLocale = "app_locale";

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

  /// 读取深浅色偏好；没选过时返回 null（由调用方回落默认）。
  Future<String?> readThemeMode() => _storage.read(key: _kThemeMode);

  Future<void> writeThemeMode(String value) =>
      _storage.write(key: _kThemeMode, value: value);

  /// 读取界面语言码；返回 null 表示跟随系统。
  Future<String?> readLocale() => _storage.read(key: _kLocale);

  /// 写入界面语言码。传 null＝改回跟随系统，此时**删除**而不是写空串——
  /// "没有这一项"和"这一项是空的"必须是同一种状态，否则读回来还得再判一次空。
  Future<void> writeLocale(String? value) => value == null
      ? _storage.delete(key: _kLocale)
      : _storage.write(key: _kLocale, value: value);

  /// 清空所有敏感项（登出 / 会话失效时调用）。
  ///
  /// ⚠️ 逐项删而不是 `deleteAll()`：主题与语言也存在这里，但它们**不是会话数据**。
  /// 一登出就把用户挑的浅色主题和语言一起抹掉，下次登录界面全变回默认，
  /// 用户只会觉得 app 在抽风。
  Future<void> clear() async {
    await _storage.delete(key: _kRefreshToken);
    await _storage.delete(key: _kUser);
  }
}
