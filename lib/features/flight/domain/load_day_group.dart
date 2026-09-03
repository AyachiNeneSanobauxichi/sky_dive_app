import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/load.dart";

part "load_day_group.freezed.dart";

/// 同一天的一组航线。列表按天分段展示，段头吸顶。
///
/// 为什么要分组：排班板上一天就有六到十班，再跨几天，平铺列表里"今天/明天"只能
/// 写在每张卡片里，滚起来根本找不到分界。分组后段头吸顶，滚到哪天一眼知道。
@freezed
abstract class LoadDayGroup with _$LoadDayGroup {
  const factory LoadDayGroup({
    /// 这一组的日历日（零点）。
    required DateTime day,
    required List<Load> loads,
  }) = _LoadDayGroup;
}

/// 把**已排好序**的航线按日历日切成若干段。
///
/// 依赖入参有序（由 `LoadQuery.apply` 保证），所以只需线性扫一遍、不重新排序
/// ——重新排会把"最晚优先"那个方向悄悄改回来。
List<LoadDayGroup> groupLoadsByDay(List<Load> loads) {
  final groups = <LoadDayGroup>[];
  DateTime? currentDay;
  var current = <Load>[];

  for (final load in loads) {
    final day = DateTime(
      load.departureAt.year,
      load.departureAt.month,
      load.departureAt.day,
    );
    if (currentDay == null || day != currentDay) {
      if (currentDay != null) {
        groups.add(LoadDayGroup(day: currentDay, loads: current));
      }
      currentDay = day;
      current = <Load>[];
    }
    current.add(load);
  }
  if (currentDay != null) {
    groups.add(LoadDayGroup(day: currentDay, loads: current));
  }
  return List<LoadDayGroup>.unmodifiable(groups);
}
