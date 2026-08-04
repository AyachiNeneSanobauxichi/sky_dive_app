import "package:happy_os/features/track/data/index.dart";
import "package:happy_os/features/track/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "track_list_controller.g.dart";

/// 轨迹列表控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/track/track.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
///
/// **列表始终整体持有、筛选在 UI 层做**：标签筛选切换必须是瞬时的（点一下 chip
/// 要立刻出结果），不能每次都回一趟数据源；真接口上分页后再把筛选下推到查询参数。
// TODO(track): track.api.md 定稿后改为经 Repository 取数（筛选下推成查询参数），
//   并删除 data/mock/。
@riverpod
class TrackListController extends _$TrackListController {
  @override
  Future<List<TrackEntry>> build() => TrackMockApi.fetchEntries();

  /// 重新拉取（错误态重试 / 下拉刷新共用）。
  ///
  /// 下拉刷新时**不**把 state 置回 loading：已有轨迹要留在原地，
  /// 否则一刷新整页变骨架，用户会以为记录丢了。
  Future<void> reload({bool showSkeleton = false}) async {
    if (showSkeleton) state = const AsyncLoading<List<TrackEntry>>();
    state = await AsyncValue.guard(TrackMockApi.fetchEntries);
  }
}
