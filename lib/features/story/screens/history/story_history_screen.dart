import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story/controllers/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:happy_os/features/story/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 生成历史全量列表页（v2）。
///
/// story tab 首页只露**最近 5 条**（那一屏的主角是创作入口，历史只是"回头看一眼"），
/// 想翻完整清单来这里。两处共用同一个 `storyHistoryControllerProvider`——
/// 数据只拉一次，从首页点进来是**秒开**，不会再转一次。
///
/// 深入页，盖住底部 tab 栏：翻长列表时不需要 tab 栏占着一条高度。
class StoryHistoryScreen extends ConsumerWidget {
  const StoryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(storyHistoryControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storyHistoryTitle)),
      body: HappyAuroraBackground(
        intensity: 0.4,
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(storyHistoryControllerProvider.notifier).reload(),
          child: switch (history) {
            AsyncData(:final value) when value.isEmpty => _EmptyList(
              onBack: () => context.pop(),
            ),
            AsyncData(:final value) => _List(stories: value),
            AsyncError(:final error) => _ErrorList(
              message: error is Failure
                  ? error.displayMessage
                  : l10n.storyHistoryLoadFailed,
              onRetry: () => ref
                  .read(storyHistoryControllerProvider.notifier)
                  .reload(showSkeleton: true),
            ),
            _ => Skeletonizer(child: _List(stories: _skeletonStories)),
          },
        ),
      ),
    );
  }

  static final List<Story> _skeletonStories = List<Story>.generate(
    // 全量页的骨架给满一屏：这一页本来就该是长列表。
    6,
    (index) => Story(
      id: "sk$index",
      title: "标题占位文字",
      excerpt: "这里是正文摘要的占位文字，长度和真实内容差不多，骨架条才不会短一截。",
      createdAt: DateTime(2026, 8, 4),
    ),
  );
}

class _List extends StatelessWidget {
  const _List({required this.stories});

  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    // 长列表用 builder：只建可见项。
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      itemCount: stories.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: HappySemanticSpacing.itemGap),
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryHistoryCard(
          key: ValueKey<String>(story.id),
          story: story,
          timeLabel: DateFormat.MMMd(locale).format(story.createdAt),
          statusLabel: switch (story.status) {
            StoryStatus.generating => l10n.storyStatusGenerating,
            StoryStatus.failed => l10n.storyStatusFailed,
            StoryStatus.ready => "",
          },
          // 点开该进阅读页，而不是开一次空白生成。阅读页还没做，先明说。
          // TODO(story): 阅读页就绪后改成带 story.id 跳过去。
          onTap: () => HappyToast.info(context, l10n.commonComingSoon),
        );
      },
    );
  }
}

/// 全量页的空态：这一页除了列表没别的内容，所以空态要给一条明确的出路——回去创作。
class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return HappyEmptyState(
      icon: LucideIcons.bookOpen,
      title: l10n.storyHistoryEmptyTitle,
      description: l10n.storyHistoryEmptyBody,
      actionLabel: l10n.storyHistoryEmptyBackAction,
      onAction: onBack,
    );
  }
}

class _ErrorList extends StatelessWidget {
  const _ErrorList({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      children: <Widget>[
        const SizedBox(height: HappySpacing.s40),
        HappyRetryCard(
          message: message,
          retryLabel: l10n.commonRetry,
          onRetry: onRetry,
        ),
      ],
    );
  }
}
