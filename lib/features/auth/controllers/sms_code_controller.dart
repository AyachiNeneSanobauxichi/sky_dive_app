import "dart:async";

import "package:happy_os/features/auth/controllers/auth_controller.dart";
import "package:happy_os/features/auth/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "sms_code_controller.g.dart";

/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// **冷却是乐观起算的**：点下去这一刻就进入倒计时，不等接口回来。
/// 为什么这么做——等接口回来再起算的话，中间那一两秒按钮既没变化又不能点，
/// 只能靠转圈来解释，而转圈恰恰是这一版要去掉的东西（点完直接显示「60s 后重发」
/// 才是用户要的信息）。服务端若下发了更长的冷却，成功后以服务端为准；
/// 发送失败则立刻解除冷却，不让用户为一条没发出去的短信干等。
///
/// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。
@riverpod
class SmsCodeController extends _$SmsCodeController {
  /// 倒计时步长。这是业务时间而非动效时长，故不取 `HappyMotion`。
  static const Duration _tick = Duration(seconds: 1);

  /// 乐观冷却时长：接口还没回来时先按这个数倒计时。
  static const Duration _optimisticCooldown = Duration(seconds: 60);

  Timer? _ticker;

  @override
  SmsCodeState build() {
    ref.onDispose(() => _ticker?.cancel());
    return const SmsCodeState();
  }

  /// 发送验证码。点下即进入冷却，失败抛出 `Failure` 由页面提示。
  Future<void> send(String phone) async {
    if (!state.canSend) return; // 冷却中：直接忽略，防重复发送

    // 同步起算冷却：这一帧界面就从「获取验证码」变成「60s 后重发」，
    // 既是"已受理"的反馈，也顺手把重复点击挡在门外，不需要额外的忙碌态。
    state = SmsCodeState(cooldownSeconds: _optimisticCooldown.inSeconds);
    _startTicker();

    try {
      final cooldown = await ref
          .read(authRepositoryProvider)
          .sendSmsCode(phone);
      if (!ref.mounted) return; // 页面已离开，provider 已销毁，不能再写 state
      // 服务端要求等更久（风控加严）时才改写，否则保持本地倒计时——
      // 用服务端值无条件覆盖会让秒数往回跳一下。
      if (cooldown.inSeconds > state.cooldownSeconds) {
        state = state.copyWith(cooldownSeconds: cooldown.inSeconds);
      }
    } on Object {
      // 失败必须解除冷却：短信没发出去还罚用户等 60 秒是纯粹的体验事故。
      if (ref.mounted) reset();
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
