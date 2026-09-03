/// 航线的业务规则常量。
///
/// 集中在这里而不是散落在表单里：上限值同时被"表单校验"和"分配名单时的
/// 兜底判断"用到，两处各写一份迟早会对不上（一处允许 20 人、另一处允许 12 人，
/// 结果是分配接口报错但表单说没问题）。
// TODO(flight): 上限区间与高度档位应由后端按机型下发（塞斯纳和皮拉图斯载客数不同），
//   `flight.api.md` 定稿后改为服务端配置，这里只留兜底默认值。
abstract final class LoadRules {
  /// 航线代号（呼号）最大长度。排班板上要能一眼扫完，太长就失去代号的意义。
  static const int codeMaxLength = 12;

  /// 机型名称最大长度。
  static const int aircraftMaxLength = 32;

  /// 顾客名额区间。下限是 1——一条一个客人都上不了的航线没有存在意义。
  static const int minCustomerCapacity = 1;
  static const int maxCustomerCapacity = 24;

  /// 摄影师名额区间。下限是 0：很多航线不配摄影师。
  static const int minPhotographerCapacity = 0;
  static const int maxPhotographerCapacity = 6;

  /// 新建航线的默认名额（按塞斯纳 208 的常见排班取值）。
  static const int defaultCustomerCapacity = 8;
  static const int defaultPhotographerCapacity = 2;

  /// 可选的出舱高度档位（英尺）。跳伞行业统一用英尺，不要换算成米。
  static const List<int> altitudeOptions = <int>[
    4000,
    8000,
    10000,
    12000,
    14000,
  ];

  /// 新建航线的默认高度（体验跳的常规档位）。
  static const int defaultAltitudeFt = 14000;

  /// 新建航线时，默认起飞时刻距当前的偏移。
  ///
  /// 排班几乎不会"现在就起飞"，给一个明天上午的合理默认值，
  /// 比让用户从当前时刻改起省好几步。
  static const Duration defaultDepartureOffset = Duration(days: 1);

  /// 默认起飞时刻（小时）。日本的跳伞场地基本都是上午第一班最稳。
  static const int defaultDepartureHour = 9;
}
