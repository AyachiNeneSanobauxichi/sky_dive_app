import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/index.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_history/controllers/index.dart";
import "package:happy_os/features/story_history/domain/index.dart";
import "package:happy_os/features/story_history/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 已生成故事的全量列表（`agent/service/story-history/story-history.md` v1）。
///
/// ## 无限滚动，不放「加载更多」按钮
/// 翻历史是个连续动作，中间插一个要点的按钮等于每翻一页都打断一次。滚到**距底部
/// 还有一屏**时就预取下一页（[_prefetchExtent]），下一页在用户滚到底之前多半已经到了。
///
/// ## 三种失败分开处理
/// 首屏失败=整页重试卡；翻页失败=列表底部一行重试，**已看到的内容不动**；
/// 删除/收藏失败=toast + 回滚。把它们混成一种会让"下一页没拿到"毁掉整页阅读。
///
/// 深入页，盖住底部 tab 栏：翻长列表时不需要 tab 栏占着一条高度。
class StoryHistoryScreen extends ConsumerStatefulWidget {
  const StoryHistoryScreen({super.key});

  @override
  ConsumerState<StoryHistoryScreen> createState() => _StoryHistoryScreenState();
}

class _StoryHistoryScreenState extends ConsumerState<StoryHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// 快到底就预取。滚动回调一秒来几十次，控制器自己有闸挡重复触发。
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - _prefetchExtent) return;
    ref.read(storyHistoryControllerProvider.notifier).loadMore();
  }

  Future<void> _toggleFavorite(String id, AppLocalizations l10n) async {
    try {
      await ref
          .read(storyHistoryControllerProvider.notifier)
          .toggleFavorite(id);
    } on Object catch (e) {
      if (!mounted) return;
      HappyToast.error(context, _messageOf(e, l10n));
    }
  }

  /// 删除：先二次确认，再删。
  ///
  /// **没有"撤销"**：服务端 `DELETE` 是真删，做一个撤销按钮却撤不回来是骗人。
  /// 所以把成本放在动作**之前**（确认），而不是之后。
  Future<void> _confirmDelete(StoryScript script, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.storyHistoryDeleteTitle),
        content: Text(l10n.storyHistoryDeleteBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: Text(l10n.storyHistoryDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    HapticFeedback.mediumImpact();
    try {
      await ref
          .read(storyHistoryControllerProvider.notifier)
          .deleteScript(script.id);
      if (!mounted) return;
      HappyToast.success(context, l10n.storyHistoryDeleted);
    } on Object catch (e) {
      if (!mounted) return;
      HappyToast.error(context, _messageOf(e, l10n));
    }
  }

  String _messageOf(Object error, AppLocalizations l10n) =>
      error is Failure ? error.displayMessage : l10n.storyHistoryLoadFailed;

  /// 空态的出路：回创作页。
  ///
  /// 不能只写 `pop()`——深链接直接落到这一页时栈里没有上一页，`pop` 会把用户留在
  /// 原地（空态按钮点了没反应，正是规范里禁止的那种"能点但没用"）。
  void _backToStory() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(RouteName.story);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(storyHistoryControllerProvider);
    final notifier = ref.read(storyHistoryControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storyHistoryTitle)),
      body: HappyStarfieldBackground(
        intensity: _backgroundIntensity,
        child: RefreshIndicator(
          onRefresh: notifier.reload,
          child: switch (history) {
            AsyncData(:final value) when value.scripts.isEmpty => _EmptyList(
              onBack: _backToStory,
            ),
            AsyncData(:final value) => _List(
              page: value,
              scrollController: _scrollController,
              isLoadingMore: notifier.isLoadingMore,
              loadMoreFailure: notifier.loadMoreFailure,
              onLoadMoreRetry: notifier.loadMore,
              onToggleFavorite: (script) => _toggleFavorite(script.id, l10n),
              onDelete: (script) => _confirmDelete(script, l10n),
            ),
            AsyncError(:final error) => _ErrorList(
              message: _messageOf(error, l10n),
              onRetry: () => notifier.reload(showSkeleton: true),
            ),
            _ => Skeletonizer(
              child: _List(
                page: _skeletonPage,
                scrollController: null,
                isLoadingMore: false,
                loadMoreFailure: null,
                onLoadMoreRetry: _noop,
                onToggleFavorite: _ignoreScript,
                onDelete: _ignoreScript,
              ),
            ),
          },
        ),
      ),
    );
  }

  static void _noop() {}
  static void _ignoreScript(StoryScript _) {}

  /// 骨架给满一屏：这一页本来就该是长列表，给三条会显得像"只有三篇"。
  static final StoryScriptPage _skeletonPage = StoryScriptPage(
    scripts: List<StoryScript>.generate(
      _skeletonCount,
      (index) => StoryScript(
        id: "sk$index",
        title: "标题占位文字",
        summary: "这里是正文摘要的占位文字，长度和真实内容差不多，骨架条才不会短一截。",
        createdAt: DateTime(2026, 8, 4),
      ),
    ),
  );
}

/// 列表本体。最后一项是"底部状态行"（加载中 / 加载失败 / 到底了），
/// 用 itemCount + 1 而不是往 Column 里塞——它必须跟着列表一起滚。
class _List extends StatelessWidget {
  const _List({
    required this.page,
    required this.scrollController,
    required this.isLoadingMore,
    required this.loadMoreFailure,
    required this.onLoadMoreRetry,
    required this.onToggleFavorite,
    required this.onDelete,
  });

  final StoryScriptPage page;

  /// 骨架态传 null：那一屏不该响应滚动，也不该触发预取。
  final ScrollController? scrollController;

  final bool isLoadingMore;
  final Failure? loadMoreFailure;
  final VoidCallback onLoadMoreRetry;
  final ValueChanged<StoryScript> onToggleFavorite;
  final ValueChanged<StoryScript> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.MMMd(locale);
    final hasFooter = page.hasMore || loadMoreFailure != null;

    // 长列表用 builder：只建可见项。
    return ListView.separated(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      itemCount: page.scripts.length + (hasFooter ? 1 : 0),
      separatorBuilder: (context, index) =>
          const SizedBox(height: HappySemanticSpacing.itemGap),
      itemBuilder: (context, index) {
        if (index >= page.scripts.length) {
          return _Footer(
            failure: loadMoreFailure,
            isLoading: isLoadingMore,
            loadingLabel: l10n.storyHistoryLoadingMore,
            retryLabel: l10n.commonRetry,
            onRetry: onLoadMoreRetry,
          );
        }

        final script = page.scripts[index];
        return Dismissible(
          key: ValueKey<String>(script.id),
          // 只允许从右往左滑：从左往右是系统返回手势的方向，两者抢会很别扭。
          direction: DismissDirection.endToStart,
          background: const _DeleteBackground(),
          // confirmDismiss 里做确认并**始终返回 false**：真正的移除交给控制器
          // （乐观更新 + 失败回滚），让 Dismissible 自己移除的话，请求失败时
          // 那一条已经被动画抹掉了，放不回来。
          confirmDismiss: (_) async {
            onDelete(script);
            return false;
          },
          child: StoryScriptCard(
            script: script,
            timeLabel: dateFormat.format(script.createdAt),
            emptyTitleLabel: l10n.storyHistoryUntitled,
            favoriteLabel: script.isFavorited
                ? l10n.storyHistoryUnfavorite
                : l10n.storyHistoryFavorite,
            // 点开该进阅读页，而不是开一次空白生成。阅读页还没做，先明说。
            // TODO(story-history): 阅读页就绪后改成带 script.id 跳过去。
            onTap: () => HappyToast.info(context, l10n.commonComingSoon),
            onToggleFavorite: () => onToggleFavorite(script),
          ),
        );
      },
    );
  }
}

/// 左滑露出的删除底衬。图标 + 文字双通道：只有一片红色说明不了要发生什么。
class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s20),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: _deleteFillAlpha),
        borderRadius: BorderRadius.circular(HappyRadius.card),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: HappySpacing.s6,
        children: <Widget>[
          Icon(LucideIcons.trash2, size: HappyIconSize.md, color: scheme.error),
          Text(
            AppLocalizations.of(context).storyHistoryDeleteConfirm,
            style: theme.textTheme.labelMedium?.copyWith(color: scheme.error),
          ),
        ],
      ),
    );
  }
}

/// 列表底部：正在加载下一页 / 加载失败可重试。
///
/// 加载态用**三点波浪**而不是转圈：这一页别处（生成页）已经用它表达"还在跑"，
/// 一个 app 里同一件事只该有一种长相。
class _Footer extends StatelessWidget {
  const _Footer({
    required this.failure,
    required this.isLoading,
    required this.loadingLabel,
    required this.retryLabel,
    required this.onRetry,
  });

  final Failure? failure;
  final bool isLoading;
  final String loadingLabel;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final error = failure;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HappySpacing.s16),
      child: Center(
        child: error != null
            ? TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.rotateCcw, size: HappyIconSize.sm),
                label: Text("${error.displayMessage} · $retryLabel"),
              )
            : isLoading
            ? HappyThinkingIndicator(label: loadingLabel)
            : const SizedBox.shrink(),
      ),
    );
  }
}

/// 空态：这一页除了列表没别的内容，所以要给一条明确的出路——回去创作。
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

/// 首屏失败：整页重试卡。仍然可下拉刷新（所以是 ListView 而不是 Center）。
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

/// 距底部还有这么多像素时就预取下一页。约等于一屏，滚到底之前多半已经到了。
const double _prefetchExtent = 600;

/// 骨架条数：给满一屏。
const int _skeletonCount = 6;

/// 删除底衬的底色透明度。用淡红而不是实红：实红那一片在深色画布上太吓人，
/// 而这只是"松手会怎样"的预告，不是已经删了。
const double _deleteFillAlpha = 0.16;

/// 这一页的星野强度：长列表要的是安静。
const double _backgroundIntensity = 0.4;
