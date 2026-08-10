import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/core/storage/index.dart";

part "app_settings.freezed.dart";

/// 应用级偏好：深浅色与界面语言。
///
/// 只放**用户显式选过**的东西。默认值不是随手定的：
/// - 主题默认深色——这个 app 的视觉基底是星空夜幕，浅色是给需要的人的选项，不是常态；
/// - 语言默认**跟随手机系统**（[locale] 为 null），而不是写死中文：装了英文系统的
///   用户第一屏就该是英文，让他先进设置里改一次是本末倒置。
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemeMode.dark) ThemeMode themeMode,

    /// 界面语言。**null 表示跟随系统**——它和"选了中文"是两种不同的状态，
    /// 不能用 `zh` 当默认值糊过去，否则用户换了手机系统语言 app 不会跟着变。
    Locale? locale,
  }) = _AppSettings;
}

/// 读取已持久化的偏好。读不到 / 存的是不认识的值时一律回落默认。
///
/// 在 `main()` 里 **runApp 之前**调用：偏好晚一帧到，用户就会看见深色闪一下再变浅色。
Future<AppSettings> loadAppSettings(SecureStorage storage) async {
  final theme = await storage.readThemeMode();
  final language = await storage.readLocale();
  return AppSettings(
    themeMode: themeModeFromStored(theme),
    locale: localeFromStored(language),
  );
}

/// [ThemeMode] ↔ 存储串。只认深/浅两档：产品上「黑白主题」就是二选一，
/// 存进来 `system` 或任何不认识的值都按默认（深色）处理。
ThemeMode themeModeFromStored(String? value) =>
    value == ThemeMode.light.name ? ThemeMode.light : ThemeMode.dark;

String themeModeToStored(ThemeMode mode) => mode.name;

/// 语言码 ↔ 存储串。空串与 null 等价，都表示跟随系统。
Locale? localeFromStored(String? value) =>
    (value == null || value.isEmpty) ? null : Locale(value);

String? localeToStored(Locale? locale) => locale?.languageCode;
