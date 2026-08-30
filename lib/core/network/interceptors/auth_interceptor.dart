import "package:dio/dio.dart";
import "package:sky_dive/core/network/access_token_store.dart";
import "package:sky_dive/core/network/api_response.dart";
import "package:sky_dive/core/network/auth_events.dart";
import "package:sky_dive/core/storage/secure_storage.dart";

/// 鉴权拦截器（v2）。
///
/// 职责：
/// - **注入**：从内存态 [AccessTokenStore] 取 accessToken 拼 `Authorization: Bearer`；
///   并给每个请求带 `X-Client-Type: app`（app 端标识，见 auth_api v2）。
/// - **401 自动刷新 + 重放**：收到 401 时，用持久化的 refreshToken 静默换新 accessToken，
///   写回内存后**重放原请求**；刷新失败则清会话并广播 [AuthEvents.notifyUnauthorized]。
///
/// 设计要点：
/// - 刷新用独立、无拦截器的 [_refreshDio]，避免「刷新请求又触发刷新」的递归。
/// - 重放走主 [Dio]（[attachDio] 注入），以复用 ResponseInterceptor 的信封解包；
///   靠 `extra[_kRetried]` 标记防止二次刷新死循环。
/// - 单飞锁 [_refreshing]：并发 401 只发起一次刷新，其余等待同一 Future。
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required AccessTokenStore tokenStore,
    required SecureStorage storage,
    required Dio refreshDio,
    required AuthEvents events,
  }) : _tokenStore = tokenStore,
       _storage = storage,
       _refreshDio = refreshDio,
       _events = events;

  final AccessTokenStore _tokenStore;
  final SecureStorage _storage;
  final Dio _refreshDio;
  final AuthEvents _events;

  /// 主 Dio 引用（用于重放）。构造后由 core_providers 调用 [attachDio] 注入，
  /// 以打破「Dio 需要拦截器、拦截器需要 Dio」的构造环。
  Dio? _dio;

  /// refresh 单飞锁：进行中的刷新 Future，避免并发重复刷新。
  Future<String>? _refreshing;

  static const String _refreshPath = "/auth/refresh-token";
  static const String _kRetried = "auth_retried";

  void attachDio(Dio dio) => _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // app 端统一标识。
    options.headers["X-Client-Type"] = "app";
    final token = _tokenStore.token;
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final is401 = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains(_refreshPath);
    final alreadyRetried = err.requestOptions.extra[_kRetried] == true;

    // 只对「非刷新请求、未重放过的 401」尝试自动刷新；其余原样放行。
    if (!is401 || isRefreshCall || alreadyRetried) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _refreshOnce();
      _tokenStore.set(newToken);
      final response = await _replay(err.requestOptions);
      handler.resolve(response);
    } on Object {
      // 刷新失败：清会话并通知业务层翻转登录态。
      _tokenStore.clear();
      await _storage.clear();
      _events.notifyUnauthorized();
      handler.next(err);
    }
  }

  /// 单飞刷新：并发调用共享同一个进行中的 Future。
  Future<String> _refreshOnce() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  /// 用持久化的 refreshToken 换新 accessToken。走无拦截器的 [_refreshDio]，
  /// 故需手动解后端统一信封 `{code, message, data}`。
  Future<String> _doRefresh() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError("no refresh token");
    }
    final res = await _refreshDio.post<dynamic>(
      _refreshPath,
      data: {"refreshToken": refreshToken},
    );
    final body = res.data;
    if (body is! Map<String, dynamic> ||
        (body["code"] as num?)?.toInt() != ApiResponse.successCode) {
      throw StateError("refresh rejected");
    }
    final data = body["data"];
    final token = data is Map<String, dynamic> ? data["accessToken"] : null;
    if (token is! String || token.isEmpty) {
      throw StateError("refresh returned no access token");
    }
    return token;
  }

  /// 重放原请求。走主 Dio 复用信封解包；标记 [_kRetried] 防止二次刷新。
  /// onRequest 会用刷新后的新 token 重新注入鉴权头。
  Future<Response<dynamic>> _replay(RequestOptions options) {
    final dio = _dio;
    if (dio == null) throw StateError("main Dio not attached");
    final retried = options.copyWith(
      extra: {...options.extra, _kRetried: true},
    );
    return dio.fetch<dynamic>(retried);
  }
}
