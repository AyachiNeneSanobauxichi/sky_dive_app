import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/weather/domain/jump_status.dart";

part "weather_window.freezed.dart";

/// 某个跳伞点当天的放飞窗口。
@freezed
abstract class WeatherWindow with _$WeatherWindow {
  const factory WeatherWindow({
    /// 跳伞点名称（如「藤岡スカイダイビングクラブ」）。
    required String dropZone,

    required JumpStatus status,

    /// 地面温度（摄氏）。
    required int temperatureC,

    /// 地面风速（m/s）。跳伞看风速不看风级，这是行业惯例。
    required double windSpeedMps,

    /// 数据的观测时刻。有值就**必须展示**——天气数据的价值随时间衰减得极快，
    /// 一条不知道什么时候测的"可跳"没有任何意义。
    ///
    /// 可空是因为解析失败时**宁可不显示**：伪造一个"刚刚"比没有时间更危险，
    /// 客人会拿着一条两小时前的判断出门。
    DateTime? observedAt,
  }) = _WeatherWindow;
}
