import "package:sky_dive/features/weather/data/index.dart";
import "package:sky_dive/features/weather/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "weather_controller.g.dart";

/// 天气数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
/// `WeatherRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。
@Riverpod(keepAlive: true)
WeatherDataSource weatherDataSource(Ref ref) => WeatherMockDataSource();

@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(Ref ref) =>
    WeatherRepository(ref.watch(weatherDataSourceProvider));

/// 今日放飞窗口。
///
/// autoDispose（默认）：只在展示它的页面存活期间有意义。天气是**时效性极强**的
/// 数据，keepAlive 会让用户从别处返回时看到一条几十分钟前的旧判断——
/// 那比没有还危险。离开页面即丢弃、回来重新取，才是这类数据该有的生命周期。
@riverpod
class WeatherWindowController extends _$WeatherWindowController {
  @override
  Future<WeatherWindow> build() =>
      ref.watch(weatherRepositoryProvider).fetchTodayWindow();

  /// 重试。用 `AsyncValue.guard` 而不是直接 `ref.invalidateSelf()`：
  /// 后者会把状态打回 loading 并丢掉上一次的数据，重试失败时卡片会先闪一下空白。
  Future<void> retry() async {
    state = const AsyncLoading<WeatherWindow>();
    state = await AsyncValue.guard(
      () => ref.read(weatherRepositoryProvider).fetchTodayWindow(),
    );
  }
}
