import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 账号页顶部的身份卡：头像 + 显示名 + 联系方式 + 资历。
///
/// 用毛玻璃而不是普通 Card：它是这一页唯一浮在天幕上的元素，
/// 玻璃让"云从卡片后面透过来"，卡片才不像硬贴在画布上的一块灰。
/// 一屏只有这一个 `BackdropFilter`，在规范给的 1–3 个预算之内。
///
/// 资历（执照等级 + 累计跳伞次数）刻意放在最显眼的位置：对跳伞的人来说，
/// 这两个数字就是他的身份，比邮箱重要得多。
class AccountProfileCard extends StatelessWidget {
  const AccountProfileCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final identifier = user.primaryIdentifier;

    return SkyGlassCard(
      padding: const EdgeInsets.all(SkySpacing.s20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Avatar(user: user),
          const SizedBox(width: SkySemanticSpacing.cardPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall,
                ),
                if (identifier != null) ...<Widget>[
                  const SizedBox(height: SkySpacing.s2),
                  Text(
                    // 打码展示：账号页常在同伴旁边打开，完整邮箱/手机号没必要摊开。
                    identifier.contains("@")
                        ? AuthRules.maskEmail(identifier)
                        : AuthRules.maskPhone(identifier),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: SkySemanticSpacing.itemGap),
                Wrap(
                  spacing: SkySpacing.s8,
                  runSpacing: SkySpacing.s8,
                  children: <Widget>[
                    _Badge(
                      icon: LucideIcons.award,
                      label: user.isLicensed
                          ? l10n.accountLicense(
                              user.licenseLevel!.toUpperCase(),
                            )
                          : l10n.accountLicenseNone,
                      // 持证是资历，用伞衣色点亮；无证是中性事实，不该被点亮。
                      isHighlighted: user.isLicensed,
                    ),
                    _Badge(
                      icon: LucideIcons.planeTakeoff,
                      label: l10n.accountTotalJumps(user.totalJumps),
                      isHighlighted: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 头像。没有头像图时用首字母 + 品牌渐变，比一个灰色人形剪影体面得多。
class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = user.avatarUrl;

    return Container(
      width: _avatarSize,
      height: _avatarSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: SkyGradients.brandFor(theme.brightness),
        shape: BoxShape.circle,
        boxShadow: SkyShadows.glow(theme.colorScheme.primary, intensity: 0.3),
      ),
      child: url == null || url.isEmpty
          ? Center(
              child: Text(
                _initials(user.displayName),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          // TODO(account): 后端下发头像后换成 CachedNetworkImage（带 placeholder
          //   与 errorWidget），当前字段恒为 null，先不引入网络图开销。
          : Image.network(url, fit: BoxFit.cover),
    );
  }

  /// 取首字母。拉丁名取首尾两个词的首字母，CJK 名取最后一个字
  /// （日文姓名「佐藤健二」取「二」不合适，取姓更合理，故 CJK 取**第一个**字）。
  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "?";
    final words = trimmed.split(RegExp(r"\s+"));
    if (words.length >= 2 && words.first.isNotEmpty && words.last.isNotEmpty) {
      return "${words.first[0]}${words.last[0]}".toUpperCase();
    }
    return trimmed.characters.first.toUpperCase();
  }
}

/// 资历徽标。
class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.isHighlighted,
  });

  final IconData icon;
  final String label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = isHighlighted
        ? theme.colorScheme.tertiary
        : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SkySpacing.s8,
        vertical: SkySpacing.s4,
      ),
      decoration: BoxDecoration(
        color:
            (isHighlighted
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onSurfaceVariant)
                .withValues(alpha: _badgeFillAlpha),
        borderRadius: BorderRadius.circular(SkyRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: SkyIconSize.xs, color: foreground),
          const SizedBox(width: SkySpacing.s4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

const double _avatarSize = 64;

/// 徽标底色的不透明度。低到只是"托一下"，不与卡片抢层级。
const double _badgeFillAlpha = 0.14;
