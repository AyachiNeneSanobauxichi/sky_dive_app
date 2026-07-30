import "package:flutter/material.dart";

/// 启动占位页：登录态未定（冷启动静默刷新进行中）时展示，
/// 避免在 login / home 之间闪烁。无文案，故无 i18n 约束。
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
