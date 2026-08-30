import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/core/error/app_exception.dart";

part "failure.freezed.dart";

/// 面向 UI 的领域失败。相比 `AppException`（技术视角），`Failure` 是「给用户看的」
/// 失败分类，UI 据此渲染友好文案与重试入口。用 freezed sealed 便于 `switch` 穷尽。
@freezed
sealed class Failure with _$Failure {
  /// 网络不可用 / 超时。
  const factory Failure.network() = NetworkFailure;

  /// 服务端错误（HTTP 非 2xx）。`message` 为后端文案（若有）。
  const factory Failure.server({String? message}) = ServerFailure;

  /// 未授权：token 缺失/失效，需重新登录。
  const factory Failure.unauthorized() = UnauthorizedFailure;

  /// 业务错误：HTTP 200 但业务 `code` 非成功码。保留后端业务码与文案。
  const factory Failure.business({required int code, String? message}) =
      BusinessFailure;

  /// 兜底未知失败。
  const factory Failure.unknown() = UnknownFailure;
}

/// 技术异常 → 领域失败的转换。Repository 层 `catch (AppException)` 后调用。
extension AppExceptionX on AppException {
  Failure toFailure() => switch (this) {
    NetworkException() => const Failure.network(),
    TimeoutException() => const Failure.network(),
    // 401 视为未授权；其余 HTTP 错误归为 server。
    ServerException(:final statusCode, :final message) =>
      statusCode == 401
          ? const Failure.unauthorized()
          : Failure.server(message: message),
    UnauthorizedException() => const Failure.unauthorized(),
    // TODO(auth): 后端业务错误码表定稿后，把「token 失效」类 code（如 11001）
    //   映射为 Failure.unauthorized() 以触发重新登录；当前统一归 business。
    BusinessException(:final code, :final message) => Failure.business(
      code: code,
      message: message,
    ),
    ParseException() => const Failure.unknown(),
    UnknownException() => const Failure.unknown(),
  };
}

/// 失败 → 展示文案。位于 core（红线 #9 的 i18n 约束仅限 screens/widgets）。
extension FailureMessage on Failure {
  // TODO(i18n): 这些兜底文案后续宜走 AppLocalizations，由 UI 层按 Failure 类型取词。
  String get displayMessage => switch (this) {
    NetworkFailure() => "网络不可用，请检查连接后重试",
    // 优先展示后端返回的 message（通常已本地化），否则用兜底。
    ServerFailure(:final message) => message ?? "服务开小差了，请稍后再试",
    UnauthorizedFailure() => "登录已过期，请重新登录",
    BusinessFailure(:final message) => message ?? "操作失败，请稍后再试",
    UnknownFailure() => "出错了，请稍后再试",
  };
}
