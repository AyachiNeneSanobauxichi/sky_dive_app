/// 航线上的人的角色。
///
/// 只分两类是有意为之：**顾客占的是伞位，摄影师占的是随行位**，两者的上限、
/// 排班规则、计费方式都不一样，所以不能合并成一个"人数"。教练暂不在此列
/// ——教练是跟着顾客走的（体验跳一对一），排班在教练系统里，不占航线名额。
// TODO(flight): 若后续要把教练也纳入航线名额，在此扩展角色并同步上限设置。
enum ParticipantRole {
  /// 顾客（跳伞者）。
  customer,

  /// 随行摄影师。
  photographer;

  /// 后端取值 ↔ 枚举。认不出的角色一律当顾客处理：宁可让运营方在名单里看到
  /// 一个多出来的顾客并手动纠正，也不要静默丢人（丢了就没人发现少了个位置）。
  static ParticipantRole fromRaw(String? raw) => switch (raw) {
    "photographer" => ParticipantRole.photographer,
    _ => ParticipantRole.customer,
  };

  /// 枚举 → 后端取值。
  String get raw => switch (this) {
    ParticipantRole.customer => "customer",
    ParticipantRole.photographer => "photographer",
  };
}
