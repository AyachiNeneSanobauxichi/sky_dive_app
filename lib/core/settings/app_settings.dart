import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/core/storage/index.dart";

part "app_settings.freezed.dart";

/// 应用级偏好：深浅色与界面语言。
///
/// 只放**用户显式选过**的东西。两个默认值都是"跟随系统"，而且理由是同一个：
/// - 主题默认 [ThemeMode.system]——白昼晴空与暮色高空**都是**一等设计目标
///   （见 `core/theme/app_colors.dart`），没有哪一套是"正统"，
///   那就该跟着用户手机的昼夜设置走；想钉死的人去账号页挑一次。
/// - 语言默认**跟随手机系统**（[locale] 为 null），而不是写死日语：本产品同时服务
///   本地客人与外国游客，装了英文系统的人第一屏就该是英文。
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// 界面语言。**null 表示跟随系统**——它和"选了中文"是两种不同的状态，
    /// 不能用 `zh` 当默认值糊过去，否则用户换了手机系统语言 app 不会跟着变。
    Locale? locale,
  }) = _AppSettings;
}

/// 读取已持久化的偏好。读不到 / 存的是不认识的值时一律回落默认。
///
/// 在 `main()` 里 **runApp 之前**调用：偏好晚一帧到，用户就会看见默认主题闪一下再切成他选的那套。
Future<AppSettings> loadAppSettings(SecureStorage storage) async {
  final theme = await storage.readThemeMode();
  final language = await storage.readLocale();
  return AppSettings(
    themeMode: themeModeFromStored(theme),
    locale: localeFromStored(language),
  );
}

/// [ThemeMode] ↔ 存储串。三档全收（跟随系统 / 浅色 / 深色）；
/// 存进来任何不认识的值都按默认（跟随系统）处理，不让一条脏数据把界面锁死。
ThemeMode themeModeFromStored(String? value) => switch (value) {
  "light" => ThemeMode.light,
  "dark" => ThemeMode.dark,
  _ => ThemeMode.system,
};

String themeModeToStored(ThemeMode mode) => mode.name;

/// 语言码 ↔ 存储串。空串与 null 等价，都表示跟随系统。
Locale? localeFromStored(String? value) =>
    (value == null || value.isEmpty) ? null : Locale(value);

String? localeToStored(Locale? locale) => locale?.languageCode;
