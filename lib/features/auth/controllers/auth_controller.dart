import "dart:async";
import "dart:convert";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/network/index.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/core/storage/index.dart";
import "package:happy_os/features/auth/data/index.dart";
import "package:happy_os/features/auth/domain/index.dart";

/// Auth 仓库 DI：组装 DataSource（依赖全局 DioClient）。
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(AuthRemoteDataSource(ref.watch(dioClientProvider))),
);

/// 全局登录态控制器（v2）。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由页面
/// 各自的本地标记承载；登录失败以异常上抛，页面本地捕获提示。
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  SecureStorage get _storage => ref.read(secureStorageProvider);
  AccessTokenStore get _tokenStore => ref.read(accessTokenStoreProvider);

  @override
  Future<AuthState> build() async {
    // 订阅拦截器广播的「会话失效」事件（refresh 失败），翻转为未登录。
    final sub = ref
        .watch(authEventsProvider)
        .onUnauthorized
        .listen((_) => _onSessionExpired());
    ref.onDispose(sub.cancel);

    // 启动静默刷新：有持久化 refreshToken 就换回 accessToken 恢复登录态；
    // 无 refreshToken 或刷新失败则清会话、置未登录（红线：accessToken 只在内存）。
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return const AuthState.unauthenticated();
    }
    try {
      final newAccessToken = await _repo.refreshToken(refreshToken);
      _tokenStore.set(newAccessToken);
      final user = await _readPersistedUser();
      if (user == null) {
        // 有令牌但无用户快照，无法恢复展示态：清理并要求重新登录。
        await _clearSession();
        return const AuthState.unauthenticated();
      }
      return AuthState.authenticated(user);
    } on Object {
      await _clearSession();
      return const AuthState.unauthenticated();
    }
  }

  /// 登录：accessToken 写内存、refreshToken + 用户快照落盘，置为已登录态。
  /// 失败抛出 [Failure]（由页面本地捕获提示），不污染全局 [state]。
  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final session = await _repo.login(
      identifier: identifier,
      password: password,
    );
    _tokenStore.set(session.tokens.accessToken);
    final refreshToken = session.tokens.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.writeRefreshToken(refreshToken);
    }
    await _storage.writeUser(_encodeUser(session.user));
    state = AsyncData(AuthState.authenticated(session.user));
  }

  /// 注册：**不改变登录态**（后端不下发令牌），成功返回用户，由页面导航到登录页。
  /// 失败抛出 [Failure]，页面自行捕获提示。
  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) => _repo.register(username: username, email: email, password: password);

  /// 登出：先请求后端（尽力而为），无论成败都清空本地会话并置为未登录。
  Future<void> logout() async {
    try {
      await _repo.logout();
    } on Object {
      // 后端登出失败不阻塞本地登出：token 可能已失效，本地清理仍需执行。
    }
    await _clearSession();
    state = const AsyncData(AuthState.unauthenticated());
  }

  /// 会话失效（拦截器 refresh 失败后广播）。拦截器已清 token/storage，这里只翻转态。
  void _onSessionExpired() {
    if (state case AsyncData(value: Unauthenticated())) return;
    state = const AsyncData(AuthState.unauthenticated());
  }

  Future<void> _clearSession() async {
    _tokenStore.clear();
    await _storage.clear();
  }

  /// 用户快照持久化：User 是纯领域实体（无 JSON 耦合），这里手动序列化最小字段。
  String _encodeUser(User user) =>
      jsonEncode({"username": user.username, "email": user.email});

  Future<User?> _readPersistedUser() async {
    final raw = await _storage.readUser();
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final username = map["username"] as String?;
      final email = map["email"] as String?;
      if (username == null || email == null) return null;
      return User(username: username, email: email);
    } on Object {
      return null;
    }
  }
}
