import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:sky_dive/app/router/index.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/booking/controllers/index.dart";
import "package:sky_dive/features/booking/widgets/index.dart";
import "package:sky_dive/features/flight/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 预约 tab：我的行程。
///
/// 数据来自 [myBookingsProvider]——「我的预约」就是**名单上有我的航线**
/// （见 `agent/service/booking/booking.api.md` v1）。所以这一页不自己发请求，
/// 加载 / 错误态跟着航线列表走，取消预约后这里和航线的剩余名额同时更新。
class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  /// 整页重试在途。
  bool _isRetrying = false;

  /// 正在取消的那条行程。忙碌的长相只给被点的那一条，
  /// 整列卡片一起转圈会让人以为点错了地方。
  String? _cancellingId;

  void _onOpenDetail(Load load) => context.pushNamed(
    RouteName.loadDetail,
    pathParameters: <String, String>{RouteParam.loadId: load.id},
  );

  Future<void> _refresh() async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(loadListControllerProvider.notifier).refresh();
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, bookingFailureMessage(error, l10n));
    }
  }

  Future<void> _onRetry() async {
    setState(() => _isRetrying = true);
    await _refresh();
    if (mounted) setState(() => _isRetrying = false);
  }

  /// 取消行程：二次确认。位置一放出去可能立刻被别人订走，
  /// 撤销未必还原得回来——能撤的操作才配给撤销。
  Future<void> _onCancel(Load load) async {
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.bookingCancelConfirmTitle(load.code)),
        content: Text(l10n.bookingCancelConfirmBody),
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
            child: Text(l10n.bookingActionCancel),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    HapticFeedback.mediumImpact();
    setState(() => _cancellingId = load.id);
    try {
      final updated = await ref
          .read(selfBookingControllerProvider.notifier)
          .cancel(load);
      if (!mounted) return;
      SkyToast.success(context, l10n.bookingCancelSuccess(updated.code));
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, bookingFailureMessage(error, l10n));
    } finally {
      if (mounted) setState(() => _cancellingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loadListControllerProvider);
    final bookings = ref.watch(myBookingsProvider);
    final isCancelling = ref.watch(selfBookingControllerProvider);
    // 同一屏共用一个"现在"，否则跨零点时上下两条会一个写"今天"一个写"明天"。
    final now = DateTime.now();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SkySemanticSpacing.screenPadding,
              SkySpacing.s24,
              SkySemanticSpacing.screenPadding,
              SkySemanticSpacing.itemGap,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(l10n.bookingsTitle, style: theme.textTheme.displaySmall),
                const SizedBox(height: SkySpacing.s4),
                Text(
                  l10n.bookingsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              // 有数据就一直渲染列表：刷新失败走 toast，不清屏。
              AsyncValue(hasValue: true) => RefreshIndicator(
                onRefresh: _refresh,
                child: bookings.isEmpty
                    ? ListView(
                        // 空态也要能下拉刷新，所以套在可滚动容器里。
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: <Widget>[
                          SizedBox(
                            height:
                                MediaQuery.sizeOf(context).height *
                                _emptyAreaFactor,
                            child: SkyEmptyState(
                              icon: LucideIcons.ticket,
                              title: l10n.bookingsEmptyTitle,
                              description: l10n.bookingsEmptyDescription,
                              actionLabel: l10n.bookingsEmptyAction,
                              // 空态是引导位：一步跳到航线列表去挑一班。
                              onAction: () =>
                                  context.goNamed(RouteName.flights),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          SkySemanticSpacing.screenPadding,
                          SkySpacing.none,
                          SkySemanticSpacing.screenPadding,
                          // 底部导航条是浮起来的（外壳 extendBody）。
                          SkySpacing.s96,
                        ),
                        itemCount: bookings.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: SkySemanticSpacing.itemGap),
                        itemBuilder: (context, index) {
                          final load = bookings[index];
                          return BookingCard(
                                load: load,
                                now: now,
                                isCancelling: _cancellingId == load.id,
                                onTap: () => _onOpenDetail(load),
                                // 已有取消在途时其余条目禁用，防并发。
                                onCancel:
                                    isCancelling && _cancellingId != load.id
                                    ? null
                                    : () => _onCancel(load),
                              )
                              // key 挂在 Animate 上：入场只在这条**第一次出现**
                              // 时跑，之后的重建不会重播。
                              .animate(key: ValueKey<String>(load.id))
                              .fadeIn(
                                duration: SkyMotion.normal,
                                curve: SkyMotion.entrance,
                                delay: index < _staggerLimit
                                    ? SkyMotion.stagger * index
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
              ),
              AsyncError(:final error) => Padding(
                padding: const EdgeInsets.all(SkySemanticSpacing.screenPadding),
                child: SkyRetryCard(
                  message: bookingFailureMessage(error, l10n),
                  retryLabel: l10n.commonRetry,
                  isRetrying: _isRetrying,
                  onRetry: _onRetry,
                ),
              ),
              _ => _BookingListSkeleton(now: now),
            },
          ),
        ],
      ),
    );
  }
}

/// 逐项入场只给首屏这几条。
const int _staggerLimit = 6;

/// 空态占页面高度的比例（撑起来才能垂直居中，不然会缩在顶部）。
const double _emptyAreaFactor = 0.6;

/// 加载骨架：用**真实的** [BookingCard] 喂占位数据，形状天然贴合。
class _BookingListSkeleton extends StatelessWidget {
  const _BookingListSkeleton({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          SkySemanticSpacing.screenPadding,
          SkySpacing.none,
          SkySemanticSpacing.screenPadding,
          SkySpacing.s96,
        ),
        itemCount: _skeletonCount,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SkySemanticSpacing.itemGap),
        itemBuilder: (_, _) =>
            BookingCard(load: placeholderLoad(now), now: now),
      ),
    );
  }
}

const int _skeletonCount = 3;
