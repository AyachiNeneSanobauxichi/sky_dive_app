import "package:dio/dio.dart";
import "package:sky_dive/core/error/app_exception.dart";
import "package:sky_dive/core/network/api_response.dart";
import "package:sky_dive/core/network/auth_events.dart";

/// 响应解包拦截器：处理后端统一信封 `{code, message, data}`。
///
/// - 成功（`code == ApiResponse.successCode`）：把内层 `data` 写回 `response.data`，
///   向下层只暴露纯业务数据（DioClient / Repository 无需再关心信封）。
/// - `code == 401`：未授权，见下。
/// - 其余 `code`：业务错误，`reject` 成携带 `BusinessException` 的 `DioException`，
///   交给后续 `ErrorInterceptor` 与 `DioClient` 统一收敛。
///
/// 非 JSON 信封（如二进制下载、纯文本）原样放行，不做解包。
class ResponseInterceptor extends Interceptor {
  ResponseInterceptor({required AuthEvents events}) : _events = events;

  final AuthEvents _events;

  /// 信封里的未授权码（本项目业务码与 HTTP 码同形）。
  static const int _unauthorizedCode = 401;

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
      // 未授权：HTTP 状态是 200，所以 AuthInterceptor 的 401 分支根本看不到它
      // （onResponse 里 reject 出的错误只会流向本拦截器之后的 onError）。
      // 这里直接广播会话失效，否则用户会看到一句错误提示却仍停在需要登录的页面上。
      if (envelope.code == _unauthorizedCode) {
        _events.notifyUnauthorized();
        handler.reject(
          _rejection(
            response,
            UnauthorizedException(message: _messageOrNull(envelope)),
          ),
        );
        return;
      }
      // 业务失败：转成错误流，携带业务码与后端文案。
      handler.reject(
        _rejection(
          response,
          BusinessException(code: envelope.code, message: envelope.message),
        ),
      );
      return;
    }
    handler.next(response);
  }

  DioException _rejection(Response<dynamic> response, AppException error) =>
      DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: error,
      );

  /// 空 message 当作"没有文案"，让下游用兜底文案而不是显示一行空白。
  String? _messageOrNull(ApiResponse envelope) =>
      envelope.message.isEmpty ? null : envelope.message;
}

// TODO(auth): 信封形态的未授权目前直接判定会话失效、不尝试静默刷新——一是刷新接口契约
//   尚未在 auth.api.md 定义，二是此处拿不到 AuthInterceptor 的单飞刷新（那套逻辑绑在
//   onError 的 HTTP 401 分支上）。后端确认「未授权到底走哪种形态 + 刷新契约」后，宜把
//   刷新逻辑从 AuthInterceptor 抽成可复用组件，两条路径共用。
