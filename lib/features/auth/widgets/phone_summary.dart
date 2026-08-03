import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 已发码后的手机号摘要（打码 + "修改"入口）。
///
/// 验证码发出去之后，手机号输入框就没有输入价值了，但**不能直接删掉**——
/// 用户需要确认"码发到哪个号了"。折叠成一行既保留这个确认信息，
/// 又把注意力交还给验证码格子；号码打码是因为登录页常在公共场合打开。
class PhoneSummary extends StatelessWidget {
  const PhoneSummary({
    super.key,
    required this.phone,
    required this.onEdit,
    this.enabled = true,
  });

  final String phone;
  final VoidCallback onEdit;

  /// 提交中置 false：请求在途时不允许改号。
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      // 不写死高度：多了一行说明文字，且要能随系统字体缩放长高。
      padding: const EdgeInsets.only(
        left: HappySpacing.s16,
        top: HappySpacing.s8,
        bottom: HappySpacing.s8,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(HappyRadius.input),
        border: Border.all(
          color: scheme.outlineVariant,
          width: HappyBorderWidth.hairline,
        ),
      ),
      child: Row(
        spacing: HappySemanticSpacing.itemGap,
        children: <Widget>[
          Icon(
            LucideIcons.smartphone,
            size: HappyIconSize.md,
            color: scheme.onSurfaceVariant,
          ),
          Expanded(
            // 一行号码不能自解释"这个号已经收到码了"，补一行极小的说明。
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l10n.authCodeSentTo,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "${AuthRules.dialCode} ${AuthRules.maskPhone(phone)}",
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SizedBox(
            // 文字按钮，但热区撑到 44。
            height: HappyControlSize.minTapTarget,
            child: HappyButton(
              label: l10n.authChangePhone,
              variant: HappyButtonVariant.ghost,
              size: HappyButtonSize.small,
              isFullWidth: false,
              onPressed: enabled ? onEdit : null,
            ),
          ),
        ],
      ),
    );
  }
}
