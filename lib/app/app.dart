import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:toastification/toastification.dart";
import "package:sky_dive/app/app_transition.dart";
import "package:sky_dive/app/router/index.dart";
import "package:sky_dive/core/settings/index.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";

class SkyApp extends ConsumerWidget {
  const SkyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 路由器由 provider 装配（依赖登录态驱动重定向），此处 watch 获取实例。
    final router = ref.watch(routerProvider);
    // 深浅色与语言来自用户设置（user 模块可改），启动前已预读，见 main.dart。
    final settings = ref.watch(appSettingsControllerProvider);
    return MaterialApp.router(
      // 标题走本地化（随 locale 切换）
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: SkyTheme.light, // 白昼晴空
      darkTheme: SkyTheme.dark, // 暮色高空
      // 默认跟随系统昼夜（`ThemeMode.system`），用户可在账号页钉死其中一套。
      // 两套主题都是一等设计目标，见 `core/theme/app_colors.dart`。
      themeMode: settings.themeMode,
      // locale 为 null 时**不写死**：Flutter 会拿手机系统语言去匹配 supportedLocales，
      // 命中则用之、否则回退首项（en）——面向国际游客，英文比日文更适合当兜底。
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations
            .localizationsDelegates, // 应用文案 + Material/Widgets/Cupertino 全局本地化
        FormBuilderLocalizations.delegate, // 表单校验库的错误文案本地化
      ],
      debugShowCheckedModeBanner: true,
      routerConfig: router, // go_router 装配（provider 提供）
      // 全局挂载 toast overlay：轻提示（SkyToast）需要它承载。
      // 过渡层放在 overlay **里面**：切主题时连带把已经弹出的 toast 一起淡过去，
      // 不会出现"整屏换了皮、只有那条提示还是旧配色"。
      // SkyDismissKeyboard 在这一层挂一次即覆盖所有路由（含 dialog / bottom
      // sheet）：点页面空白处收键盘，新增页面不必各自接线。
      builder: (context, child) => ToastificationWrapper(
        child: SkyDismissKeyboard(
          child: AppSettingsTransition(settings: settings, child: child!),
        ),
      ),
    );
  }
}
