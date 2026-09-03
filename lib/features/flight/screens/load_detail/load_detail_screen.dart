import "package:flutter/material.dart";
import "package:flutter/services.dart";
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

/// 航线详情页：航班信息 + 名额 + 名单（顾客 / 摄影师分组）。
///
/// 深链接 `/flights/:loadId`。挂在 flights 分支下，所以底部 tab 保持可见、
/// 返回栈跟着这个 tab 走——排班的人常在"航线"和"预约"之间来回跳，
/// 切回来还停在这条航线上是对的。
///
/// 管理员在这里排名单（加人 / 移人 / 改航线），客人看到同一张详情减去那些入口。
/// 角色由后端下发（见 [isLoadAdminProvider]）。
///
/// **按 id 订阅列表**而不是把 `Load` 传进来定死：加完人之后名单要在原地立刻更新，
/// 传值做不到；深链接直达时也没有对象可传。
class LoadDetailScreen extends ConsumerStatefulWidget {
  const LoadDetailScreen({super.key, required this.loadId});

  final String loadId;

  @override
  ConsumerState<LoadDetailScreen> createState() => _LoadDetailScreenState();
}

class _LoadDetailScreenState extends ConsumerState<LoadDetailScreen> {
  /// 正在被移出名单的人。按人记而不是一个全局 bool：移 A 的时候不该把 B 那行
  /// 也锁住，那会让人以为整个名单在重算。
  final Set<String> _removingIds = <String>{};

  /// 正在分配中的角色（一次只可能有一个选择器开着）。
  ParticipantRole? _assigningRole;

  void _onEdit() => context.pushNamed(
    RouteName.loadEdit,
    pathParameters: <String, String>{RouteParam.loadId: widget.loadId},
  );

  Future<void> _onAdd(Load load, ParticipantRole role) async {
    final picked = await ParticipantPickerSheet.show(
      context,
      loadId: load.id,
      role: role,
    );
    if (picked == null || !mounted) return;

    final l10n = AppLocalizations.of(context);
    setState(() => _assigningRole = role);
    try {
      final updated = await ref
          .read(loadListControllerProvider.notifier)
          .assign(loadId: load.id, participant: picked);
      if (!mounted) return;
      SkyToast.success(
        context,
        l10n.loadAssignSuccess(picked.name, updated.code),
      );
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, loadFailureMessage(error, l10n));
    } finally {
      if (mounted) setState(() => _assigningRole = null);
    }
  }

  /// 把人移出名单：**先做，再给撤销**，不弹二次确认。
  ///
  /// 移人是完全可逆的（位置立刻释放，人还在候选池里），而排班时往往要连移好几个
  /// ——每次都弹窗拦一道，是把可逆操作按不可逆的规格收费。删除航线那种不可逆的
  /// 才留二次确认。
  Future<void> _onRemove(Load load, LoadParticipant participant) async {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(loadListControllerProvider.notifier);

    setState(() => _removingIds.add(participant.id));
    try {
      final updated = await notifier.unassign(
        loadId: load.id,
        participantId: participant.id,
      );
      if (!mounted) return;
      SkyToast.success(
        context,
        l10n.loadRemoveSuccess(participant.name, updated.code),
        actionLabel: l10n.commonUndo,
        onAction: () => _undoRemove(
          loadId: load.id,
          participant: participant,
          l10n: l10n,
          notifier: notifier,
        ),
      );
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, loadFailureMessage(error, l10n));
    } finally {
      if (mounted) setState(() => _removingIds.remove(participant.id));
    }
  }

  /// 撤销一次移出：把人原样排回去。
  ///
  /// 刻意**不依赖本页还活着**——toast 停留期间用户完全可能已经返回列表，那时
  /// 撤销仍然必须生效（否则等于点了个假按钮）。所以 notifier 与文案在发起移出时
  /// 就先抓住，这里只用它们；context 相关的提示才判 [mounted]。
  ///
  /// 撤销可能失败：这几秒里位置被别人占走了。那就照实报"已满"，
  /// 不假装成功——排班板上多一个不存在的人比少一个危险得多。
  Future<void> _undoRemove({
    required String loadId,
    required LoadParticipant participant,
    required AppLocalizations l10n,
    required LoadListController notifier,
  }) async {
    try {
      final updated = await notifier.assign(
        loadId: loadId,
        participant: participant,
      );
      if (!mounted) return;
      SkyToast.success(
        context,
        l10n.loadAssignSuccess(participant.name, updated.code),
      );
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, loadFailureMessage(error, l10n));
    }
  }

  /// 客人给自己预约这一班。
  Future<void> _onBook(Load load) async {
    final l10n = AppLocalizations.of(context);
    try {
      final booked = await ref
          .read(selfBookingControllerProvider.notifier)
          .book(load);
      if (!mounted) return;
      SkyToast.success(context, l10n.bookingBookSuccess(booked.code));
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, bookingFailureMessage(error, l10n));
    }
  }

  /// 取消我在这一班上的预约。
  ///
  /// 这里用**二次确认**而不是"先做 + 撤销"（名单里运营移人用的是后者）：
  /// 位置一放出去可能立刻被别人订走，撤销未必还原得回来——能撤的操作才配给撤销。
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
    try {
      final updated = await ref
          .read(selfBookingControllerProvider.notifier)
          .cancel(load);
      if (!mounted) return;
      SkyToast.success(context, l10n.bookingCancelSuccess(updated.code));
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, bookingFailureMessage(error, l10n));
    }
  }

  /// 拖完就发请求。失败时把服务端的真实顺序覆盖回来，并说清楚原因——
  /// 顺序这种"看起来已经成了"的操作，失败必须有声音，否则运营会按着一个
  /// 只存在于自己屏幕上的登机顺序叫人。
  Future<void> _onReorder(
    Load load,
    ParticipantRole role,
    List<String> participantIds,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(loadListControllerProvider.notifier)
          .reorder(loadId: load.id, role: role, participantIds: participantIds);
    } on Object catch (error) {
      if (!mounted) return;
      SkyToast.error(context, loadFailureMessage(error, l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAdmin = ref.watch(isLoadAdminProvider);
    final state = ref.watch(loadListControllerProvider);
    // 客人视角才需要：我是谁（判断约过没有）、预约请求有没有在途。
    final me = isAdmin ? null : ref.watch(currentJumperProvider);
    final isBooking = ref.watch(selfBookingControllerProvider);
    final load = ref.watch(
      loadListControllerProvider.select(
        (value) => findLoadById(value.asData?.value, widget.loadId),
      ),
    );

    return SkyBackground(
      intensity: _backgroundIntensity,
      parallax: false,
      child: SafeArea(
        bottom: false,
        child: switch ((state, load)) {
          // 有这条航线：正常详情。
          (_, final Load found) => _LoadDetailBody(
            load: found,
            isAdmin: isAdmin,
            assigningRole: _assigningRole,
            removingIds: _removingIds,
            onBack: context.pop,
            onEdit: _onEdit,
            onAdd: (role) => _onAdd(found, role),
            onRemove: (participant) => _onRemove(found, participant),
            onReorder: (role, ids) => _onReorder(found, role, ids),
            isBooked: me != null && found.hasParticipant(me.id),
            isBooking: isBooking,
            onBook: me == null ? null : () => _onBook(found),
            onCancel: me == null ? null : () => _onCancel(found),
          ),
          // 列表还没到（深链接直达 / 冷启动）：先把框架画出来，别白屏。
          (AsyncValue(hasValue: false, hasError: false), _) =>
            const _LoadDetailSkeleton(),
          // 列表加载失败：整页重试（这时本来就没有内容可保留）。
          (AsyncError(:final error), _) => Padding(
            padding: const EdgeInsets.all(SkySemanticSpacing.screenPadding),
            child: SkyRetryCard(
              message: loadFailureMessage(error, l10n),
              retryLabel: l10n.commonRetry,
              onRetry: () =>
                  ref.read(loadListControllerProvider.notifier).refresh(),
            ),
          ),
          // 列表到了但没有这条：多半是刚被别人删掉，或者深链接过期了。
          _ => SkyEmptyState(
            icon: LucideIcons.planeLanding,
            title: l10n.loadDetailGoneTitle,
            description: l10n.loadDetailGoneDescription,
            actionLabel: l10n.loadDetailBackToList,
            onAction: () => context.goNamed(RouteName.flights),
          ),
        },
      ),
    );
  }
}

/// 详情页背景氛围强度。信息密集页压到 0.5 以下（见 [SkyBackground]）。
const double _backgroundIntensity = 0.35;

/// 详情正文。抽出来是为了让骨架屏能用**同一套**布局喂占位数据。
class _LoadDetailBody extends StatelessWidget {
  const _LoadDetailBody({
    required this.load,
    required this.isAdmin,
    required this.assigningRole,
    required this.removingIds,
    this.onBack,
    this.onEdit,
    this.onAdd,
    this.onRemove,
    this.onReorder,
    this.isBooked = false,
    this.isBooking = false,
    this.onBook,
    this.onCancel,
  });

  final Load load;
  final bool isAdmin;
  final ParticipantRole? assigningRole;
  final Set<String> removingIds;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final ValueChanged<ParticipantRole>? onAdd;
  final ValueChanged<LoadParticipant>? onRemove;

  /// 重排回调：(角色, 该角色的新顺序)。为空表示不可拖（客人视角 / 骨架屏）。
  final void Function(ParticipantRole role, List<String> participantIds)?
  onReorder;

  /// 当前客人是否已经约了这一班。
  final bool isBooked;

  /// 预约 / 取消请求在途。
  final bool isBooking;

  final VoidCallback? onBook;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SkySemanticSpacing.screenPadding,
        SkySpacing.s8,
        SkySemanticSpacing.screenPadding,
        // 底部导航条是浮起来的（外壳 extendBody），留出它的高度。
        SkySpacing.s96,
      ),
      children: <Widget>[
        Semantics(
          header: true,
          label: l10n.loadDetailTitle(load.code),
          child: LoadHeader(
            title: load.code,
            subtitle:
                "${formatLoadDay(context, load.departureAt, now: now)} "
                "${formatLoadTime(context, load.departureAt)} · "
                "${load.dropZone.name}",
            onBack: onBack,
            trailing: isAdmin
                ? IconButton(
                    onPressed: onEdit,
                    tooltip: l10n.loadEditTooltip,
                    icon: const Icon(LucideIcons.pencil, size: SkyIconSize.md),
                  )
                : null,
          ),
        ),
        const SizedBox(height: SkySemanticSpacing.itemGap),
        Text(
          "${load.aircraft} · ${formatAltitude(context, load.altitudeFt)}",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SkySemanticSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: LoadCapacityMeter(
                load: load,
                role: ParticipantRole.customer,
              ),
            ),
            const SizedBox(width: SkySemanticSpacing.itemGap),
            Expanded(
              child: LoadCapacityMeter(
                load: load,
                role: ParticipantRole.photographer,
              ),
            ),
          ],
        ),
        const SizedBox(height: SkySemanticSpacing.sectionGap),
        Text(l10n.loadManifestTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: SkySemanticSpacing.itemGap),
        LoadManifestSection(
          load: load,
          role: ParticipantRole.customer,
          isAdmin: isAdmin,
          isAssigning: assigningRole == ParticipantRole.customer,
          removingIds: removingIds,
          onAdd: () => onAdd?.call(ParticipantRole.customer),
          onRemove: (participant) => onRemove?.call(participant),
          onReorder: onReorder == null
              ? null
              : (ids) => onReorder!(ParticipantRole.customer, ids),
        ),
        const SizedBox(height: SkySemanticSpacing.sectionGap),
        LoadManifestSection(
          load: load,
          role: ParticipantRole.photographer,
          isAdmin: isAdmin,
          isAssigning: assigningRole == ParticipantRole.photographer,
          removingIds: removingIds,
          onAdd: () => onAdd?.call(ParticipantRole.photographer),
          onRemove: (participant) => onRemove?.call(participant),
          onReorder: onReorder == null
              ? null
              : (ids) => onReorder!(ParticipantRole.photographer, ids),
        ),
        // 客人视角的主行动。这一屏唯一的 primary 就在这里——
        // 列表卡片上的预约按钮刻意做成 secondary，把 primary 留给这一处。
        if (onBook != null || onCancel != null) ...<Widget>[
          const SizedBox(height: SkySemanticSpacing.sectionGap),
          if (isBooked)
            SkyButton(
              label: l10n.bookingActionCancel,
              icon: LucideIcons.ticketX,
              variant: SkyButtonVariant.danger,
              isLoading: isBooking,
              onPressed: load.hasDepartedBy(now) ? null : onCancel,
            )
          else
            SkyButton(
              label: l10n.bookingActionBook,
              icon: LucideIcons.ticketCheck,
              isLoading: isBooking,
              // 已起飞 / 已满时禁用而不是点了报错。
              onPressed: load.hasDepartedBy(now) || load.isSoldOut
                  ? null
                  : onBook,
            ),
        ],
      ],
    );
  }
}

/// 加载骨架：用**同一套**详情正文喂占位数据，形状天然贴合。
class _LoadDetailSkeleton extends StatelessWidget {
  const _LoadDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: _LoadDetailBody(
        load: placeholderLoad(DateTime.now()),
        isAdmin: false,
        assigningRole: null,
        removingIds: const <String>{},
      ),
    );
  }
}
