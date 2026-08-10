import "package:flutter/material.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/core/settings/app_settings.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "app_settings_controller.g.dart";

/// 启动时预读到的偏好。
///
/// `main()` 在 runApp 之前把它 override 成真实值。**这不是可有可无的优化**：
/// 不预读就只能在首帧之后异步补上，用户会看见默认的深色闪一下再切成他选的浅色。
/// 没被 override 时（测试、或将来某个不走 main 的入口）落到默认值，不会炸。
@Riverpod(keepAlive: true)
AppSettings initialAppSettings(Ref ref) => const AppSettings();

/// 应用偏好控制器：深浅色 + 界面语言。
///
/// keepAlive：它是整个 app 的主题与语言来源，监听者归零就销毁重建等于设置被重置。
///
/// 写入是 fire-and-forget 的顺序——**先改内存态再落盘**，界面立刻响应，
/// 持久化在后台完成。落盘失败最坏是下次启动回到上一次的选择，不该让用户
/// 等一次 Keychain 写入才看到主题变化。
@Riverpod(keepAlive: true)
class AppSettingsController extends _$AppSettingsController {
  @override
  AppSettings build() => ref.watch(initialAppSettingsProvider);

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;
    state = state.copyWith(themeMode: mode);
    await ref
        .read(secureStorageProvider)
        .writeThemeMode(themeModeToStored(mode));
  }

  /// 切换界面语言。传 null＝改回跟随系统。
  Future<void> setLocale(Locale? locale) async {
    if (state.locale?.languageCode == locale?.languageCode) return;
    // copyWith 传 null 不会置空（Freezed 的 copyWith 分不清"没传"和"传了 null"），
    // 所以这里整个重建一次 state。
    state = AppSettings(themeMode: state.themeMode, locale: locale);
    await ref.read(secureStorageProvider).writeLocale(localeToStored(locale));
  }
}
