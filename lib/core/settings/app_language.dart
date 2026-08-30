import "package:flutter/material.dart";
import "package:sky_dive/l10n/app_localizations.dart";

/// 界面语言选项（含"跟随系统"）。
///
/// 为什么不直接用 `AppLocalizations.supportedLocales`：那个列表里没有
/// "跟随系统"这一项，而它恰恰是**默认值**，必须能在设置里被选回来。
/// 另外每种语言的名字要用**该语言自己**写（日本語 / English / 中文），
/// 而不是翻译成当前界面语言——找语言的人往往正看不懂当前界面。
enum AppLanguageOption {
  /// 跟随手机系统语言。对应 `AppSettings.locale == null`。
  system(null),
  japanese(Locale("ja")),
  english(Locale("en")),
  chinese(Locale("zh"));

  const AppLanguageOption(this.locale);

  /// 对应的 locale；null 表示跟随系统。
  final Locale? locale;

  /// 选项文案。只有"跟随系统"走 i18n，其余用语言自称的固定写法。
  String label(AppLocalizations l10n) => switch (this) {
    AppLanguageOption.system => l10n.accountLanguageSystem,
    AppLanguageOption.japanese => "日本語",
    AppLanguageOption.english => "English",
    AppLanguageOption.chinese => "中文",
  };
}
