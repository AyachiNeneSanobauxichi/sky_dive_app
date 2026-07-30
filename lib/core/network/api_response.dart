/// 后端统一响应信封：`{ "code": 0, "message": "success", "data": {...} }`。
///
/// 约定：`code == 0` 为成功，其余为业务错误码（如 11001 Invalid token）。
/// 由 `ResponseInterceptor` 用于解包——成功时取出 `data` 继续向下传，
/// 失败时抛 `BusinessException`。业务层不直接接触本类，只拿到解包后的 `data`。
class ApiResponse {
  const ApiResponse({required this.code, required this.message, this.data});

  /// 业务码：0 成功，非 0 为业务错误。
  final int code;

  /// 提示文案（成功为 "success"，失败为错误信息）。
  final String message;

  /// 实际业务数据，结构随接口而定（Map / List / 基本类型 / null）。
  final dynamic data;

  /// 是否业务成功。
  bool get isSuccess => code == 0;

  /// 从原始 JSON 解析。字段缺失时给出安全默认，避免解析即崩。
  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    code: (json["code"] as num?)?.toInt() ?? -1,
    message: json["message"] as String? ?? "",
    data: json["data"],
  );
}
