import "package:flutter/material.dart";
import "package:toastification/toastification.dart";

/// 全局轻提示（toast）统一入口。
///
/// 业务层的用户提示一律走这里，**不**直接调 `toastification` 或
/// `ScaffoldMessenger`，以保证样式 / 位置 / 时长一致（顶部、扁平语义色、3 秒自动关）。
/// 需 app 根挂载 `ToastificationWrapper`（见 `app.dart`）。
abstract final class HappyToast {
  static const Duration _duration = Duration(seconds: 3);
  static const AlignmentGeometry _alignment = Alignment.topCenter;
  static const ToastificationStyle _style = ToastificationStyle.flatColored;

  /// 成功提示（绿色语义）。
  static void success(BuildContext context, String message) =>
      _show(context, message, ToastificationType.success);

  /// 错误提示（红色语义）。失败场景默认用它。
  static void error(BuildContext context, String message) =>
      _show(context, message, ToastificationType.error);

  /// 中性信息提示。
  static void info(BuildContext context, String message) =>
      _show(context, message, ToastificationType.info);

  static void _show(
    BuildContext context,
    String message,
    ToastificationType type,
  ) {
    toastification.show(
      context: context,
      type: type,
      style: _style,
      title: Text(message),
      alignment: _alignment,
      autoCloseDuration: _duration,
      showProgressBar: false,
    );
  }
}
