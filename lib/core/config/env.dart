import "package:flutter_dotenv/flutter_dotenv.dart";

/// 环境配置的唯一读取入口。
///
/// 为什么集中一处：`.env` 的裸读（`dotenv.env["X"]`）散落各业务会导致 key
/// 拼写漂移、缺省值不一致。这里统一做「读取 + 默认值 + 类型转换」，业务只依赖 `Env`。
/// 若 `.env` 未加载或缺字段，回退到本地开发默认值，保证不会因缺配置而崩溃。
abstract final class Env {
  /// 服务器根地址（**不含**路径前缀），如 `http://localhost:3000`。默认本地后端。
  static String get baseUrl => _stripTrailingSlash(
    dotenv.maybeGet("BASE_URL") ?? "http://localhost:3000",
  );

  /// 全局接口前缀，如 `/api`。所有请求路径都拼在它之上。
  static String get apiPrefix =>
      _ensureLeadingSlash(dotenv.maybeGet("API_PREFIX") ?? "/api");

  /// 真实请求根地址 = [baseUrl] + [apiPrefix]（v2：拆分配置后在此拼接）。
  /// DioClient 的 `baseUrl` 用它，业务层与 core_providers 无需感知拆分细节。
  static String get apiBaseUrl => "$baseUrl$apiPrefix";

  /// 是否启用网络详细日志（PrettyDioLogger）。生产应关闭。
  static bool get enableLogging =>
      (dotenv.maybeGet("ENABLE_LOGGING") ?? "true").toLowerCase() == "true";

  /// 去掉末尾斜杠，避免与前缀拼出 `//`。
  static String _stripTrailingSlash(String v) =>
      v.endsWith("/") ? v.substring(0, v.length - 1) : v;

  /// 确保前缀以 `/` 开头，保证与 baseUrl 正确拼接。
  static String _ensureLeadingSlash(String v) => v.startsWith("/") ? v : "/$v";
}
