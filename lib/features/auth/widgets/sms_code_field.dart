import "package:flutter/material.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";

/// 验证码区块：6 格 OTP 输入 + 发送 / 重发入口。
///
/// 发送按钮放在格子**下方右侧**而不是右侧并排：OTP 需要整行宽度才能保证每格够大、
/// 数字够醒目；挤一个按钮进去会把格子压窄成"小方块"。按钮本身撑到
/// `HappyControlSize.minTapTarget`（44），视觉上是弱行动、热区仍然合规。
///
/// 按钮只有两态：可发送 / 冷却中（纯文字说明剩余秒数）。
///
/// 刻意**没有忙碌态、也没有切换动效**：冷却在点击那一刻同步起算
/// （见 `SmsCodeController.send`），所以点下去的下一帧就是「N 秒后重发」——
/// 转圈没有信息量，交叉淡入还会让这行字横向挪一下。两态高度锁在
/// `HappyControlSize.minTapTarget`，切换时布局不跳。
class SmsCodeField extends StatelessWidget {
  const SmsCodeField({
    super.key,
    required this.controller,
    required this.state,
    required this.onSendCode,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
    this.isSuccess = false,
  });

  final TextEditingController controller;

  /// 发送验证码的状态（忙碌 / 冷却剩余秒数）。
  final SmsCodeState state;

  final VoidCallback onSendCode;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// 6 位填满时回调，供调用方自动提交。
  final ValueChanged<String>? onCompleted;

  /// 提交中置 false：锁住输入与发送入口。
  final bool enabled;

  /// 校验通过：格子换成对勾（换页前的成功确认）。
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HappySpacing.s4,
      children: <Widget>[
        HappyOtpField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          isSuccess: isSuccess,
          length: AuthRules.smsCodeLength,
          onChanged: onChanged,
          onCompleted: onCompleted,
          validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
            FormBuilderValidators.required(errorText: l10n.authCodeRequired),
            FormBuilderValidators.match(
              AuthRules.smsCode,
              errorText: l10n.authCodeInvalid,
            ),
          ]),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            // 两态同高：视觉上是弱行动，热区仍撑到 44，且切换时这行不上下跳。
            height: HappyControlSize.minTapTarget,
            child: state.isCoolingDown
                // 冷却中换成**纯文字说明**而不是禁用按钮：灰掉的按钮读起来像"坏了"，
                // 一句"N 秒后可重发"才说清这是在等而不是出错。
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: HappySpacing.s12,
                    ),
                    // widthFactor: 1 —— 只做垂直居中。用 `Center` 会撑满可用宽度，
                    // 把外层的右对齐吃掉，这行字就跑到屏幕正中去了。
                    child: Align(
                      alignment: Alignment.centerRight,
                      widthFactor: 1,
                      child: Text(
                        l10n.authResendAfter(state.cooldownSeconds),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : HappyButton(
                    label: l10n.authSendCode,
                    variant: HappyButtonVariant.ghost,
                    size: HappyButtonSize.small,
                    isFullWidth: false,
                    onPressed: enabled && state.canSend ? onSendCode : null,
                  ),
          ),
        ),
      ],
    );
  }
}
