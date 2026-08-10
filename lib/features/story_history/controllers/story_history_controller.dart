import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/features/story_history/data/index.dart";
import "package:happy_os/features/story_history/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "story_history_controller.g.dart";

/// story-history 仓库 DI。
@Riverpod(keepAlive: true)
StoryHistoryRepository storyHistoryRepository(Ref ref) =>
    StoryHistoryRepository(
      StoryHistoryRemoteDataSource(ref.watch(dioClientProvider)),
    );

/// 历史列表控制器：分页 + 收藏 + 删除。
///
/// ## 状态怎么分的
/// **首屏**的加载/错误交给 `AsyncValue`；**加载更多**的进行态与失败放在
/// [StoryScriptPage] 之外的两个字段里（[isLoadingMore] / [loadMoreFailure]）。
/// 混在一起的话，翻第 3 页失败会把已经看到的两页一起换成错误页——用户读到一半
/// 的列表凭什么因为下一页没拿到就消失。
///
/// ## keepAlive
/// story 首页和历史全量页共用本控制器：从首页点进来是**秒开**，不会再转一次圈。
/// 两处看到的收藏/删除结果也天然一致，不存在"删了回到首页还在"。
@Riverpod(keepAlive: true)
class StoryHistoryController extends _$StoryHistoryController {
  StoryHistoryRepository get _repo => ref.read(storyHistoryRepositoryProvider);

  /// 已收藏的 id 集合。列表接口不下发收藏态，只能另探一次再套上去
  /// （见 `StoryHistoryRepository.fetchFavoriteIds`）。
  Set<String> _favoriteIds = const <String>{};

  /// 正在加载下一页。同时也是**防重复触发**的闸：滚动回调一秒能来很多次。
  bool isLoadingMore = false;

  /// 加载下一页失败的原因。非空时列表底部显示一行可点重试。
  Failure? loadMoreFailure;

  @override
  Future<StoryScriptPage> build() => _fetchFirstPage();

  Future<StoryScriptPage> _fetchFirstPage() async {
    // 收藏探测失败不该拖垮整页历史：拿不到就当没有收藏，星标全暗，
    // 点一下仍然能正确切换。
    _favoriteIds = await _repo.fetchFavoriteIds().onError(
      (_, _) => const <String>{},
    );
    return _repo.fetchPage(current: 1, favoriteIds: _favoriteIds);
  }

  /// 下拉刷新 / 错误重试：回到第一页。
  ///
  /// [showSkeleton] 只在错误重试时给 true。下拉刷新时**不**塌成骨架——
  /// 已有列表要留在原地，刷新指示器自己表达进行中。
  Future<void> reload({bool showSkeleton = false}) async {
    if (showSkeleton) state = const AsyncLoading<StoryScriptPage>();
    isLoadingMore = false;
    loadMoreFailure = null;
    state = await AsyncValue.guard(_fetchFirstPage);
  }

  /// 加载下一页。滚到底自动调，所以这里必须自己挡住重复触发与越界。
  Future<void> loadMore() async {
    final page = state.value;
    if (page == null || !page.hasMore || isLoadingMore) return;

    isLoadingMore = true;
    loadMoreFailure = null;
    // 用 copyWith 触发一次重建让底部进行态露出来。这两个标志刻意不进 Freezed 状态：
    // 它们是**瞬时的 UI 附属信息**，进了状态就得给分页数据加两个和数据无关的字段。
    state = AsyncData<StoryScriptPage>(page.copyWith());

    try {
      final next = await _repo.fetchPage(
        current: page.current + 1,
        favoriteIds: _favoriteIds,
      );
      // 拼接时按 id 去重：翻页期间有人新写了一篇，后端的偏移会整体后移一位，
      // 上一页的最后一条就会在下一页里再出现一次（列表里出现重复 key 会直接抛异常）。
      final seen = <String>{for (final script in page.scripts) script.id};
      state = AsyncData<StoryScriptPage>(
        page.copyWith(
          scripts: <StoryScript>[
            ...page.scripts,
            ...next.scripts.where((script) => seen.add(script.id)),
          ],
          current: next.current,
          total: next.total,
        ),
      );
    } on Object catch (e) {
      // 失败**不动已加载的内容**，只在底部挂一行重试。
      loadMoreFailure = e is Failure ? e : const Failure.unknown();
      state = AsyncData<StoryScriptPage>(page.copyWith());
    } finally {
      isLoadingMore = false;
    }
  }

  /// 切换收藏。
  ///
  /// 乐观更新：点下去立刻变。收藏是个轻动作，等一次网络往返才变星标会让人以为没点上，
  /// 然后再点一次——反而切回去了。失败回滚并把错误抛给调用方提示。
  Future<void> toggleFavorite(String id) async {
    final page = state.value;
    if (page == null) return;
    final target = page.scripts.where((s) => s.id == id).firstOrNull;
    if (target == null) return;

    _applyFavorite(id, !target.isFavorited);
    try {
      final result = await _repo.toggleFavorite(id);
      // 以服务端返回的为准，不信本地取反：并发点两下时两者会对不上。
      _applyFavorite(id, result);
    } on Object {
      _applyFavorite(id, target.isFavorited);
      rethrow;
    }
  }

  void _applyFavorite(String id, bool isFavorited) {
    final page = state.value;
    if (page == null) return;
    _favoriteIds = <String>{..._favoriteIds, if (isFavorited) id}
      ..removeWhere((value) => !isFavorited && value == id);
    state = AsyncData<StoryScriptPage>(
      page.copyWith(
        scripts: <StoryScript>[
          for (final script in page.scripts)
            if (script.id == id)
              script.copyWith(isFavorited: isFavorited)
            else
              script,
        ],
      ),
    );
  }

  /// 删除。
  ///
  /// 同样乐观：先从列表里拿掉，请求失败再放回**原来的位置**（不是补到末尾——
  /// 那会让用户以为顺序乱了）。服务端删除不可逆，所以调用方必须先二次确认。
  Future<void> deleteScript(String id) async {
    final page = state.value;
    if (page == null) return;
    final index = page.scripts.indexWhere((s) => s.id == id);
    if (index < 0) return;
    final removed = page.scripts[index];

    state = AsyncData<StoryScriptPage>(
      page.copyWith(
        scripts: <StoryScript>[...page.scripts]..removeAt(index),
        // 总数跟着减一，否则 hasMore 会一直是 true，滚到底反复去拉空的下一页。
        total: page.total > 0 ? page.total - 1 : 0,
      ),
    );

    try {
      await _repo.deleteScript(id);
    } on Object {
      final current = state.value;
      if (current != null) {
        state = AsyncData<StoryScriptPage>(
          current.copyWith(
            scripts: <StoryScript>[...current.scripts]
              ..insert(index.clamp(0, current.scripts.length), removed),
            total: current.total + 1,
          ),
        );
      }
      rethrow;
    }
  }
}

/// story 首页只露最近几条。取 3 而不是 5：首页的主角是创作入口，
/// 历史是"回头看一眼"，铺太多会把输入区挤出第一屏。
const int homePreviewCount = 3;
