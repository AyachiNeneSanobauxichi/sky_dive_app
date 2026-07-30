import "package:happy_os/core/error/failure.dart";

/// 不抛异常的结果包装（可选）。
///
/// 大多数场景用「抛 AppException → Repository catch → Failure」链路即可；
/// 当某些调用方希望以返回值而非异常表达成败（便于 `switch` 分支处理）时，
/// 用 `sealed ApiResult<T>`。UI/controller 可对其做穷尽匹配。
sealed class ApiResult<T> {
  const ApiResult();
}

/// 成功，携带数据。
final class Success<T> extends ApiResult<T> {
  const Success(this.data);
  final T data;
}

/// 失败，携带面向 UI 的 `Failure`。
final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.failure);
  final Failure failure;
}
