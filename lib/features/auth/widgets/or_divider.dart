import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

/// "或" 分隔线。登录 / 注册两页共用，避免两处样式各自漂移。
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: HappySpacing.s12,
      children: <Widget>[
        const Expanded(child: Divider()),
        Text(text, style: Theme.of(context).textTheme.labelSmall),
        const Expanded(child: Divider()),
      ],
    );
  }
}
