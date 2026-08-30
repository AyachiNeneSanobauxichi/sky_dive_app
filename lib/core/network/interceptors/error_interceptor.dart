import "package:dio/dio.dart";
import "package:sky_dive/core/error/app_exception.dart";

/// 错误映射拦截器：把底层 `DioException` 收敛成项目 `AppException`。
///
/// 放在 `ResponseInterceptor` 之后：业务错误（`BusinessException`）已在上游产生，
/// 这里遇到「已是 AppException」的直接放行，只负责把传输层错误（超时/断网/HTTP 非 2xx）
/// 翻译成对应 `AppException`，塞回 `err.error` 供 `DioClient` 取出重抛。
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 上游已给出领域异常（如业务错误），不重复映射。
    if (err.error is AppException) {
      handler.next(err);
      return;
    }

    final mapped = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const TimeoutException(),
      DioExceptionType.connectionError => const NetworkException(),
      DioExceptionType.badResponse => ServerException(
        statusCode: err.response?.statusCode,
        message: _extractMessage(err.response?.data),
      ),
      _ => const UnknownException(),
    };
    handler.next(err.copyWith(error: mapped));
  }

  /// HTTP 非 2xx 时后端可能仍返回信封，尽力取出 `message` 作为服务端文案。
  String? _extractMessage(dynamic data) =>
      data is Map<String, dynamic> ? data["message"] as String? : null;
}
