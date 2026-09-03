import "package:sky_dive/features/flight/domain/load.dart";

/// 航线列表的时间排序方式。
///
/// 只提供按时间排的两个方向：航线本质上是时刻表，按名称或地点排都读不出
/// "接下来该飞哪一班"。默认最早优先——当天排班永远从最近的一班看起。
enum LoadSort {
  /// 起飞时刻由早到晚（默认）。
  departureAsc,

  /// 起飞时刻由晚到早。用于回看今天已经飞完的班次。
  departureDesc;

  /// 排序比较器。
  int compareLoads(Load a, Load b) {
    final byTime = a.departureAt.compareTo(b.departureAt);
    // 同一时刻起飞的两条航线（不同场地）用代号兜底定序：
    // 没有稳定的次序，列表每次刷新都会自己抖一下。
    final tie = byTime != 0 ? byTime : a.code.compareTo(b.code);
    return this == LoadSort.departureAsc ? tie : -tie;
  }
}
