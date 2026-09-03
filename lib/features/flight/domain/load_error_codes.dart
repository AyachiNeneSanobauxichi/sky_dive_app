import "package:sky_dive/core/error/index.dart";

/// 航线相关的后端业务错误码（`Failure.business` 携带的 `code`）。
///
/// 页面要区分"这次失败是规则拦下的"（名额满、重复分配）和"系统出问题了"：
/// 前者是可预期的正常业务分支，要用具体文案讲清楚下一步；后者才提示重试。
/// 判断只能靠码，不能靠文案匹配——文案会随 locale 变。
///
/// ⚠️ 当前码值来自 `data/mock/` 的假后端。
// TODO(flight): 真实后端接入后按 `flight.api.md` 的错误码表校对这张表。
abstract final class LoadErrorCode {
  /// 该角色的名额已满。
  static const int loadFull = 20001;

  /// 这个人已经在本航线名单上。
  static const int alreadyAssigned = 20002;

  /// 航线不存在（多半是别人刚删掉，本地列表还没刷新）。
  static const int loadNotFound = 20003;

  /// 名额上限不能低于已分配人数。
  static const int capacityBelowAssigned = 20004;

  /// 这次失败是否"航线已经不在了"——是则要把本地列表里那条也拿掉，
  /// 否则用户会对着一条幽灵航线反复操作反复失败。
  static bool isLoadGone(Object error) => switch (error) {
    BusinessFailure(:final code) => code == loadNotFound,
    _ => false,
  };
}
