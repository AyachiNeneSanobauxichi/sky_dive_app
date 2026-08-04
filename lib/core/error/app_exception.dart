/// 技术层异常层级：由拦截器 / DataSource 抛出。
///
/// 分工：`AppException` 表达「哪里出错、什么类型」（技术视角），面向 UI 的
/// 友好失败由 `Failure` 承载（见 failure.dart）。上层用 `on AppException` 捕获，
/// 再 `toFailure()` 转成可展示的领域失败。
sealed class AppException implements Exception {
  const AppException(this.message);

  /// 技术描述（用于日志/调试，不直接展示给用户）。
  final String message;

  @override
  String toString() => "$runtimeType($message)";
}

/// 无网络连接（DioExceptionType.connectionError）。
final class NetworkException extends AppException {
  const NetworkException() : super("网络连接失败");
}

/// 请求超时（连接/发送/接收任一超时）。
final class TimeoutException extends AppException {
  const TimeoutException() : super("请求超时");
}

/// HTTP 层错误（非 2xx 响应）。携带 HTTP 状态码。
final class ServerException extends AppException {
  const ServerException({this.statusCode, String? message})
    : super(message ?? "服务器异常");
  final int? statusCode;
}

/// 业务错误：HTTP 200 但响应体业务 `code` 非成功码。携带后端业务码与后端文案。
///
/// 例如后端返回 `{"code": 11001, "message": "Invalid token"}`——HTTP 成功，
/// 但业务失败。由 ResponseInterceptor 解包时抛出。
final class BusinessException extends AppException {
  const BusinessException({required this.code, String? message})
    : super(message ?? "业务处理失败");

  /// 后端业务错误码（非 0）。
  final int code;
}

/// 未授权：token 缺失 / 失效 / 无权限，会话必须重建。
///
/// 与 `ServerException(statusCode: 401)` 区分开，是因为后端把未授权也放在 **HTTP 200
/// 的信封里**（`code: 401`）下发——那种情况 HTTP 层完全正常，只有解包时才看得出来。
final class UnauthorizedException extends AppException {
  const UnauthorizedException({String? message}) : super(message ?? "登录状态已失效");
}

/// 数据解析失败（响应结构与预期不符）。
final class ParseException extends AppException {
  const ParseException() : super("数据解析失败");
}

/// 兜底未知异常。
final class UnknownException extends AppException {
  const UnknownException() : super("未知错误");
}
