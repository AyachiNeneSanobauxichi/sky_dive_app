import "package:sky_dive/core/network/index.dart";
import "package:sky_dive/features/weather/data/weather_data_source.dart";

/// 天气远程数据源。
///
/// ⚠️ 后端尚未就绪，当前 provider 装配的是 `WeatherMockDataSource`。
// TODO(weather): 端点与字段待 `agent/service/weather/weather.api.md` 定稿后校对。
class WeatherRemoteDataSource implements WeatherDataSource {
  const WeatherRemoteDataSource(this._client);

  final DioClient _client;

  static const String _todayWindow = "/weather/today";

  @override
  Future<Map<String, dynamic>> fetchTodayWindow() =>
      _client.get<Map<String, dynamic>>(_todayWindow);
}
