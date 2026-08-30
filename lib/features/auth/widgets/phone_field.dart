import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 手机号输入框（日本国内格式）。
///
/// 三个刻意的取舍：
/// 1. **输入时就归一化**：用户常从通讯录粘贴 `+81 90-1234-5678`，
///    见 [_JapanPhoneInputFormatter]——那种格式失败是我们没处理，不是他填错了；
/// 2. **输入过程中不校验**（默认 [AutovalidateMode.disabled]），校验时机由调用方
///    在"该判的那一刻"给（离开输入框 / 点发送验证码 / 提交）——见 [autovalidateMode]；
/// 3. **区号做成前缀而不是可编辑字段**：当前只支持日本国内号码，多一个可编辑框
///    只会让人犹豫。
///
/// 报错时就地显示在输入框下方，不弹 toast——toast 会消失，用户不知道是哪个字段错了。
// TODO(auth): 支持多区号（外国游客用本国号码接码）需要区号选择器，待产品确认。
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.isOptional = false,
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// 提交中置 false：锁住输入，避免请求在途时手机号被改。
  final bool enabled;

  /// 从折叠态点"修改"回来时自动聚焦，省一次点击。
  final bool autofocus;

  /// 注册页里手机号是**选填**的：留空合法，填了才校验格式。
  /// 登录页则必填（没有号码就没法发码）。
  final bool isOptional;

  final TextInputAction textInputAction;

  /// 何时自动校验。**默认关闭**：手机号是逐位敲进去的，边敲边校验等于从第 1 位起
  /// 一路红到第 11 位——用户没做错任何事，只是还没输完。
  ///
  /// 调用方在"该判的那一刻"改传 [AutovalidateMode.always]，把这个字段单独点亮：
  /// 一来比走整表单 `validate()` 精准（后者会连带把别的字段一起报错，而那些事
  /// 此刻还没轮到用户做），二来 `always` 让用户改对的那一刻红字立刻消失。
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
      textInputAction: textInputAction,
      autofillHints: const <String>[AutofillHints.telephoneNumber],
      autovalidateMode: autovalidateMode,
      inputFormatters: const <TextInputFormatter>[_JapanPhoneInputFormatter()],
      validator: (value) {
        final input = value ?? "";
        // 选填且留空：合法，直接放行。不能走 required 校验器，
        // 否则注册页每次提交都会因为一个可选字段被拦下。
        if (isOptional && input.trim().isEmpty) return null;
        return FormBuilderValidators.compose(<FormFieldValidator<String>>[
          FormBuilderValidators.required(errorText: l10n.authPhoneRequired),
          FormBuilderValidators.match(
            AuthRules.japanMobile,
            errorText: l10n.authPhoneInvalid,
          ),
        ])(input);
      },
      onChanged: onChanged,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: isOptional ? l10n.authPhoneOptionalHint : l10n.authPhoneHint,
        prefixIcon: const Icon(LucideIcons.smartphone, size: SkyIconSize.md),
        prefixText: "${AuthRules.dialCode}  ",
        prefixStyle: theme.textTheme.bodyLarge,
      ),
    );
  }
}

/// 把任何写法收敛成 `0XXXXXXXXXX`，并截到 11 位。
///
/// 为什么不用现成的 `FilteringTextInputFormatter.digitsOnly`：它会把
/// `+81 90-1234-5678` 里的 `+` 和 `-` 直接剥掉，剩下 `819012345678`（12 位），
/// 再被限长截成 `81901234567`——一个**看起来像手机号的错号**。
/// 那比直接拒绝还糟：用户会盯着屏幕想不通哪里错了。
class _JapanPhoneInputFormatter extends TextInputFormatter {
  const _JapanPhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = AuthRules.normalizePhone(
      newValue.text,
    ).replaceAll(RegExp(r"\D"), "");
    final clipped = digits.length > AuthRules.phoneLength
        ? digits.substring(0, AuthRules.phoneLength)
        : digits;

    // 逐位输入与中间删除都走这条分支：文本没被改写，光标位置原样保留。
    if (clipped == newValue.text) return newValue;

    // 只有粘贴触发改写。光标收到末尾——改写后原来的偏移量已经没有意义了。
    return TextEditingValue(
      text: clipped,
      selection: TextSelection.collapsed(offset: clipped.length),
    );
  }
}
