import "dart:math";

import "package:happy_os/core/providers/index.dart";
import "package:happy_os/features/story/data/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "inspiration_controller.g.dart";

/// Story 仓库 DI：组装 DataSource（依赖全局 DioClient）。
///
// TODO(story): 生成历史接口定稿后也复用本 provider，别再各自 new 一份。
@Riverpod(keepAlive: true)
StoryRepository storyRepository(Ref ref) =>
    StoryRepository(StoryRemoteDataSource(ref.watch(dioClientProvider)));

/// 「灵感一下」控制器：从灵感池里抽几条展示，支持换一换。
///
/// 抽签逻辑放在 controller 而不是 UI：换一换要保证**和上一轮不重复**——
/// 换了一下还是同样三条，用户会以为按钮坏了。池子不够大时（少于两屏）
/// 才允许重复，否则永远换不出来。
@riverpod
class InspirationController extends _$InspirationController {
  /// 一屏展示条数。三条是实测的平衡点：够挑，又不至于让人挑不动。
  static const int _visibleCount = 3;

  final Random _random = Random();

  List<InspirationPrompt> _pool = const <InspirationPrompt>[];

  @override
  Future<List<InspirationPrompt>> build() async {
    // 一次拿全量推荐，「换一换」在本地这一池里抽——换一下就打一次接口的话，
    // 用户连点几下就是几次请求，而且慢网下会出现"点了没反应"。
    _pool = await ref.read(storyRepositoryProvider).fetchInspirations();
    return _pick(exclude: const <InspirationPrompt>[]);
  }

  /// 换一换：重新抽一组，尽量不含当前这组。
  void shuffle() {
    final current = switch (state) {
      AsyncData<List<InspirationPrompt>>(:final value) => value,
      _ => const <InspirationPrompt>[],
    };
    state = AsyncData<List<InspirationPrompt>>(_pick(exclude: current));
  }

  List<InspirationPrompt> _pick({required List<InspirationPrompt> exclude}) {
    if (_pool.length <= _visibleCount) return List.of(_pool);

    final excludedIds = exclude.map((prompt) => prompt.id).toSet();
    // 池子不足以完全避开上一组时，放宽到"允许重复"，不然会抽不满。
    final candidates = _pool.length - excludedIds.length >= _visibleCount
        ? _pool.where((prompt) => !excludedIds.contains(prompt.id)).toList()
        : List.of(_pool);

    candidates.shuffle(_random);
    return candidates.take(_visibleCount).toList();
  }
}
