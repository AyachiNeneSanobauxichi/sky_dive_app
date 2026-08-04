import "dart:ui" show lerpDouble;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/track/controllers/index.dart";
import "package:happy_os/features/track/domain/index.dart";
import "package:happy_os/features/track/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// track 模块主页（v2）：人生轨迹时间线。首页第 2 个 tab。
///
/// 模块职责：**记录真实经历**（时间 / 事件 / 感受 / 结果）。这些条目是 story 改写
/// 爽文的 key——没有轨迹就没有可改写的原料，所以这一页的主行动是"再记一条"。
///
/// 页面结构：招呼语 → 标签筛选 → 按年份分组、带连线的时间线；右下角浮着「记一笔」。
/// 没有 AppBar（和 story / user 一致），第一屏留给标题与筛选。
///
/// **用 slivers 而不是 ListView**：年份标题要吸顶（见 [TrackYearHeaderDelegate]），
/// 而吸顶只有 sliver 能做。每一年包成一个 `SliverMainAxisGroup`，
/// 上一年的标题会被下一年顶走，不会越滚越多堆在顶上。
///
/// 筛选**在本地做**：点一下 chip 要立刻出结果，不能每次回一趟数据源
/// （真接口分页后再把筛选下推成查询参数，见 `TrackListController` 的 TODO）。
/// 切换时列表整体淡一下：几张长得差不多的卡片瞬间换掉，用户分不清"筛过了"
/// 还是"没生效"。
///
/// 四态齐全：加载=骨架时间线 / 空=分两种（一条都没有 vs 这个标签下没有，引导不同）/
/// 错误=内联重试卡 / 有数据=时间线。
class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({super.key});

  @override
  ConsumerState<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends ConsumerState<TrackScreen>
    with SingleTickerProviderStateMixin {
  /// 当前筛选的标签；null = 全部。
  TrackTag? _selected;

  /// 切换筛选时给列表的一次淡入。
  late final AnimationController _filterFade = AnimationController(
    duration: HappyMotion.fast,
    vsync: this,
    // 首帧就位：进页面时不该演一次"筛选切换"。
    value: 1,
  );

  /// 淡入起点。刻意不从 0 开始——从 0 起会先给一帧空列表（分支容器那一版踩过）。
  static const double _fadeFrom = 0.6;

  @override
  void dispose() {
    _filterFade.dispose();
    super.dispose();
  }

  void _onSelectTag(TrackTag? tag) {
    if (_selected == tag) return;
    setState(() => _selected = tag);
    if (!MediaQuery.disableAnimationsOf(context)) {
      _filterFade.forward(from: 0);
    }
  }

  /// 记一笔 / 点开某条轨迹：编辑页还没有，先给轻提示。
  // TODO(track): 接 track.api.md 后换成真实的记录表单（新增 + 编辑同一套），
  //   需要新增一条路由，属 infra，届时要单独确认。
  void _comingSoon() =>
      HappyToast.info(context, AppLocalizations.of(context).commonComingSoon);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(trackListControllerProvider);

    return Scaffold(
      // 透明底：让外层首页的极光背景透上来。
      backgroundColor: Colors.transparent,
      body: SafeArea(
        // 底部不留：外壳的导航条自己会让出手势条高度。
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(trackListControllerProvider.notifier).reload(),
          child: AnimatedBuilder(
            animation: _filterFade,
            builder: (context, _) {
              final t = HappyMotion.standard.transform(_filterFade.value);
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: HappySemanticSpacing.screenPadding,
                      right: HappySemanticSpacing.screenPadding,
                      top: HappySemanticSpacing.cardPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            l10n.trackTitle,
                            style: theme.textTheme.displaySmall,
                          ),
                          const SizedBox(height: HappySpacing.s8),
                          Text(
                            l10n.trackGreetingBody,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(
                            height: HappySemanticSpacing.sectionGap,
                          ),
                          // 筛选栏在加载/错误时也显示（用空计数），避免整页"跳出来"。
                          // 它**不参与淡入**：刚点过的 chip 跟着闪一下很怪。
                          TrackTagFilter(
                            selected: _selected,
                            counts: _countsOf(entries),
                            totalCount: _allOf(entries).length,
                            onSelect: _onSelectTag,
                          ),
                          const SizedBox(
                            height: HappySemanticSpacing.sectionGap,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverOpacity(
                    opacity: lerpDouble(_fadeFrom, 1, t)!,
                    sliver: SliverMainAxisGroup(
                      slivers: _timelineSlivers(context, entries),
                    ),
                  ),
                  // 给右下角的「记一笔」留出不遮挡最后一条的空间。
                  const SliverToBoxAdapter(
                    child: SizedBox(height: HappySpacing.s80),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      // 深入页的表单还没有，这颗按钮先给轻提示；位置与视觉先立住。
      floatingActionButton: TrackAddButton(
        label: l10n.trackAddAction,
        onTap: _comingSoon,
      ),
    );
  }

  /// 时间线部分的 slivers：四态各自的形态。
  List<Widget> _timelineSlivers(
    BuildContext context,
    AsyncValue<List<TrackEntry>> state,
  ) {
    final l10n = AppLocalizations.of(context);

    return switch (state) {
      AsyncData(:final value) => _dataSlivers(context, value),
      AsyncError(:final error) => <Widget>[
        _boxed(
          HappyRetryCard(
            message: error is Failure
                ? error.displayMessage
                : l10n.trackLoadFailed,
            retryLabel: l10n.commonRetry,
            onRetry: () => ref
                .read(trackListControllerProvider.notifier)
                .reload(showSkeleton: true),
          ),
        ),
      ],
      // 骨架：三条就够表达"这里是一条时间线"，铺满一屏反而像真内容。
      _ => <Widget>[
        _boxed(Skeletonizer(child: _plainList(context, _skeletonEntries))),
      ],
    };
  }

  List<Widget> _dataSlivers(BuildContext context, List<TrackEntry> all) {
    // 一条都没有 和 这个标签下没有 是两种空态：前者引导"记第一条"，
    // 后者引导"换个标签"——把用户往他真正需要的下一步推。
    if (all.isEmpty) {
      return <Widget>[_boxed(_EmptyAll(onAdd: _comingSoon))];
    }

    final filtered = _selected == null
        ? all
        : all.where((entry) => entry.tag == _selected).toList();
    if (filtered.isEmpty) {
      return <Widget>[
        _boxed(
          _EmptyFiltered(
            onClearFilter: () => _onSelectTag(null),
            onAdd: _comingSoon,
          ),
        ),
      ];
    }

    // 时间线按时间倒序：最近发生的排最上面。
    final sorted = List<TrackEntry>.of(filtered)
      ..sort((a, b) => b.happenedAt.compareTo(a.happenedAt));

    final locale = Localizations.localeOf(context).toLanguageTag();
    final yearFormat = DateFormat.y(locale);

    // 按年份分组。已经倒序排过，顺着切就是"新 → 旧"。
    final groups = <int, List<TrackEntry>>{};
    for (final entry in sorted) {
      groups
          .putIfAbsent(entry.happenedAt.year, () => <TrackEntry>[])
          .add(entry);
    }

    return <Widget>[
      for (final MapEntry<int, List<TrackEntry>> group in groups.entries)
        SliverMainAxisGroup(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: TrackYearHeaderDelegate(
                label: yearFormat.format(DateTime(group.key)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: HappySemanticSpacing.screenPadding,
              ),
              sliver: SliverList.builder(
                itemCount: group.value.length,
                itemBuilder: (context, index) => _tile(
                  context,
                  entry: group.value[index],
                  // 首/末按**整条时间线**算而不是按组：跨年的连线要连着，
                  // 按组算的话每组首尾都断一次，看起来像被截断了。
                  isFirst: sorted.first.id == group.value[index].id,
                  isLast: sorted.last.id == group.value[index].id,
                ),
              ),
            ),
          ],
        ),
    ];
  }

  /// 骨架 / 空 / 错误这几种非列表形态共用的包一层（补页面左右边距）。
  Widget _boxed(Widget child) => SliverPadding(
    padding: const EdgeInsets.symmetric(
      horizontal: HappySemanticSpacing.screenPadding,
    ),
    sliver: SliverToBoxAdapter(child: child),
  );

  Widget _plainList(BuildContext context, List<TrackEntry> entries) => Column(
    children: <Widget>[
      for (final (int index, TrackEntry entry) in entries.indexed)
        _tile(
          context,
          entry: entry,
          isFirst: index == 0,
          isLast: index == entries.length - 1,
        ),
    ],
  );

  Widget _tile(
    BuildContext context, {
    required TrackEntry entry,
    required bool isFirst,
    required bool isLast,
  }) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return TrackTimelineTile(
      key: ValueKey<String>(entry.id),
      entry: entry,
      // 组内只给月日：年份已经在吸顶标题上了，再重复一遍是噪音。
      dateLabel: DateFormat.MMMd(locale).format(entry.happenedAt),
      outcomePrefix: l10n.trackOutcomePrefix,
      pendingOutcomeLabel: l10n.trackOutcomePending,
      isFirst: isFirst,
      isLast: isLast,
      onTap: _comingSoon,
    );
  }

  List<TrackEntry> _allOf(AsyncValue<List<TrackEntry>> state) =>
      switch (state) {
        AsyncData(:final value) => value,
        _ => const <TrackEntry>[],
      };

  /// 各标签条数，给筛选 chip 用。
  Map<TrackTag, int> _countsOf(AsyncValue<List<TrackEntry>> state) {
    final counts = <TrackTag, int>{};
    for (final entry in _allOf(state)) {
      counts[entry.tag] = (counts[entry.tag] ?? 0) + 1;
    }
    return counts;
  }

  static final List<TrackEntry> _skeletonEntries = List<TrackEntry>.generate(
    3,
    (index) => TrackEntry(
      id: "sk$index",
      event: "事件占位文字，长度和真实内容差不多",
      happenedAt: DateTime(2026, 7, 30),
      feeling: "感受占位文字，一句话的长度",
      outcome: "结果占位文字，也是一句话",
      tag: TrackTag.values[index % TrackTag.values.length],
    ),
  );
}

/// 一条都没有：这一页除了时间线没别的内容，空态就是主引导位。
class _EmptyAll extends StatelessWidget {
  const _EmptyAll({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return HappyEmptyState(
      icon: LucideIcons.footprints,
      title: l10n.trackEmptyTitle,
      description: l10n.trackEmptyBody,
      actionLabel: l10n.trackEmptyAction,
      onAction: onAdd,
    );
  }
}

/// 这个标签下没有：给两条出路——换个标签，或就在这个标签下记一条。
class _EmptyFiltered extends StatelessWidget {
  const _EmptyFiltered({required this.onClearFilter, required this.onAdd});

  final VoidCallback onClearFilter;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.trackFilteredEmptyTitle,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: HappySpacing.s6),
            Text(
              l10n.trackFilteredEmptyBody,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HappySemanticSpacing.itemGap),
            Row(
              spacing: HappySemanticSpacing.itemGap,
              children: <Widget>[
                HappyButton(
                  label: l10n.trackFilteredEmptyClear,
                  size: HappyButtonSize.small,
                  variant: HappyButtonVariant.secondary,
                  isFullWidth: false,
                  onPressed: onClearFilter,
                ),
                HappyButton(
                  label: l10n.trackAddAction,
                  size: HappyButtonSize.small,
                  isFullWidth: false,
                  icon: LucideIcons.plus,
                  onPressed: onAdd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
