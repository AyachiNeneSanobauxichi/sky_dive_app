import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/flight/controllers/flight_providers.dart";
import "package:sky_dive/features/flight/data/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "load_list_controller.g.dart";

/// 航线列表状态与增删改。
///
/// ## 为什么写操作不把 state 打回 loading
/// 新建 / 编辑 / 分配都是**局部**变化，把整个列表打回 `AsyncLoading` 会让屏幕
/// 上已经在看的内容整块变回骨架——用户只是给一条航线加了个人，凭什么整页闪一下。
/// 所以这里统一"拿服务端返回的那条航线，就地替换本地那条"，忙碌态由发起操作的
/// 按钮自己承担（`SkyButton.isLoading`）。
///
/// ## 为什么失败时不设 AsyncError
/// 同理：失败了就把异常抛给调用方去弹 toast，列表内容留在原地。
/// 网络抖一下就把整页已加载的航线清成错误页，是在惩罚用户。
/// 唯一例外是 [LoadErrorCode.loadNotFound]——那条航线**确实**不在了，
/// 必须从本地列表里拿掉，否则用户会对着一条幽灵航线反复操作反复失败。
@riverpod
class LoadListController extends _$LoadListController {
  @override
  Future<List<Load>> build() =>
      ref.watch(flightRepositoryProvider).fetchLoads();

  FlightRepository get _repo => ref.read(flightRepositoryProvider);

  /// 下拉刷新 / 失败重试。
  ///
  /// 不用 `ref.invalidateSelf()`：后者会把状态打回 loading 并丢掉当前数据，
  /// 刷新时列表会整块闪成骨架。
  ///
  /// 失败时也**不**把已有列表打回错误态，而是把失败原样抛给调用方去弹提示——
  /// 满屏航线因为一次网络抖动被清成错误页，是在惩罚用户。首屏就失败的情况由
  /// [build] 产出 `AsyncError`，那时列表本来就是空的，整页错误态才合理。
  Future<void> refresh() async {
    state = AsyncData(await _repo.fetchLoads());
  }

  /// 新建航线。返回新建出来的航线，供调用方做成功提示。
  Future<Load> create(LoadDraft draft) async {
    final created = await _repo.createLoad(draft);
    state = AsyncData(<Load>[..._current, created]);
    return created;
  }

  /// 编辑航线。
  ///
  /// 名字用 `edit` 而不是 `update`：`AsyncNotifier` 基类已经有一个语义完全不同的
  /// `update`（对当前值做变换），重名会把它覆盖掉。
  Future<Load> edit(LoadDraft draft) =>
      _mutate(draft.id!, () => _repo.updateLoad(draft));

  /// 删除航线。
  Future<void> delete(String loadId) async {
    try {
      await _repo.deleteLoad(loadId);
    } on Failure catch (failure) {
      // 已经被别人删掉了：本地也拿掉，然后照常上抛让页面提示一句。
      if (LoadErrorCode.isLoadGone(failure)) _removeLocally(loadId);
      rethrow;
    }
    _removeLocally(loadId);
  }

  /// 把某人排进航线名单。
  Future<Load> assign({
    required String loadId,
    required LoadParticipant participant,
  }) => _mutate(
    loadId,
    () => _repo.assignParticipant(loadId: loadId, participant: participant),
  );

  /// 把某人移出航线名单。
  Future<Load> unassign({
    required String loadId,
    required String participantId,
  }) => _mutate(
    loadId,
    () => _repo.removeParticipant(loadId: loadId, participantId: participantId),
  );

  /// 重排某个角色的名单顺序（= 登机 / 出舱顺序）。
  ///
  /// 拖拽结束就发请求、**不等服务端**再动 UI：`ReorderableListView` 松手那一刻
  /// 已经把行挪到位了，等 600ms 再让它跳一下是最差的观感。失败时 [_mutate]
  /// 会用服务端返回的真实顺序覆盖回来，调用方再弹一条提示。
  Future<Load> reorder({
    required String loadId,
    required ParticipantRole role,
    required List<String> participantIds,
  }) => _mutate(
    loadId,
    () => _repo.reorderParticipants(
      loadId: loadId,
      role: role,
      participantIds: participantIds,
    ),
  );

  /// 取本地某条航线的最新状态（详情页打开期间列表可能已被别处更新）。
  Load? loadById(String loadId) => findLoadById(_current, loadId);

  List<Load> get _current => state.asData?.value ?? const <Load>[];

  /// 执行一次"返回整条航线"的写操作，并就地替换本地那条。
  Future<Load> _mutate(String loadId, Future<Load> Function() action) async {
    try {
      final updated = await action();
      state = AsyncData(<Load>[
        for (final load in _current)
          if (load.id == updated.id) updated else load,
      ]);
      return updated;
    } on Failure catch (failure) {
      if (LoadErrorCode.isLoadGone(failure)) _removeLocally(loadId);
      rethrow;
    }
  }

  void _removeLocally(String loadId) {
    state = AsyncData(<Load>[
      for (final load in _current)
        if (load.id != loadId) load,
    ]);
  }
}
