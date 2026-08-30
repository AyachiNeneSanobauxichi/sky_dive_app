import "package:flutter/material.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";

/// 验证码区块：6 格 OTP 输入 + 发送 / 重发入口。
///
/// 发送按钮放在格子**下方**而不是右侧并排：OTP 需要整行宽度才能保证每格够大、
/// 数字够醒目；挤一个按钮进去会把格子压窄成"小方块"。按钮本身撑到
/// `SkyControlSize.minTapTarget`（44），视觉上是弱行动、热区仍然合规。
///
/// **居中**而不是右对齐：上面是六个居中排布的格子，底下挂一个贴右边的按钮会读成
/// 一个游离的元素；居中才让这两行是同一个"验证码区块"。
///
/// 按钮只有两态：可发送 / 冷却中（纯文字说明剩余秒数）。
///
/// 刻意**没有忙碌态、也没有切换动效**：冷却在点击那一刻同步起算
/// （见 `SmsCodeController.send`），所以点下去的下一帧就是「N 秒后重发」——
/// 转圈没有信息量，交叉淡入还会让这行字横向挪一下。两态高度锁在
/// `SkyControlSize.minTapTarget`，切换时布局不跳。
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
      spacing: SkySpacing.s4,
      children: <Widget>[
        SkyOtpField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          isSuccess: isSuccess,
          length: AuthRules.smsCodeLength,
          onChanged: onChanged,
          onCompleted: onCompleted,
          // 输入过程中不校验：验证码是逐位敲进去的，边敲边校验等于从第 1 位起
          // 整排红到第 6 位——用户没做错任何事，只是还没输完。校验留给提交那一刻
          // （`Form.validate()`），而真正的"码不对"由后端返回后就地反馈。
          autovalidateMode: AutovalidateMode.disabled,
          validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
            FormBuilderValidators.required(errorText: l10n.authCodeRequired),
            FormBuilderValidators.match(
              AuthRules.smsCode,
              errorText: l10n.authCodeInvalid,
            ),
          ]),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            // 两态同高：视觉上是弱行动，热区仍撑到 44，且切换时这行不上下跳。
            height: SkyControlSize.minTapTarget,
            child: state.isCoolingDown
                // 冷却中换成**纯文字说明**而不是禁用按钮：灰掉的按钮读起来像"坏了"，
                // 一句"N 秒后可重发"才说清这是在等而不是出错。
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SkySpacing.s12,
                    ),
                    // widthFactor: 1 —— 只包住文字本身，不撑满可用宽度，
                    // 否则外层的居中会失效（一个撑满的盒子居不了中）。
                    child: Align(
                      alignment: Alignment.center,
                      widthFactor: 1,
                      child: Text(
                        l10n.authResendAfter(state.cooldownSeconds),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : SkyButton(
                    label: l10n.authSendCode,
                    variant: SkyButtonVariant.ghost,
                    size: SkyButtonSize.small,
                    isFullWidth: false,
                    onPressed: enabled && state.canSend ? onSendCode : null,
                  ),
          ),
        ),
      ],
    );
  }
}
