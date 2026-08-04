/// 后端统一响应信封：`{ "code": 200, "message": "success", "data": {...} }`。
///
/// 约定：`code == 200` 为成功，其余为业务错误码。注意这里的 `code` 是**业务码**而不是
/// HTTP 状态码，只是后端选了同一套数字；HTTP 层的失败仍由 `ErrorInterceptor` 处理。
/// 由 `ResponseInterceptor` 用于解包——成功时取出 `data` 继续向下传，
/// 失败时抛 `BusinessException`。业务层不直接接触本类，只拿到解包后的 `data`。
class ApiResponse {
  const ApiResponse({required this.code, required this.message, this.data});

  /// 业务码：200 成功，其余为业务错误。
  final int code;

  /// 提示文案（成功为 "success"，失败为错误信息）。
  final String message;

  /// 实际业务数据，结构随接口而定（Map / List / 基本类型 / null）。
  final dynamic data;

  /// 业务成功码。抽成常量供绕过拦截器手解信封的地方（如 `AuthInterceptor` 的静默刷新）
  /// 复用，避免同一个约定在两处各写一个字面量、改一处漏一处。
  static const int successCode = 200;

  /// 是否业务成功。
  bool get isSuccess => code == successCode;

  /// 从原始 JSON 解析。字段缺失时给出安全默认，避免解析即崩。
  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    code: (json["code"] as num?)?.toInt() ?? -1,
    message: json["message"] as String? ?? "",
    data: json["data"],
  );
}
