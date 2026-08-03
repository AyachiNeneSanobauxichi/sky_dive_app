import "package:freezed_annotation/freezed_annotation.dart";

part "sms_code_state.freezed.dart";

/// 「发送验证码」按钮的状态。
///
/// 不用 `AsyncValue`：这里要同时表达「正在发」和「发完了、还剩 N 秒不能再发」两件事，
/// 后者不是 loading 也不是 error，而是一个持续倒计时的可用性约束。
@freezed
abstract class SmsCodeState with _$SmsCodeState {
  const SmsCodeState._();

  const factory SmsCodeState({
    /// 请求进行中（按钮进入忙碌态，防止重复发送）。
    @Default(false) bool isSending,

    /// 距离可再次发送的剩余秒数，0 表示无冷却。
    @Default(0) int cooldownSeconds,
  }) = _SmsCodeState;

  bool get isCoolingDown => cooldownSeconds > 0;

  /// 只有空闲且不在冷却里才允许发送。
  bool get canSend => !isSending && !isCoolingDown;
}
