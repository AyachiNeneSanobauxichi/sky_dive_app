import "dart:math" as math;

import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/weather/data/weather_data_source.dart";

/// 假天气服务。
///
/// 刻意**按分钟轮换三种放飞状态**（可跳 / 临界 / 停飞），而不是恒返回"可跳"：
/// 三种状态的卡片长相完全不同（配色、图标、文案），恒定的 mock 会让另外两种
/// 永远没被人眼看过一次，上线才发现停飞态的红配色和天幕打架。
///
/// 另外每 5 次里有 1 次直接失败——错误态同理，不给它复现机会就等于没实现。
///
// TODO(weather): 接入真实后端后删除整个 `data/mock/` 目录，并把
//   `weatherDataSourceProvider` 换回 `WeatherRemoteDataSource`。
class WeatherMockDataSource implements WeatherDataSource {
  WeatherMockDataSource();

  static final math.Random _random = math.Random();

  /// 轮换用的调用计数。static 是必要的：provider 重建时不该把轮换重置回第一种。
  static int _calls = 0;

  @override
  Future<Map<String, dynamic>> fetchTodayWindow() async {
    await Future<void>.delayed(
      _latency + Duration(milliseconds: _random.nextInt(_jitterMillis)),
    );

    _calls++;
    if (_calls % _failEvery == 0) {
      throw const NetworkException();
    }

    final variant = _variants[(_calls ~/ 1) % _variants.length];
    return <String, dynamic>{
      ...variant,
      "observedAt": DateTime.now()
          .subtract(const Duration(minutes: 12))
          .toIso8601String(),
    };
  }

  /// 三种放飞状态各来一条，字段值取真实量级
  /// （跳伞的地面风速门槛通常在 7–8 m/s 上下）。
  static const List<Map<String, dynamic>> _variants = <Map<String, dynamic>>[
    <String, dynamic>{
      "dropZone": "藤岡スカイダイビングクラブ",
      "status": "go",
      "temperatureC": 21,
      "windSpeedMps": 3.4,
    },
    <String, dynamic>{
      "dropZone": "藤岡スカイダイビングクラブ",
      "status": "marginal",
      "temperatureC": 18,
      "windSpeedMps": 7.2,
    },
    <String, dynamic>{
      "dropZone": "藤岡スカイダイビングクラブ",
      "status": "hold",
      "temperatureC": 14,
      "windSpeedMps": 11.6,
    },
  ];
}

const Duration _latency = Duration(milliseconds: 900);
const int _jitterMillis = 400;

/// 每 N 次请求失败一次，给错误态一个稳定的复现路径。
const int _failEvery = 5;
