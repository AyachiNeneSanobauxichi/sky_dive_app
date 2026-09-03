import "package:flutter/widgets.dart";
import "package:intl/intl.dart";
import "package:sky_dive/l10n/app_localizations.dart";

/// 航线相关的展示格式化。
///
/// 全部走 `intl` 并**显式传入当前 locale**：日 / 英 / 中三种客人看到的日期写法
/// 完全不同（「9月5日(金)」/「Fri, Sep 5」/「9月5日周五」），手拼格式必错。
/// locale 的日期符号由 `GlobalMaterialLocalizations` 在首帧前装好，可直接用。

/// 起飞时刻（`09:30`）。
String formatLoadTime(BuildContext context, DateTime dateTime) =>
    DateFormat.Hm(_localeOf(context)).format(dateTime);

/// 起飞日期。今天 / 明天用词而不是日期——排班当天扫时刻表时，
/// "今天"比"9月3日"少一次心算。
String formatLoadDay(
  BuildContext context,
  DateTime dateTime, {
  required DateTime now,
}) {
  final l10n = AppLocalizations.of(context);
  final days = _dayDifference(dateTime, now);
  return switch (days) {
    0 => l10n.loadDayToday,
    1 => l10n.loadDayTomorrow,
    _ => DateFormat.MMMEd(_localeOf(context)).format(dateTime),
  };
}

/// 表单里的完整日期（`2026年9月5日(金)`）。
String formatLoadDate(BuildContext context, DateTime dateTime) =>
    DateFormat.yMMMEd(_localeOf(context)).format(dateTime);

/// 出舱高度（`14,000 ft`）。千分位分隔跟随 locale。
String formatAltitude(BuildContext context, int altitudeFt) =>
    AppLocalizations.of(context).loadAltitude(
      NumberFormat.decimalPattern(_localeOf(context)).format(altitudeFt),
    );

String _localeOf(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

/// 相差几个**日历日**（不是几个 24 小时）：23:00 起飞的航线在次日 01:00 看，
/// 差值必须是 1（明天已经过去了），按小时算会得到 0（"今天"），那是错的。
int _dayDifference(DateTime target, DateTime now) {
  final a = DateTime(target.year, target.month, target.day);
  final b = DateTime(now.year, now.month, now.day);
  return a.difference(b).inDays;
}
