// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_code_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// 冷却时长取后端下发值（见 `AuthRepository.sendSmsCode`），不在客户端写死，
/// 否则风控加严时会出现「倒计时归零但仍然发不出去」。
///
/// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。

@ProviderFor(SmsCodeController)
final smsCodeControllerProvider = SmsCodeControllerProvider._();

/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// 冷却时长取后端下发值（见 `AuthRepository.sendSmsCode`），不在客户端写死，
/// 否则风控加严时会出现「倒计时归零但仍然发不出去」。
///
/// autoDispose（默认）：只在登录页存活期间有意义，离开页面即重置。
final class SmsCodeControllerProvider
    extends $NotifierProvider<SmsCodeController, SmsCodeState> {
  /// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
  ///
  /// 冷却时长取后端下发值（见 `AuthRepository.sendSmsCode`），不在客户端写死，
  /// 否则风控加严时会出现「倒计时归零但仍然发不出去」。
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

String _$smsCodeControllerHash() => r'6b303b5c3dd0b6783780ea17cad24e8347c47d9e';

/// 「发送验证码」控制器：管发送请求 + 重发冷却倒计时。
///
/// 冷却时长取后端下发值（见 `AuthRepository.sendSmsCode`），不在客户端写死，
/// 否则风控加严时会出现「倒计时归零但仍然发不出去」。
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
