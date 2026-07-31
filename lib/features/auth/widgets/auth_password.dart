import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 认证流程的密码输入框（自带明文切换）。
class AuthPassword extends StatefulWidget {
  const AuthPassword({
    super.key,
    required this.label,
    this.controller,
    this.textInputAction,
    this.validator,
    this.autofillHints,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final AutovalidateMode autovalidateMode;

  @override
  State<AuthPassword> createState() => _AuthPasswordState();
}

class _AuthPasswordState extends State<AuthPassword> {
  bool _obscure = true;
  void _toggle() => setState(() => _obscure = !_obscure);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: widget.controller,
      autovalidateMode: widget.autovalidateMode,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.label,
        prefixIcon: const Icon(LucideIcons.lock, size: HappyIconSize.md),
        suffixIcon: IconButton(
          onPressed: _toggle,
          tooltip: _obscure ? l10n.authShowPassword : l10n.authHidePassword,
          icon: Icon(
            _obscure ? LucideIcons.eyeOff : LucideIcons.eye,
            size: HappyIconSize.md,
          ),
        ),
      ),
    );
  }
}
