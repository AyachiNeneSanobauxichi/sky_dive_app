import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/flight/controllers/current_jumper.dart";
import "package:sky_dive/features/flight/controllers/load_list_controller.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "self_booking_controller.g.dart";

/// 客人给**自己**预约 / 取消一条航线。
///
/// 放在 flight 而不是 booking，是为了守住模块依赖的单向：booking 消费 flight
/// 的航线（见 `references/01-project-structure.md` 的模块地图），反过来 flight
/// 不该知道 booking 的存在。而"预约"在 v1 就等于**在航线名单上占一个顾客位**，
/// 本来就是一次航线名单的写操作（见 `agent/service/booking/booking.api.md`）。
///
/// 状态是"有没有请求在途"：客人一屏能看见好几条航线的预约按钮，
/// 一个全局忙碌位顺手挡掉"连点两条"这种双重下单。
@riverpod
class SelfBookingController extends _$SelfBookingController {
  @override
  bool build() => false;

  /// 预约一条航线，返回更新后的航线。
  Future<Load> book(Load load) {
    final me = ref.read(currentJumperProvider);
    if (me == null) throw const Failure.unauthorized();
    return _run(
      () => ref
          .read(loadListControllerProvider.notifier)
          .assign(loadId: load.id, participant: me),
    );
  }

  /// 取消我在某条航线上的预约。
  Future<Load> cancel(Load load) {
    final me = ref.read(currentJumperProvider);
    if (me == null) throw const Failure.unauthorized();
    return _run(
      () => ref
          .read(loadListControllerProvider.notifier)
          .unassign(loadId: load.id, participantId: me.id),
    );
  }

  Future<Load> _run(Future<Load> Function() action) async {
    state = true;
    try {
      return await action();
    } finally {
      // 无论成败都解锁：失败后客人要能立刻再试一次（或换一班）。
      state = false;
    }
  }
}
