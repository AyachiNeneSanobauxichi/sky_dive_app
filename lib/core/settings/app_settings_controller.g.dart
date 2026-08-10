// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 启动时预读到的偏好。
///
/// `main()` 在 runApp 之前把它 override 成真实值。**这不是可有可无的优化**：
/// 不预读就只能在首帧之后异步补上，用户会看见默认的深色闪一下再切成他选的浅色。
/// 没被 override 时（测试、或将来某个不走 main 的入口）落到默认值，不会炸。

@ProviderFor(initialAppSettings)
final initialAppSettingsProvider = InitialAppSettingsProvider._();

/// 启动时预读到的偏好。
///
/// `main()` 在 runApp 之前把它 override 成真实值。**这不是可有可无的优化**：
/// 不预读就只能在首帧之后异步补上，用户会看见默认的深色闪一下再切成他选的浅色。
/// 没被 override 时（测试、或将来某个不走 main 的入口）落到默认值，不会炸。

final class InitialAppSettingsProvider
    extends $FunctionalProvider<AppSettings, AppSettings, AppSettings>
    with $Provider<AppSettings> {
  /// 启动时预读到的偏好。
  ///
  /// `main()` 在 runApp 之前把它 override 成真实值。**这不是可有可无的优化**：
  /// 不预读就只能在首帧之后异步补上，用户会看见默认的深色闪一下再切成他选的浅色。
  /// 没被 override 时（测试、或将来某个不走 main 的入口）落到默认值，不会炸。
  InitialAppSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialAppSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialAppSettingsHash();

  @$internal
  @override
  $ProviderElement<AppSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppSettings create(Ref ref) {
    return initialAppSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$initialAppSettingsHash() =>
    r'752ffa723905a5678aff3a7183138f45ef5077e5';

/// 应用偏好控制器：深浅色 + 界面语言。
///
/// keepAlive：它是整个 app 的主题与语言来源，监听者归零就销毁重建等于设置被重置。
///
/// 写入是 fire-and-forget 的顺序——**先改内存态再落盘**，界面立刻响应，
/// 持久化在后台完成。落盘失败最坏是下次启动回到上一次的选择，不该让用户
/// 等一次 Keychain 写入才看到主题变化。

@ProviderFor(AppSettingsController)
final appSettingsControllerProvider = AppSettingsControllerProvider._();

/// 应用偏好控制器：深浅色 + 界面语言。
///
/// keepAlive：它是整个 app 的主题与语言来源，监听者归零就销毁重建等于设置被重置。
///
/// 写入是 fire-and-forget 的顺序——**先改内存态再落盘**，界面立刻响应，
/// 持久化在后台完成。落盘失败最坏是下次启动回到上一次的选择，不该让用户
/// 等一次 Keychain 写入才看到主题变化。
final class AppSettingsControllerProvider
    extends $NotifierProvider<AppSettingsController, AppSettings> {
  /// 应用偏好控制器：深浅色 + 界面语言。
  ///
  /// keepAlive：它是整个 app 的主题与语言来源，监听者归零就销毁重建等于设置被重置。
  ///
  /// 写入是 fire-and-forget 的顺序——**先改内存态再落盘**，界面立刻响应，
  /// 持久化在后台完成。落盘失败最坏是下次启动回到上一次的选择，不该让用户
  /// 等一次 Keychain 写入才看到主题变化。
  AppSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsControllerHash();

  @$internal
  @override
  AppSettingsController create() => AppSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$appSettingsControllerHash() =>
    r'5def55894dbfe04278150c063977f5dbe94bae2f';

/// 应用偏好控制器：深浅色 + 界面语言。
///
/// keepAlive：它是整个 app 的主题与语言来源，监听者归零就销毁重建等于设置被重置。
///
/// 写入是 fire-and-forget 的顺序——**先改内存态再落盘**，界面立刻响应，
/// 持久化在后台完成。落盘失败最坏是下次启动回到上一次的选择，不该让用户
/// 等一次 Keychain 写入才看到主题变化。

abstract class _$AppSettingsController extends $Notifier<AppSettings> {
  AppSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppSettings, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppSettings, AppSettings>,
              AppSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
