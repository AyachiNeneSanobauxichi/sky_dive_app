import "package:dio/dio.dart";
import "package:happy_os/core/error/app_exception.dart";
import "package:happy_os/core/network/api_response.dart";

/// 响应解包拦截器：处理后端统一信封 `{code, message, data}`。
///
/// - `code == 0`：成功，把内层 `data` 写回 `response.data`，向下层只暴露纯业务数据
///   （DioClient / Repository 无需再关心信封）。
/// - `code != 0`：业务错误，`reject` 成携带 `BusinessException` 的 `DioException`，
///   交给后续 `ErrorInterceptor` 与 `DioClient` 统一收敛。
///
/// 非 JSON 信封（如二进制下载、纯文本）原样放行，不做解包。
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final envelope = ApiResponse.fromJson(data);
      if (envelope.isSuccess) {
        response.data = envelope.data; // 解包：向下只传 data
        handler.next(response);
        return;
      }
      // 业务失败：转成错误流，携带业务码与后端文案。
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: BusinessException(
            code: envelope.code,
            message: envelope.message,
          ),
        ),
      );
      return;
    }
    handler.next(response);
  }
}
