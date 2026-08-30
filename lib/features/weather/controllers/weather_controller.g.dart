// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 天气数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
/// `WeatherRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。

@ProviderFor(weatherDataSource)
final weatherDataSourceProvider = WeatherDataSourceProvider._();

/// 天气数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
/// `WeatherRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。

final class WeatherDataSourceProvider
    extends
        $FunctionalProvider<
          WeatherDataSource,
          WeatherDataSource,
          WeatherDataSource
        >
    with $Provider<WeatherDataSource> {
  /// 天气数据源 DI。
  ///
  /// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
  /// `WeatherRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。
  WeatherDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherDataSourceHash();

  @$internal
  @override
  $ProviderElement<WeatherDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherDataSource create(Ref ref) {
    return weatherDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherDataSource>(value),
    );
  }
}

String _$weatherDataSourceHash() => r'b6abcf72fb7b562f445958431b313116be92898f';

@ProviderFor(weatherRepository)
final weatherRepositoryProvider = WeatherRepositoryProvider._();

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'22490dff0dc3cef29a883ed2595ac32f4bd09378';

/// 今日放飞窗口。
///
/// autoDispose（默认）：只在展示它的页面存活期间有意义。天气是**时效性极强**的
/// 数据，keepAlive 会让用户从别处返回时看到一条几十分钟前的旧判断——
/// 那比没有还危险。离开页面即丢弃、回来重新取，才是这类数据该有的生命周期。

@ProviderFor(WeatherWindowController)
final weatherWindowControllerProvider = WeatherWindowControllerProvider._();

/// 今日放飞窗口。
///
/// autoDispose（默认）：只在展示它的页面存活期间有意义。天气是**时效性极强**的
/// 数据，keepAlive 会让用户从别处返回时看到一条几十分钟前的旧判断——
/// 那比没有还危险。离开页面即丢弃、回来重新取，才是这类数据该有的生命周期。
final class WeatherWindowControllerProvider
    extends $AsyncNotifierProvider<WeatherWindowController, WeatherWindow> {
  /// 今日放飞窗口。
  ///
  /// autoDispose（默认）：只在展示它的页面存活期间有意义。天气是**时效性极强**的
  /// 数据，keepAlive 会让用户从别处返回时看到一条几十分钟前的旧判断——
  /// 那比没有还危险。离开页面即丢弃、回来重新取，才是这类数据该有的生命周期。
  WeatherWindowControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherWindowControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherWindowControllerHash();

  @$internal
  @override
  WeatherWindowController create() => WeatherWindowController();
}

String _$weatherWindowControllerHash() =>
    r'94ed13b4c684994c6fb525e0fbd3642758d09129';

/// 今日放飞窗口。
///
/// autoDispose（默认）：只在展示它的页面存活期间有意义。天气是**时效性极强**的
/// 数据，keepAlive 会让用户从别处返回时看到一条几十分钟前的旧判断——
/// 那比没有还危险。离开页面即丢弃、回来重新取，才是这类数据该有的生命周期。

abstract class _$WeatherWindowController extends $AsyncNotifier<WeatherWindow> {
  FutureOr<WeatherWindow> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WeatherWindow>, WeatherWindow>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WeatherWindow>, WeatherWindow>,
              AsyncValue<WeatherWindow>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
