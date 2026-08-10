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
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 已生成故事的全量列表（`agent/service/story-history/story-history.md` v2）。
///
/// ## 分类 tab
/// 全部 / 短篇 / 中篇 / 长篇 / 收藏。篇幅由**服务端**过滤（不是在客户端筛已加载的
/// 那几页——"当前页恰好没有短篇"会被读成"我没写过短篇"）；收藏走另一个端点。
/// 每个分类各自维护分页与滚动位置（控制器按分类分家 + [AutomaticKeepAliveClientMixin]），
/// 切回来不重新加载、不跳回顶部。
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

class _StoryHistoryScreenState extends ConsumerState<StoryHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: StoryScriptFilter.values.length,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    // chip 的选中态跟着 TabBarView 的滑动走，所以要监听索引变化重建那一行。
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() => setState(() {});

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storyHistoryTitle)),
      body: HappyStarfieldBackground(
        intensity: _backgroundIntensity,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _FilterChips(
                filters: StoryScriptFilter.values,
                currentIndex: _tabController.index,
                onSelected: (index) {
                  HapticFeedback.selectionClick();
                  _tabController.animateTo(index);
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    for (final filter in StoryScriptFilter.values)
                      _FilterPage(filter: filter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 分类切换条。
///
/// 用 chip 而不是 Material 的 `TabBar`：那条下划线指示器是"页签"的语言，
/// 而这五个是**筛选条件**——填充式 chip 更接近"已选中的过滤器"这个心智。
class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<StoryScriptFilter> filters;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: HappySemanticSpacing.screenPadding,
        vertical: HappySpacing.s8,
      ),
      child: Row(
        spacing: HappySpacing.s8,
        children: <Widget>[
          for (final (index, filter) in filters.indexed)
            _FilterChip(
              label: filterLabelOf(l10n, filter),
              // 收藏那一格带个星，和卡片右上角的星标是同一个符号——
              // 用户不用读文字就知道这一格装的是什么。
              icon: filter.isFavoriteOnly ? LucideIcons.star : null,
              selected: index == currentIndex,
              onTap: () => onSelected(index),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HappyRadius.chip),
        child: AnimatedContainer(
          duration: HappyMotion.fast,
          curve: HappyMotion.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: HappySpacing.s16,
            vertical: HappySpacing.s8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: _chipSelectedAlpha)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(HappyRadius.chip),
            border: Border.all(
              color: selected
                  ? scheme.primary
                  : scheme.outlineVariant.withValues(alpha: _chipBorderAlpha),
              width: HappyBorderWidth.hairline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: HappySpacing.s4,
            children: <Widget>[
              if (icon case final IconData value)
                Icon(
                  value,
                  size: HappyIconSize.xs,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 一个分类下的列表。
///
/// 独立成 widget（而不是让外层按当前分类渲染一个列表）有两个用处：
/// 每个分类有自己的 `ScrollController`（切回来还停在原处），
/// 以及 keepAlive 让它在 TabBarView 里不被销毁。
class _FilterPage extends ConsumerStatefulWidget {
  const _FilterPage({required this.filter});

  final StoryScriptFilter filter;

  @override
  ConsumerState<_FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends ConsumerState<_FilterPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

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

  StoryHistoryController get _notifier =>
      ref.read(storyHistoryControllerProvider(widget.filter).notifier);

  /// 快到底就预取。滚动回调一秒来几十次，控制器自己有闸挡重复触发。
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - _prefetchExtent) return;
    _notifier.loadMore();
  }

  Future<void> _toggleFavorite(String id, AppLocalizations l10n) async {
    try {
      await _notifier.toggleFavorite(id);
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
      await _notifier.deleteScript(script.id);
      if (!mounted) return;
      HappyToast.success(context, l10n.storyHistoryDeleted);
    } on Object catch (e) {
      if (!mounted) return;
      HappyToast.error(context, _messageOf(e, l10n));
    }
  }

  String _messageOf(Object error, AppLocalizations l10n) =>
      error is Failure ? error.displayMessage : l10n.storyHistoryLoadFailed;

  /// 空态的出路：去创作页写一篇。
  ///
  /// 不写 `pop()`——从「收藏」的空态退回上一页多半不是用户想要的下一步，而且深链接
  /// 直接落到这一页时栈里没有上一页，`pop` 会让按钮点了没反应。
  void _goWrite() => context.goNamed(RouteName.story);

  @override
  Widget build(BuildContext context) {
    super.build(context); // keepAlive 要求
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(storyHistoryControllerProvider(widget.filter));
    final notifier = _notifier;

    return RefreshIndicator(
      onRefresh: notifier.reload,
      child: switch (history) {
        AsyncData(:final value) when value.scripts.isEmpty => _EmptyList(
          filter: widget.filter,
          onGoWrite: _goWrite,
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
        theme: "心愿原文的占位文字",
        style: "文风",
        length: StoryLength.medium,
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
            timeLabel: storyRelativeTimeOf(
              l10n,
              script.createdAt,
              locale: locale,
            ),
            emptyTitleLabel: l10n.storyHistoryUntitled,
            favoriteLabel: script.isFavorited
                ? l10n.storyHistoryUnfavorite
                : l10n.storyHistoryFavorite,
            lengthLabel: lengthLabelOf(l10n, script.length),
            onTap: () => context.pushNamed(
              RouteName.storyHistoryDetail,
              queryParameters: <String, String>{RouteQuery.scriptId: script.id},
            ),
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

/// 空态。
///
/// 三种分类三套说法：一篇都还没写 / 这个篇幅还没写过 / 还没收藏过。都用同一句
/// 「去写一篇」收尾——不管是哪一格空着，用户接下来能做的事都是同一件。
class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.filter, required this.onGoWrite});

  final StoryScriptFilter filter;
  final VoidCallback onGoWrite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lengthName = lengthLabelOf(l10n, filter.length);

    final (icon, title, description) = switch (filter) {
      StoryScriptFilter.favorite => (
        LucideIcons.star,
        l10n.storyHistoryEmptyFavoriteTitle,
        l10n.storyHistoryEmptyFavoriteBody,
      ),
      StoryScriptFilter.all => (
        LucideIcons.bookOpen,
        l10n.storyHistoryEmptyTitle,
        l10n.storyHistoryEmptyBody,
      ),
      _ => (
        LucideIcons.bookOpen,
        l10n.storyHistoryEmptyLengthTitle(lengthName ?? ""),
        l10n.storyHistoryEmptyLengthBody(lengthName ?? ""),
      ),
    };

    // 空态也要能下拉刷新（外层是 RefreshIndicator），所以套一层可滚动容器。
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: MediaQuery.sizeOf(context).height * _emptyHeightRatio,
          child: HappyEmptyState(
            icon: icon,
            title: title,
            description: description,
            actionLabel: l10n.storyHistoryEmptyGoWrite,
            onAction: onGoWrite,
          ),
        ),
      ],
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

/// 选中 chip 的底色透明度与未选中描边的浓淡。
const double _chipSelectedAlpha = 0.16;
const double _chipBorderAlpha = 0.5;

/// 空态占屏幕高度的比例。给足高度让插画居中，但仍留出可下拉的余量。
const double _emptyHeightRatio = 0.7;

/// 这一页的星野强度：长列表要的是安静。
const double _backgroundIntensity = 0.4;
