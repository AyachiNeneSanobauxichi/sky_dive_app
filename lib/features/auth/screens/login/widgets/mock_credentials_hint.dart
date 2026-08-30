import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/data/mock/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 演示账号提示条（**仅 mock 期间存在**）。
///
/// 后端未就绪时，任何想看看这个 app 的人（设计、产品、新同事）都会卡在登录页——
/// 没账号、注册了刷新一下又没了。这一条把演示账号摆出来并支持一键填入，
/// 省掉每次口头交代一遍。
///
/// 视觉刻意做成**虚线描边 + 弱化色**：它不是产品的一部分，一眼要看得出是脚手架。
///
// TODO(auth): 删除 `data/mock/` 时，把这个组件、它的 barrel 导出、
//   以及登录页里 `kAuthMockEnabled` 的分支一起删掉。
class MockCredentialsHint extends StatelessWidget {
  const MockCredentialsHint({super.key, required this.onFill});

  final VoidCallback onFill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(SkySemanticSpacing.cardPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: _fillAlpha),
        borderRadius: BorderRadius.circular(SkyRadius.card),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: SkyBorderWidth.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                LucideIcons.flaskConical,
                size: SkyIconSize.sm,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: SkySpacing.s6),
              Text(
                l10n.authMockTitle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: SkySpacing.s8),
          // 账号密码用等宽数字档位的正文，方便手动照抄。
          SelectableText(
            "${AuthMockDataSource.demoEmail}\n${AuthMockDataSource.demoPassword}",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: SkySpacing.s4),
          Text(
            l10n.authMockSmsHint(AuthMockDataSource.demoSmsCode),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SkySpacing.s8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              height: SkyControlSize.minTapTarget,
              child: SkyButton(
                label: l10n.authMockFill,
                variant: SkyButtonVariant.secondary,
                size: SkyButtonSize.small,
                isFullWidth: false,
                icon: LucideIcons.wandSparkles,
                onPressed: onFill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 底色透明度。压得很低，让它读成"贴在页面上的便签"而不是一张内容卡。
const double _fillAlpha = 0.5;
