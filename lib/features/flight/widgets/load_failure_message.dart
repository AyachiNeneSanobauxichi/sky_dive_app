import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/utils/index.dart";

/// 航线操作失败 → 用户可见文案。
///
/// 航线的业务码含义明确且稳定（满员、重复分配、航线已删、上限低于已分配），
/// 每一条都能给出**具体的下一步**，比服务端那句通用文案有用得多。
/// 码表以外的一切交给 [localizedFailureMessage] 兜底。
String loadFailureMessage(Object error, AppLocalizations l10n) {
  if (error case BusinessFailure(:final code)) {
    final known = _messageForCode(code, l10n);
    if (known != null) return known;
  }
  return localizedFailureMessage(error, l10n);
}

/// 预约 / 取消失败 → **客人**可见文案。
///
/// 同一个业务码对两种人要说不同的话：`20001`（满员）对运营是"先空出名额或调高
/// 上限"（他有权限那么做），对客人只能是"这班刚满了，换一班"。
/// 拿运营的话给客人看，等于让他去做一件他做不到的事。
String bookingFailureMessage(Object error, AppLocalizations l10n) {
  if (error case BusinessFailure(code: LoadErrorCode.loadFull)) {
    return l10n.bookingErrorFull;
  }
  return loadFailureMessage(error, l10n);
}

String? _messageForCode(int code, AppLocalizations l10n) => switch (code) {
  LoadErrorCode.loadFull => l10n.loadErrorFull,
  LoadErrorCode.alreadyAssigned => l10n.loadErrorAlreadyAssigned,
  LoadErrorCode.loadNotFound => l10n.loadErrorNotFound,
  LoadErrorCode.capacityBelowAssigned => l10n.loadErrorCapacityBelowAssigned,
  _ => null,
};
