import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";

/// 名单 / 候选池里的一个人。
///
/// 名字旁边一定带一句 [LoadParticipant.detail]（跳伞类型 / 执照等级 / 机位）：
/// 排班的人靠它判断"这个人能不能上这条航线"，只有名字的列表等于让他去别处查。
class ParticipantTile extends StatelessWidget {
  const ParticipantTile({
    super.key,
    required this.participant,
    this.onTap,
    this.trailing,
    this.trailingIcon,
  });

  final LoadParticipant participant;
  final VoidCallback? onTap;

  /// 尾部自定义控件（如移除按钮）。与 [trailingIcon] 二选一。
  final Widget? trailing;

  /// 尾部图标（纯提示性，如选择器里的"＋"）。
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final detail = participant.detail;
    final trailingWidget = trailing;
    final icon = trailingIcon;

    return Material(
      color: scheme.surfaceContainer,
      borderRadius: BorderRadius.circular(SkyRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SkyRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SkySpacing.s12,
            vertical: SkySpacing.s8,
          ),
          child: Row(
            children: <Widget>[
              // 头像位先用首字占位：候选池里没有头像字段，空着会让整行发虚。
              Container(
                width: SkyControlSize.buttonSmall,
                height: SkyControlSize.buttonSmall,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  participant.initial,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              const SizedBox(width: SkySemanticSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      participant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (detail != null)
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailingWidget != null)
                trailingWidget
              else if (icon != null)
                Icon(
                  icon,
                  size: SkyIconSize.md,
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
