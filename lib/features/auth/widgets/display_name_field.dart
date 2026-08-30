import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 显示名输入框（注册页）。
///
/// 只要一个"怎么称呼你"，**不拆姓 / 名两栏**：日语姓名的姓名顺序、
/// 外国游客的中间名、只想用昵称的人——拆栏会让这三种人都别扭，
/// 而这个字段的用途只是"教练在集合点怎么叫他"。
///
/// 真实姓名（护照拼写）属于**下单时**才需要的资料，不在注册收集。
class DisplayNameField extends StatelessWidget {
  const DisplayNameField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final AutovalidateMode autovalidateMode;

  /// 显示名长度上限。够长到容得下带中间名的外国姓名，又不至于把列表撑爆。
  static const int maxLength = 32;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.name,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.words,
      autofillHints: const <String>[AutofillHints.name],
      autovalidateMode: autovalidateMode,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(maxLength),
      ],
      validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
        FormBuilderValidators.required(errorText: l10n.authNameRequired),
      ]),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: l10n.authNameHint,
        prefixIcon: const Icon(LucideIcons.user, size: SkyIconSize.md),
      ),
    );
  }
}
