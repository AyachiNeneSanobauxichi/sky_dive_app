import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";
import "package:happy_os/core/config/index.dart";
import "package:happy_os/core/network/index.dart";
import "package:happy_os/core/storage/index.dart";

// 说明：本仓库当前 Flutter SDK（analyzer 8.4.1 / meta 1.17.0）无法运行
// riverpod_generator（其 analyzer_utils/source_helper 依赖 analyzer 9 的新 API），
// 故 provider 暂用「手写」而非 @riverpod 代码生成。等价的注解写法与差异见
// agent/study/riverpod-codegen-issue.md。改动 provider 无需再跑 build_runner。

/// 安全存储单例：refreshToken / 用户快照等持久化数据的读写入口。
final secureStorageProvider = Provider<SecureStorage>(
  (ref) => const SecureStorage(FlutterSecureStorage()),
);

/// 内存态 accessToken 持有者（v2：accessToken 不落盘，仅存内存）。
final accessTokenStoreProvider = Provider<AccessTokenStore>(
  (ref) => AccessTokenStore(),
);

/// 鉴权事件通道：拦截器广播「会话失效」，业务层订阅后翻转登录态（core 不反依赖 feature）。
final authEventsProvider = Provider<AuthEvents>((ref) {
  final events = AuthEvents();
  ref.onDispose(events.dispose);
  return events;
});

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
final dioProvider = Provider<Dio>((ref) {
  // 刷新专用 Dio：无任何拦截器，供 AuthInterceptor 在 401 时静默换 token，
  // 避免「刷新请求本身又触发刷新」的递归。
  final refreshDio = Dio(_baseOptions());

  final authInterceptor = AuthInterceptor(
    tokenStore: ref.watch(accessTokenStoreProvider),
    storage: ref.watch(secureStorageProvider),
    refreshDio: refreshDio,
    events: ref.watch(authEventsProvider),
  );

  final dio = Dio(_baseOptions());
  dio.interceptors.addAll([
    authInterceptor,
    ResponseInterceptor(),
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
});

/// 网络访问门面：业务层只依赖 `DioClient`，不直接接触 `Dio`。
final dioClientProvider = Provider<DioClient>(
  (ref) => DioClient(ref.watch(dioProvider)),
);
