import "package:freezed_annotation/freezed_annotation.dart";

part "sms_code_state.freezed.dart";

/// 「发送验证码」按钮的状态。
///
/// 不用 `AsyncValue`：这里要表达的不是 loading / error，而是「还剩 N 秒不能再发」
/// 这样一个持续倒计时的可用性约束。
///
/// 也**没有** `isSending`：冷却在点击那一刻同步起算（见 `SmsCodeController.send`），
/// 请求在途的窗口已经被冷却盖住了，再留一个忙碌态既没人读也会诱使 UI 转圈。
@freezed
abstract class SmsCodeState with _$SmsCodeState {
  const SmsCodeState._();

  const factory SmsCodeState({
    /// 距离可再次发送的剩余秒数，0 表示无冷却。
    @Default(0) int cooldownSeconds,
  }) = _SmsCodeState;

  bool get isCoolingDown => cooldownSeconds > 0;

  /// 不在冷却里才允许发送。
  bool get canSend => !isCoolingDown;
}
