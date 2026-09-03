import "dart:math" as math;

import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/drop_zone.dart";
import "package:sky_dive/features/flight/domain/load_participant.dart";
import "package:sky_dive/features/flight/domain/participant_role.dart";

part "load.freezed.dart";

/// 一条航线（load）：某个跳伞点、某个时刻、某架飞机的一次爬升。
///
/// 跳伞行业里 load 是**排班的最小单位**——名额、名单、起飞时刻都挂在它上面。
/// 顾客与摄影师的名额刻意分成两个字段而不是一个总数：两者占的不是同一种位置
/// （顾客占伞位并计费，摄影师是随行位），共用一个总数会出现"摄影师把伞位吃光"
/// 这种排班事故。
@freezed
abstract class Load with _$Load {
  const factory Load({
    required String id,

    /// 航线代号 / 呼号（如 `L-204`）。排班板上叫它、对讲机里也叫它。
    required String code,

    /// 跳伞地点。
    required DropZone dropZone,

    /// 计划起飞时刻（本地时区）。
    required DateTime departureAt,

    /// 机型（如 `Cessna 208B`）。
    required String aircraft,

    /// 出舱高度（英尺）。行业统一用英尺。
    required int altitudeFt,

    /// 顾客名额上限。
    required int customerCapacity,

    /// 摄影师名额上限。
    required int photographerCapacity,

    /// 已分配的名单（顾客 + 摄影师混在一起，按 [ParticipantRole] 区分）。
    @Default(<LoadParticipant>[]) List<LoadParticipant> participants,
  }) = _Load;

  const Load._();

  /// 某个角色已在名单上的人。保持后端下发的顺序（= 分配顺序，即登机顺序）。
  List<LoadParticipant> participantsOf(ParticipantRole role) =>
      participants.where((p) => p.role == role).toList(growable: false);

  /// 某个角色的名额上限。
  int capacityOf(ParticipantRole role) => switch (role) {
    ParticipantRole.customer => customerCapacity,
    ParticipantRole.photographer => photographerCapacity,
  };

  /// 某个角色已占用的名额。
  int assignedCountOf(ParticipantRole role) => participantsOf(role).length;

  /// 某个角色的剩余名额。
  ///
  /// 用 `max(0, ...)` 兜底：运营方把上限往下调到低于已分配人数时（后端允许的话），
  /// 剩余名额算出来会是负数，UI 上"剩 -2 位"没有任何意义。
  int seatsLeftOf(ParticipantRole role) =>
      math.max(0, capacityOf(role) - assignedCountOf(role));

  /// 某个角色是否已满。
  bool isFullOf(ParticipantRole role) => seatsLeftOf(role) <= 0;

  /// 顾客位是否已满。列表上的"满员"角标只看顾客——摄影师位满不影响客人下单。
  bool get isSoldOut => isFullOf(ParticipantRole.customer);

  /// 名单是否为空（一个人都还没排）。
  bool get hasNobody => participants.isEmpty;

  /// 名单上有没有这个人（按人的 id）。客人视角靠它判断"我约过没有"。
  bool hasParticipant(String participantId) =>
      participants.any((p) => p.id == participantId);

  /// 相对 [now] 是否已经起飞。已起飞的航线不再接受分配与改期，只用于回看。
  bool hasDepartedBy(DateTime now) => departureAt.isBefore(now);

  /// 搜索用的可匹配文本：代号 + 地点 + 机型。
  ///
  /// 刻意**不**把名单里的人名并进来：排班的人搜"藤岡"是想找场地的航线，
  /// 若某条航线上恰好有位客人叫藤岡，把它一起搜出来只会干扰。
  String get searchText => "$code ${dropZone.searchText} $aircraft";
}

/// 从一批航线里按 id 找一条，没有则返回 null。
///
/// 详情页 / 表单页都靠它从列表状态里取自己那条（页面按 id 订阅，不传对象），
/// 各写一遍 for 循环只会散在四五个文件里。
Load? findLoadById(List<Load>? loads, String loadId) {
  if (loads == null) return null;
  for (final load in loads) {
    if (load.id == loadId) return load;
  }
  return null;
}
