import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/features/flight/widgets/participant_tile.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 一个角色的名单分组（标题 + 添加入口 + 人员列表 / 空态）。
///
/// ## 名单顺序是有意义的
/// 名单顺序 = **登机 / 出舱顺序**，运营在舱门口就照着它叫人。所以这一组支持
/// 长按拖拽调整（只有运营看得到把手）。拖完立刻发请求、不等服务端再动 UI——
/// 松手那一刻行已经到位了，等回包再跳一下是最差的观感。
///
/// ## 左滑移出是**快捷方式**，不是唯一入口
/// 每行右侧仍然保留可见的移出按钮：隐藏手势可以更快，但不能是唯一路径
/// （见 skill `17-ux-interaction.md`）。两条路走的是同一个"先做 + 可撤销"流程。
class LoadManifestSection extends StatelessWidget {
  const LoadManifestSection({
    super.key,
    required this.load,
    required this.role,
    required this.isAdmin,
    required this.isAssigning,
    required this.removingIds,
    required this.onAdd,
    required this.onRemove,
    this.onReorder,
  });

  final Load load;
  final ParticipantRole role;
  final bool isAdmin;
  final bool isAssigning;
  final Set<String> removingIds;
  final VoidCallback onAdd;
  final ValueChanged<LoadParticipant> onRemove;

  /// 重排回调，入参是**这一组**的完整新顺序（人的 id）。为空则不可拖。
  final ValueChanged<List<String>>? onReorder;

  void _onReorder(List<LoadParticipant> people, int oldIndex, int newIndex) {
    // ReorderableListView 给的 newIndex 是"插入到第几个之前"，
    // 往下拖时要减一才是最终下标。
    final target = newIndex > oldIndex ? newIndex - 1 : newIndex;
    if (target == oldIndex) return;

    final ids = people.map((p) => p.id).toList();
    ids.insert(target, ids.removeAt(oldIndex));
    HapticFeedback.selectionClick();
    onReorder?.call(ids);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final isCustomer = role == ParticipantRole.customer;
    final people = load.participantsOf(role);
    final isFull = load.isFullOf(role);
    final canManage = isAdmin && onReorder != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                isCustomer
                    ? l10n.loadRoleCustomers
                    : l10n.loadRolePhotographers,
                style: theme.textTheme.labelLarge,
              ),
            ),
            if (isAdmin)
              SkyButton(
                label: isCustomer
                    ? l10n.loadAddCustomer
                    : l10n.loadAddPhotographer,
                icon: LucideIcons.userPlus,
                variant: SkyButtonVariant.secondary,
                size: SkyButtonSize.small,
                isFullWidth: false,
                isLoading: isAssigning,
                // 满员时禁用而不是点了报错：不可用要看得出来。
                onPressed: isFull ? null : onAdd,
              ),
          ],
        ),
        const SizedBox(height: SkySemanticSpacing.labelGap),
        if (people.isEmpty)
          Text(
            isCustomer
                ? l10n.loadManifestEmptyCustomers
                : l10n.loadManifestEmptyPhotographers,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          )
        else if (!canManage)
          // 客人视角（以及骨架屏）：只读名单，不给拖拽也不给左滑。
          Column(
            spacing: SkySemanticSpacing.labelGap,
            children: <Widget>[
              for (final participant in people)
                ParticipantTile(
                  key: ValueKey<String>(participant.id),
                  participant: participant,
                ),
            ],
          )
        else ...<Widget>[
          ReorderableListView.builder(
            shrinkWrap: true,
            // 外层已经是可滚动页面，这里不能再抢滚动。
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            // 关掉默认把手（默认整行可拖，会和左滑打架），改成只有把手图标可拖。
            buildDefaultDragHandles: false,
            itemCount: people.length,
            onReorder: (oldIndex, newIndex) =>
                _onReorder(people, oldIndex, newIndex),
            // 拖起来的那一行浮起来：没有这层反馈，拖拽会像"行卡在手指下面"。
            proxyDecorator: (child, index, animation) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SkyRadius.md),
                boxShadow: SkyShadows.lifted(theme.brightness),
              ),
              child: child,
            ),
            itemBuilder: (context, index) {
              final participant = people[index];
              final isRemoving = removingIds.contains(participant.id);

              return Padding(
                key: ValueKey<String>(participant.id),
                padding: const EdgeInsets.only(
                  bottom: SkySemanticSpacing.labelGap,
                ),
                child: Dismissible(
                  key: ValueKey<String>("dismiss_${participant.id}"),
                  direction: isRemoving
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  background: const _SwipeBackground(),
                  // 返回 false：这一行不由 Dismissible 自己删——名单是 provider
                  // 驱动的，移出成功后列表自然少一行；失败时行还得留在原地。
                  confirmDismiss: (_) async {
                    onRemove(participant);
                    return false;
                  },
                  child: ParticipantTile(
                    participant: participant,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _RemoveButton(
                          isBusy: isRemoving,
                          onPressed: () => onRemove(participant),
                        ),
                        ReorderableDragStartListener(
                          index: index,
                          child: Tooltip(
                            message: l10n.loadReorderTooltip,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SkySpacing.s4,
                              ),
                              child: Icon(
                                LucideIcons.gripVertical,
                                size: SkyIconSize.md,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // 左滑是隐藏手势，给一句一次性的说明；可见入口（移出按钮）始终都在。
          Text(
            l10n.loadSwipeToRemove,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// 左滑时露出的底：错误色 + 垃圾桶，方向感和"移出"一致。
class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s16),
      decoration: BoxDecoration(
        color: scheme.error.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(SkyRadius.md),
      ),
      child: Icon(
        LucideIcons.userMinus,
        size: SkyIconSize.md,
        color: scheme.error,
      ),
    );
  }
}

/// 把人移出名单的按钮。请求在途时换成转圈并禁用——这是"按钮内联忙碌态"，
/// 是骨架屏规则里明确的例外。
class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.isBusy, required this.onPressed});

  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (isBusy) {
      return SizedBox(
        width: SkyControlSize.minTapTarget,
        height: SkyControlSize.minTapTarget,
        child: Center(
          child: SizedBox(
            width: SkyIconSize.sm,
            height: SkyIconSize.sm,
            child: CircularProgressIndicator(
              strokeWidth: SkyBorderWidth.thick,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onPressed,
      tooltip: l10n.loadRemoveParticipant,
      color: theme.colorScheme.error,
      icon: const Icon(LucideIcons.userMinus, size: SkyIconSize.md),
    );
  }
}
