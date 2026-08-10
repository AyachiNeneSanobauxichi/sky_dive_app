import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:toastification/toastification.dart";
import "package:happy_os/app/app_transition.dart";
import "package:happy_os/app/router/index.dart";
import "package:happy_os/core/settings/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/l10n/app_localizations.dart";

class HappyApp extends ConsumerWidget {
  const HappyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 路由器由 provider 装配（依赖登录态驱动重定向），此处 watch 获取实例。
    final router = ref.watch(routerProvider);
    // 深浅色与语言来自用户设置（user 模块可改），启动前已预读，见 main.dart。
    final settings = ref.watch(appSettingsControllerProvider);
    return MaterialApp.router(
      // 标题走本地化（随 locale 切换）
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: HappyTheme.light, // 亮色主题
      darkTheme: HappyTheme.dark, // 深色主题
      // 深浅色由用户显式选择，**不跟随系统**：这个 app 的视觉基底是星空夜幕，
      // 默认深色；想要浅色的人去设置里挑一次，而不是被系统的白天黑夜牵着走。
      themeMode: settings.themeMode,
      // locale 为 null 时**不写死**：Flutter 会拿手机系统语言去匹配 supportedLocales，
      // 命中则用之、否则回退首项（en）。用户显式选过语言才把它钉住。
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations
            .localizationsDelegates, // 应用文案 + Material/Widgets/Cupertino 全局本地化
        FormBuilderLocalizations.delegate, // 表单校验库的错误文案本地化
      ],
      debugShowCheckedModeBanner: true,
      routerConfig: router, // go_router 装配（provider 提供）
      // 全局挂载 toast overlay：轻提示（HappyToast）需要它承载。
      // 过渡层放在 overlay **里面**：切主题时连带把已经弹出的 toast 一起淡过去，
      // 不会出现"整屏换了皮、只有那条提示还是旧配色"。
      builder: (context, child) => ToastificationWrapper(
        child: AppSettingsTransition(settings: settings, child: child!),
      ),
    );
  }
}
