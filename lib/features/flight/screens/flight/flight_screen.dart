import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:sky_dive/app/router/index.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/controllers/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/features/flight/widgets/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 航线 tab：航线（load）时刻表。
///
/// 一屏承载四件事：**搜**（代号 / 地点 / 机型）、**排序**（最早 / 最晚优先）、
/// **看**（按天分段、段头吸顶，已起飞的折到段末；每条给时刻、地点、机型高度、名额）、
/// **管**（运营的增删改，入口由后端下发的角色决定，见 [isLoadAdminProvider]）。
///
/// 客人视角和运营视角是同一张列表：客人少了新建 / 编辑 / 删除入口，其余一致。
/// 两套视角共用布局，长相才不会随着功能加减慢慢分叉。
class FlightScreen extends ConsumerStatefulWidget {
  const FlightScreen({super.key});

  @override
  ConsumerState<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends ConsumerState<FlightScreen> {
  /// 正在删除的航线 id。删除请求在途时把那条卡的删除键禁掉，防止连点两次。
  final Set<String> _deletingIds = <String>{};

  /// 已展开「已起飞」分组的那些天（键是日历日零点）。
  ///
  /// 状态放页面本地而不是 provider：它是纯粹的**观看姿势**，切走 tab 再回来重新
  /// 折起是对的——客人回到列表时该先看见还能约的班次。
  final Set<DateTime> _expandedDays = <DateTime>{};

  /// 整页重试（首屏失败时）在途。
  bool _isRetrying = false;

  /// 正在预约的那条航线。全局忙碌位（[selfBookingControllerProvider]）负责挡住
  /// 并发下单，但**忙碌的长相只能给被点的那一条**——整列卡片一起转圈，
  /// 用户会以为自己点错了地方。
  String? _bookingId;

  void _onCreate() => context.pushNamed(RouteName.loadCreate);

  void _onEdit(Load load) => context.pushNamed(
    RouteName.loadEdit,
    pathParameters: <String, String>{RouteParam.loadId: load.id},
  );

  void _onOpenDetail(Load load) => context.pushNamed(
    RouteName.loadDetail,
    pathParameters: <String, String>{RouteParam.loadId: load.id},
  );

  Future<void> _onDelete(Load load) async {
    final l10n = AppLocalizations.of(context);

    // 删航线会连带把名单上的人踢下来，且**不可撤销**，所以这里保留二次确认
    // （名单里移一个人是可逆的，那边用的是"先做 + 给撤销"）。
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.loadDeleteConfirmTitle(load.code)),
        content: Text(l10n.loadDeleteConfirmBody(load.participants.length)),
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
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    HapticFeedback.mediumImpact();
    setState(() => _deletingIds.add(load.id));
    try {
      await ref.read(loadListControllerProvider.notifier).delete(load.id);
      if (!mounted) return;
      SkyToast.success(context, l10n.loadDeleteSuccess(load.code));
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, loadFailureMessage(error, l10n));
    } finally {
      if (mounted) setState(() => _deletingIds.remove(load.id));
    }
  }

  /// 客人给自己预约一班。
  ///
  /// 忙碌态由 [selfBookingControllerProvider] 统一持有：客人一屏能看见好几个
  /// 预约按钮，一个全局忙碌位顺手挡掉"连点两条"这种双重下单。
  Future<void> _onBook(Load load) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _bookingId = load.id);
    try {
      final booked = await ref
          .read(selfBookingControllerProvider.notifier)
          .book(load);
      if (!mounted) return;
      SkyToast.success(context, l10n.bookingBookSuccess(booked.code));
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, bookingFailureMessage(error, l10n));
    } finally {
      if (mounted) setState(() => _bookingId = null);
    }
  }

  /// 下拉刷新与整页重试共用。失败只弹提示，不清掉已经在看的内容。
  Future<void> _refresh() async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(loadListControllerProvider.notifier).refresh();
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, loadFailureMessage(error, l10n));
    }
  }

  /// 展开 / 收起某一天的已起飞班次。
  void _onToggleDeparted(DateTime day) {
    // 展开收起是"切换"类交互，给选择档触感，和主行动的轻击区分开。
    HapticFeedback.selectionClick();
    setState(() {
      if (!_expandedDays.remove(day)) _expandedDays.add(day);
    });
  }

  Future<void> _onRetry() async {
    setState(() => _isRetrying = true);
    await _refresh();
    if (mounted) setState(() => _isRetrying = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isAdmin = ref.watch(isLoadAdminProvider);
    final state = ref.watch(loadListControllerProvider);
    final query = ref.watch(loadQueryControllerProvider);
    final days = ref.watch(visibleLoadDaysProvider);
    // 客人视角才需要这两样：我是谁（判断哪班已经约过）、有没有预约在途。
    final me = isAdmin ? null : ref.watch(currentJumperProvider);
    final isBooking = ref.watch(selfBookingControllerProvider);
    // 同一屏共用一个"现在"：否则跨零点时段头写"明天"、卡片写"今天"。
    final now = DateTime.now();
    // 吸顶段头的高度是固定值，必须跟着系统字体缩放走（delegate 自己拿不到 context）。
    final textScaler = MediaQuery.textScalerOf(context);

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            // 标题随内容滚走，工具条吸顶：搜索与排序是边滚边用的。
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SkySemanticSpacing.screenPadding,
                  SkySpacing.s24,
                  SkySemanticSpacing.screenPadding,
                  SkySpacing.none,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.flightsTitle,
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: SkySpacing.s4),
                    Text(
                      l10n.flightsSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: LoadListHeaderDelegate(
                isAdmin: isAdmin,
                onCreate: _onCreate,
                textScaler: textScaler,
              ),
            ),
            // 已经有数据就一直渲染列表——刷新失败时错误走 toast，
            // 不把满屏航线清成一张错误卡（见 LoadListController.refresh）。
            if (state.hasValue)
              if (days.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _LoadEmptyState(
                    query: query,
                    isAdmin: isAdmin,
                    onCreate: _onCreate,
                  ),
                )
              else
                ..._buildDaySlivers(
                  days: days,
                  now: now,
                  isAdmin: isAdmin,
                  me: me,
                  isBooking: isBooking,
                  textScaler: textScaler,
                  // 只有"最早优先"下，把已起飞的搬到段末才制造出时间断点。
                  hasTimelineBreak: query.sort == LoadSort.departureAsc,
                )
            else if (state case AsyncError(:final error))
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(
                    SkySemanticSpacing.screenPadding,
                  ),
                  child: SkyRetryCard(
                    message: loadFailureMessage(error, l10n),
                    retryLabel: l10n.commonRetry,
                    isRetrying: _isRetrying,
                    onRetry: _onRetry,
                  ),
                ),
              )
            else
              _LoadListSkeleton(now: now),
            // 底部导航条是浮起来的（外壳 extendBody），留出它的高度，
            // 否则最后一条永远被压在条下面。
            const SliverToBoxAdapter(child: SizedBox(height: SkySpacing.s96)),
          ],
        ),
      ),
    );
  }

  /// 按天生成「吸顶段头 + 该天的卡片」若干 sliver。
  ///
  /// 每天内部再切一刀：**未起飞的在前，已起飞的折到段末**。客人扫列表要找的是
  /// "还能约哪班"，让上午飞走的班次占着首屏前两条是信息优先级倒置；但飞走的还得
  /// 能回看（运营要对今天的账、客人要确认自己那班走没走），所以是折叠不是隐藏。
  List<Widget> _buildDaySlivers({
    required List<LoadDayGroup> days,
    required DateTime now,
    required bool isAdmin,
    required LoadParticipant? me,
    required bool isBooking,
    required TextScaler textScaler,
    required bool hasTimelineBreak,
  }) {
    final slivers = <Widget>[];

    // 逐项入场的延迟按**全局**序号算：每段都从 0 开始重新错峰的话，
    // 第二段的第一条会比第一段的最后一条先出现，看着像乱序。
    //
    // 偏移量在这里逐段累加，并且每段先 copy 成局部量再进闭包
    // ——itemBuilder 是懒调用且会重复调用的，直接读外层可变量会拿到最终值。
    var globalOffset = 0;

    for (final group in days) {
      final upcoming = <Load>[];
      final departed = <Load>[];
      for (final load in group.loads) {
        (load.hasDepartedBy(now) ? departed : upcoming).add(load);
      }
      final isExpanded = _expandedDays.contains(group.day);

      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: LoadDayHeaderDelegate(
            // 段头报的是这一天**总共**几班（含已起飞的），折叠只改看的方式，
            // 不改"今天排了几班"这个事实。
            day: group.day,
            count: group.loads.length,
            now: now,
            textScaler: textScaler,
          ),
        ),
      );

      if (upcoming.isNotEmpty) {
        final offset = globalOffset;
        globalOffset += upcoming.length;
        slivers.add(
          _buildLoadsSliver(
            key: ValueKey<DateTime>(group.day),
            loads: upcoming,
            padding: EdgeInsets.fromLTRB(
              SkySemanticSpacing.screenPadding,
              SkySemanticSpacing.itemGap,
              SkySemanticSpacing.screenPadding,
              // 后面紧跟折叠行时不再留下边距，否则两者之间会空出一大截。
              departed.isEmpty ? SkySemanticSpacing.itemGap : SkySpacing.none,
            ),
            staggerOffset: offset,
            now: now,
            isAdmin: isAdmin,
            me: me,
            isBooking: isBooking,
          ),
        );
      }

      if (departed.isEmpty) continue;

      slivers.add(
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            SkySemanticSpacing.screenPadding,
            // 整天都飞走了（当天没有未起飞的班次）时，折叠行要自己跟段头拉开距离。
            upcoming.isEmpty
                ? SkySemanticSpacing.itemGap
                : SkySemanticSpacing.labelGap,
            SkySemanticSpacing.screenPadding,
            isExpanded ? SkySpacing.none : SkySemanticSpacing.itemGap,
          ),
          sliver: SliverToBoxAdapter(
            child: LoadDepartedToggle(
              count: departed.length,
              isExpanded: isExpanded,
              onToggle: () => _onToggleDeparted(group.day),
              hasTimelineBreak: hasTimelineBreak,
            ),
          ),
        ),
      );

      if (!isExpanded) continue;

      final offset = globalOffset;
      globalOffset += departed.length;
      slivers.add(
        _buildLoadsSliver(
          key: ValueKey<String>("departed-${group.day}"),
          loads: departed,
          padding: const EdgeInsets.fromLTRB(
            SkySemanticSpacing.screenPadding,
            SkySemanticSpacing.itemGap,
            SkySemanticSpacing.screenPadding,
            SkySemanticSpacing.itemGap,
          ),
          staggerOffset: offset,
          now: now,
          isAdmin: isAdmin,
          me: me,
          isBooking: isBooking,
        ),
      );
    }

    return slivers;
  }

  /// 一组航线卡片（同一天的未起飞组、或展开后的已起飞组）。
  Widget _buildLoadsSliver({
    required Key key,
    required List<Load> loads,
    required EdgeInsets padding,
    required int staggerOffset,
    required DateTime now,
    required bool isAdmin,
    required LoadParticipant? me,
    required bool isBooking,
  }) {
    return SliverPadding(
      key: key,
      padding: padding,
      sliver: SliverList.separated(
        itemCount: loads.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SkySemanticSpacing.itemGap),
        itemBuilder: (context, index) {
          final load = loads[index];
          final delayIndex = staggerOffset + index;
          final isDeleting = _deletingIds.contains(load.id);

          return LoadCard(
                load: load,
                now: now,
                isAdmin: isAdmin,
                onTap: () => _onOpenDetail(load),
                onEdit: () => _onEdit(load),
                // 删除在途时禁用入口，防止连点两次删两回。
                onDelete: isDeleting ? null : () => _onDelete(load),
                isBooked: me != null && load.hasParticipant(me.id),
                isBooking: _bookingId == load.id,
                // 已有预约在途时其余卡片一律禁用：防的是"连点两条"。
                onBook: me == null || (isBooking && _bookingId != load.id)
                    ? null
                    : () => _onBook(load),
              )
              // key 挂在 Animate 上：入场动效只在这条卡**第一次出现**时跑，
              // 之后的重建（搜索、刷新、删别的卡）不会重播。
              .animate(key: ValueKey<String>(load.id))
              .fadeIn(
                duration: SkyMotion.normal,
                curve: SkyMotion.entrance,
                // 只给首屏几条做逐项延迟；滚动进来的卡立刻显示，
                // 否则越往下越像"卡住了"。
                delay: delayIndex < _staggerLimit
                    ? SkyMotion.stagger * delayIndex
                    : Duration.zero,
              )
              .slideY(
                begin: SkyMotion.slideOffset,
                end: 0,
                duration: SkyMotion.normal,
                curve: SkyMotion.entrance,
              );
        },
      ),
    );
  }
}

/// 逐项入场只给首屏这几条。
const int _staggerLimit = 6;

/// 空态：**搜不到** 与 **一条都没有** 是两回事，给的下一步也不同。
class _LoadEmptyState extends StatelessWidget {
  const _LoadEmptyState({
    required this.query,
    required this.isAdmin,
    required this.onCreate,
  });

  final LoadQuery query;
  final bool isAdmin;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // 搜不到：引导清掉搜索词回到全部，而不是让人对着空白发呆。
    if (query.hasKeyword) {
      return Consumer(
        builder: (context, ref, _) => SkyEmptyState(
          icon: LucideIcons.searchX,
          title: l10n.loadSearchEmptyTitle,
          description: l10n.loadSearchEmptyDescription,
          actionLabel: l10n.loadSearchClear,
          onAction: () =>
              ref.read(loadQueryControllerProvider.notifier).clearKeyword(),
        ),
      );
    }

    // 一条航线都没有。运营的下一步是"去排一班"，客人的下一步只能是等通知。
    if (isAdmin) {
      return SkyEmptyState(
        icon: LucideIcons.planeTakeoff,
        title: l10n.loadEmptyTitle,
        description: l10n.loadEmptyDescription,
        actionLabel: l10n.loadEmptyAction,
        onAction: onCreate,
      );
    }

    return SkyEmptyState(
      icon: LucideIcons.planeTakeoff,
      title: l10n.flightsEmptyTitle,
      description: l10n.flightsEmptyDescription,
      actionLabel: l10n.flightsEmptyAction,
      // 订阅开航通知还没有接口，先给轻提示而不是一个静默的死按钮。
      // TODO(flight): 接入"开航通知"订阅接口后替换。
      onAction: () => SkyToast.info(context, l10n.commonComingSoon),
    );
  }
}

/// 首屏加载骨架：用**真实的** [LoadCard] 喂占位数据，形状天然贴合真实布局。
class _LoadListSkeleton extends StatelessWidget {
  const _LoadListSkeleton({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: SkySemanticSpacing.screenPadding,
      ),
      sliver: SliverList.separated(
        itemCount: _skeletonCount,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SkySemanticSpacing.itemGap),
        itemBuilder: (_, _) => Skeletonizer(
          child: LoadCard(load: placeholderLoad(now), now: now, isAdmin: false),
        ),
      ),
    );
  }
}

const int _skeletonCount = 4;
