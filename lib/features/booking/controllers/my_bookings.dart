import "package:sky_dive/features/flight/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "my_bookings.g.dart";

/// 我的预约：名单上有我的航线，按起飞时刻由早到晚。
///
/// 直接从**已经加载的航线列表**里筛，而不是另发一个请求（见
/// `agent/service/booking/booking.api.md` v1 的取舍）：预约就是航线名单上的
/// 一个顾客位，两边同一份真源，取消的那一刻航线剩余名额也跟着变，
/// 不会出现"我的预约里还在、航线上已经没了"这种对不上的状态。
///
/// 已起飞的行程**保留**在列表里：客人要回看自己跳过哪几班。
@riverpod
List<Load> myBookings(Ref ref) {
  final me = ref.watch(currentJumperProvider);
  if (me == null) return const <Load>[];

  final loads = ref.watch(loadListControllerProvider).asData?.value;
  if (loads == null) return const <Load>[];

  final mine = loads.where((load) => load.hasParticipant(me.id)).toList()
    ..sort((a, b) => a.departureAt.compareTo(b.departureAt));
  return List<Load>.unmodifiable(mine);
}
