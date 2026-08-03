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
/// 按钮三态由 [state] 驱动：可发送 / 发送中（忙碌，禁点）/ 冷却中（显示剩余秒数，禁点）。
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
          child: AnimatedSwitcher(
            duration: HappyMotion.fast,
            child: state.isCoolingDown
                // 冷却中换成**纯文字说明**而不是禁用按钮：灰掉的按钮读起来像"坏了"，
                // 一句"N 秒后可重发"才说清这是在等而不是出错。
                ? Padding(
                    key: const ValueKey("cooldown"),
                    padding: const EdgeInsets.symmetric(
                      horizontal: HappySpacing.s12,
                      vertical: HappySpacing.s12,
                    ),
                    child: Text(
                      l10n.authResendAfter(state.cooldownSeconds),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : SizedBox(
                    key: const ValueKey("send"),
                    // 视觉上是一个文字按钮，但热区撑到 44，符合最小可点尺寸。
                    height: HappyControlSize.minTapTarget,
                    child: HappyButton(
                      label: l10n.authSendCode,
                      variant: HappyButtonVariant.ghost,
                      size: HappyButtonSize.small,
                      isFullWidth: false,
                      isLoading: state.isSending,
                      // 发送中禁用：禁用态有明确长相，比"能点但没反应"清楚。
                      onPressed: enabled && state.canSend ? onSendCode : null,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
