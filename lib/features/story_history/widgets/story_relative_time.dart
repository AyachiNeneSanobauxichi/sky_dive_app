import "package:happy_os/l10n/app_localizations.dart";
import "package:intl/intl.dart";

/// 历史卡片上的相对时间。
///
/// 规则（与 `story-history.md` v2 对齐）：
/// - 今天 → 「今天」
/// - 昨天 → 「昨天」
/// - 2–6 天前 → 「N 天前」
/// - 更早 → 退回本地化的月日（超过一周再看相对天数已经没体感了）
///
/// 用**日历日**差而不是小时差：凌晨 1 点写的故事，中午看还是"今天"，
/// 到了第二天凌晨才变成"昨天"——这才是人说"今天"时的意思。
String storyRelativeTimeOf(
  AppLocalizations l10n,
  DateTime createdAt, {
  DateTime? now,
  required String locale,
}) {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  final day = DateTime(createdAt.year, createdAt.month, createdAt.day);
  final days = today.difference(day).inDays;

  if (days <= 0) return l10n.storyHistoryTimeToday;
  if (days == 1) return l10n.storyHistoryTimeYesterday;
  if (days < 7) return l10n.storyHistoryTimeDaysAgo(days);
  return DateFormat.MMMd(locale).format(createdAt);
}
