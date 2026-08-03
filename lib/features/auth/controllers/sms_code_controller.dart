import "dart:async";

import "package:happy_os/features/auth/controllers/auth_controller.dart";
import "package:happy_os/features/auth/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "sms_code_controller.g.dart";

/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// 冷却时长取后端下发值（见 `AuthRepository.sendSmsCode`），不在客户端写死，
/// 否则风控加严时会出现「倒计时归零但仍然发不出去」。
///
/// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。
@riverpod
class SmsCodeController extends _$SmsCodeController {
  /// 倒计时步长。这是业务时间而非动效时长，故不取 `HappyMotion`。
  static const Duration _tick = Duration(seconds: 1);

  Timer? _ticker;

  @override
  SmsCodeState build() {
    ref.onDispose(() => _ticker?.cancel());
    return const SmsCodeState();
  }

  /// 发送验证码。成功进入冷却，失败抛出 `Failure` 由页面提示。
  ///
  /// 失败**不**进入冷却：短信没发出去还罚用户等 60 秒是纯粹的体验事故。
  Future<void> send(String phone) async {
    if (!state.canSend) return; // 冷却中或发送中：直接忽略，防重复发送

    state = state.copyWith(isSending: true);
    try {
      final cooldown = await ref
          .read(authRepositoryProvider)
          .sendSmsCode(phone);
      if (!ref.mounted) return; // 页面已离开，provider 已销毁，不能再写 state
      // 成功：一次性把 isSending 落回 false 并起算冷却。
      state = SmsCodeState(cooldownSeconds: cooldown.inSeconds);
      _startTicker();
    } on Object {
      if (ref.mounted) state = state.copyWith(isSending: false);
      rethrow;
    }
  }

  /// 清空发送态与冷却。
  ///
  /// 用户改了手机号时调用：冷却是"给刚才那个号码"的，换号后本地再拦 60 秒毫无意义
  /// （真正的限频由服务端按号码兜）。留着只会让改错号码的用户干等一分钟。
  void reset() {
    _ticker?.cancel();
    state = const SmsCodeState();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(_tick, (timer) {
      final next = state.cooldownSeconds - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(cooldownSeconds: 0);
        return;
      }
      state = state.copyWith(cooldownSeconds: next);
    });
  }
}
