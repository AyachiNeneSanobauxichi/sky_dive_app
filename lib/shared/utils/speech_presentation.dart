import "package:flutter/widgets.dart";
import "package:happy_os/core/speech/index.dart";
import "package:happy_os/l10n/app_localizations.dart";

/// 语音识别的"怎么说给用户听"这一层。
///
/// 单独抽出来是因为**有两个入口**（故事页的按住说话、生成页的心愿输入），
/// 而"没权限"和"设备不支持"该说什么、识别用哪个 locale，两处必须一模一样——
/// 各写一份的结果就是两处文案迟早不一致。
///
/// 这里只做映射，不碰识别本身（那是 `SpeechRecognizer` 的事）。

/// 把不可用的原因翻译成一句给用户看的话。
///
/// 两种原因给的**出路**不同，所以不能合并成一句"语音不可用"：
/// 没权限是用户能解决的（去设置里开），设备不支持是解决不了的（只能改用手打）。
String speechMessageOf(
  AppLocalizations l10n,
  SpeechAvailability availability,
) => switch (availability) {
  // ready 不该走到这里（调用方只在失败时才问），兜底给"不支持"这条更保守的话。
  SpeechAvailability.ready ||
  SpeechAvailability.unavailable => l10n.speechUnavailable,
  SpeechAvailability.permissionDenied => l10n.speechPermissionDenied,
};

/// 取当前界面语言对应的识别 locale（如 `zh_CN`）。
///
/// 不用 `toLanguageTag()`：它会给出 `zh-Hans-CN` 这类带书写系统的标签，而识别引擎
/// 的语言列表用的是 `语言_地区`。这里拼成引擎认得的形状，具体能不能用、要不要回落
/// 到系统默认，交给 `SpeechRecognizer` 按设备实际装的语言包决定。
String speechLocaleIdOf(BuildContext context) {
  final locale = Localizations.localeOf(context);
  final country = locale.countryCode;
  return country == null || country.isEmpty
      ? locale.languageCode
      : "${locale.languageCode}_$country";
}
