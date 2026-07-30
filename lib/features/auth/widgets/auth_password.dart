import "package:flutter/material.dart";
import "package:happy_os/l10n/app_localizations.dart";

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
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: _toggle,
          tooltip: _obscure ? l10n.authShowPassword : l10n.authHidePassword,
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}
