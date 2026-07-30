import "dart:async";

/// 鉴权事件通道（core 层，解耦 infra 与 feature）。
///
/// 为什么需要它：AuthInterceptor（core）在 refresh 失败时要通知业务层「会话已失效」，
/// 但 core **不得反向依赖** feature（红线 #3 单向依赖）。于是 core 只对外广播事件，
/// 由 feature 的 AuthController 订阅并翻转登录态，避免 core→feature 的耦合。
class AuthEvents {
  final StreamController<void> _unauthorized =
      StreamController<void>.broadcast();

  /// 会话失效事件流（refresh 失败 / 无有效 refreshToken 时触发）。
  Stream<void> get onUnauthorized => _unauthorized.stream;

  void notifyUnauthorized() {
    if (!_unauthorized.isClosed) _unauthorized.add(null);
  }

  void dispose() => _unauthorized.close();
}
