import "package:happy_os/features/story_history/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";

/// 篇幅的展示名。
///
/// null 表示这一篇没有篇幅信息（早期数据），调用方**不显示这一枚徽标**，
/// 而不是显示"未知"——一列"未知"只会让人以为坏了。
String? lengthLabelOf(AppLocalizations l10n, StoryLength? length) =>
    switch (length) {
      StoryLength.short => l10n.storyHistoryFilterShort,
      StoryLength.medium => l10n.storyHistoryFilterMedium,
      StoryLength.long => l10n.storyHistoryFilterLong,
      null => null,
    };

/// 分类 chip 的展示名。
String filterLabelOf(AppLocalizations l10n, StoryScriptFilter filter) =>
    switch (filter) {
      StoryScriptFilter.all => l10n.storyHistoryFilterAll,
      StoryScriptFilter.short => l10n.storyHistoryFilterShort,
      StoryScriptFilter.medium => l10n.storyHistoryFilterMedium,
      StoryScriptFilter.long => l10n.storyHistoryFilterLong,
      StoryScriptFilter.favorite => l10n.storyHistoryFilterFavorite,
    };
