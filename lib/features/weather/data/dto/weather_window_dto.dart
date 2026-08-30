import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/weather/domain/index.dart";

part "weather_window_dto.freezed.dart";
part "weather_window_dto.g.dart";

/// `GET /weather/today` 响应体（信封解包后的 data）。
@freezed
abstract class WeatherWindowDto with _$WeatherWindowDto {
  const WeatherWindowDto._();

  const factory WeatherWindowDto({
    required String dropZone,
    required String status,
    required int temperatureC,
    required double windSpeedMps,
    String? observedAt,
  }) = _WeatherWindowDto;

  factory WeatherWindowDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherWindowDtoFromJson(json);

  WeatherWindow toEntity() => WeatherWindow(
    dropZone: dropZone,
    status: JumpStatus.fromRaw(status),
    temperatureC: temperatureC,
    windSpeedMps: windSpeedMps,
    // 解析不了就留 null（卡片会把时刻那一项隐掉），**不要**兜底成 DateTime.now()
    // ——一条假的观测时间比没有时间更危险。天气本身仍然可用，不该因此整卡报错。
    observedAt: DateTime.tryParse(observedAt ?? ""),
  );
}
