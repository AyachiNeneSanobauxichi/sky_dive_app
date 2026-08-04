import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:happy_os/core/config/index.dart";
import "package:happy_os/core/network/index.dart";
import "package:happy_os/core/storage/index.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "core_providers.g.dart";

// 本文件全部用 @Riverpod(keepAlive: true) 而非裸 @riverpod：这些都是全局单例，
// 一旦 autoDispose，监听者归零时会被销毁重建——accessToken 丢失、事件通道断开、
// Dio 连接被关。keepAlive 与迁移前手写 Provider 的语义一致。

/// 安全存储单例：refreshToken / 用户快照等持久化数据的读写入口。
@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) =>
    const SecureStorage(FlutterSecureStorage());

/// 内存态 accessToken 持有者（v2：accessToken 不落盘，仅存内存）。
@Riverpod(keepAlive: true)
AccessTokenStore accessTokenStore(Ref ref) => AccessTokenStore();

/// 鉴权事件通道：拦截器广播「会话失效」，业务层订阅后翻转登录态（core 不反依赖 feature）。
@Riverpod(keepAlive: true)
AuthEvents authEvents(Ref ref) {
  final events = AuthEvents();
  ref.onDispose(events.dispose);
  return events;
}

/// Dio 公共配置。集中一处，主 Dio 与「刷新专用 Dio」共用同一份基线。
BaseOptions _baseOptions() => BaseOptions(
  baseUrl: Env.apiBaseUrl,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
  headers: const {
    "Content-Type": "application/json",
    // v2：app 端所有请求统一带此标识。
    "X-Client-Type": "app",
  },
);

/// 全局唯一 Dio 实例。
///
/// 集中配置 baseUrl / 超时 / 公共头，并按顺序挂载拦截器：
/// 鉴权(注入 token) → 解包(信封) → 错误映射 → 日志(仅 debug)。
/// 顺序要点：ErrorInterceptor 必须在 ResponseInterceptor 之后，
/// 才能接住后者 reject 出的业务错误。provider 销毁时关闭连接。
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  // 刷新专用 Dio：无任何拦截器，供 AuthInterceptor 在 401 时静默换 token，
  // 避免「刷新请求本身又触发刷新」的递归。
  final refreshDio = Dio(_baseOptions());

  final authEvents = ref.watch(authEventsProvider);
  final authInterceptor = AuthInterceptor(
    tokenStore: ref.watch(accessTokenStoreProvider),
    storage: ref.watch(secureStorageProvider),
    refreshDio: refreshDio,
    events: authEvents,
  );

  final dio = Dio(_baseOptions());
  dio.interceptors.addAll([
    authInterceptor,
    // 解包拦截器也要拿 events：信封形态的未授权（HTTP 200 + code 401）只有它看得到。
    ResponseInterceptor(events: authEvents),
    ErrorInterceptor(),
    // 仅 debug 且配置开启时打印，避免生产泄露请求/响应体。
    if (kDebugMode && Env.enableLogging)
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
  ]);
  // 注入主 Dio 引用，供拦截器重放刷新后的请求（打破构造环）。
  authInterceptor.attachDio(dio);

  ref.onDispose(() {
    dio.close();
    refreshDio.close();
  });
  return dio;
}

/// 网络访问门面：业务层只依赖 `DioClient`，不直接接触 `Dio`。
@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) => DioClient(ref.watch(dioProvider));
