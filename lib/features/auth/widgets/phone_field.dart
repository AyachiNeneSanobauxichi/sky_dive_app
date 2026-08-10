import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 手机号输入框。
///
/// 三个刻意的取舍：
/// 1. **只收数字 + 限长 11**：靠 `inputFormatters` 在输入时就挡住，而不是等提交才报错；
/// 2. **输入过程中不校验**（默认 [AutovalidateMode.disabled]），校验时机由调用方
///    在"该判的那一刻"给（离开输入框 / 点发送验证码 / 提交）——见 [autovalidateMode]；
/// 3. **区号做成前缀而不是可编辑字段**：当前只支持大陆号码，多一个可编辑框只会让人犹豫。
///
/// 报错时就地显示在输入框下方，不弹 toast——toast 会消失，用户不知道是哪个字段错了。
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// 提交中置 false：锁住输入，避免请求在途时手机号被改。
  final bool enabled;

  /// 从折叠态点"修改"回来时自动聚焦，省一次点击。
  final bool autofocus;

  /// 何时自动校验。**默认关闭**：手机号是逐位敲进去的，边敲边校验等于从第 1 位起
  /// 一路红到第 11 位——用户没做错任何事，只是还没输完。
  ///
  /// 调用方在"该判的那一刻"（离开输入框 / 点了发送验证码 / 提交）改传
  /// [AutovalidateMode.always]，把这个字段单独点亮：一来比走整表单 `validate()`
  /// 精准（后者会连带把验证码格子和协议勾选一起报错，而那两件事此刻还没轮到用户做），
  /// 二来 `always` 让用户改对的那一刻红字立刻消失，不用再触发一次校验才知道对了。
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      autofillHints: const <String>[AutofillHints.telephoneNumber],
      autovalidateMode: autovalidateMode,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(AuthRules.phoneLength),
      ],
      validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
        FormBuilderValidators.required(errorText: l10n.authPhoneRequired),
        FormBuilderValidators.match(
          AuthRules.mainlandPhone,
          errorText: l10n.authPhoneInvalid,
        ),
      ]),
      onChanged: onChanged,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: l10n.authPhoneHint,
        prefixIcon: const Icon(LucideIcons.smartphone, size: HappyIconSize.md),
        prefixText: "${AuthRules.dialCode}  ",
        prefixStyle: theme.textTheme.bodyLarge,
      ),
    );
  }
}
