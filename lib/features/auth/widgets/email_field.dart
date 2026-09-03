import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 邮箱输入框。
///
/// 两个容易被忽略但每天都在坑人的细节：
/// 1. **`TextInputType.emailAddress`** 让键盘直接带 `@` 和 `.`，少两次切换；
/// 2. **`AutofillHints.username`** 让系统密码管理器认得出这是账号栏，
///    配合下一个字段的 `password`，iOS / Android 才会提供"一键填充"。
///
/// 输入时不校验：邮箱是一个字一个字敲的，敲到 `a@` 就红着"格式不正确"
/// 是在指责用户还没输完。校验时机由调用方在离开输入框 / 提交时给。
class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.isNewAccount = false,
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.errorText,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;

  /// 注册场景。影响自动填充语义：注册时提示系统"这是新账号"，
  /// 密码管理器才会提议**保存**而不是填充旧密码。
  final bool isNewAccount;

  final TextInputAction textInputAction;
  final AutovalidateMode autovalidateMode;

  /// 来自服务端的就地错误（如"该邮箱已被注册"）。
  ///
  /// 这类错误客户端校验不出来，只能等接口回来才知道，但它属于**这个字段**，
  /// 就该显示在这个字段下方，而不是弹一条转瞬即逝的 toast。
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      onTapOutside: skyDismissKeyboardOnTapOutside,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      autofillHints: <String>[
        if (isNewAccount) AutofillHints.newUsername else AutofillHints.username,
        AutofillHints.email,
      ],
      autovalidateMode: autovalidateMode,
      inputFormatters: <TextInputFormatter>[
        // 邮箱里不该有空格。挡在输入这一步，比等提交时报错友好得多
        // ——手机键盘在词尾自动补的那个空格，用户自己完全看不见。
        FilteringTextInputFormatter.deny(RegExp(r"\s")),
        LengthLimitingTextInputFormatter(AuthRules.emailMaxLength),
      ],
      validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
        FormBuilderValidators.required(errorText: l10n.authEmailRequired),
        FormBuilderValidators.match(
          AuthRules.email,
          errorText: l10n.authEmailInvalid,
        ),
      ]),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: l10n.authEmailHint,
        errorText: errorText,
        prefixIcon: const Icon(LucideIcons.mail, size: SkyIconSize.md),
      ),
    );
  }
}
