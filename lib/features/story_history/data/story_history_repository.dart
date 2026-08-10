import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/story_history/data/dto/index.dart";
import "package:happy_os/features/story_history/data/story_history_remote_data_source.dart";
import "package:happy_os/features/story_history/domain/index.dart";

/// story-history 仓库：DTO→Entity 映射 + 把 [AppException] 收敛成 [Failure]。
/// controller 只依赖本类，不接触 DataSource / DTO / Dio。
class StoryHistoryRepository {
  const StoryHistoryRepository(this._remote);

  final StoryHistoryRemoteDataSource _remote;

  /// 拉一页历史。
  ///
  /// [favoriteIds] 由调用方传进来而不是这里每次现拉：翻第 2、3 页时收藏集合没变，
  /// 每页都去探一次收藏列表等于把请求数翻倍。
  Future<StoryScriptPage> fetchPage({
    required int current,
    int size = defaultPageSize,
    Set<String> favoriteIds = const <String>{},
  }) => _guard(() async {
    final json = await _remote.fetchPage(current: current, size: size);
    return StoryScriptPageDto.fromJson(json).toEntity(favoriteIds);
  });

  /// 探已收藏的 id 集合。
  ///
  /// ⚠️ 这是个**绕法**：列表接口的 `EpicScriptResponse` 里没有 `isFavorited`
  /// （见 `story-history.api.md` 的契约缺口），只能另拉一次收藏列表再套上去。
  /// 只探第一页——收藏本来就是少数，探到上限也就够标出绝大多数；
  /// 探不到的那几条会显示成未收藏，点一下星标仍然能正确切换。
  // TODO(story-history): 后端在 EpicScriptResponse 补上 isFavorited 后删掉本方法，
  //   收藏态直接跟列表一起下发。
  Future<Set<String>> fetchFavoriteIds() => _guard(() async {
    final json = await _remote.fetchFavoritePage(
      current: 1,
      size: _favoriteProbeSize,
    );
    final page = StoryScriptPageDto.fromJson(json);
    return <String>{for (final record in page.records) record.id};
  });

  Future<void> deleteScript(String id) =>
      _guard(() => _remote.deleteScript(id));

  /// 切换收藏，返回切换**之后**的状态。以服务端返回的为准，不猜：
  /// 并发点两下时本地取反会和服务端对不上。
  Future<bool> toggleFavorite(String id) => _guard(() async {
    final json = await _remote.toggleFavorite(id);
    return json["isFavorited"] as bool? ?? false;
  });

  /// 统一异常收敛：底层抛的 [AppException] 转成 [Failure] 再抛出。
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AppException catch (e) {
      throw e.toFailure();
    }
  }
}

/// 每页条数。一屏大约放得下 5–6 张卡，取 10 让第一屏之后还有一页余量，
/// 用户滚到底之前下一页多半已经到了。
const int defaultPageSize = 10;

/// 收藏探测的条数上限。见 [StoryHistoryRepository.fetchFavoriteIds]。
const int _favoriteProbeSize = 100;
