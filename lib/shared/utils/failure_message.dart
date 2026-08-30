import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";

/// [Failure] → 用户可见文案（已本地化）。
///
/// ## 为什么不用 `Failure.displayMessage`
/// `core/error/failure.dart` 上那个扩展是**给 core 自己兜底**的，文案写死在代码里、
/// 不随语言切换。而本产品同时服务日/英/中三种客人，错误提示是最不能夹生的地方
/// ——看不懂错误的人只会直接卸载。所以 UI 一律走这里。
///
/// ## 文案原则
/// 每一条都要回答"我现在能做什么"，而不是"发生了什么技术故障"。
/// 业务码（[BusinessFailure]）优先用**服务端下发的文案**：只有服务端知道
/// 这个具体的码意味着什么，客户端穷举不完。
String localizedFailureMessage(Object error, AppLocalizations l10n) {
  if (error is! Failure) return l10n.errorGeneric;

  return switch (error) {
    NetworkFailure() => l10n.errorNetwork,
    ServerFailure(:final message) => message ?? l10n.errorServer,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    BusinessFailure(:final message) => message ?? l10n.errorGeneric,
    UnknownFailure() => l10n.errorGeneric,
  };
}
