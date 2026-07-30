import "package:flutter/foundation.dart";
import "package:logger/logger.dart";

/// 全局日志封装：统一级别（d/i/w/e）与格式，替代裸 `print`（红线 #6 禁止 print）。
///
/// 仅在 debug 环境输出（`kDebugMode`），生产环境静默，避免泄露请求体/敏感信息。
/// 记日志时应带上下文，而非仅 `e.toString()`。切勿记录 token、密码等 PII。
abstract final class AppLogger {
  static final Logger _logger = Logger(
    // methodCount: 0 —— 正常日志不打调用栈；错误日志保留少量栈帧便于定位。
    printer: PrettyPrinter(methodCount: 0, errorMethodCount: 6),
    level: kDebugMode ? Level.trace : Level.off,
  );

  static void d(Object? msg) => _logger.d(msg);
  static void i(Object? msg) => _logger.i(msg);
  static void w(Object? msg) => _logger.w(msg);
  static void e(Object? msg, [Object? error, StackTrace? st]) =>
      _logger.e(msg, error: error, stackTrace: st);
}
