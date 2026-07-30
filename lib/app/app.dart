import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:toastification/toastification.dart";
import "package:happy_os/app/router/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/l10n/app_localizations.dart";

class HappyApp extends ConsumerWidget {
  const HappyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 路由器由 provider 装配（依赖登录态驱动重定向），此处 watch 获取实例。
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      // 标题走本地化（随 locale 切换）
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: HappyTheme.light, // 亮色主题
      darkTheme: HappyTheme.dark, // 深色主题
      themeMode: ThemeMode.system, // 跟随系统切换深浅色
      // 不写死 locale：跟随手机系统语言，命中 supportedLocales 则用之，否则回退首项（en）
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations
            .localizationsDelegates, // 应用文案 + Material/Widgets/Cupertino 全局本地化
        FormBuilderLocalizations.delegate, // 表单校验库的错误文案本地化
      ],
      debugShowCheckedModeBanner: true,
      routerConfig: router, // go_router 装配（provider 提供）
      // 全局挂载 toast overlay：轻提示（HappyToast）需要它承载。
      builder: (context, child) => ToastificationWrapper(child: child!),
    );
  }
}
