import "package:happy_os/features/story/data/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "story_history_controller.g.dart";

/// 生成历史控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/story/story.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
// TODO(story): story.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。
@riverpod
class StoryHistoryController extends _$StoryHistoryController {
  @override
  Future<List<Story>> build() => StoryMockApi.fetchHistory();

  /// 重新拉取（错误态重试 / 下拉刷新共用）。
  ///
  /// 下拉刷新时**不**把 state 置回 loading：已有列表要留在原地，
  /// 否则一刷新整页变骨架，用户会以为内容丢了。
  Future<void> reload({bool showSkeleton = false}) async {
    if (showSkeleton) state = const AsyncLoading<List<Story>>();
    state = await AsyncValue.guard(StoryMockApi.fetchHistory);
  }
}
