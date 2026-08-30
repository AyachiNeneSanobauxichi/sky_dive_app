import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/weather/data/dto/index.dart";
import "package:sky_dive/features/weather/data/weather_data_source.dart";
import "package:sky_dive/features/weather/domain/index.dart";

/// 天气仓库：DTO→Entity 映射 + 异常收敛。
class WeatherRepository {
  const WeatherRepository(this._source);

  final WeatherDataSource _source;

  Future<WeatherWindow> fetchTodayWindow() async {
    try {
      final json = await _source.fetchTodayWindow();
      return WeatherWindowDto.fromJson(json).toEntity();
    } on AppException catch (e) {
      throw e.toFailure();
    }
  }
}
