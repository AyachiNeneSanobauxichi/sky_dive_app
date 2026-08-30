import "dart:async";
import "dart:convert";

import "package:flutter/painting.dart" show PaintingBinding;
import "package:sky_dive/core/network/index.dart";
import "package:sky_dive/core/providers/index.dart";
import "package:sky_dive/core/storage/index.dart";
import "package:sky_dive/features/auth/data/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_controller.g.dart";

/// Auth 数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时把这里换成
/// `AuthRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/` 整个目录。
/// 这是整条认证链路上**唯一**需要改的一行。
@Riverpod(keepAlive: true)
AuthDataSource authDataSource(Ref ref) => AuthMockDataSource();

/// Auth 仓库 DI。
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(authDataSourceProvider));

/// 全局登录态控制器。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/注册/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由
/// 页面各自的本地标记承载；失败以异常上抛，页面本地捕获提示。
///
/// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
/// 造成登录态抖动甚至误登出。
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  /// 等服务端确认登出的上限。这是业务等待而非动效时长，故不取 `SkyMotion`。
  /// 取值短于 DioClient 的 15 秒超时——见 [logout] 的说明。
  static const Duration _serverLogoutTimeout = Duration(seconds: 5);

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

  // ───────────────────────── 校验（不改登录态） ─────────────────────────
  //
  // 「拿到会话」和「落地会话」拆成两步，是为了给页面留出"成功确认"的时间：
  // 登录态一翻转，路由守卫立刻换页——用户刚敲完最后一位就被"啪"地弹走，
  // 没有任何成果确认。页面拿到会话后可以先播一段确认动效，再调 [completeSession]。
  //
  // 失败一律抛 [Failure]（由页面本地捕获提示），**不污染全局 [state]**：
  // 否则登录失败会把路由打回 splash，用户已填的邮箱和密码全丢。

  /// 邮箱 + 密码校验。
  Future<AuthSession> authenticateWithEmail({
    required String email,
    required String password,
  }) => _repo.loginWithEmail(email: email, password: password);

  /// 手机号 + 验证码校验。未注册手机号由服务端直接建号。
  Future<AuthSession> authenticateWithPhone({
    required String phone,
    required String code,
  }) => _repo.loginWithSms(phone: phone, code: code);

  /// 邮箱注册。成功即返回可用会话，无需再登录一次。
  Future<AuthSession> registerAccount({
    required String email,
    required String password,
    required String displayName,
    String? phone,
  }) => _repo.register(
    email: email,
    password: password,
    displayName: displayName,
    phone: phone,
  );

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

  /// 登出：请求后端吊销会话（尽力而为、有等待上限），无论成败都清空本地会话与
  /// 缓存并置为未登录。
  ///
  /// 三个刻意的取舍：
  /// 1. **先请求再清 token**：鉴权头是拦截器在发送那一刻从 [AccessTokenStore] 取的，
  ///    先清就等于把一个匿名请求发过去，服务端那边的会话根本不会被吊销。
  /// 2. **等待有上限**（[_serverLogoutTimeout]，短于 DioClient 的 15 秒）：登出是
  ///    "我现在就要离开"的诉求，服务端不可达时让用户对着没反馈的页面干等 15 秒是最差的
  ///    结果——本地登出必须几秒内生效。超时只是**不再等**，请求并未取消，服务端仍有机会
  ///    把会话吊销掉。
  /// 3. **失败也照清**：token 可能本来就失效了（这也是用户想登出的常见原因），
  ///    服务端成不成功都不该影响"本地不再留着这个账号"。
  Future<void> logout() async {
    // 已经是未登录就别再打一次接口：连点两次退出、或会话刚失效紧接着点退出都会走到这。
    if (state case AsyncData(value: Unauthenticated())) return;

    try {
      await _repo.logout().timeout(_serverLogoutTimeout);
    } on Object {
      // 后端登出失败 / 超时不阻塞本地登出。
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

  /// 清空本地会话与缓存。
  ///
  /// 覆盖三类残留：
  /// 1. 内存态 accessToken；
  /// 2. 安全存储里的 refreshToken 与用户快照（`clear`）；
  /// 3. 图片解码缓存——同一台设备换个账号登录，不该在别人的页面上闪出上一个人的头像。
  ///
  /// 各页面的数据缓存不用在这里逐个清：业务 controller 都是 autoDispose，
  /// 登出触发重定向后整个 shell 卸载，无监听者即销毁，下次登录重新取数。
  // TODO(auth): cached_network_image 的**磁盘**缓存清不掉——需要 flutter_cache_manager
  //   进 pubspec（属工程配置，须人工确认）。头像字段目前后端还没下发，等真有头像再补。
  Future<void> _clearSession() async {
    _tokenStore.clear();
    await _storage.clear();
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  }

  /// 用户快照持久化：User 是纯领域实体（无 JSON 耦合），这里手动序列化。
  ///
  /// 冷启动只有这份快照能还原「已登录」界面（accessToken 只在内存，重启后拿不回
  /// 登录响应里的 userInfo），所以实体加字段时这里必须同步补——漏存 licenseLevel，
  /// 重启后持证跳伞员就被当成体验客，首页会给他推错航线。
  String _encodeUser(User user) => jsonEncode(<String, dynamic>{
    "id": user.id,
    "displayName": user.displayName,
    "email": user.email,
    "phone": user.phone,
    "avatarUrl": user.avatarUrl,
    "licenseLevel": user.licenseLevel,
    "totalJumps": user.totalJumps,
    "createdAt": user.createdAt?.toIso8601String(),
    "lastActiveAt": user.lastActiveAt?.toIso8601String(),
  });

  Future<User?> _readPersistedUser() async {
    final raw = await _storage.readUser();
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final id = map["id"] as String?;
      final displayName = map["displayName"] as String?;
      // id + 显示名是最小可展示身份：缺了就当快照失效，用户重新登录一次即可拿到
      // 完整 userInfo，不会带着半个实体跑。
      if (id == null || displayName == null) return null;
      return User(
        id: id,
        displayName: displayName,
        email: map["email"] as String?,
        phone: map["phone"] as String?,
        avatarUrl: map["avatarUrl"] as String?,
        licenseLevel: map["licenseLevel"] as String?,
        totalJumps: (map["totalJumps"] as num?)?.toInt() ?? 0,
        createdAt: DateTime.tryParse(map["createdAt"] as String? ?? ""),
        lastActiveAt: DateTime.tryParse(map["lastActiveAt"] as String? ?? ""),
      );
    } on Object {
      return null;
    }
  }
}
