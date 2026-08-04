// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_code_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// **冷却是乐观起算的**：点下去这一刻就进入倒计时，不等接口回来。
/// 为什么这么做——等接口回来再起算的话，中间那一两秒按钮既没变化又不能点，
/// 只能靠转圈来解释，而转圈恰恰是这一版要去掉的东西（点完直接显示「60s 后重发」
/// 才是用户要的信息）。发送失败则立刻解除冷却，不让用户为一条没发出去的短信干等。
///
/// 冷却时长**只有本地这一个来源**：`auth.api.md` v1 的发码接口不下发重发间隔
/// （`expiresIn` 是验证码有效期，不是冷却）。真正的限频仍由服务端按号码兜。
///
/// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。

@ProviderFor(SmsCodeController)
final smsCodeControllerProvider = SmsCodeControllerProvider._();

/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// **冷却是乐观起算的**：点下去这一刻就进入倒计时，不等接口回来。
/// 为什么这么做——等接口回来再起算的话，中间那一两秒按钮既没变化又不能点，
/// 只能靠转圈来解释，而转圈恰恰是这一版要去掉的东西（点完直接显示「60s 后重发」
/// 才是用户要的信息）。发送失败则立刻解除冷却，不让用户为一条没发出去的短信干等。
///
/// 冷却时长**只有本地这一个来源**：`auth.api.md` v1 的发码接口不下发重发间隔
/// （`expiresIn` 是验证码有效期，不是冷却）。真正的限频仍由服务端按号码兜。
///
/// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。
final class SmsCodeControllerProvider
    extends $NotifierProvider<SmsCodeController, SmsCodeState> {
  /// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
  ///
  /// **冷却是乐观起算的**：点下去这一刻就进入倒计时，不等接口回来。
  /// 为什么这么做——等接口回来再起算的话，中间那一两秒按钮既没变化又不能点，
  /// 只能靠转圈来解释，而转圈恰恰是这一版要去掉的东西（点完直接显示「60s 后重发」
  /// 才是用户要的信息）。发送失败则立刻解除冷却，不让用户为一条没发出去的短信干等。
  ///
  /// 冷却时长**只有本地这一个来源**：`auth.api.md` v1 的发码接口不下发重发间隔
  /// （`expiresIn` 是验证码有效期，不是冷却）。真正的限频仍由服务端按号码兜。
  ///
  /// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。
  SmsCodeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smsCodeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smsCodeControllerHash();

  @$internal
  @override
  SmsCodeController create() => SmsCodeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SmsCodeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SmsCodeState>(value),
    );
  }
}

String _$smsCodeControllerHash() => r'588d74c028d00bcd215e1e12b88449698ea277c9';

/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// **冷却是乐观起算的**：点下去这一刻就进入倒计时，不等接口回来。
/// 为什么这么做——等接口回来再起算的话，中间那一两秒按钮既没变化又不能点，
/// 只能靠转圈来解释，而转圈恰恰是这一版要去掉的东西（点完直接显示「60s 后重发」
/// 才是用户要的信息）。发送失败则立刻解除冷却，不让用户为一条没发出去的短信干等。
///
/// 冷却时长**只有本地这一个来源**：`auth.api.md` v1 的发码接口不下发重发间隔
/// （`expiresIn` 是验证码有效期，不是冷却）。真正的限频仍由服务端按号码兜。
///
/// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。

abstract class _$SmsCodeController extends $Notifier<SmsCodeState> {
  SmsCodeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SmsCodeState, SmsCodeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SmsCodeState, SmsCodeState>,
              SmsCodeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
