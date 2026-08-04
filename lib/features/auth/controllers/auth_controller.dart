import "dart:async";
import "dart:convert";

import "package:happy_os/core/network/index.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/core/storage/index.dart";
import "package:happy_os/features/auth/data/index.dart";
import "package:happy_os/features/auth/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_controller.g.dart";

/// Auth 仓库 DI：组装 DataSource（依赖全局 DioClient）。
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(AuthRemoteDataSource(ref.watch(dioClientProvider)));

/// 全局登录态控制器（v2）。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由页面
/// 各自的本地标记承载；登录失败以异常上抛，页面本地捕获提示。
///
/// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
/// 造成登录态抖动甚至误登出。
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
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

  /// 手机号验证码登录（v3）：一步完成「校验 + 落地会话」。
  ///
  /// 失败抛出 [Failure]（由页面本地捕获提示），不污染全局 [state]——否则登录失败
  /// 会把路由打回 splash，用户已填的手机号和验证码全丢。
  Future<void> login({required String phone, required String code}) async =>
      completeSession(await authenticate(phone: phone, code: code));

  /// 只校验手机号 + 验证码，拿到会话但**不改登录态**。
  ///
  /// 拆出这一步是为了给页面留出"成功确认"的时间：登录态一翻转，路由守卫立刻换页，
  /// 用户刚填完最后一位就被"啪"地弹走，没有任何成果确认。页面拿到会话后可以先播
  /// 一段确认动效，再调 [completeSession]。
  Future<AuthSession> authenticate({
    required String phone,
    required String code,
  }) => _repo.login(phone: phone, code: code);

  /// 落地会话：accessToken 写内存、refreshToken + 用户快照落盘，置为已登录态。
  ///
  /// **这一步会触发路由重定向**，所以调用方要在确认动效播完后再调；也**不要**因为
  /// 页面已经卸载就跳过它——会话丢了用户得重新登录一次。
  Future<void> completeSession(AuthSession session) async {
    _tokenStore.set(session.tokens.accessToken);
    final refreshToken = session.tokens.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.writeRefreshToken(refreshToken);
    }
    await _storage.writeUser(_encodeUser(session.user));
    state = AsyncData(AuthState.authenticated(session.user));
  }

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

  /// 会话失效（拦截器广播）：翻转为未登录并补清本地会话。
  ///
  /// 先翻转态再清理：翻转即触发路由重定向，用户立刻离开需要登录的页面；
  /// 清理即使失败也不该把人留在里面。
  ///
  /// 为什么自己也清一遍：HTTP 401 那条路径由 `AuthInterceptor` 清过，但**信封形态的
  /// 401**（HTTP 200 + `code: 401`）是 `ResponseInterceptor` 广播的，它手上没有
  /// token/storage。清理是幂等的，重复清一次远好过内存里留着死 token 继续发请求。
  Future<void> _onSessionExpired() async {
    if (state case AsyncData(value: Unauthenticated())) return;
    state = const AsyncData(AuthState.unauthenticated());
    try {
      await _clearSession();
    } on Object {
      // 安全存储抹除失败不影响"已登出"这个结论，下次登录会覆盖写入。
    }
  }

  Future<void> _clearSession() async {
    _tokenStore.clear();
    await _storage.clear();
  }

  /// 用户快照持久化：User 是纯领域实体（无 JSON 耦合），这里手动序列化。
  ///
  /// 冷启动只有这份快照能还原「已登录」界面（accessToken 只在内存，重启后拿不回
  /// 登录响应里的 userInfo），所以实体加字段时这里必须同步补——漏存 memberLevel，
  /// 重启后会员就被当成免费用户。
  String _encodeUser(User user) => jsonEncode({
    "id": user.id,
    "phone": user.phone,
    "account": user.account,
    "username": user.username,
    "nickname": user.nickname,
    "status": user.status,
    "memberLevel": user.memberLevel,
    "totalDays": user.totalDays,
    "lastActiveTime": user.lastActiveTime?.toIso8601String(),
    "createTime": user.createTime?.toIso8601String(),
  });

  Future<User?> _readPersistedUser() async {
    final raw = await _storage.readUser();
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final id = map["id"] as String?;
      final phone = map["phone"] as String?;
      // id + 手机号是身份锚点，缺了就当快照失效——旧版本只存 phone/nickname 的快照
      // 正好在这里被判废，用户重新登录一次即可拿到完整 userInfo，不会带着半个实体跑。
      if (id == null || phone == null) return null;
      return User(
        id: id,
        phone: phone,
        account: map["account"] as String?,
        username: map["username"] as String?,
        nickname: map["nickname"] as String?,
        status: (map["status"] as num?)?.toInt(),
        memberLevel: map["memberLevel"] as String?,
        totalDays: (map["totalDays"] as num?)?.toInt() ?? 0,
        lastActiveTime: DateTime.tryParse(
          map["lastActiveTime"] as String? ?? "",
        ),
        createTime: DateTime.tryParse(map["createTime"] as String? ?? ""),
      );
    } on Object {
      return null;
    }
  }
}
