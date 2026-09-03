import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 密码输入框（带明文切换）。
///
/// ## 为什么一定要有"显示密码"
/// 手机上盲打一串带数字的密码，错一位就是一次登录失败，而失败之后用户
/// **仍然不知道自己错在哪**。一个眼睛图标把这个死循环打断，是投入产出比最高的一处交互。
/// 默认仍是隐藏——旁边站着人的场景更常见。
///
/// ## 校验分两种场合
/// - [isNewAccount] = false（登录）：只校验非空。登录时拿"密码至少 8 位"去拦用户
///   毫无意义——他的密码是什么样，服务端说了算，客户端多拦一道只会把老账号挡在门外。
/// - [isNewAccount] = true（注册）：校验长度与字母 + 数字组合（[AuthRules.isValidPassword]）。
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.isNewAccount = false,
    this.labelKind = PasswordFieldLabel.password,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.errorText,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  /// 注册场景：走强度校验，并给系统密码管理器 `newPassword` 提示。
  final bool isNewAccount;

  /// 决定 hint 文案（密码 / 确认密码）。
  final PasswordFieldLabel labelKind;

  final TextInputAction textInputAction;
  final AutovalidateMode autovalidateMode;

  /// 自定义校验（确认密码要比对另一个字段，规则不在本组件内）。
  /// 传了就完全接管，不再叠加默认规则。
  final FormFieldValidator<String>? validator;

  /// 来自服务端的就地错误。
  final String? errorText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _obscured = !_obscured);
  }

  String? _defaultValidator(String? value, AppLocalizations l10n) {
    final input = value ?? "";
    if (input.isEmpty) return l10n.authPasswordRequired;
    if (!widget.isNewAccount) return null;
    if (!AuthRules.isValidPassword(input)) return l10n.authPasswordWeak;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      obscureText: _obscured,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      onTapOutside: skyDismissKeyboardOnTapOutside,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: <String>[
        if (widget.isNewAccount)
          AutofillHints.newPassword
        else
          AutofillHints.password,
      ],
      autovalidateMode: widget.autovalidateMode,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(AuthRules.passwordMaxLength),
      ],
      validator: widget.validator ?? (value) => _defaultValidator(value, l10n),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: switch (widget.labelKind) {
          PasswordFieldLabel.password => l10n.authPasswordHint,
          PasswordFieldLabel.newPassword => l10n.authNewPasswordHint,
          PasswordFieldLabel.confirmPassword => l10n.authConfirmPasswordHint,
        },
        errorText: widget.errorText,
        prefixIcon: const Icon(LucideIcons.lockKeyhole, size: SkyIconSize.md),
        suffixIcon: IconButton(
          onPressed: widget.enabled ? _toggle : null,
          // 纯图标按钮必须有 tooltip 或 Semantics，两者给其一即可；
          // tooltip 顺带解决了长按说明的需求。
          tooltip: _obscured ? l10n.authShowPassword : l10n.authHidePassword,
          icon: Icon(
            _obscured ? LucideIcons.eye : LucideIcons.eyeOff,
            size: SkyIconSize.md,
          ),
        ),
      ),
    );
  }
}

/// 密码框的文案角色。
enum PasswordFieldLabel { password, newPassword, confirmPassword }
