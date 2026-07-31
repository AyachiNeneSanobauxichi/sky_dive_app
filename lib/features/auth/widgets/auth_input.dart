import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

/// 认证流程的通用文本输入框。
///
/// 用 `hintText` 而不是 `labelText`：登录/注册这种字段含义一目了然的场景，
/// 浮动标签只会让输入框在聚焦时"跳一下"，占位提示更安静。
class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autofillHints,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      validator: validator,
      autofillHints: autofillHints,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon, size: HappyIconSize.md),
      ),
    );
  }
}
