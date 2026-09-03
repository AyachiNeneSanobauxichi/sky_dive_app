import "package:sky_dive/features/flight/controllers/load_list_controller.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "load_query_controller.g.dart";

/// 航线列表的搜索词与排序。
///
/// 单独一个 provider 而不是页面 `setState`：航线 tab 是常驻挂载的分支，
/// 用户切到预约页再切回来，搜索词与排序方式必须还在（规范要求 tab 切换不丢状态）。
@riverpod
class LoadQueryController extends _$LoadQueryController {
  @override
  LoadQuery build() => const LoadQuery();

  void setKeyword(String keyword) => state = state.copyWith(keyword: keyword);

  void setSort(LoadSort sort) => state = state.copyWith(sort: sort);

  void clearKeyword() => state = state.copyWith(keyword: "");
}

/// 当前查询条件下**该显示**的航线。
///
/// 过滤 + 排序放在派生 provider 里，页面只管画：Widget 里做 filter/sort 会在
/// 每次重建（包括键盘弹起这种无关重建）时重算一遍整张列表。
@riverpod
List<Load> visibleLoads(Ref ref) {
  final loads = ref.watch(loadListControllerProvider).asData?.value;
  if (loads == null) return const <Load>[];
  return ref.watch(loadQueryControllerProvider).apply(loads);
}

/// 当前查询条件下该显示的航线，**按天分好组**。
///
/// 分组也放在 provider 里：列表页每次重建（键盘弹起、搜索框输入）都重新分一遍组
/// 是白干，而且分组结果本身是"该显示什么"的一部分，属于业务而不是布局。
@riverpod
List<LoadDayGroup> visibleLoadDays(Ref ref) =>
    groupLoadsByDay(ref.watch(visibleLoadsProvider));
